# = ruby-webp - A gem providing a ruby interface to Google WebP Codec.
#
# Homepage::  http://github.com/jjuliano/ruby-webp
# Author::    Joel Bryan Juliano
# Copyright:: (cc) 2011 Joel Bryan Juliano
# License::   MIT
#

#
# class WebP::Decoder.new( array, str, array)
#
# Decompresses WebP image files into PNG, PGM or PPM images.
#
class WebP::Decoder

  # Specify the name of the input file.
  attr_accessor :input_file, :input

  # Specify the name of the output file (as PNG format by default).
  attr_accessor :output_file, :output, :o

  # Change the output format to PPM.
  attr_accessor :output_format_ppm, :output_ppm, :ppm
  
  # Change the output format to PGM. The output consist of luma/chroma
  # samples instead of RGB, using the ICM4 layout. This option is mainly for
  # verification and debugging purpose.
  attr_accessor :output_format_pgm, :output_pgm, :pgm

  # Print extra information.
  attr_accessor :verbose, :extra_information, :v

  # Sets the executable path, otherwise the environment path will be used.
  attr_accessor :path_to_dwebp

  # Returns a new WebP::Decoder Object
  def initialize()
  end

  # Print usage summary.
  def help
    execute_string("-h")
  end

  # Print the version number (as major.minor.revision) and exit.
  def version
    execute_string("-version")
  end

  def show_config
    if (option_string()) == "dwebp "
      raise "No options specified"
    else
      option_string()
    end
  end
  
  # Execute and decode
  def decode
    execute_string(option_string())
  end

  alias :usage_summary :help
  alias :run :decode
  alias :start :decode
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

      unless @path_to_dwebp
        ostring = "dwebp "
      else
        ostring = @path_to_dwebp + " "
      end

      if (@verbose || @extra_information || @v)
        ostring += "-v "
      end

      if (@output_format_ppm || @output_ppm || @ppm)
        ostring += "-ppm "
      end
      
      if (@output_format_pgm || @output_pgm || @pgm)
        ostring += "-pgm "
      end

      if (params = (@input_file || @input))
        case
        when params.nil?:
            raise "No input file specified."
        end
        ostring += params.to_s + " "
      end

      if (params = (@output_file || @output || @o))
        ostring += "-o " + params.to_s + " "
      end

      return ostring

    end

end
