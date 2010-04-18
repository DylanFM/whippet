sys: require("sys")
app: require("./vendor/call")

app.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "Custom error: no route matched."

app.get '/', -> 'index.html'

app.get /([^\/.]*)\.(css|js)/, -> "lib/${@[0]}.${@[1]}"

app.get /\/pages\/([^\/.]*)\.html/, -> "content/${@[0]}.html"
