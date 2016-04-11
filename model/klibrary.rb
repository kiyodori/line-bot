require 'open-uri'
require 'nokogiri'

Book = Struct.new(:no, :type, :title, :author, :publisher, :year, :url)
KLIBRARY_DOMAIN_URL = 'http://www.library.city.kawasaki.jp/'.freeze
SEARCH_CONDITION_URL = KLIBRARY_DOMAIN_URL + 'search.html'.freeze

class Klibrary
  attr_reader :key1

  def initialize(key1)
    @key1 = sjis_safe(key1).encode(Encoding::SJIS)
  end

  def search
    books = search_books
    return noresult if books.empty?

    result = "#{greeting}"
    books.each { |b| result << book_info(b) }
    result << closing

    return result
  end

  private

  def search_books
    html_doc.css("tbody tr").map do |tr|
      td = tr.css("td")
      url = KLIBRARY_DOMAIN_URL + td[2].css("a").first.values.first
      book = Book.new(td[0].text, td[1].text, td[2].text, td[3].text, td[4].text, td[5].text, url)
    end
  end

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

  def noresult
    text = ['う〜1件もヒットしなかったよ(´；ω；｀)', '0件どんまい！', '調べなおしてちょ(*´ω｀*)'].sample
    <<"EOS"
#{text}
#{SEARCH_CONDITION_URL}
EOS
  end

  def greeting
    text = ['見つかったってばよ！', '素晴らしい本たちだ！', '世界が広がるね、うんうん'].sample
    <<-EOS
#{text}

    EOS
  end

  def book_info(book)
    <<"EOS"
#{book.no}.
#{book.title}
#{book.author}
#{book.year}
#{book.url}

EOS
  end

  def closing
    text = ['ここからも調べられるよ', 'もっと調べてもよいぞよ', 'さらなる本の旅へ、いざ行かん！'].sample
    <<"EOS"
#{text}
#{SEARCH_CONDITION_URL}
EOS
  end
end
