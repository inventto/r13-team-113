UPLOADS_DIR =  if Rails.env.production?
                 "/var/www/apps/railsrumble/shared/images/uploads"
               else
                 Rails.root.join("public","images", "uploads")
               end
