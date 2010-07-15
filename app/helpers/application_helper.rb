# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Return a title on a per-page basis.
    def title
	base_title = "zVault Cloud based Two Factor Authentication"
	if @title.nil?
		base_title
	else
		"#{base_title} | #{@title}"
	end
    end

    def logo
	image_tag("logo.png", :alt => "zVault App", :class => "round")
    end

end
