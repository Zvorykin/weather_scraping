module Api::V1::ApiError
  extend ActiveSupport::Concern

  private

  def api_error(status, message, details = nil)
    Rails.logger.info "================= API ERROR ================="
    Rails.logger.info "Status: #{status}"
    Rails.logger.info "Message: #{message}"
    Rails.logger.info "Details: #{details}"
    Rails.logger.info "============================================="

    if details
      render json: { error: message, details: details }, status: status
    else
      render json: { error: message }, status: status
    end

    false
  end
end
