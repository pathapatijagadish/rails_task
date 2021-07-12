class Event < ApplicationRecord
	belongs_to :user, class_name: "User", foreign_key: :actor_id
	belongs_to :repository
	enum event_type: [ "PushEvent", "ReleaseEvent", "WatchEvent" ]

	# handled below validation in controller level
	# validates :event_type, inclusion: { in: Event.event_types.keys }
end
