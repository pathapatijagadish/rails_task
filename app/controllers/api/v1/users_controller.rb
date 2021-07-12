class Api::V1::UsersController < ApplicationController
	api :GET, "/users", "Get list of all users"
  desc "Content for display users page"

  example "
    Success response parameters:
    {
      message: 'List of users',
      data: [
        {
          id: 1,
          name: 'FirstUser',
          email: 'first_user@gmail.com',
          created_at: '2021-07-11T18:52:59.943Z',
          updated_at: '2021-07-11T18:52:59.943Z'
        },
        {
          id: 2,
          name: 'SecondUser',
          email: 'second_user@gmail.com',
          created_at: '2021-07-11T18:52:59.958Z',
          updated_at: '2021-07-11T18:52:59.958Z'
        }
      ]
    }
    
    Error messages with http status code:
    403: Exception found error
    613: users not exists
  "

  def index
    begin
      @users = User.all
      if @users.present?
        success(@users, I18n.t("users.success.users_list"))
      else    
      	error(I18n.t("users.errors.no_users"), HTTP_STATUS_CODE_613)
      end
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
  end
end
