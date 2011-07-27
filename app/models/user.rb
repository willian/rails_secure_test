class User < ActiveRecord::Base
  attr_accessor :service_name, :service_uid, :service_uname, :service_uemail, :remember_me
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :name, :email, :presence => true
  validates :email, :uniqueness => true
  permalink :name, :to_param => :permalink
  has_many :services, :class_name => "UserService"

  after_create :create_an_user_service
  before_create { generate_token(:auth_token) }

  def self.find_by_omniauth(auth)
    user_service = UserService.where(:name => auth["provider"], :uid => auth["uid"]).first
    if user_service
      user = user_service.user
    else
      omniauth_email = nil
      if auth["user_info"] && auth["user_info"]["email"]
        omniauth_email = auth["user_info"]["email"]
      elsif auth["extra"]["user_hash"] && auth["extra"]["user_hash"]["email"]
        omniauth_email = auth["extra"]["user_hash"]["email"]
      end

      user = User.find_by_email(omniauth_email) if omniauth_email
      user ||= create_with_omniauth(auth)
    end
    user
  end

  def create_an_user_service
    if service_name && service_uid
      unless self.services.where(:name => service_name, :uid => service_uid).first
        self.services.create({
          :name => service_name,
          :uid => service_uid,
          :uname => service_uname,
          :uemail => service_uemail
        })
      end
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private

  def self.create_with_omniauth(auth)
    user_password = generate_password

    user = User.new({
      :service_name => auth["provider"],
      :service_uid => auth["uid"],
      :password => user_password,
      :password_confirmation => user_password
    })

    if auth["user_info"]
      if auth["user_info"]["name"] # Twitter, Google, Yahoo, GitHub
        user.name = auth["user_info"]["name"]
        user.service_uname = auth["user_info"]["name"]
      end

      if auth["user_info"]["email"] # Google, Yahoo, GitHub
        user.email = auth["user_info"]["email"]
        user.service_uemail = auth["user_info"]["email"]
      end
    end

    if auth["extra"]["user_hash"]
      if auth["extra"]["user_hash"]["name"] # Facebook
        user.name = auth["extra"]["user_hash"]["name"]
        user.service_uname = auth["extra"]["user_hash"]["name"]
      end

      if auth["extra"]["user_hash"]["email"] # Facebook
        user.email = auth["extra"]["user_hash"]["email"]
        user.service_uemail = auth["extra"]["user_hash"]["email"]
      end
    end

    if user.valid?
      user.save
    end

    user
  end

  def self.generate_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a
    chars_count = chars.size
    password_chars = []
    8.times { password_chars << chars[rand(chars_count)] }
    password_chars.join
  end
end
