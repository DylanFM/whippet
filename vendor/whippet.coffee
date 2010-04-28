fs: require("fs")
http: require("http")
sys: require("sys")
url: require("url")

ContentTypes: {
  'css': "text/css"
  'html': "text/html"
  'js': "text/javascript",
  'jpg': "image/jpeg"
}

exports.routes: {}

exports.get: (path, callback) ->
  exports.routes[path] ||= {
    callback: callback,
    regexp: path
  }

# Create the server
http.createServer((req, res) ->

  try
    path: url.parse(req.url).pathname
    segments: []
    filepath: undefined

    if path in exports.routes
      filepath: exports.routes[path].callback()
    else
      for route, info of exports.routes
        if typeof(info.regexp) is "function"
          segments: path.match(info.regexp)
          if segments?
            segments.shift()
            filepath: exports.routes[route].callback.apply(segments)

    throw new Error "404" if !filepath

    file: fs.readFileSync filepath, "binary"
    if file?
      headers: {
        'Content-Type': (ContentTypes[filepath.match(/(.*)\.(.+)/)[2]] || ContentTypes['html']),
        'Content-Length': (file.length || 0)
      }
      # Output to client
      res.writeHead 200, headers
      res.write file, "binary"
      res.end()
      sys.puts "Requested: ${path}; Served: ${filepath} with content-type ${headers['Content-Type']}"
    else
      throw new Error "404"

  catch e
    res.writeHead 404, {'Content-Type': 'text/html'}
    res.write e.message
    res.end()
    sys.puts "!! Requested: ${path}; Error: ${e.message}"

).listen 5678, 'localhost'

sys.puts "Listening on port 5678"
