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
        
        # If wants to change the image
        if form_params[:file]
            image_params[:file] = form_params[:file]
        end

        # Find latitude and longitude
        address = [form_params[:street], form_params[:city], form_params[:province], form_params[:country]].compact.join(', ')
        results = Geocoder.search(address)

        # Check if valid address
        if results.first != nil
            image_params[:address] = address
            image_params[:latitude] = results.first.coordinates[0]
            image_params[:longitude] = results.first.coordinates[1]
            image_params[:street] = form_params[:street]
            image_params[:city] = form_params[:city]
            image_params[:province] = form_params[:province]
            image_params[:country] = form_params[:country]
        else
            image_params[:address] = nil
            image_params[:latitude] = nil
            image_params[:longitude] = nil
            image_params[:street] = nil
            image_params[:city] = nil
            image_params[:province] = nil
            image_params[:country] = nil
        end

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
        params.require(:image).permit(:title, :privacy, :description, :street, :city, :province, :country, :file)
    end
end
