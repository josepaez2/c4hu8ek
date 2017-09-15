class Pin < ActiveRecord::Base
  belongs_to :user
  # id, user_id, title, created_at, updated_at, image_url
end
