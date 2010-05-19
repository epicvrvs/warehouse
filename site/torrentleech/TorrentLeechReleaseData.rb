require 'nil/string'

require 'shared/timeString'
require 'shared/ReleaseData'

require 'cgi'

class TorrentLeechReleaseData < ReleaseData
	Debugging = false
	
	Targets =
	[
		['Release', /<h1>(.+?)<\/h1>/, :name],
		['Path', /"(download\.php.+?)"/, :path],
		['Info hash', /<td valign="top" align=left>(.+?)<\/td>/, :infoHash],
		['NFO', /<nobr>([\s\S]+?)<\/nobr>/, :nfo],
		['Category', /Type<\/td><td valign="top" align=left>(.+?)<\/td>/, :category],
		['Size', /Size<\/td><td valign="top" align=left>.+?\((.+?) bytes\)/, :sizeString],
		['Release date', /Added<\/td><td valign="top" align=left>(.+?)<\/td>/, :releaseDate],
		['Snatched', /Snatched<\/td><td valign="top" align=left>(\d+) time\(s\)<\/td>/, :downloads],
		['Uploader', /Upped by<\/td><td valign="top" align=left><a href=userdetails\.php\?id=\d+><b>(.+?)<\/b>/, :uploader],
		['Files', /\[See full list\]<\/a><\/td><td valign="top" align=left>(\d+) files<\/td>/, :fileCount],
		['Seeders', /<td valign="top" align=left>(\d+) seeder\(s\), /, :seeders],
		['Leechers', /, (\d+) leecher\(s\) = /, :leechers],
		
		['ID', /details\.php\?id=(\d+)&amp;/, :id],
	]
	
	def postProcessing(input)
		size = @sizeString.gsub(',', '')
		if !size.isNumber
			errorMessage = "Invalid file size specified: #{@sizeString}"
			raise Error.new(errorMessage)
		end
		@size = size.to_i
		
		@id = @id.to_i
		@hits = @hits.to_i
		@downloads = @downloads.to_i
		@seeders = @seeders.to_i
		@leechers = @leechers.to_i
		
		@path = "/#{@path}" if !@path.empty? && @path[0] != '/'
		
		@nfo = @nfo.gsub('<br />', '')
		@nfo = @nfo.gsub('&nbsp;', ' ')
		@nfo = CGI::unescapeHTML(@nfo)
	end
	
	def getData
		return {
			site_id: @id,
			torrent_path: @path,
			info_hash: @infoHash,
			section_name: @category,
			name: @name,
			nfo: @nfo,
			release_date: @releaseDate,
			release_size: @size,
			file_count: @fileCount,
			#screw it
			comment_count: nil,
			download_count: @downloads,
			seeder_count: @seeders,
			leecher_count: @leechers,
			uploader: @uploader,
		}
	end
end
