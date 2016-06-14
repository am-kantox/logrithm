module Logrithm
  module Utils
    class Airslack
      require 'slack-notifier'

      SLACK_CHANNEL = Logrithm::Log.option :general, :slack, :channel

      SETTINGS = {
        dbg: { color: '#999999', preface: "Debugged error" },
        wrn: { color: '#DD00DD', preface: "Expected error" },
        err: { color: '#DD0000', preface: "Internal server error" },
        ftl: { color: '#FF9900', preface: "Unexpected error" }
      }.freeze

      class << self
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def notify(**params)
          # {
          #   :cause => #<ZeroDivisionError: divided by 0>,
          #   :controller => Api::V1::CompaniesController < Api::V1::BaseController,
          #   :current_api_user => "#<ApiUser id: 2, login: \"api_user_1@kantox.com\", email: ...
          #   :current_company => "#<Profile id: 1, group_id: 1, company_name: \"usd\", elegible_for_matching: nil, ...
          #   :current_power_class => "Power",
          #   :hide_locale_switcher => "false",
          #   :message => "Error #200 :: “divided by 0”",
          #   :owner => Api::GetCompany < Mutations::Command,
          #   :sender => "Kantox::Herro::ReportedError",
          #   :wrap => #<Kantox::Herro::Reporter:0x000000057eed20 @cause=#<Kantox::Herro::ReportedError: Error #200 :: “divided by 0”>>
          # }

          # {
          #   "text": "New Help Ticket Received:",
          #   "attachments": [
          #       {
          #           "title": "App hangs on reboot",
          #           "title_link": "http://domain.com/ticket/123456",
          #           "text": "If I restart my computer without quitting your app, it stops the reboot sequence.\nhttp://domain.com/ticket/123456",
          #       }
          #   ]
          # }
          fields = params.reject do |k, _|
            %i(type cause message owner sender wrap backtrace).include? k
          end.map do |k, v|
            value = case v
                    when String then [v.to_s[0...64]]
                    when Array then v.map(&:to_s)
                    when Hash
                      [
                        v[:id] ? "id=“#{v[:id]}”" : nil,
                        v[:reference] ? "ref=“#{v[:reference]}”" : nil,
                        v[:name] ? "name=“#{v[:name]}”" : nil
                      ]
                    else
                      [
                        v.respond_to?(:id) ? "id=“#{v.id}”" : nil,
                        v.respond_to?(:reference) ? "ref=“#{v.reference}”" : nil,
                        v.respond_to?(:name) ? "name=“#{v.name}”" : nil
                      ]
                    end.compact.join(', ')

            value = v.to_s[0...64] if value.empty?
            { title: k, value: value, short: value.length <= 64 }
          end

          preface = SETTINGS[params[:type] || :ftl][:preface]
          msg = "_#{preface}:_ #{params[:cause].try(:class)} | *#{params[:cause].try(:message)}*"
          atts = [
            {
              fallback: "#{preface} in #{params[:owner] || '[see backtrace]'}",
              color: SETTINGS[params[:type] || :ftl][:color],
              title: "#{preface} in #{params[:owner] || '[see backtrace]'}",
              fields: fields,
              mrkdwn_in: [:text],
              text: "```\n" << params[:cause].to_s << "\n```",
              author_name: params[:owner].to_s
            },
            {
              fallback: "Backtrace is available for desktop clients only",
              color: '#DDDDDD',
              title: "Backtrace (Rails.root related only)",
              mrkdwn_in: [:text, :title],
              text: "```\n" << params[:backtrace].map.with_index { |bt, i| bt =~ /#{Rails.root}/ ? "[#{i.to_s.rjust(3, '0')}] #{bt}" : nil }.compact.join($RS) << "\n```"
            }
          ]
          SLACK.ping msg, attachments: atts
        rescue => e
          Kantox::Rescuer.log_error(e).airbrake
        end
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/MethodLength

        def my_first_private_ipv4
          ip_priv = Socket.ip_address_list.detect(&:ipv4_private?)
          ip_priv && ip_priv.ip_address || 'Unknown server'
        end
      end

      SLACK = ::Slack::Notifier.new(
        SLACK_CHANNEL[:endpoint],
        channel: SLACK_CHANNEL[:channel],
        icon_emoji: ':vertical_traffic_light:',
        username: Airslack.my_first_private_ipv4
      )
    end
  end
end
