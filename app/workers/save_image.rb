Resque.logger = Logger.new("log/resque_log_file.log")
class SaveImage
  @queue = :save_image
  def self.perform(project_id, image, thumb)
    Resque.logger.info "Saving image for project id: #{project_id}" 
    begin
      project = Project.find project_id
      image = project.images.create filename: "#{ project.images.count + 1 }.png"
      image_file = File.join(image.project.dir, image.filename)
      File.open(image_file, 'wb') do |f|
        f.write(image)
      end
      thumb_file = File.join(image.project.thumbs_dir, image.filename)
      File.open(thumb_file, 'wb') do |f|
        f.write(thumb)
      end
    rescue
      Resque.logger.info "Error: #{$!}"
      Resque.logger.info "StackTRACE: #{$@.join("\n")}"
    end
  end
end
