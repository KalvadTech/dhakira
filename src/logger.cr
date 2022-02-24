class MyCustomLogger < Kemal::BaseLogHandler
  # This is run for each request. You can access the request/response context with `context`.
  def initialize(@io : IO = STDOUT)
  end

  def call(context)
    elapsed_time = Time.measure { call_next(context) }
    elapsed_text = elapsed_text(elapsed_time)
    ip = context.request.remote_address
    if context.request.headers.has_key?("X-Forwarded-For")
      ip = context.request.headers["X-Forwarded-For"]
    end
    @io << ip << " "
    @io << "[" << Time.utc << "] "
    @io << " \"" << context.request.method << ' ' << context.request.hostname << context.request.resource << "\" "
    @io << context.response.status_code << ' ' << context.request.content_length
    @io << ' ' << elapsed_text << '\n'
    @io.flush
    context
  end

  def write(message)
    @io << message
    @io.flush
    @io
  end

  private def elapsed_text(elapsed)
    millis = elapsed.total_milliseconds
    return "#{millis.round(2)}ms" if millis >= 1

    "#{(millis * 1000).round(2)}µs"
  end
end
