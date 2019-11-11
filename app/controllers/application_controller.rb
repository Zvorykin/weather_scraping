class ApplicationController < ActionController::Base
  include Api::V1::ApiError
  include Api::V1::CheckServiceResult

  skip_before_action :verify_authenticity_token
end
