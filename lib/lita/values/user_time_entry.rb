class UserTimeEntry
  attr_reader :owner, :user_name, :user_email, :project_name, :description, :active, :started_at

  def initialize(data)
    @user_name = data[:user_name]
    @user_email = data[:user_email]
    @owner = user_name || user_email
    @project_name = data[:project_name]
    @description = data[:description]
    @started_at = Time.at(data[:duration].to_i.abs) if data[:duration] && !data[:stop]
    @active = !!started_at
  end

  def active?
    !!active
  end

  def inactive?
    !active
  end

  def owned_by?(identifier)
    normalize_string(owner).include?(normalize_string(identifier))
  end

  private

  def normalize_string(value)
    value.to_s.gsub(/[^0-9A-Z]/i, '').downcase
  end
end
