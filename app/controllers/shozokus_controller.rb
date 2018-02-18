class ShozokusController < ApplicationController
  def index
    @shozokus = Shozoku.all
  end

  def create
    if params[:file]
      bulk_create
    elsif params[:shozoku]
      once_create
    else
      redirect_to shozokus_path
    end
  end

  def update
    @shozoku = Shozoku.find_by(id: params[:id])
    respond_to do |format|
      if  @shozoku.update(shozoku_params)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    if params[:ids]     
      Shozoku.where(id: params[:ids]).destroy_all      
      respond_to do |format|
        format.json { render json: { status: 'OK' } }
      end
    else
      shozoku = Shozoku.find_by(id: params[:id])
      shozoku.destroy if shozoku
    end
  end

  private
  
  def shozoku_params
    params.require(:shozoku).permit(:code, :name)
  end

  def bulk_create
    if File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to shozokus_path
    else
      begin
        Shozoku.transaction do
          Shozoku.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to shozokus_path
      end
    end
  end

  def once_create
    @shozoku = Shozoku.new(shozoku_params)
    respond_to do |format|
      if  @shozoku.save
        format.js
      else
        format.js
      end
    end
  end
end