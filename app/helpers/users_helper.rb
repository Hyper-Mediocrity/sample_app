module UsersHelper
  def gravatar_for(user, options = { :size => 50 } ) # default value for options
    gravatar_image_tag(user.email.downcase, # gravatar is case-sensitive
                       :alt => user.name,
                       :class => "gravatar",
                       :gravatar => options) 
  end
end
