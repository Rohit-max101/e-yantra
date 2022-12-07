defmodule Task1bNumberDetection do
@moduledoc """
  A module that implements functions for detecting numbers present in a grid in provided image
  """
  alias Evision, as: OpenCV

  # This function is used to read an image from a given file
  def get_img_ref(path) do
    {:ok, image} = OpenCV.imread(path)
    image
  end


  # This function is used to read an image
  # from a given file as grayscale
  def get_gray_img_ref(path) do
    OpenCV.imread!(path, flags: OpenCV.cv_IMREAD_GRAYSCALE)
  end


  # This is the most useful function which is
  # used to display the image
  def show(%Evision.Mat{channels: _, dims: _, raw_type: _, ref: image, shape: _, type: _}) do
    OpenCV.HighGui.imshow!("image",image)
    OpenCV.HighGui.waitkey!(7000)
    OpenCV.HighGui.destroyWindow!("image")
  end


  # This function is used to resize a given image
  def resize(image, width, height) do
    OpenCV.resize!(image, [_width = width, _height = height])
  end

  # The main function which reads the image as graysacale using "get_gray_img_ref" function
  # while cropping it as per sepcified dimensions using "crop" function
  # and displays it using "show" function
  def main do
    get_img_ref("images/grid_1.png") |> resize(400, 400) |> show
  end

  def crop(image_path,[startx,starty],[sizex,sizey]) do
       image_path
       |>get_gray_img_ref()
       |>OpenCV.Nx.to_nx!(Nx.BinaryBackend)
       |>Nx.slice([starty,startx],[sizey,sizex])
       |>OpenCV.Nx.to_mat!()
  end
  def crop_mat(image_mat,[startx,starty],[sizex,sizey]) do
       image_mat
       |>OpenCV.Nx.to_nx!(Nx.BinaryBackend)
       |>Nx.slice([starty,startx],[sizey,sizex])
       |>OpenCV.Nx.to_mat!()
  end
  def detect_list(path) do
       cropped_img = crop(path,[140,235],[800,800])
       {:ok,{_threshold, binary_img}} =
              cropped_img
              |> OpenCV.threshold(100, 255, OpenCV.cv_THRESH_BINARY)
    binary_image_tensor = OpenCV.Nx.to_nx!(binary_img,Nx.BinaryBackend)
    list_of_pixelvalue_of_top_row = Nx.to_flat_list(binary_image_tensor[0])
    list_of_pixelvalue_of_top_row_indexed = Enum.with_index(list_of_pixelvalue_of_top_row)
    list_of_blackpixels_with_index=  Enum.filter(list_of_pixelvalue_of_top_row_indexed,fn {x,_i} -> (x == 0) end)
    |>Enum.reject(fn {x,i} -> Enum.member?(list_of_pixelvalue_of_top_row_indexed, {x,i+1}) end)
    |>Enum.map(fn {_x,i} -> i end)
    coordinates_of_intersecting_points = [0] ++ list_of_blackpixels_with_index
    grid_size = length(coordinates_of_intersecting_points)
    origins = for x <- coordinates_of_intersecting_points,y <- coordinates_of_intersecting_points do
      [y+7,x+7]
    end
    cell_size = [Enum.at(coordinates_of_intersecting_points,1) - Enum.at(coordinates_of_intersecting_points,0),Enum.at(coordinates_of_intersecting_points,1) - Enum.at(coordinates_of_intersecting_points,0)]
    answer = for o <- origins do
        cropped_cell = crop_mat(binary_img,o,cell_size) |> resize(250,250)
       #  show(cropped_cell)
        OpenCV.imwrite!("temp.png",cropped_cell)
        num = TesseractOcr.read("temp.png",%{psm: 11,c: "tessedit_char_whitelist=0123456789"})
        if num == "" do
          _digit = "na"
        else
          _digit = num
        end
    end
    {grid_size,answer}
  end
  @doc """
  #Function name:
         identifyCellNumbers
  #Inputs:
         image  : Image path with name for which numbers are to be detected
  #Output:
         Matrix containing the numbers detected
  #Details:
         Function that takes single image as an argument and provides the matrix of detected numbers
  #Example call:

      iex(1)> Task1bNumberDetection.identifyCellNumbers("images/grid_1.png")
      [["22", "na", "na"], ["na", "na", "16"], ["na", "25", "na"]]
  """
  def identifyCellNumbers(image) do
       {grid_size,detected_list} = image|>detect_list()
       _answer_1 = for i <- 0..(grid_size-1) do
              _answer_2 = for j <- 0..(grid_size-1) do
                Enum.at(detected_list,j+(grid_size*i)) end
              end
  end


  @doc """
  #Function name:
         identifyCellNumbersWithLocations
  #Inputs:
         matrix  : matrix containing the detected numbers
  #Output:
         List containing tuple of detected number and it's location in the grid
  #Details:
         Function that takes matrix generated as an argument and provides list of tuple
  #Example call:

        iex(1)> matrix = Task1bNumberDetection.identifyCellNumbers("images/grid_1.png")
        [["22", "na", "na"], ["na", "na", "16"], ["na", "25", "na"]]
        iex(2)> Task1bNumberDetection.identifyCellNumbersWithLocations(matrix)
        [{"22", 1}, {"16", 6}, {"25", 8}]
  """
  def identifyCellNumbersWithLocations(matrix) do
       matrix
       |>List.flatten()
       |>Enum.with_index(1)
       |>Enum.filter(fn {x,_i} -> x != "na" end)
  end


  @doc """
  #Function name:
         driver
  #Inputs:
         path  : The path where all the provided images are present
  #Output:
         A final output with image name as well as the detected number and it's location in gird
  #Details:
         Driver functional which detects numbers from mutiple images provided
  #Note:
         DO NOT EDIT THIS FUNCTION
  #Example call:

      iex(1)> Task1bNumberDetection.driver("images/")
      [
        {"grid_1.png", [{"22", 1}, {"16", 6}, {"25", 8}]},
        {"grid_2.png", [{"13", 3}, {"27", 5}, {"20", 7}]},
        {"grid_3.png", [{"17", 3}, {"20", 4}, {"11", 5}, {"15", 9}]},
        {"grid_4.png", []},
        {"grid_5.png", [{"13", 1}, {"19", 2}, {"17", 3}, {"20", 4}, {"16", 5}, {"11", 6}, {"24", 7}, {"15", 8}, {"28", 9}]},
        {"grid_6.png", [{"20", 2}, {"17", 6}, {"23", 9}, {"15", 13}, {"10", 19}, {"19", 22}]},
        {"grid_7.png", [{"19", 2}, {"21", 4}, {"10", 5}, {"23", 11}, {"15", 13}]}
      ]
  """
  def driver(path \\ "images/") do

       # Getting the path of images
       image_path = path <> "*.png"
       # Creating a list of all images paths with extension .png
       image_list = Path.wildcard(image_path)
       # Parsing through all the images to get final output using the two funtions which teams need to complete
       Enum.map(image_list, fn(x) ->
              {String.trim_leading(x,path), identifyCellNumbers(x) |> identifyCellNumbersWithLocations}
       end)
  end

end
