fs: require("fs")
http: require("http")
sys: require("sys")
url: require("url")

exports.routes: {}

exports.get: (path, callback) ->

  exports.routes[path] ||= {
    callback: callback,
    regexp: path
  }

exports.error: (res) ->
  res.writeHead 404, {'Content-Type': 'text/html'}
  res.write "No route matched."

# Create the server
http.createServer((req, res) ->

  try
    path: url.parse(req.url).pathname
    segments: []
    filepath: ""

    if path in exports.routes
      filepath: exports.routes[path].callback()
    else
      for route, info of exports.routes
        if typeof(info.regexp) is "function"
          segments: path.match(info.regexp)
          if segments?
            segments.shift()
            filepath: exports.routes[route].callback.apply(segments)

    if filepath

      file: fs.readFileSync filepath

      types: {
        css : "text/css"
        html: "text/html"
        js  : "text/javascript" }

      extension: filepath.match(/(.*)\.(.+)/)
      contentType: if extension? then types[extension[2]] else types.html

      if file?
        res.writeHead 200, {'Content-Type': contentType}
        res.write file
      else
        exports.error(res)
      sys.puts "Requested: ${path}; serving: ${filepath}"
      res.end()
    else
      throw new Error "404"
  catch e
    exports.error(res)
    res.end()
).listen 5678, 'localhost'

sys.puts "Listening on port 5678"
