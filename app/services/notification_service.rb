class NotificationService
  CONN_POOL = Apnotic::ConnectionPool.new(
    auth_method: :token,
    cert:          ENV['APNS_TOKEN'],
    key_id:        ENV['APNS_KEY_ID'],
    team_id:       ENV['APNS_TEAM_ID']
  )

  def self.send(notification)
    notification.user.devices.each do |d|
      next if d.push_token.nil?

      CONN_POOL.with do |conn|
        apns_notification       = Apnotic::Notification.new(token)
        apns_notification.alert = notification.message
        apns_notification.sound = 'default'

        response = conn.push(apns_notification)
        return if response.nil? || response['apns-id'].nil?

        notification.external_id = response['apns-id']
        notification.save!
      end
    end
  end
end
