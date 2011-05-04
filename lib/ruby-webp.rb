  # = ruby-webp - A gem providing a ruby interface to Google WebP Codec.
  #
  # Homepage::  http://github.com/jjuliano/ruby-webp
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT
  #

  require 'tempfile'

  Dir[File.join(File.dirname(__FILE__), 'ruby-webp/**/*.rb')].sort.reverse.each { |lib| require lib }

