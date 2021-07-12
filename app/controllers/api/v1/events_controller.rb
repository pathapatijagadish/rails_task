class Api::V1::EventsController < ApplicationController

	api :GET, "/events", "Get list of all events"
  desc "Content for display events page"

  example "
    Success response parameters:
    {
      message: 'List of events',
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
        }
      ]
    }
    
    Error messages with http status code:
    403: Exception found error
    610: Events not exists
  "

  def index
    begin
      events = Event.include(:user, :repository).all
      if events.present?
        @events = events_info(events)
        success(@events, I18n.t("events.success.events_list"))
      else    
      	error(I18n.t("events.errors.no_events"), HTTP_STATUS_CODE_610)
      end
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
  end

  api :POST, '/events', "Event creation"

	param :event_type, Integer, "Event type of event (+0+ for PushEvent and +1+ for ReleaseEvent and +2+ for WatchEvent)", :required => true
	param :actor_id, Integer, "Id of the user", :required => true
	param :repository_id, Integer, "Id of the repository", :required => true
	param :public, [true, false], "Event visiblity access(+true+ for public and +false+ for private)", :required => true

	example "
    Success response parameters:
    {
      message: 'Event created successfully'
      data: {}
    }
    Error messages with http status code:
    400: event_type, actor_id, public, repository_id : required fields
    403: Exception found error
    404: Record not found with given id
	"

	def create
    begin
    	missing_params = check_required_params(['event_type', 'public', 'actor_id', 'repository_id'])
  		if missing_params.empty?
        is_type_valid = Event.event_types.values.include?(params[:event_type].to_i)
        is_user_valid = User.where(id: params[:actor_id]).exists?
        is_repo_valid = Repository.where(id: params[:repository_id]).exists?
        if is_type_valid && is_user_valid && is_repo_valid
          event = Event.create(
            event_type: params[:event_type].to_i,
            public: params[:public],
            actor_id: params[:actor_id].to_i,
            repository_id: params[:repository_id].to_i
          )
          success([], I18n.t("events.success.event_create"))
        else
          error(I18n.t("events.errors.invalid_user_repo_type"), HTTP_STATUS_CODE_404)
        end
    	else
      	error(missing_params.join(", ") + I18n.t("events.errors.required_fields"), HTTP_STATUS_CODE_400)
    	end
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
	end


  api :GET, "/events/:id", "Get Event details"

  param :id, Integer, "Event id pass in url like : '/events/1'", :required => true

  example "
    Success response parameters:
    {
      message: 'Event Details.'
      data: [
        {
            id: 1,
            event_type: 'ReleaseEvent',
            public: true,
            repository: 'Repo_two',
            user: 'user_two',
            created_time: '2021-07-11T11:47:13.921+05:30'
        }
      ]
    }
    Error messages with http status code:
    403: Exception found error
    404: Record not found with given id
  "

  def show
    begin
     	event = Event.find(params[:id])
      @event = events_info([event]).first
      success(@event, I18n.t("events.success.event_details"))
    rescue ActiveRecord::RecordNotFound
      error(I18n.t("events.errors.event_id_not_exist"), HTTP_STATUS_CODE_404)
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
  end

  api :GET, "/repos/:repo_id/events", "Get list of events for specific repo"

  param :repo_id, Integer, "repo_id pass in url like : '/repos/1/events'", :required => true

  example "
    Success response parameters:
    {
      message: 'Event Details.'
      data: [
        {
            id: 1,
            event_type: 'ReleaseEvent',
            public: true,
            repository_id: 'repo_one',
            actor_id: 'user_one',
            created_time: '2021-07-11T21:04:29.912+05:30'
        },
        {
            id: 2,
            event_type: 'PushEvent',
            public: false,
            repository_id: 'repo_two',
            actor_id: 'user_tow',
            created_time: '2021-07-11T21:04:29.912+05:30'
        }
      ]
    }
    Error messages with http status code:
    403: Exception found error
    404: Record not found with given id
    611: Repo does't have any events
  "

  def repository_events
    begin
     	repository = Repository.find(params[:id])
     	if repository.events.present?
        @event_details = events_info(repository.events)
        success(@event_details, I18n.t("events.success.repo_event_details")+ repository.name)
      else
        error(I18n.t("events.errors.no_repo_events"), HTTP_STATUS_CODE_611)
      end
    rescue ActiveRecord::RecordNotFound
      error(I18n.t("events.errors.repo_not_exists"), HTTP_STATUS_CODE_404)
    rescue Exception => e
      error(e.message, HTTP_STATUS_CODE_403)
    end
  end

  private

    def events_info(events)
      event_details = []
      events.each do |event|
        event_detail = {
          id: event.id,
          name: event.event_type,
          public: event.public,
          repository: event.repository.name,
          user: event.user.name,
          created_time: event.created_at.localtime
        }
        event_details << event_detail
      end
      return event_details
    end
end
