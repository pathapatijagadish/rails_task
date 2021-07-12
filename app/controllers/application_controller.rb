class ApplicationController < ActionController::API

	HTTP_STATUS_CODE_200 = 200 # success response
  HTTP_STATUS_CODE_400 = 400 # Bad Request(<name of parameter> is missing. & <name of parameter> is not a valid data to process.)
  HTTP_STATUS_CODE_401 = 401 # Authentication failed
  HTTP_STATUS_CODE_403 = 403 # Exception found error
  HTTP_STATUS_CODE_404 = 404 # Record not found with given id

  HTTP_STATUS_CODE_610 = 610 # Events not exists
  HTTP_STATUS_CODE_611 = 611 # Repo does't have any events.
  HTTP_STATUS_CODE_612 = 612 # Repos not exists
  HTTP_STATUS_CODE_613 = 613 # users nost exits

  def check_required_params(required_params_list)
    missing_params_list = []
    required_params_list.each do |field|
      missing_params_list << field if !params[field].present?
    end
    return missing_params_list
  end

  # For success response from api
  def success(data, message)
    success_response = {
      message: message,
      data: data.present? ? data : {}
    }
    render :json => success_response, :status => HTTP_STATUS_CODE_200
  end

  # common for all errors based on http status code
  def error(message, code)
    error_response = {
      message: message
    }
    render :json => error_response, :status => code
  end
end
