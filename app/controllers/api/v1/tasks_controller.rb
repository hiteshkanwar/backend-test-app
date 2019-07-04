require 'roo'
class Api::V1::TasksController < ApplicationController
	def index
		file = File.join(Rails.root,  'public/table.xlsx')
     	@xlsx = Roo::Spreadsheet.open(file)
     	render json: {
     		status: true,
	        data: @xlsx,
	      }
	end

	def create 
		isUpload = convert_data_url_to_image(params[:file], 'public/table.xlsx') rescue false
		if isUpload == true
			render json: {
     		status: true,
	        message: "successfully uploaded",
	      }
		else
			render json: {
     		status: true,
	        message: "Error in uplaoding",
	      }
		end	
	end

	def convert_data_url_to_image(data_url, file_path)
    split_data = splitBase64(data_url)
    file_path = "#{file_path}"
    imageDataString = split_data[:data]
    imageDataBinary = Base64.decode64(imageDataString)
    File.open("#{file_path}", "wb") { |f| f.write(imageDataBinary) }
    return true
  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
       return {
        :type => $1,
        :encoder =>$2,
        :data => $3,
        :extension =>'xlsx'
        }
    end
  end

end
