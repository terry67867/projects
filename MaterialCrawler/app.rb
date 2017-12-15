require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

require 'nokogiri'
require 'uri'

require 'rest-client'
require 'csv'
require 'date'

set :bind, '0.0.0.0'

get '/' do
  send_file 'index.html'
end

get '/search' do
  erb :search
end

get '/searchComplete' do
  @materialName=params[:materialName]
  puts @materialName
  #1. 위키백과 주소를 url에 저장한다.
  url = "https://ko.wikipedia.org/wiki/#{@materialName}"
  #2. url통해 요청한다.
  response = RestClient.get(URI.encode(url))
  #3. 가져온 문서를 nokogiri형식으로 저장
  doc = Nokogiri::HTML(response)
  #4. 문서에서 css중 ID,Class or 검사로 위치 지정하여 변수에 저장
  @elementType=doc.css("table.infobox").children[9].text.strip.split[2]
  @atomWeight=doc.css("table.infobox").children[13].text.strip.split[2..3]
  @density=doc.css("table.infobox").children[23].text.strip.split[2..3]
  @meltingPoint=doc.css("table.infobox").children[25].text.strip.split[1..2]
  @boilingPoint=doc.css("table.infobox").children[27].text.strip.split[1..2]
  @triplePoint=doc.css("table.infobox").children[29].text.strip.split[1..2]
  @heatOfDissolution=doc.css("table.infobox").children[31].text.strip.split[1..2]
  @evaporationHeat=doc.css("table.infobox").children[33].text.strip.split[1..2]
  @heatCapacity=doc.css("table.infobox").children[35].text.strip.split[2..3]
  @electroNegativity=doc.css("table.infobox").children[45].text.strip.split[2]
  @ionizationEnergy=doc.css("table.infobox").children[47].text.strip.split[3..4]
  @atomRadius=doc.css("table.infobox").children[49].text.strip.split[2..3]
###숫자만 추출, ##
  #5. 저장된 변수 내용 중 텍스트 서버에 출력
  # puts @materialName
  # puts @boilingPoint.text
  # puts @meltingPoint.text

  CSV.open('material.csv','a+:utf-8') do |csv|
    csv<<[@materialName,@elementType,@atomWeight,@density,@meltingPoint,@boilingPoint,
      @triplePoint,@heatOfDissolution,@evaporationHeat,@heatCapacity,@electroNegativity,
      @ionizationEnergy,@atomRadius]
  end
  erb :searchComplete
end
#잘 안찾아지는 경우 => 클래스 아래 .children[] 배열로 일일이 찾아볼 수 있다.
#puts @meltingPoint.strip.split[1] +"K"
#puts @boilingPoint.strip.split[1] +"K"

get '/resultPage' do
  @materials=[]
  CSV.foreach('material.csv',encoding:'utf-8') do |row|
    @materials<<row
  end
  erb :resultPage
end

##추가 가입, 아이디 확인 페이지

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
