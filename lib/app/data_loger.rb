class DataLoger
  attr_accessor :data
  
  def initialize(data)
    @data = data.to_a.map(&:clone).to_h
  end
  
  def save_as_JSON
    File.open("db/emails.json", "w") { |f| f << JSON.pretty_generate(@data)}
    puts "The data is saved as JSON"
  end
  
  def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("config.json")
    
    # First worksheet of
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("pz7XtlQC-PYx-jrVMJErTcg").worksheets[0]
    
    # Gets content of A2 cell.
    p ws[2, 1]  #==> "hoge"
    
    # Changes content of cells.
    # Changes are not sent to the server until you call ws.save().
    ws[2, 1] = "foo"
    ws[2, 2] = "bar"
    ws.save
    
    # Dumps all cells.
    (1..ws.num_rows).each do |row|
      (1..ws.num_cols).each do |col|
        p ws[row, col]
      end
    end
    
    # Yet another way to do so.
    p ws.rows  #==> [["fuga", ""], ["foo", "bar]]
    
    # Reloads the worksheet to get changes by other clients.
    ws.reload
  end
  
  def save_as_CSV
    CSV.open("db/emails.csv", "w") do |csv|
      @data.to_a.each { |item| csv << item }
      puts "The data is saved as CSV"
    end
  end
end