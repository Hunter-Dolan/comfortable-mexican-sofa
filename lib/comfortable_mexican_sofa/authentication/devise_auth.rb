module ComfortableMexicanSofa::DeviseAuth

  def authenticate
    if !current_user.nil? && current_user.admin?
      true
    else
      redirect_to :new_user_session, flash: [error: "You must be authenticated to view this page."]
    end
  end
  
end
