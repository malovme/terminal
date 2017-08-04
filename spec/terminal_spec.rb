require "spec_helper"

RSpec.describe Terminal do
  before do
    @terminal = Terminal::Terminal.new
  end

  it "has a version number" do
    expect(Terminal::VERSION).not_to be nil
  end

  it "creates terminal instance" do
    expect(@terminal).to be_instance_of(Terminal::Terminal)
  end


  it "set and return pricing" do
    @terminal.set_pricing({A: {1 => 2, 4 => 7},
                           B: {1 => 12},
                           C: {1 => 1.25, 6 => 6},
                           D: {1 => 0.15}})
    expect(@terminal.pricing['C'][6]).to eq 6
  end

  it "scan and return products" do
    @terminal.scan('A')
    @terminal.scan('B')
    @terminal.scan('C')
    expect(@terminal.products).to eq ['A', 'B', 'C']
  end

  context "getting totals price" do
    before do
      @terminal.set_pricing({A: {1 => 2, 4 => 7},
                             B: {1 => 12},
                             C: {1 => 1.25, 6 => 6},
                             D: {1 => 0.15}})
    end

    it "calculates total ABCDABAA" do
      @terminal.scan('A')
      @terminal.scan('B')
      @terminal.scan('C')
      @terminal.scan('D')
      @terminal.scan('A')
      @terminal.scan('B')
      @terminal.scan('A')
      @terminal.scan('A')
      expect(@terminal.total).to eq '$ 32.40'
    end

    it "calculates total CCCCCCC" do
      @terminal.scan('CCCCCCC')
      expect(@terminal.total).to eq '$ 7.25'
    end

    it "calculates total ABCD" do
      @terminal.scan('ABCD')
      expect(@terminal.total).to eq '$ 15.40'
    end
  end

  it "clear product on next order" do
    @terminal.scan('CCCCCCC')
    @terminal.next_order
    expect(@terminal.products).to be_empty
  end

  it "count products amount after scanning" do
    @terminal.scan('ABCDABAA')
    products_total = @terminal.send('get_products_total')
    expect(products_total).to eq({ 'A' => 4, 'B' => 2, 'C' => 1, 'D' => 1 })
  end

  it "get_product_by_packs" do
    @terminal.set_pricing({ A: {1 => 2, 4 => 7} })
    packs = @terminal.send('get_product_by_packs', 'A', 10)
    expect(packs).to eq [4, 4, 1, 1]
  end

  it "get_products_total is private" do
    @terminal.scan('CCCCCCC')
    expect { @terminal.get_products_total }.to raise_error(NoMethodError)
  end

  it "get_product_by_packs is private" do
    @terminal.set_pricing({ A: {1 => 2, 4 => 7} })
    expect { @terminal.get_product_by_packs('A', 10) }.to raise_error(NoMethodError)
  end

end
