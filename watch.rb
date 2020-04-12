require 'filewatcher'
require 'colorize'
require 'open-uri'
require 'nokogiri'

log_folder = '/Users/johno/Downloads/drive-download-20200412T092002Z-001/'
helper_file_path = "#{log_folder}RandomizerHelperLog.txt"
tracker_file_path = "#{log_folder}RandomizerTrackerLog.txt"

# xml = Nokogiri::XML(open('https://raw.githubusercontent.com/homothetyhk/HollowKnight.RandomizerMod/master/RandomizerMod3.0/Resources/items.xml'))
# Hash[xml.css('item').group_by { |i| i.children.css('pool').text }.map { |k, v| [k, v.map { |item| item.attributes['name'].text }] }]

# Filewatcher.new([helper_file_path, tracker_file_path]).watch do |_|
  raw_helper_file_lines = File.readlines(helper_file_path)
  raw_helper_file = File.read(helper_file_path)
  raw_tracker_file_lines = File.readlines(tracker_file_path)

  current_scene = raw_helper_file_lines.grep(/Current scene:/).first.gsub("\r\n", '').split('Current scene: ').last
  reachable_grubs = raw_helper_file_lines.grep(/Reachable grubs:/).first.gsub("\r\n", '')
  reachable_essence = raw_helper_file_lines.grep(/Reachable essence:/).first.gsub("\r\n", '')

  checked_items = raw_tracker_file_lines.grep(/ITEM --- /)

  reachable = raw_helper_file.split('REACHABLE ITEM LOCATIONS').last
                             .split('CHECKED ITEM LOCATIONS').first
                             .split("\r\n\r\n")[1...-1]
  reachable_areas = Hash[
    reachable.map do |ra|
      lines = ra.split("\r\n - ")
      area = lines.shift
      [area, lines]
    end.sort_by{ |_, v| 0 - v.count }
  ]

  puts '----'
  puts "Current scene: #{current_scene.colorize(:green)} - #{reachable_grubs} - #{reachable_essence}"
  if(checked_items.any?)
    puts "Last pickup: #{checked_items.last.split('ITEM --- ').last.gsub("\r\n", '').colorize(:green)}"
  end
  puts reachable_areas.map { |area, items| "#{area.colorize(:green)} #{items.count.to_s.colorize(:red)} (#{items.join(', ')})" }.join(' -- ')
# end
