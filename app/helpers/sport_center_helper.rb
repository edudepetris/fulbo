module SportCenterHelper

def prof_avatar(profile,size)
    image_tag profile.avatar_url(size)
end	

 def rem_avatar_section(form)
    if @sport_center.avatar.url.present?
      check_box = form.check_box :remove_avatar
      label     = form.label :remove_avatar, I18n.t("user_profile.remove_avatar")
      content_tag :div, check_box + label, class: 'form-inline'
    end  
 end

def avatar_2(form, profile)
    form.label :avatar, :class => "img-polaroid pull-right" do
    image_tag(@sport_center.avatar_url(:thumb)) if @sport_center.avatar?
    end
 end

end