# Gets the transactions of a market
def getTransactionsAndValueInTime(market, timestamp)
  begin
    res = HTTPX.get("#{URL_BASE}/markets/#{market}/trades?timestamp=#{timestamp}&limit=100")
    if res.status != 200 then raise "Error in the call to the trades API: #{res} with status #{res.status}" end

    entries = JSON.parse(res)['trades']['entries']
    return entries.map { |transaction| {
      timestamp: transaction[0].to_i,
      amount: transaction[1].to_f,
      price:  transaction[2].to_f,
      direction: transaction[3],
      value: transaction[1].to_f * transaction[2].to_f
    }}
  rescue => e
    puts "An unknown error occurred in the trades API: #{e} - Using mocked data."
    # If service is down, the app will continue to work with data mocked in the file app/mocks/trades/#{market}.json
    entries = JSON.parse(File.read(File.join(__dir__, '..', '..', 'mocks', 'trades', "#{market}.json")))['trades']['entries']
    return entries.map { |transaction| {
      timestamp: transaction[0].to_i,
      amount: transaction[1].to_f,
      price:  transaction[2].to_f,
      direction: transaction[3],
      value: transaction[1].to_f * transaction[2].to_f
    }}
  end
end