Resque.logger = Logger.new("log/resque_log_file.log")
class CreateVideo
  @queue = :create_video
  def self.perform(project_id)
    Resque.logger.info "Generating video for project id: #{project_id}" 
    project = Project.find(project_id)
    video_output_path = project.video_output_path
    Resque.logger.info "video output: #{video_output_path}" 
    File.delete project.video_output_path if File.exists? video_output_path
    Dir.foreach(Dir.pwd) do |img|
      `convert -antialias -delay 25 '#{img}' #{img.split(/\.png$/).first}.mpeg`
    end
    `cat *.mpeg | ffmpeg -y -i - #{video_output_path}`
    `rm -f *.mpeg`
  rescue
    Resque.logger.info "Error: #{$!}"
    Resque.logger.info "StackTRACE: #{$@.join("\n")}"
  end
end
