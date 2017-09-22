require 'base64'

class NotificationService
  CONN_OPTIONS = {
      auth_method: :token,
      cert:  Base64.decode64(ENV['APNS_TOKEN'] || ""),
      key_id: ENV['APNS_KEY_ID'],
      team_id: ENV['APNS_TEAM_ID']
  }.freeze
  PROD_POOL = Apnotic::ConnectionPool.new CONN_OPTIONS
  DEV_POOL = Apnotic::ConnectionPool.development CONN_OPTIONS

  def self.send_notification(notification)
    notification.user.devices.each do |d|
      next if d.push_token.nil?

      if d.platform == :ios
        pool = d.is_dev_device ? DEV_POOL : PROD_POOL
        pool .with do |conn|
          apns_notification       = Apnotic::Notification.new(d.push_token)
          apns_notification.alert = notification.message
          apns_notification.sound = 'default'
          apns_notification.topic = d.app_id || 'watch.cut'

          response = conn.push(apns_notification)
          return if response.nil? || response['apns-id'].nil?

          notification.external_id = response['apns-id']
          notification.save!
        end
      end
    end
  end

  def self.send_message(message, device)
    return if message.nil? || device.push_token.nil?

    if device.platform == :ios
      pool = d.is_dev_device ? DEV_POOL : PROD_POOL
      pool.with do |conn|
        apns_notification       = Apnotic::Notification.new(device.push_token)
        apns_notification.alert = message
        apns_notification.sound = 'default'
        apns_notification.topic = device.app_id || 'watch.cut'
        conn.push(apns_notification)
      end
    end
  end
end
