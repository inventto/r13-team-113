json.array!(@projects) do |project|
  json.extract! project, :name, :url
  json.url project_url(project, format: :json)
end
