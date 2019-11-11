module Api::V1::CheckServiceResult
  extend ActiveSupport::Concern

  def check_service_result(result)
    return unless result.is_a?(Array)

    status, payload = result

    api_error(status, payload) if status.present? && status != :ok
    nil
  end
end
