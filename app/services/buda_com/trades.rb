# Gets the transactions of a market
def getTransactionsAndValueInTime(market, timestamp)
  begin
    res = HTTPX.get("#{URL_BASE}/markets/#{market}/trades?timestamp=#{timestamp}&limit=100")
    if res.status != 200 then raise "Error in the call to the trades API: #{res} with status #{res.status}" end

    # Create a archive database/buda_com/cache/ if not exist
    Dir.mkdir(File.join(__dir__, '..', '..', 'database')) unless Dir.exist?(File.join(__dir__, '..', '..', 'database'))
    Dir.mkdir(File.join(__dir__, '..', '..', 'database', 'buda_com')) unless Dir.exist?(File.join(__dir__, '..', '..', 'database', 'buda_com'))
    Dir.mkdir(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache')) unless Dir.exist?(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache'))
    # Create a json file with the last response from the API
    File.open(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', "#{market}.json"), 'w') { |file| file.write(res.to_s) }
    entries = JSON.parse(res)['trades']['entries']
    return entries.map { |transaction| {
      timestamp: transaction[0].to_i,
      amount: transaction[1].to_f,
      price:  transaction[2].to_f,
      direction: transaction[3],
      value: transaction[1].to_f * transaction[2].to_f
    }}
  rescue => e
    # If service is down, the app will continue to work with the last response from the API
    if File.exist?(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', "#{market}.json")) then
      puts "An unknown error occurred in the trades API: #{e} - Using the last response from the API."
      entries = JSON.parse(File.read(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', "#{market}.json")))['trades']['entries']
      return entries.map { |transaction| {
        timestamp: transaction[0].to_i,
        amount: transaction[1].to_f,
        price:  transaction[2].to_f,
        direction: transaction[3],
        value: transaction[1].to_f * transaction[2].to_f
      }}
    end

    # If service is down, the app will continue to work with data mocked in the file app/mocks/trades/#{market}.json
    puts "An unknown error occurred in the trades API: #{e} - Using mocked data."
    entries = JSON.parse(File.read(File.join(__dir__, '..', '..', 'mocks', 'buda_com', 'trades', "#{market}.json")))['trades']['entries']
    return entries.map { |transaction| {
      timestamp: transaction[0].to_i,
      amount: transaction[1].to_f,
      price:  transaction[2].to_f,
      direction: transaction[3],
      value: transaction[1].to_f * transaction[2].to_f
    }}
  end
end