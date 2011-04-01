module SiteAreaTags
  include Radiant::Taggable
  
  desc %{
    Renders the slug of the top-most parent page which is not the homepage
    This functions nicely as a site area (or “section”) name

    *Usage:*
    <pre><code><r:site_area /></code></pre>
  }
  tag "site_area" do |tag|
    site_area(tag)
  end

  desc %{
    Renders the second level parent page slug
    (which functions nicely as a site sub-area name)

    *Usage:*
    <pre><code><r:site_subarea /></code></pre>
  }
  tag "site_subarea" do |tag|
    site_subarea(tag)
  end
  
  desc %{
    Renders the contents of this tag if the local page context is in the same site
    area as the global page context (see <pre><code><r:site_area /></code></pre>)
    
    This is typically used inside another tag (like <pre><code><r:children:each></code></pre>) to add
    conditional mark-up if the child element is in the current site area.

    *Usage:*
    <pre><code><r:if_same_site_area>…</if_same_site_area></code></pre>
    
    *Example:*
    <pre><code>
    <r:children:each>
    <r:link><r:title /><r:if_same_site_area>*</r:if_same_site_area></r:link>
    </r:children:each>
    </code></pre>
  }
  tag 'if_same_site_area' do |tag|
    tag.expand if same_site_area?(tag)
  end
  
  desc %{
    Renders the contents of this tag unless the local page context is in the same site
    area as the global page context (see <pre><code><r:if_same_site_area /></code></pre> and <pre><code><r:site_area /></code></pre>)
    
    This is typically used inside another tag (like <pre><code><r:children:each></code></pre>) to add
    conditional mark-up if the child element is not in the current site area.

    *Usage:*
    <pre><code><r:unless_same_site_area>…</unless_same_site_area></code></pre>
  }
  tag 'unless_same_site_area' do |tag|
    tag.expand unless same_site_area?(tag)
  end
  
  desc %{
    Renders the contents of this tag if the local page context is in the same site
    subarea as the global page context (see <pre><code><r:site_subarea /></code></pre>)
    
    This is typically used inside another tag (like <pre><code><r:children:each></code></pre>) to add
    conditional mark-up if the child element is in the same site sub-area as 
    the actual page.

    *Usage:*
    <pre><code><r:if_same_site_subarea>…</if_same_site_subarea></code></pre>
  }
  tag 'if_same_site_subarea' do |tag|
    tag.expand if same_site_subarea?(tag)
  end
  
  desc %{
    Renders the contents of this tag unless the local page context is in the same site
    subarea as the global page context (see <pre><code><r:site_subarea /></code></pre>)
    
    This is typically used inside another tag (like <r:children:each>) to add
    conditional mark-up if the child element is is note in the same site sub-area
    as the actual page.

    *Usage:*
    <pre><code><r:unless_same_site_subarea>…</unless_same_site_subarea></code></pre>
  }
  tag 'unless_same_site_subarea' do |tag|
    tag.expand unless same_site_subarea?(tag)
  end

private

  def site_area(tag)
    page = tag.locals.page
    unless page.part("site_area").nil?
      page.part("site_area").content
    else
      site_area = case page.ancestors.length
                  when 0
                    "homepage"
                  when 1
                    page.slug
                  else
                    page.ancestors[-2].slug
                  end
      if site_area =~ /^\d/
        site_area = "n#{site_area}"
      end
      site_area
    end
  end

  def site_subarea(tag)
    page = tag.locals.page
    unless page.part("site_subarea").nil?
      page.part("site_subarea").content
    else
      site_area = case page.ancestors.length
                  when 0..1
                    ""
                  when 2
                    page.slug
                  else
                    page.ancestors[-3].slug
                  end
      if site_area =~ /^\d/
        site_area = "n#{site_area}"
      end
      site_area
    end
  end
  
  def same_site_area?(tag)
    local_page = tag.locals.page
    local_site_area = site_area(tag)
    
    tag.locals.page = tag.globals.page
    global_site_area = site_area(tag)
    
    tag.locals.page = local_page
    
    local_site_area == global_site_area
  end
  
  def same_site_subarea?(tag)
    local_page = tag.locals.page
    local_site_subarea = site_subarea(tag)
    tag.locals.page = tag.globals.page
    global_site_subarea = site_subarea(tag)
    tag.locals.page = local_page

    ((local_site_subarea == global_site_subarea) and (local_site_subarea != "" or global_site_subarea != ""))
  end
end
