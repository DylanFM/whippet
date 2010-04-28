sys: require("sys")

app: require("./vendor/whippet")

app.get '/', -> 'index.html'

app.get '/image.jpg', -> 'image.jpg'

app.get /([^\/.]*)\.(css|js)/, -> "lib/${@[0]}.${@[1]}"

app.get /\/pages\/([^\/.]*)\.html/, -> "content/${@[0]}.html"
