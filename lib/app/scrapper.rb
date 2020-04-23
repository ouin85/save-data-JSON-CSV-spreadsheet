class Scrapper
  attr_accessor  :url_phonebook, :townhalls_names_emails_of_val_d_oise, :data_loger

  def initialize(url)
    @url_phonebook = url
    @townhalls_names_emails_of_val_d_oise = {}
    @data_loger = DataLoger.new({})
  end
  
  def perform
    begin
      puts 'Get townhalls names, please wait!'
      townhalls_names = get_townhalls_names(@url_phonebook)
      puts 'Done.'
    rescue => e
      puts e.message
      puts "Oups! Sorry, that didn't work!"
    end
    begin
      puts 'Get townhalls emails, please wait!'
      townhalls_emails = get_townhalls_emails(@url_phonebook)
      puts 'Done.'
    rescue => e
      puts e.message
      puts "Oups! Sorry, that didn't work!"
    end
    # @townhalls_names_emails_of_val_d_oise = {mother: "Ouahiba", father: "Abdellah", wife: "Aziza", son: "Salah"}
    @townhalls_names_emails_of_val_d_oise = townhalls_names.zip(townhalls_emails).to_h
    data_loger.data = @townhalls_names_emails_of_val_d_oise
    data_loger.save_as_JSON
    data_loger.save_as_CSV
  end

  private
  def open_page_at_(url)
    Nokogiri::HTML(open(url))
  end

  def get_townhall_email(townhall_url)
    open_page_at_(townhall_url).xpath('//tr[4]/td[2]')[0].text
  end
  
  def get_townhalls_urls(url_phonebook)
    open_page_at_(url_phonebook).xpath('//tr/td/p/a')
    .map { |item| item['href'] }
  end
  
  def get_townhalls_names(url_phonebook)
    open_page_at_(url_phonebook).xpath('//tr/td/p/a')
      .map { |item| item.text }
  end
  
  def get_townhalls_emails(url_phonebook)
    url_complement = url_phonebook[0..url_phonebook.size-16]
    townhalls_emails = get_townhalls_urls(url_phonebook).map { |townhall_url| get_townhall_email(url_complement + townhall_url[2..townhall_url.size-1]) }
  end
end