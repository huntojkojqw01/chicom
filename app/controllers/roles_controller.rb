class RolesController < ApplicationController
  def index
    @roles = Role.all
  end

  def create
    if params[:file]
      bulk_create
    elsif params[:role]
      once_create
    else
      redirect_to roles_path
    end
  end

  def update
    @role = Role.find_by(id: params[:id])
    respond_to do |format|
      if  @role.update(role_params)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    if params[:ids]     
      Role.where(id: params[:ids]).destroy_all      
      respond_to do |format|
        format.json { render json: { status: 'OK' } }
      end
    else
      role = Role.find_by(id: params[:id])
      role.destroy if role
    end
  end

  private
  
  def role_params
    params.require(:role).permit(:code, :name, :rank)
  end

  def bulk_create
    if File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to roles_path
    else
      begin
        Role.transaction do
          Role.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to roles_path
      end
    end
  end

  def once_create
    @role = Role.new(role_params)
    respond_to do |format|
      if  @role.save
        format.js
      else
        format.js
      end
    end
  end
end
