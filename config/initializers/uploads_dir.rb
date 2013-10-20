UPLOADS_DIR =  if Rails.env.production?
                 Rails.root.join("public","system", "uploads")
               else
                 Rails.root.join("public","images", "uploads")
               end
