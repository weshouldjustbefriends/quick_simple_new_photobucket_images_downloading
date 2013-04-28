require 'open-uri'
require 'nokogiri'

require './blank'

f = File.open './photobucket.html'
  @doc = Nokogiri::XML( f )
f.close

sources = @doc.css( 'img[src]' )

File.open( 'wget.txt', 'w' ) { |f|
  sources.each do |each_html|
    
    image_url = each_html[ 'src' ]
    if !image_url.blank?
      image_file_name = File.basename image_url
      image_file_name.sub!( /^(bth_)/, '' )
      
      image_url = File.join( "#{File.dirname image_url}", image_file_name )
      
      f.puts image_url
      
      #TODO need better header field, and maybe referer/from
      File.open( "images/#{image_file_name}", 'wb' ) do |fo|
        fo.write open( image_url ).read
      end
    end
    
  end
}
