class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  def format_result(status = nil, payload = {})
    [status, payload]
  end

  def check_service_result(result)
    return unless result.is_a?(Array)

    status, payload = result

    raise(payload) if status.present? && status != :ok
    nil
  end
end
