require 'net/http'
require 'json'
require 'date'

URL_BASE = 'https://www.buda.com/api/v2'

# Get the date from one day ago in UNIX timestamp in milliseconds
def timestampDayAgo
  return (Date.today - 1).to_time.to_i * 1000
end

# Get the IDs of the transactional markets
def getMarkets
  uri = URI("#{URL_BASE}/markets")
  response = Net::HTTP.get(uri)
  return JSON.parse(response)['markets'].map { |market| market['id'] }
end

# Gets the transactions of a market in the last 24 hours
def getTransactionsAndValue24h(market)
  uri = URI("#{URL_BASE}/markets/#{market}/trades?timestamp=#{timestampDayAgo}&limit=100")
  res = Net::HTTP.get(uri)
  entries = JSON.parse(res)['trades']['entries']
  return entries.map { |transaction| {
    timestamp: transaction[0].to_i,
    amount: transaction[1].to_f,
    price:  transaction[2].to_f,
    direction: transaction[3],
    value: transaction[1].to_f * transaction[2].to_f
  }}
end

# Get the highest value transaction in the last 24 hours
def getHighestTransaction24h(market)
  transactions = getTransactionsAndValue24h(market)
  return transactions.max_by { |transaction| transaction[:value] }
end

# Get the highest value transaction in the last 24 hours of all markets
def getHighestTransactions24h
  markets = getMarkets
  return markets.map { |market| [market, getHighestTransaction24h(market)] }.to_h
end

# Generate the HTML file with the information of the highest value transactions in the last 24 hours
def generateReport
  highest_transactions = getHighestTransactions24h
  html_content = generateHTML(highest_transactions)
  File.write('highest_transactions.html', html_content)
  puts "Archivo 'highest_transactions.html' generado exitosamente."
end

# Generate the HTML with the information of the highest value transactions in the last 24 hours
def generateHTML(highest_transactions)
  <<~HTML
    <html>
      <head><title>Transacciones de Mayor Valor en Buda.com</title></head>
      <body>
        <h1>Transacciones de Mayor Valor en Buda.com (Últimas 24 horas)</h1>
        <ul>
          #{highest_transactions.map { |market, transaction|
            <<~HTML
              <li>
                <strong>Mercado:</strong> #{market}<br>
                <strong>Fecha:</strong> #{Time.at(transaction[:timestamp] / 1000)}<br>
                <strong>Monto:</strong> #{transaction[:amount]}<br>
                <strong>Precio:</strong> #{transaction[:price]}<br>
                <strong>Valor:</strong> #{transaction[:value].round(2)}<br>
              </li>
            HTML
          }.join("\n")}
        </ul>
      </body>
    </html>
  HTML
end

generateReport