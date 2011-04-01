require 'radiant-site_area_tags-extension/version'
class SiteAreaTagsExtension < Radiant::Extension
  version RadiantSiteAreaTagsExtension::VERSION
  description "Adds site_area_tags to Radiant."
  url "http://github.com/jomz/radiant-site_area_tags-extension"
  
  def activate
    Page.send :include, SiteAreaTags
  end
end
