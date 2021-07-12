Apipie.configure do |config|
  config.app_name                = "RailsTask"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apidoc"
  config.validate                = false 
  config.translate               = false
  config.validate_value          = false

  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.default_version = "1.0"
  config.app_info = "
    == RailsTask API Document & Standards

    There are two types of responses:

    === Success Response format would be
     
      {
        message: 'All Events information.'
         data: [
          {
            id: 1,
            name: 'ReleaseEvent',
            public: true,
            repository: 'Repo_one',
            user: 'user_one',
            created_time: '2021-07-10T12:50:08.964+05:30'
          },
          {
            id: 2,
            name: 'WatchEvent',
            public: true,
            repository: 'Repo_two',
            user: 'user_two',
            created_time: '2021-07-11T11:47:13.921+05:30'
          },
          ----
        ] 
      }

    === Error Response format would be

      response: {
        message: 'repository_id : field required'
      }

    === HTTP Status Code

      HTTP_STATUS_CODE_200 = 200 # success response
      HTTP_STATUS_CODE_400 = 400 # Bad Request(<name of parameter> is missing. & <name of parameter> is not a valid data to process.)
      HTTP_STATUS_CODE_401 = 401 # Authentication failed
      HTTP_STATUS_CODE_403 = 403 # Exception found error
      HTTP_STATUS_CODE_404 = 404 # Record not found with given id
      HTTP_STATUS_CODE_610 = 610 # Events not exists
      HTTP_STATUS_CODE_611 = 611 # Repo does't have any events.
      HTTP_STATUS_CODE_612 = 612 # Repos not exists
      HTTP_STATUS_CODE_613 = 613 # users nost exits
  "

  config.authenticate = Proc.new do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'Admin' && password == 'Pass@123'
    end
  end
end

