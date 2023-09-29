# Get the IDs of the transactional markets
def getMarkets
  begin
    res = HTTPX.get("#{URL_BASE}/markets")
    if res.status != 200 then raise "Error in the markets API call: #{res} with status #{res.status}" end

    return JSON.parse(res)['markets'].map { |market| market['id'] }
  rescue => e
    puts "An unknown error occurred in the markets API: #{e}"
  end
end