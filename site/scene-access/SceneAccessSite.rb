require 'shared/irc/IRCReleaseSite'

class SceneAccessSite < IRCReleaseSite
	def initialize(siteData, torrentData, database)
		super(siteData, torrentData, database)
		@ircHandler.httpHandler = @httpHandler
	end
end
