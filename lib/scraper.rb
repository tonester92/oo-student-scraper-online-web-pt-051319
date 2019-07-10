require 'open-uri'
require 'pry'

class Scraper
attr_accessor :students

  def self.scrape_index_page(index_url)
    index_html = open(index_url)
    index_doc = Nokogiri::HTML(index_html)
    student_cards = index_doc.css(".student-card")
    students = []
    student_cards.collect do |student_card_xml|
      students << {
        :name => student_card_xml.css("h4.student-name").text,
        :location => student_card_xml.css("p.student-location").text,
        :profile_url => "./fixtures/student-site/" + student_card_xml.css("a").attribute("href").value
        }
    end
    students
  end	

  def self.scrape_profile_page(profile_url)
    profile_html = open(profile_url)
    profile_doc = Nokogiri::HTML(profile_html)
    student_attributes = {}
    profile_doc.css("div.social-icon-container a").each do |link_xml|
      case link_xml.student_attribute("href").value
      when /twitter/
        student_attributes[:twitter] = link_xml.attribute("href").value
      when /github/
        student_attributes[:github] = link_xml.attribute("href").value
      when /linkedin/
        student_attributes[:linkedin] = link_xml.attribute("href").value
      else
        student_attributes[:blog] = link_xml.attribute("href").value
      end
    end
   student_attributes[:profile_quote] = profile_doc.css("div.profile-quote").text
   student_attributes[:bio] = profile_doc.css("div.bio-content div.description-holder").text.strip
   student_attributes
  end
end