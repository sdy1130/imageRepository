class ImagesController < ApplicationController

    def show
        @image = Image.find(params[:id])
        # Prevent users from accessing image that
        # is private and they don't own
        if @image.privacy && !(current_user && current_user.id == @image.user_id)
            redirect_to root_path, notice: 'You could not access the image.'
        end
    end

    def edit
        @image = Image.find(params[:id])
        if @image.privacy && !(current_user && current_user.id == @image.user_id)
            redirect_to root_path, notice: 'You could not access the image.'
        end
    end

    def update
        @image = Image.find(params[:id])
        image_params = form_params

        # Privacy = true if private, false if public
        if form_params[:privacy] == "private"
            image_params[:privacy] = true
        else
            image_params[:privacy] = false
        end

        if @image.update(image_params)
            redirect_to image_path(@image)
        else
            render 'edit'
        end
    end

    def destroy
        @image = Image.find(params[:id])
        @image.destroy

        redirect_to root_path
    end

    private
    def form_params
        params.require(:image).permit(:title, :privacy, :description, :file)
    end
end
