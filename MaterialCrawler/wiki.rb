require 'nokogiri'
require 'uri'

require 'rest-client'

url = "https://ko.wikipedia.org/wiki/수소"
response = RestClient.get(URI.encode(url))
doc = Nokogiri::HTML(response)
@elementType=doc.css("table.infobox").children[9].text
@atomWeight=doc.css("table.infobox").children[13].text
@density=doc.css("table.infobox").children[23].text
@meltingPoint=doc.css("table.infobox").children[25].text
@boilingPoint=doc.css("table.infobox").children[27].text
@triplePoint=doc.css("table.infobox").children[29].text
@heatOfDissolution=doc.css("table.infobox").children[31].text
@evaporationHeat=doc.css("table.infobox").children[33].text
@heatCapacity=doc.css("table.infobox").children[35].text
@electroNegativity=doc.css("table.infobox").children[45].text
@ionizationEnergy=doc.css("table.infobox").children[47].text
@atomRadius=doc.css("table.infobox").children[49].text.strip.split[2..3]
=begin
for i in 1...50
puts "#{i} 번째 \n"
puts doc.css("table.infobox").children[i].text.strip
end
=end
#잘 안찾아지는 경우 => 클래스 아래 .children[] 배열로 일일이 찾아볼 수 있다.
puts @meltingPoint.strip.split[1] +"K"
puts @boilingPoint.strip.split[1] +"K"
puts @atomRadius
#mw-content-text > div > table.infobox > tbody > tr:nth-child(12)
#mw-content-text > div > table.infobox > tbody > tr:nth-child(13)
#mw-content-text > div > table.infobox > tbody > tr:nth-child(1)
=begin
종류  9
원자질량 13
전자배열 15
밀도 23
녹는점 25
끓는점 27
삼중점 29
용해열 31
기화열 33
열용량 35
전기음성도 45
이온화에너지 47
원자반지름 49

내용에서 '숫자'만 추출, strip은 빈칸제거, split하면 배열출력
str.strip.split[1].to_i
내용에서 '문자'만 추출
str.strip.split[1].to_s
=end
