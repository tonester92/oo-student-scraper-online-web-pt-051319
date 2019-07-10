require 'open-uri'
require 'pry'

class Scraper
attr_accessor :students

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_infomation = {:name => name,
                :location => location,
                :profile_url => profile_url}
      students << student_infomation
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
        student_attributes[:twitter] = link_xml.student_attribute("href").value
      when /github/
        student_attributes[:github] = link_xml.student_attribute("href").value
      when /linkedin/
        student_attributes[:linkedin] = link_xml.student_attribute("href").value
      else
        student_attributes[:blog] = link_xml.student_attribute("href").value
      end
    end
    student_attributes[:profile_quote] = profile_doc.css("div.profile-quote").text
    student_attributes[:bio] = profile_doc.css("div.bio-content div.description-holder").text.strip
    student_attributes
  end
end