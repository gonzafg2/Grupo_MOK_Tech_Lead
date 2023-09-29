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