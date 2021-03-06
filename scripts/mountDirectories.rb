$: << '.'

require 'configuration/Configuration'

source = Configuration::User.getPath('torrent/complete')
target = '/home/warehouse/user/'
directory = 'all'

Dir.foreach target do |user|
  next if user[0] == '.'
  puts "Processing #{user}"
  current = target + user + '/' + directory
  `mkdir #{current}`
  `mount --bind -o ro #{source} #{current}`
end
