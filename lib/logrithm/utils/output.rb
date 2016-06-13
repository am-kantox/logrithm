module Logrithm
  module Utils
    module Output
      VB = '│'.freeze
      HB = '─'.freeze
      TL = '┌'.freeze
      TR = '┐'.freeze
      BL = '└'.freeze
      BR = '┘'.freeze

      TERM_MARGIN  = 2
      BOX_MARGIN   = 2

      TERM_MARGIN_STR = ' ' * TERM_MARGIN
      BOX_MARGIN_STR  = ' ' * BOX_MARGIN

      HIGHLIGHT_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :highlight) || '01;38;05;51')
      EXCEPTION_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :exception) || '01;38;05;88')
      APPDIR_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :root) || '01;38;05;253')
      METHOD_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :method_call) || '01;38;05;253')
      DATETIME_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :datetime) || '01;38;05;240')
      EXTENDED_COLOR = Color.new(Logrithm::Log.option(:log, :colors, :extended) || '01;38;05;246')

      class << self
        def line(filler = HB, width: $stdin.winsize.last, margin: TERM_MARGIN, color: Color::RED)
          color.colorize(' ' * margin, filler * (width - 2 * margin))
        end

        # rubocop:disable Metrics/AbcSize
        def rectangle(text, width: $stdin.winsize.last - 2 * TERM_MARGIN, color: Color::RED, frame_color: :same)
          text_width = width - 2 - 2 * BOX_MARGIN
          splitted = text.split(' ').each_with_object(['']) do |word, memo|
            next if word.strip.empty?
            memo.last.length + word.length + 1 <= text_width ? memo.last << ' ' << word : memo << word
          end.map(&:strip)
          frame_color = case frame_color
                        when :same then color
                        when :none then Color::NONE
                        else frame_color
                        end
          spaces = ' ' * (BOX_MARGIN + (text_width - splitted.max_by(&:length).length) / 2)
          [
            frame_color.colorize(TERM_MARGIN_STR + TL << HB * (width - 2) << TR),
            frame_color.colorize("#{TERM_MARGIN_STR}#{VB}#{' ' * (width - 2)}#{VB}"),
            *splitted.map do |line|
              trailing_spaces = ' ' * (width - (2 + spaces.length + line.length))
              frame_color.colorize("#{TERM_MARGIN_STR}#{VB}") <<
                color.colorize("#{spaces}#{line}#{trailing_spaces}") <<
                frame_color.colorize(VB)
            end,
            frame_color.colorize("#{TERM_MARGIN_STR}#{VB}#{' ' * (width - 2)}#{VB}"),
            frame_color.colorize(TERM_MARGIN_STR + BL << HB * (width - 2) << BR)
          ].join($/)
        end
        # rubocop:enable Metrics/AbcSize

        def clrz(txt, clr)
          txt = txt.to_s
                   .gsub(/«(.*?)»/m, "#{HIGHLIGHT_COLOR.to_esc}\\1#{clr.to_esc}")
                   .gsub(/⟨(.*?)⟩/m, "#{EXCEPTION_COLOR.to_esc}\\1#{clr.to_esc}")
                   .gsub(/⟦(.*?)⟧/m, "#{APPDIR_COLOR.to_esc}\\1#{clr.to_esc}")
                   .gsub(/⟬(.*?)⟭/m, "#{METHOD_COLOR.to_esc}\\1#{clr.to_esc}")
                   .gsub(/⟪(.*?)⟫/m, "#{EXTENDED_COLOR.to_esc}\\1#{clr.to_esc}")

          clr.colorize txt
        end
      end
    end
  end
end
