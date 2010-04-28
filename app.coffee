sys: require("sys")
app: require("./vendor/whippet")

# Set up routing
app.get '/', -> 'index.html'
app.get /\/pages\/([^\/.]*)\.html/, -> "content/${@[0]}.html"

app.get /([^\/.]*)\.css/, -> "stylesheets/${@[0]}.css"
app.get /([^\/.]*)\.js/, -> "javascripts/${@[0]}.js"

app.get '/image.jpg', -> 'image.jpg'
