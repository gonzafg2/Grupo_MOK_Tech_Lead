# Gems
require 'erb'
# Helpers
require_relative 'helpers/date'
require_relative 'helpers/templateHTML'
# External Services
require_relative 'services/buda_com/markets'
require_relative 'services/buda_com/trades'

URL_BASE = 'https://www.buda.com/api/v2'

# Get the highest value transaction in the last 24 hours of all markets
def getHighestTransactions24h
  begin
    # Only obtain the highest value transactions in the last 24 hours if has been more than 5 minutes since the last time it was obtained
    if File.exist?(File.join(__dir__, 'database', 'buda_com', 'cache', 'highest_transactions.json')) then
      lastTimeObtained = File.mtime(File.join(__dir__, 'database', 'buda_com', 'cache', 'highest_transactions.json'))
      if Time.now - lastTimeObtained < 5 * 60 then
        puts "The highest value transactions in the last 24 hours were obtained less than 5 minutes ago."
        return JSON.parse(File.read(File.join(__dir__, 'database', 'buda_com', 'cache', 'highest_transactions.json'))).map { |market, transaction| [market, transaction.transform_keys(&:to_sym)] }.to_h
      end
    end

    markets = getMarkets
    if markets.nil? then raise "Error obtaining the markets." end

    highestTransactions24h = markets.map { |market| [market, getTransactionsAndValueInTime(market, timestampDayAgo).max_by { |transaction| transaction[:value] }] }.to_h
    # Create a json file with the highest value transactions in the last 24 hours
    File.open(File.join(__dir__, 'database', 'buda_com', 'cache', 'highest_transactions.json'), 'w') { |file| file.write(highestTransactions24h.to_json) }
    if highestTransactions24h.nil? then raise "Error obtaining the highest value transactions in the last 24 hours." end
      

    return highestTransactions24h
  rescue => e
    puts "Error getting the highest value transactions from all markets in the last 24 hours: #{e}."
  end
end

# Generate the HTML file with the information of the highest value transactions in the last 24 hours
def generateReport
  routeTemplateHTML = File.join(__dir__, 'views', 'index.erb')

  highest_transactions = getHighestTransactions24h

  html_content = getTemplateHTML(routeTemplateHTML).result(binding)
  route_html = File.join(__dir__, 'public' , 'index.html')
  begin
    File.write(route_html, html_content)
    puts "File 'index.html' successfully generated."
  rescue => e
    puts "Error generating file 'index.html': #{e}."
  end
end