require "mime"
require "compress/gzip"

class Loadr
  def initialize
    @mem = Hash(String, Hash(String, String)).new
    MIME.register(".webmanifest", "application/json")
  end

  def load_file(path)
    mime_type = MIME.from_filename(path)
    content = File.read(path)
    cleaned_path = path.split("/")
    short_cleaned_path = cleaned_path.skip(2).join("/")

    File.open(path, "r") do |input_file|
      File.open("/tmp/dhakira.gzip", "w") do |output_file|
        Compress::Gzip::Writer.open(output_file) do |gzip|
          IO.copy(input_file, gzip)
        end
      end
    end

    gzip_content = File.read("/tmp/dhakira.gzip")

    Log.info { "Loading: #{short_cleaned_path}" }
    @mem[short_cleaned_path] = {"mime_type" => mime_type, "content" => content, "gzip_content" => gzip_content}
  end

  def mem
    @mem
  end
end
