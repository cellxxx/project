json.extract! comment, :id, :username, :content, :created_at, :updated_at
json.url comment_url(comment, format: :json)
