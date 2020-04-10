class Inventory
  def initialize(yaml_file = 'inventory.yml')
    @items = {}

    YAML.load_file(yaml_file)['items'].each { |item| @items[item] = false }
  end

  def toggle(item)
    @items[item] = !@items[item]
  end

  def self.draw
    INV_PANE.clear
    INV_PANE.puts("Inventory\n")
    INVENTORY.items.each do |name, acquired|
      label = name.colorize(acquired ? :green : :red)
      INV_PANE.button(label, item: name) do |btn|
        INVENTORY.toggle(btn['original_msg']['item'])
        Inventory.draw
        Area.draw
      end
    end
  end

  def items
    @items.select{ |_, acq| !acq }.merge(@items.select{ |_, acq| acq })
  end
end
