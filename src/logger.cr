class DhakiraLogger < Kemal::BaseLogHandler
  def initialize(@io : IO = STDOUT)
  end

  def call(context)
    elapsed_time = Time.measure { call_next(context) }
    if context.request.headers.has_key?("X-Forwarded-For")
      @io << context.request.headers["X-Forwarded-For"] << " "
    else
      @io << context.request.remote_address << " "
    end

    @io << "[" << Time.utc << "] "
    @io << " \"" << context.request.method << ' ' << context.request.hostname << context.request.resource << "\" "
    @io << context.response.status_code << ' ' << context.request.content_length
    @io << ' ' << "#{elapsed_time.total_milliseconds.round(3)}ms" << '\n'
    @io.flush
    context
  end

  def write(message)
    @io << message
    @io.flush
    @io
  end
end
