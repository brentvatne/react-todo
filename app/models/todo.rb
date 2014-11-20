class Todo < ActiveRecord::Base
  scope :completed, -> { where(complete: true) }
end
