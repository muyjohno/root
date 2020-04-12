require 'filewatcher'
require 'colorize'

log_folder = ''
helper_file_path = "#{log_folder}RandomizerHelperLog.txt"

Filewatcher.new([helper_file_path]).watch do |_|
  raw_helper_file_lines = File.readlines(helper_file_path)
  raw_helper_file = File.read(helper_file_path)

  current_scene = raw_helper_file_lines.grep(/Current scene:/).first.gsub("\r\n", '').split('Current scene: ').last
  reachable_grubs = raw_helper_file_lines.grep(/Reachable grubs:/).first.gsub("\r\n", '')
  reachable_essence = raw_helper_file_lines.grep(/Reachable essence:/).first.gsub("\r\n", '')
  here = "Current scene: #{current_scene.colorize(:green)} - #{reachable_grubs} - #{reachable_essence}"

  reachable = raw_helper_file.split('REACHABLE ITEM LOCATIONS').last.split('CHECKED ITEM LOCATIONS').first
  reachable_areas = reachable.split("\r\n\r\n")[1...-1]
  reachable_items = reachable_areas.map do |ra|
    lines = ra.split("\r\n - ")
    area = lines.shift
    "#{area.colorize(:green)} (#{lines.join(', ')})"
  end.join(' -- ')

  puts nil
  puts here
  puts reachable_items
end
