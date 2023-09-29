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
    markets = getMarkets
    if markets.nil? then raise "Error obtaining the markets." end

    highestTransactions24h = markets.map { |market| [market, getTransactionsAndValueInTime(market, timestampDayAgo).max_by { |transaction| transaction[:value] }] }.to_h
    if highestTransactions24h.nil? then raise "Error obtaining the highest value transactions in the last 24 hours." end

    return highestTransactions24h
  rescue => e
    puts "Error getting the highest value transactions from all markets in the last 24 hours: #{e}."
  end
end

# Generate the HTML file with the information of the highest value transactions in the last 24 hours
def generateReport
  rootRouteFiles = __dir__
  routeTemplateHTML = File.join(rootRouteFiles, 'views', 'index.erb')

  highest_transactions = getHighestTransactions24h
  html_content = getTemplateHTML(routeTemplateHTML).result(binding)
  route_html = File.join(rootRouteFiles, 'public' , 'index.html')
  begin
    File.write(route_html, html_content)
    puts "File 'index.html' successfully generated."
  rescue => e
    puts "Error generating file 'index.html': #{e}."
  end
end