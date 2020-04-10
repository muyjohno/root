require_relative './includes'

require 'colorized'
f = Flammarion::Engraving.new(title: 'Root')
f.orientation = :horizontal

LOC_PANE = f.pane('default')
INV_PANE = f.pane('inventory')
INVENTORY = Inventory.new
CHECKED = {}

Area.draw
Inventory.draw

f.wait_until_closed
