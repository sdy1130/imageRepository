class PagesController < ApplicationController
  def home

    # Fetch public images
    @images = Image.where(privacy: false)

    # If user is logged in, fetch its images
    if current_user
      @images = @images + Image.where(user_id: current_user.id)
    end

    # Sort them by created time (newest -> oldest)
    @images = @images.sort_by(&:created_at).reverse.uniq
  end

  def new
    # New page should only be visible to logged
    # in users
    if current_user
      @image = Image.new
    else
      redirect_to new_user_session_path
    end
  end

  def create
    @image = Image.new

    # Validate uploading images
    if (!validate_image_present(page_params[:images]))
      @image.errors.add(:images, "are missing!")
      render 'new'
      return
    end

    if (!validate_image_type(page_params[:images]))
      @image.errors.add(:image, 'needs to be a JPEG or PNG')
      render 'new'
      return
    end

    image_params = {}
    image_params[:user_id] = current_user.id
    image_params[:description] = page_params[:description]

    # Privacy = true if private, false if public
    if page_params[:privacy] == "private"
      image_params[:privacy] = true
    else
      image_params[:privacy] = false
    end

    # Iterate through the attached images then
    # create Image object for every one of
    # them and save
    count = 0
    page_params[:images].each { |image|
      image_params[:file] = image
      image_params[:title] = page_params[:title]

      # If there are multiple images being uploaded at once,
      # append index to their name
      if page_params[:images].length() > 1
        count += 1
        image_params[:title] = image_params[:title] + " " + count.to_s
      end
      
      @image = Image.new(image_params)

      if !@image.save
        render 'new'
        return
      end
    }
    redirect_to root_path
  end

  private
    def page_params
      params.require(:page).permit(:title, :privacy, :description, images: [])
    end

    def validate_image_present(images)
        if images == nil
            return false
        end
        return true
    end

    def validate_image_type(images)
      images.each do |image|
        if !image.content_type.in?(%('image/jpeg image/png'))
            return false
        end
      end
      return true
    end
end