sys: require("sys")
app: require("./vendor/whippet")

# Set up routing
app.get "/", -> "index.html"
app.get /\/pages\/([^\/.]*)\.html/, -> "content/${@[0]}.html"

app.get /([^\/.]*)\.(css|js)/, ->
  file: @[0]
  ext: @[1]
  path: if ext is "css" then "stylesheets" else "javascripts"
  "${path}/${file}.${ext}"

app.get /([^\/.]*)\.jpg/, -> "images/${@[0]}.jpg"
