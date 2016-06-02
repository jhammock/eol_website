class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter,
                                             :google_oauth2, :yahoo]
  
  has_many :open_authentications      
  
  validates :display_name, presence: true,length: {minimum: 4, maximum: 32}

  def after_confirmation
    self.update_attribute(:active, true)
  end

end