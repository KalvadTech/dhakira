require "mime"

class Loadr
  def initialize()
    @mem = Hash(String, Hash(String, String)).new
  end

  def load_file(path)
    mime_type = MIME.from_filename(path)
    content = File.open(path) do |file|
      file.gets_to_end
    end
    cleaned_path = path.split("/")
    short_cleaned_path = cleaned_path.skip(2).join("/")
    Log.info {"Loading: #{short_cleaned_path}"}
    @mem[short_cleaned_path] = {"mime_type" => mime_type, "content" => content}
  end

  def mem
    @mem
  end
end
