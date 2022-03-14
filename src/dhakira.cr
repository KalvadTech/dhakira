require "kemal"
require "log"
require "./globr"
require "./loadr"
require "./logger"

Kemal.config.logger = DhakiraLogger.new
Kemal.config.env = "production"

if Dir.exists?("dhakira_html") == false
  Log.error { "No ./dhakira_html folder" }
  exit(status = 1)
end

if Dir.exists?("dhakira_html/websites") == false && Dir.exists?("dhakira_html/spas") == false
  Log.error { "No websites or SPAs to load" }
  exit(status = 1)
end

websites = [] of String
spas = [] of String

if Dir.exists?("dhakira_html/websites") == true
  to_load = Dir.glob("dhakira_html/websites/**", match_hidden: false)
  i = 0
  while i < to_load.size
    websites << to_load[i].split("/")[2]
    i += 1
  end
end

if Dir.exists?("dhakira_html/spas") == true
  to_load = Dir.glob("dhakira_html/spas/**", match_hidden: false)
  i = 0
  while i < to_load.size
    spas << to_load[i].split("/")[2]
    i += 1
  end
end

# Load files in memory
globr = Globr.new
globr.ls("dhakira_html")
loadr = Loadr.new
i = 0
while i < globr.file_list.size
  loadr.load_file(globr.file_list[i])
  i += 1
end

get "/*path" do |env|
  host = env.request.hostname
  request_headers = env.request.headers
  gzip = false
  if env.request.headers.includes_word?("Accept-Encoding", "gzip")
    gzip = true
    env.response.headers["Content-Encoding"] = "gzip"
  end
  path = env.params.url["path"]
  if path == ""
    path = "index.html"
  end
  if websites.index(host) != nil
    short_path = "#{host}/#{path}"
    begin
      env.response.headers["Content-Type"] = loadr.mem[short_path]["mime_type"]
      if gzip == true
        loadr.mem[short_path]["gzip_content"]
      else
        loadr.mem[short_path]["content"]
      end
    rescue
      halt env, status_code: 404, response: "Not Found"
    end
  elsif spas.index(host) != nil
    short_path = "#{host}/#{path}"
    begin
      env.response.headers["Content-Type"] = loadr.mem[short_path]["mime_type"]
      if gzip == true
        loadr.mem[short_path]["gzip_content"]
      else
        loadr.mem[short_path]["content"]
      end
    rescue
      short_path = "#{host}/index.html"
      env.response.headers["Content-Type"] = loadr.mem[short_path]["mime_type"]
      if gzip == true
        loadr.mem[short_path]["gzip_content"]
      else
        loadr.mem[short_path]["content"]
      end
    end
  else
    halt env, status_code: 404, response: "Not Found"
  end
end

Kemal.run
