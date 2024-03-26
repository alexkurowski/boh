require 'json'

hints = JSON.parse File.read 'tomes_with_memory_hint-full_aspect_infos.json'
tomes = JSON.parse File.read 'tomes.json'

all_aspects = [
  "edge",
  "forge",
  "grail",
  "heart",
  "knock",
  "lantern",
  "moon",
  "moth",
  "nectar",
  "rose",
  "scale",
  "sky",
  "winter",
]

data = []

hints['elements'].each do |el|
  id = el['ID']
  memory = el['Desc'].scan /(?<=Upon reading gives )<b>(.+)<\/b>/
  aspects = el['Desc'].scan /\<sprite name=(\w+)\> (\d)/
  tome = tomes['elements'].find { |tome| tome['ID'] == id }
  book = tome['Label']
  book_asp = tome['aspects'].keys.find { |key| key.start_with? 'mystery' }.sub("mystery.", '')
  book_dif = tome['aspects']["mystery.#{book_asp}"]


  entry = {
    "book" => "\"#{book}\"",
    "aspect" => book_asp,
    "dif" => book_dif,
    "memory" => memory.flatten.first,
    "edge" => '',
    "forge" => '',
    "grail" => '',
    "heart" => '',
    "knock" => '',
    "lantern" => '',
    "moon" => '',
    "moth" => '',
    "nectar" => '',
    "rose" => '',
    "scale" => '',
    "sky" => '',
    "winter" => '',
  }

  aspects.each do |asp|
    entry[asp.first] = asp.last
  end

  data.push entry
end

csv = "book,book aspect,book level,memory,forge,knock,lantern,grail,moth,scale,winter,rose,sky,edge,nectar,heart,moon\n"
html = ''
data.each do |entry|
  csv << "#{entry['book']},#{entry['aspect']},#{entry['dif']},#{entry['memory']}"
  all_aspects.each do |asp|
    csv << ",#{entry[asp]}"
  end
  csv << "\n"

  html << "<tr>"
  html << "<td>#{entry['book'].gsub(/^"|"$/, '')}</td>"
  html << "<td>#{entry['aspect']}</td>"
  html << "<td>#{entry['dif']}</td>"
  html << "<td>#{entry['memory']}</td>"
  all_aspects.each do |asp|
    html << "<td>#{entry[asp]}</td>"
  end
  html << "</tr>\n"
end

File.write 'boh_books.csv', csv
File.write 'boh_table.html', html
