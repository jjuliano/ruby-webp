# = ruby-webp - A gem providing a ruby interface to Google WebP Codec.
#
# Homepage::  http://github.com/jjuliano/ruby-webp
# Author::    Joel Bryan Juliano
# Copyright:: (cc) 2011 Joel Bryan Juliano
# License::   MIT
#

#
# class WebP::Encoder.new( array, str, array)
#
# Compresses image using the WebP format. Input format can be either
# PNG, JPEG, or raw Y'CbCr samples. When using PNG, the transparency
# information (alpha channel) is currently discarded.
#
class WebP::Encoder

  # Specify the name of the input file.
  attr_accessor :input_file, :input

  # Specify the name of the output WebP file. If omitted, cwebp will
  # perform compression but only report statistics.
  attr_accessor :output_file, :output, :o

  # Specify the compression factor between 0 and 100. A small factor
  # produces smaller file with lower quality. Best quality is achieved
  # using a value of 100. The default is 75.
  attr_accessor :compression_factor, :q

  # Specify the strength of the deblocking filter, between 0 (no filtering)
  # and 100 (maximum filtering). A value of 0 will turn off any filtering.
  # Higher value will increase the strength of the filtering process
  # applied after decoding the picture. The higher the smoother the picture
  # will appear. Typical values are usually in the range of 20 to 50.
  attr_accessor :deblocking_filter, :f

  # Specify a set of pre-defined parameters to suit a particular type of
  # source material. Possible values are: default, photo, picture, drawing,
  # icon, text.
  attr_accessor :preset, :preset_default, :preset_photo, :preset_picture, :preset_drawing, :preset_icon, :preset_text

  # Specify the amplitude of the spatial noise shaping. Spatial noise
  # shaping (or sns for short) refers to a general collection of built-in
  # algorithms used to decide which area of the picture should use
  # relatively less bits, and where else to better transfer these bits. The
  # possible range goes from 0 (algorithm is off) to 100 (the maximal
  # effect). The default value is 80.
  attr_accessor :spatial_noise_shaping, :sns

  # Specify the compression method to use. This parameter controls the
  # tradeoff between encoding speed and the compressed file size and
  # quality. Possible values range from 0 to 6. Default value is 4. When
  # higher values are used, the encoder will spend more time inspecting
  # additional encoding possibilities and decide on the quality gain. Lower
  # value can result is faster processing time at the expense of larger
  # filesize and lower compression quality.
  attr_accessor :compression_method, :method, :m

  # Turns auto-filter on. This algorithm will spend additional time
  # optimizing the filtering strength to reach a well-balanced quality.
  attr_accessor :auto_filter, :af

  # Specify the sharpness of the filtering (if used). Range is 0 (sharpest)
  # to 7 (least sharp)Turns auto-filter on. This algorithm will spend
  # additional time optimizing the filtering strength to reach a
  # well-balanced quality.
  attr_accessor :sharpness

  # Use a stronger filtering than the default one (if filtering is being
  # used thanks to the -f option). Strong filtering is off by default.
  attr_accessor :strong_filtering, :strong

  # Change the number of partitions to use during the segmentation of the
  # sns algorithm. Segments should be in range 1 to 4. Default value is 4.
  attr_accessor :segments

  # Specify a target size (in bytes) to try and reach for the compressed
  # output. Compressor will make several passes of partial encoding in
  # order to get as close as possible to this target.
  attr_accessor :target_size, :size

  # Specify a target PSNR (in dB) to try and reach for the compressed output.
  # Compressor will make several passes of partial encoding in order to get
  # as close as possible to this target.
  attr_accessor :peak_signal_to_noise_ratio, :psnr

  # Set a maximum number of pass to use during the dichotomy used by options
  # :size or :psnr. Maximum value is 10.
  attr_accessor :pass

  # Crop the source to a rectangle with top-left corner at coordinates
  # (x_position, y_position) and size width x height. This cropping area must
  # be fully contained within the source rectangle.
  attr_accessor :crop

  # Specify that the input file actually consists of raw Y'CbCr samples
  # following the ITU-R BT.601 recommendation, in 4:2:0 linear format. The
  # luma plane has size width x height.
  attr_accessor :input_luma_plane_size, :luma_plane_size, :s

  # Output additional ASCII-map of encoding information. Possible map values
  # range from 1 to 6. This is only meant to help debugging.
  attr_accessor :map

  # Specify a pre-processing filter. This option is a placeholder and has
  # currently no effect.
  attr_accessor :pre_processing_filter, :pre

  # Print extra information (encoding time in particular).
  attr_accessor :verbose, :extra_information, :encoding_time, :v

  # Do not print anything.
  attr_accessor :quiet

  # Only print brief information (output file size and PSNR) for testing
  # purposes.
  attr_accessor :brief_information, :short

  # Sets the executable path, otherwise the environment path will be used.
  attr_accessor :path_to_cwebp

  # Returns a new WebP::Encoder Object
  def initialize()
  end

  # A short usage summary.
  def short_help
    execute_string("-help")
  end

  # A summary of all the possible options.
  def long_help
    execute_string("-longhelp")
  end

  # Print the version number (as major.minor.revision) and exit.
  def version
    execute_string("-version")
  end

  def show_config
    if (option_string()) == "cwebp "
      raise "No options specified"
    else
      option_string()
    end
  end
  
  # Execute and encode
  def encode
    execute_string(option_string())
  end

  alias :help :short_help
  alias :shorthelp :short_help
  alias :longhelp :long_help
  alias :run :encode
  alias :start :encode
  alias :show :show_config
  alias :config :show_config

  private

    # Add a parameters to an execute string
    def execute_string(param_string)
      tmp = Tempfile.new('tmp')
      command_string = option_string() + "#{param_string} " + " 2> " + tmp.path
      success = system(command_string)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    def option_string()

      unless @path_to_cwebp
        ostring = "cwebp "
      else
        ostring = @path_to_cwebp + " "
      end

      if (params = (@preset || @preset_default || @preset_photo || @preset_picture || @preset_drawing || @preset_icon || @preset_text))
        case
        when @preset_default:
            params = "default"
        when @preset_photo:
            params = "photo"
        when @preset_picture:
            params = "picture"
        when @preset_drawing:
            params = "drawing"
        when @preset_icon:
            params = "icon"
        when @preset_text:
            params = "text"
        end
        ostring += "-preset " + params.to_s + " "
      end

      if (params = (@compression_factor || @q))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Specify the compression factor between 0 and 100."
        when params > 100:
            params = 100
        end
        ostring += "-q " + params.to_f.to_s + " "
      end

      if (params = (@deblocking_filter || @f))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Specify the strength of the deblocking filter, between 0 (no filtering) and 100 (maximum filtering)."
        when params > 100:
            params = 100
        end
        ostring += "-f " + params.to_i.to_s + " "
      end

      if (params = (@spatial_noise_shaping || @sns))
        case
        when (params =~ /[0-9]/).nil?:
            raise "The possible range goes from 0 (algorithm is off) to 100 (the maximal effect)."
        when params > 100:
            params = 100
        end
        ostring += "-sns " + params.to_i.to_s + " "
      end

      if (params = (@compression_method || @method || @m))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Possible values range from 0 to 6."
        when params > 6:
            params = 6
        end
        ostring += "-m " + params.to_i.to_s + " "
      end

      if (@auto_filter || @af)
        ostring += "-af "
      end

      if @sharpness
        case
        when (@sharpness =~ /[0-9]/).nil?:
            raise "Range is 0 (sharpest) to 7 (least sharp)."
        when @sharpness > 7:
            @sharpness = 7
        end
        ostring += "-sharpness " + @sharpness.to_i.to_s + " "
      end

      if (@strong_filtering || @strong)
        ostring += "-strong "
      end

      if @segments
        case
        when (@segments =~ /[0-9]/).nil?:
            raise "Segments should be in range 1 to 4."
        when @segments > 4:
            @segments = 4
        when @segments < 1:
            @segments = 1
        end
        ostring += "-segments " + @segments.to_i.to_s + " "
      end

      if (params = (@target_size || @size))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Specify a target size (in bytes) to try and reach for the compressed output."
        end
        ostring += "-size " + params.to_i.to_s + " "
      end

      if (params = (@peak_signal_to_noise_ratio || @psnr))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Specify a target PSNR (in dB) to try and reach for the compressed output."
        end
        ostring += "-psnr " + params.to_f.to_s + " "
      end

      if @pass
        case
        when (@pass =~ /[0-9]/).nil?:
            raise "Set a maximum number of pass to use during the dichotomy used by options @size or @psnr."
        when @pass > 10:
            @pass = 10
        end
        ostring += "-pass " + @pass.to_i.to_s + " "
      end

      if @crop
        case
        when (@crop.scan(/ /).size) > 3:
            raise "Crop the source to a rectangle with top-left corner at coordinates (x_position, y_position) and size width x height. Crop must be 'x_position y_position width height' enclosed in string quotes."
        end
        ostring += "-crop " + @crop.to_s + " "
      end

      if (params = (@input_luma_plane_size || @luma_plane_size || @s))
        case
        when (params.scan(/ /).size) > 1:
            raise "Specify that the input file actually consists of raw Y'CbCr samples following the ITU-R BT.601 recommendation, in 4:2:0 linear format. The luma plane has size width x height. Luma plane size must be 'width height' enclosed in string quotes."
        end
        ostring += "-s " + params.to_s + " "
      end

      if @map
        case
        when (@map =~ /[0-9]/).nil?:
            raise "Possible map values range from 1 to 6."
        when @map > 6:
            @map = 6
        when @map < 1:
            @map = 1
        end
        ostring += "-map " + @map.to_i.to_s + " "
      end

      if (params = (@pre_processing_filter || @pre))
        case
        when (params =~ /[0-9]/).nil?:
            raise "Specify a pre-processing filter."
        end
        ostring += "-pre " + params.to_i.to_s + " "
      end

      if (@verbose || @extra_information || @encoding_time || @v)
        ostring += "-v "
      end

      if @quiet
        ostring += "-quiet "
      end

      if (@brief_information || @short)
        ostring += "-short "
      end

      if (params = (@input_file || @input))
        case
        when params.nil?:
            raise "No input file specified."
        end
        ostring += params.to_s + " "
      end

      if (params = (@output_file || @output || @o))
        case (params =~ /webp/)
        when nil:
            params << ".webp"
        end
        ostring += "-o " + params.to_s + " "
      end

      return ostring

    end

end
