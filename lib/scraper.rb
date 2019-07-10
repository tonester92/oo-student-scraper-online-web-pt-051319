require 'open-uri'
require 'pry'

class Scraper
attr_accessor :students

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    index = Nokogiri::HTML(open(index_url))
    index.css("div.student-card").each do |student|
      student_information = {}
      student_information[:name] = student.css("h4.student-name").text
      student_information[:location] = student.css("p.student-location").text
      profile_path = student.css("a").attribute("href").value
      student_information[:profile_url] = student.css('./fixtures/student-site/') + profile_path
      students << student_information
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