# Get the IDs of the transactional markets
def getMarkets
  begin
    res = HTTPX.get("#{URL_BASE}/markets")
    if res.status != 200 then raise "Error in the markets API call: #{res} with status #{res.status}" end

    # Create a json file with the last response from the API
    File.open(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', 'markets.json'), 'w') { |file| file.write(res.to_s) }
    return JSON.parse(res)['markets'].map { |market| market['id'] }
  rescue => e
    # If service is down, the app will continue to work with the last response from the API
    if File.exist?(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', 'markets.json')) then
      puts "An unknown error occurred in the markets API: #{e} - Using the last response from the API."
      return JSON.parse(File.read(File.join(__dir__, '..', '..', 'database', 'buda_com', 'cache', 'markets.json')))['markets'].map { |market| market['id'] }
    end
    # If service is down, the app will continue to work with data mocked in the file app/mocks/markets.json
    puts "An unknown error occurred in the markets API: #{e} - Using mocked data."
    return JSON.parse(File.read(File.join(__dir__, '..', '..', 'mocks', 'buda_com', 'markets.json')))['markets'].map { |market| market['id'] }
  end
end