#
# A single committer
#

_html do
  _base href: '..'
  _link rel: 'stylesheet', href: 'stylesheets/app.css'
  _whimsy_body(
    title: 'ASF Committer Search',
    breadcrumbs: {
      roster: '.',
      committer: 'committer/'
    }
  ) do
    _div_.main!
    _script src: 'app.js'
    _.render '#main' do
      _CommitterSearch
    end
  end
end
