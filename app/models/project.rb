class Project < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_uniqueness_of :url
  validates_format_of :url, with: /^[a-z0-9\-_!]*$/m, multiline: true
end
