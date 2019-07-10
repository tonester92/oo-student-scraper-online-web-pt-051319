require 'open-uri'
require 'pry'

class Scraper
attr_accessor :students

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
    student_profile = {}
    html = open(profile_url)
    profile = Nokogiri::HTML(html)
    profile.css("div.main-wrapper.profile .social-icon-container a").each do |social|
      if social.attribute("href").value.include?("twitter")
        student_profile[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        student_profile[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        student_profile[:github] = social.attribute("href").value
      else
        student_profile[:blog] = social.attribute("href").value
      end
    end 
  end
end