require 'csv'
require 'open-uri'
require 'bundler'
require "google_drive"
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'app/data_loger'

# Scrapper.new('https://www.annuaire-des-mairies.com/val-d-oise.html').perform

# binding.pry