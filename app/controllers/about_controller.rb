class AboutController < ApplicationController
  def index
    @about = About.first
  end
  
  def show

  end

  def new
    if About.first.blank?
      @about = About.new
    else
      redirect_to about_path
    end
  end

  def create
    @about = About.new(about_params)
    if @about.save
      redirect_to about_path
    else
      render 'new'
    end
  end

  def edit
    @about = About.first
  end

  def update
    @about = About.first
    if @about.update_attributes(about_params)
      redirect_to about_path
    else
      render 'edit'
    end
  end

  private
  def about_params
    params.require(:about).permit(:body)
  end

end
