require 'mongo'

Mongo::Logger.logger.level = ::Logger::INFO

module DB
  def self.client
    @client ||= Mongo::Client.new(
      ENV["MONGO_URL"] || "mongodb://localhost:27017/trep_publicator",
      server_selection_timeout: 5
    )
  end

  def self.actas
    client[:actas]
  end

  def self.stats_region
    client[:stats_region]
  end
end
