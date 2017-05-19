class UserTimeEntry
  attr_accessor :owner, :user_name, :user_email, :project_name, :description, :active, :started_at

  def initialize(data)
    @user_name = data[:user_name]
    @user_email = data[:user_email]
    @owner = user_name || user_email
    @project_name = data[:project_name]
    @description = data[:description]
    @started_at = Time.at(data[:duration].to_i.abs) if data[:duration] && !data[:stop]
    @active = !!started_at
  end
end
