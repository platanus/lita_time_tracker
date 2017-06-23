class UserTimeEntry
  attr_reader :owner, :user_name, :user_email, :project_name, :description, :active, :started_at

  def initialize(data)
    @data = data
    @user_name = safe_value(:user_name)
    @user_email = safe_value(:user_email)
    @owner = user_name || user_email
    @project_name = safe_value(:project_name)
    @description = safe_value(:description)
    @started_at = safe_value(:started_at)
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

  def safe_value(attribute)
    return if @data[attribute].to_s.strip == ""
    @data[attribute]
  end

  private

  def normalize_string(value)
    value.to_s.gsub(/[^0-9A-Z]/i, '').downcase
  end
end
