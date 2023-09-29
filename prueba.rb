require 'rest-client'
require 'json'
require_relative 'helpers/date'
require_relative 'helpers/html'

URL_BASE = 'https://www.buda.com/api/v2'

# Get the IDs of the transactional markets
def getMarkets
  begin
    res = RestClient.get("#{URL_BASE}/markets")
    return JSON.parse(res)['markets'].map { |market| market['id'] }
  rescue RestClient::ExceptionWithResponse => e
    if e.response
      e_message = JSON.parse(e.response)["message"]
      puts "Error in the markets API call: #{e_message}"
    else
      puts "Generic error in the markets API call."
    end
  rescue JSON::ParserError => e
    puts "Error processing markets API response as JSON: #{e.message}"
  rescue => e
    puts "An unknown error occurred in the markets API: #{e}"
  end
end

# Gets the transactions of a market in the last 24 hours
def getTransactionsAndValue24h(market)
  begin
    res = RestClient.get("#{URL_BASE}/markets/#{market}/trades?timestamp=#{timestampDayAgo}&limit=100")
    entries = JSON.parse(res)['trades']['entries']
    return entries.map { |transaction| {
      timestamp: transaction[0].to_i,
      amount: transaction[1].to_f,
      price:  transaction[2].to_f,
      direction: transaction[3],
      value: transaction[1].to_f * transaction[2].to_f
    }}
  rescue RestClient::ExceptionWithResponse => e
    if e.response
      e_message = JSON.parse(e.response)["message"]
      puts "Error in the call to the trades API: #{e_message}"
    else
      puts "Generic error in the trades API call."
    end
  rescue JSON::ParserError => e
    puts "Error processing trades API response as JSON: #{e.message}"
  rescue => e
    puts "An unknown error occurred in the trades API: #{e}"
  end
end

# Get the highest value transaction in the last 24 hours
def getHighestTransaction24h(market)
  begin
    return getTransactionsAndValue24h(market).max_by { |transaction| transaction[:value] }
  rescue => e
    puts "Error obtaining the highest value transaction on the market #{market}: #{e}."
  end
end

# Get the highest value transaction in the last 24 hours of all markets
def getHighestTransactions24h
  begin
    return getMarkets.map { |market| [market, getHighestTransaction24h(market)] }.to_h
  rescue => e
    puts "Error getting the highest value transactions from all markets in the last 24 hours: #{e}."
  end
end

# Generate the HTML file with the information of the highest value transactions in the last 24 hours
def generateReport
  html_content = generateHTML(getHighestTransactions24h)
  begin
    File.write('highest_transactions_for_market.html', html_content)
    puts "File 'highest_transactions_for_market.html' successfully generated."
  rescue => e
    puts "Error generating file 'highest_transactions_for_market.html': #{e}."
  end
end

generateReport