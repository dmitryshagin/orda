#!/usr/bin/ruby
require "socket"
require "caxlsx"
require "roo"

def is_alive?(source)
  address = source[:ip]
  port = 80
  timeout = 2
  # port_is_open = rand > 0.5 #TODO
  port_is_open = Socket.tcp(address, port, connect_timeout: timeout) { true } rescue false
  # puts "#{address} is #{port_is_open}"
  return port_is_open
end


workbook = Roo::Spreadsheet.open './test.xlsx'
worksheets = workbook.sheets

sources = {}

worksheets.each do |worksheet|
  workbook.each_row_streaming do |row|
    next if row[0].to_s == nil
    if row[0].to_s.start_with?("sudo")
      sources[row[1].to_s] = { command: row[0].to_s, ip: row[1].to_s, info: row[2].to_s }
    end
  end
end

sources.each do |k, v|
  v[:is_alive] = is_alive?(v)
end

dead = 0

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(name: workbook.sheets[0]) do |ws|
    red_cell = ws.styles.add_style(:bg_color => "FF0000", :fg_color => "FFFFFF")

    sources.each do |key, source|
      style = nil
      if source[:ip] != nil && source[:is_alive] == false
        dead = dead + 1
        style = red_cell
      end
      ws.add_row [source[:command], source[:ip], source[:info]], style: style
    end

    ws.add_row ["#{dead}/#{sources.size}"]
  end
  p.serialize("result.xlsx")
end
