class Api::V1::RepositoriesController < ApplicationController
	api :GET, "/repositories", "Get list of all repos"
  desc "Content for display repos page"

  example "
    Success response parameters:
    {
      message: 'List of Repos',
      data: [
        {
          id: 1,
          name: 'FirstRepo',
          created_at: '2021-07-11T18:52:59.982Z',
          updated_at: '2021-07-11T18:52:59.982Z'
        },
        {
          id: 2,
          name: 'SecondRepo',
          created_at: '2021-07-11T18:53:00.018Z',
          updated_at: '2021-07-11T18:53:00.018Z'
        }
      ]
    }
    
    Error messages with http status code:
    403: Exception found error
    612: Repos not exists
  "

  def index
    begin
      @repos = Repository.all
      if @repos.present?
        success(@repos, I18n.t("repos.success.repos_list"))
      else    
      	error(I18n.t("repos.errors.no_repos"), HTTP_STATUS_CODE_612)
      end
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
  end
end
