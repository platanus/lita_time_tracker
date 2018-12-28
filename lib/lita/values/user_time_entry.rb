class UserTimeEntry
  attr_reader :owner, :user_name, :user_email, :project_name, :description, :active, :time_elapsed

  def initialize(data)
    @user_name = safe_value(data[:user_name])
    @user_email = safe_value(data[:user_email])
    @owner = user_name || user_email
    @project_name = safe_value(data[:project_name])
    @description = safe_value(data[:description])
    @time_elapsed = safe_value(data[:time_elapsed])
    @active = safe_value(data[:is_active])
  end

  def active?
    !!@active
  end

  def inactive?
    !@active
  end

  def owned_by?(identifier)
    normalize_string(owner).include?(normalize_string(identifier))
  end

  def safe_value(value)
    return if value.to_s.strip == ""
    value
  end

  private

  def normalize_string(value)
    value.to_s.gsub(/[^0-9A-Z]/i, '').downcase
  end
end
