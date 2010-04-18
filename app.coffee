sys: require("sys")
app: require("./vendor/call")

app.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

app.get '/', -> 'index.html'

app.get '/stylesheets/main.css', -> 'lib/main.css'

app.get '/javascripts/jquery.js', -> 'lib/jquery.js'

app.get '/javascripts/coffee-script.js', -> 'lib/coffee-script.js'
