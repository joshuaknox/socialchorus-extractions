module TextSimplifierHelper

  def anchors_away(string, parsed = '')
    return parsed if string.empty?
    until(string.first(2) == "<a" || string.empty?) do
      parsed << string.slice!(0).to_s
    end
    link_text = ""
    return parsed if string.empty?
    if string.include?("</a>")
      until(string.start_with?("</a>"))
        link_text << string.slice!(0)
      end
      string.slice!(0..3)
      link, text = link_text.split(">")
      split = link.split(/href\s*=\s*/)
      href = split.length > 1 ? split.last : ''
      href.gsub!("'","")
      href.gsub!("\"", "")
      parsed << [text, href].reject {|x| x.blank? }.join(" ")
    else
      until(string.first == ">" || string.empty?)
        link_text << string.slice!(0).to_s
      end
      string.slice!(0)
    end
    anchors_away(string, parsed)
  end

  def rich_to_text(string)
    strip_tags(anchors_away(string).gsub("</p>","\n").gsub("<br />","\n"))
  end
end
