class Area
  include Logic

  attr_reader :name, :logic, :locations

  def initialize(opts = {})
    @name = opts['name']
    @logic = opts['logic']
    @locations = opts['locations'].map { |loc| Location.new(loc) }
  end

  def self.load(yaml_file = 'locations.yml')
    @load ||= YAML.load_file(yaml_file)['areas'].map do |area_data|
      Area.new(area_data)
    end
  end

  def self.draw
    LOC_PANE.clear
    LOC_PANE.puts("Locations\n")
    Area.load.each do |area|
      LOC_PANE.puts area.description.colorize(area.accessible? ? (area.cleared? ? :blue : :green) : :red)
      if area.accessible?
        area.locations.reject(&:checked?).each do |loc|
          label = "\t#{loc.description}".colorize(loc.accessible? ? :green : :red)
          LOC_PANE.button(label, location: loc.name) do |btn|
            CHECKED[btn['original_msg']['location']] = !CHECKED[btn['original_msg']['location']]
            Area.draw
          end
        end
      else
        LOC_PANE.puts "\t#{area.logic}".red
      end
    end

    LOC_PANE.break

    Area.load.each do |area|
      area.locations.select(&:checked?).each do |loc|
        label = "#{area.name}: #{loc.description}".colorize(:blue)
        LOC_PANE.button(label, location: loc.name) do |btn|
          CHECKED[btn['original_msg']['location']] = !CHECKED[btn['original_msg']['location']]
          Area.draw
        end
      end
    end
  end

  def weight
    locations.sum(&:weight)
  end

  def accessible_weight
    return 0 unless accessible?

    locations.select { |l| l.accessible? }.sum(&:weight)
  end

  def checked_weight
    locations.select { |l| l.checked? }.sum(&:weight)
  end

  def cleared?
    locations.all? &:checked?
  end

  def description
    "#{name} (#{checked_weight}/#{accessible_weight}/#{weight})"
  end
end
