require 'date'

# Get the date from one day ago in UNIX timestamp in milliseconds
def timestampDayAgo
  return (Date.today - 1).to_time.to_i * 1000
end