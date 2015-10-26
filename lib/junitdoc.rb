require 'nokogiri'
require 'haml'

def main
  files = Dir.glob ARGV
  data = process_files files
  doc = render_template data
  puts doc
end

def process_files files
  data = {}
  files.each { |fn| process_file fn, data }
  data
end

def render_template data
  engine = Haml::Engine.new(template)
  engine.render 'teh data', :data => data
end

def process_file fn, data
  doc = open_document fn
  doc.xpath('//testcase').each do |testcase|
    process_testcase testcase, data
  end
end

def open_document fn
  File.open(fn) { |f| Nokogiri::XML(f) }
end

def process_testcase testcase, data
  test_name = sentencize testcase[:name]
  package_name = parse_package_name testcase[:classname]
  class_name = titlize parse_class_name(testcase[:classname])
  add_to_data test_name, package_name, class_name, data
end

def sentencize s
  s.split(/(?=[A-Z0-9])/).map(&:downcase).join ' '
end

def titlize s
  s.split(/(?=[A-Z0-9])/)[0...-1].join ' '
end

def parse_class_name s
  s.rpartition('.').last
end

def parse_package_name s
  s.rpartition('.').first
end

def add_to_data test_name, package_name, class_name, data
  data[package_name] ||= {}
  data[package_name][class_name] ||= []
  data[package_name][class_name] << test_name
end

def template
%q(
!!! 5
%html{:lang => 'en'}
  %head
    %title JUnit Test Descriptions
    %style body { font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif; margin-left: 20px }
    %style h1 { font-size: 24px; margin-bottom: 0px }
    %style h2 { margin-left: 0px; margin-bottom: 0px; font-size: 18px }
    %style h2 span { font-size: 12px }
    %style ul { margin-top: 0px }
  %body
    %header
      %h1 JUnit Test Descriptions
    %section
      - data.each do |package_name, classes|
        - classes.each do |class_name, tests|
          %h2<
            = class_name
            %span
              = "(#{package_name})"
          %ul
            - tests.each do |test_name|
              %li<
                = test_name
  )
end

main
