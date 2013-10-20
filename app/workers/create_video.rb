class CreateVideo
  @queue = :create_video
  def self.perform(project_id)
    project = Project.find(project_id)
    video_output_path = project.video_output_path
    File.delete project.video_output_path if File.exists? video_output_path
    `ffmpeg -y -r 1 -pattern_type glob -i '#{File.join(project.dir, "*.png")}' -c:v libx264 -pix_fmt yuv420p #{video_output_path}` 
  end
end
