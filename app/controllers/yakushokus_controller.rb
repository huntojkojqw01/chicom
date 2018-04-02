class YakushokusController < ApplicationController
  def index
    @yakushokus = Yakushoku.all
  end

  def create
    if params[:file]
      bulk_create
    elsif params[:yakushoku]
      once_create
    else
      redirect_to yakushokus_path
    end
  end

  def update
    @yakushoku = Yakushoku.find_by(id: params[:id])
    respond_to do |format|
      if  @yakushoku.update(yakushoku_params)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    if params[:ids]     
      Yakushoku.where(id: params[:ids]).destroy_all      
      respond_to do |format|
        format.json { render json: { status: 'OK' } }
      end
    else
      yakushoku = Yakushoku.find_by(id: params[:id])
      yakushoku.destroy if yakushoku
    end
  end

  private
  
  def yakushoku_params
    params.require(:yakushoku).permit(:code, :name)
  end

  def bulk_create
    if File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to yakushokus_path
    else
      begin
        Yakushoku.transaction do
          Yakushoku.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to yakushokus_path
      end
    end
  end

  def once_create
    @yakushoku = Yakushoku.new(yakushoku_params)
    respond_to do |format|
      if  @yakushoku.save
        format.js
      else
        format.js
      end
    end
  end
end
