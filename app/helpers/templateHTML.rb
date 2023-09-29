# Get the HTML template
def getTemplateHTML(routeTemplateHTML)
  begin
    return ERB.new(File.read(routeTemplateHTML))
  rescue => e
    puts "Error obtaining the HTML template: #{e}."
  end
end