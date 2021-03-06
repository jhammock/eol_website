# NOTE: yes, I pluralized this. It's a plural thing.
class Comments
  class << self
    def discourse
      return @client if @client
      discourse_url
      return Rails.logger.error("Missing discourse_url") if discourse_url.nil?
      return Rails.logger.error("Missing discourse_url") if
        Rails.application.secrets.discourse_key.nil?
      return Rails.logger.error("Missing discourse_url") if
        Rails.application.secrets.discourse_user.nil?
      @client = DiscourseApi::Client.new(
        discourse_url,
        Rails.application.secrets.discourse_key,
        Rails.application.secrets.discourse_user
      )
    end

    def discourse_url
      @discourse_url ||= Rails.application.secrets.discourse_url
    end

    def post_url(post)
      "#{discourse_url}/t/#{post["topic_slug"]}/#{post["topic_id"]}"
    end
  end
end
