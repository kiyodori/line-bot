require 'open-uri'
require 'nokogiri'
require 'pry'

Book = Struct.new(:no, :type, :title, :author, :publisher, :year, :url)
KLIBRARY_DOMAIN_URL = 'http://www.library.city.kawasaki.jp/'.freeze
SEARCH_CONDITION_URL = KLIBRARY_DOMAIN_URL + 'search.html'.freeze

class Klibrary
  attr_reader :key1

  def initialize(key1)
    @key1 = sjis_safe(key1).encode(Encoding::SJIS)
  end

  def search
    books = html_doc.css("tbody tr").map do |tr|
      td = tr.css("td")
      url = KLIBRARY_DOMAIN_URL + td[2].css("a").first.values.first
      book = Book.new(td[0].text, td[1].text, td[2].text, td[3].text, td[4].text, td[5].text, url)
    end

    if books.empty?
      return <<"EOS"
う〜1件もヒットしなかったよ(´；ω；｀)
#{SEARCH_CONDITION_URL}
EOS
    end

    greeting = <<-EOS
よしきたっ、あるぞ！

    EOS

    result = "#{greeting}"
    books.each do |b|
      result << <<"EOS"
#{b.no}.
#{b.title}
#{b.author}
#{b.year}
#{b.url}

EOS
    end

    result << <<"EOS"
もっと調べたきゃ
#{SEARCH_CONDITION_URL}
EOS
    return result
  end

  private

  def html_doc
    response = RestClient.post('http://www.library.city.kawasaki.jp/clis/search', request_params)
    Nokogiri::HTML(response.body)
  end

  def request_params
    {
      'KEY1': @key1,
      'BOOK': 'ON',
      'AV': 'ON',
      'ITEM1': 'ZZ',
      'COMP1': '3',
      'COND': '2',
      'MAXVIEW': '5',
      'SORT': '1'
    }
  end

  def sjis_safe(str)
    [
      ["301C", "FF5E"], # wave-dash
      ["2212", "FF0D"], # full-width minus
      ["00A2", "FFE0"], # cent as currency
      ["00A3", "FFE1"], # lb(pound) as currency
      ["00AC", "FFE2"], # not in boolean algebra
      ["2014", "2015"], # hyphen
      ["2016", "2225"], # double vertical lines
    ].inject(str) do |s, (before, after)|
      s.gsub(
        before.to_i(16).chr('UTF-8'),
        after.to_i(16).chr('UTF-8'))
    end
  end
end
