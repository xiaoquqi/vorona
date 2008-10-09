function handleTreeClick(e) {
  var elt = e.element();
  if (elt.tagName == 'INPUT')
    return;  // eventually handle update the data table
  e.stop();
  if (elt.tagName == 'IMG')
    elt = elt.up('a');
  if (elt.tagName == 'A') {
    var elt_li = elt.up('li');
    var group = elt_li.down('ul');
    var text  = elt_li.down('span', 1);
    var image = elt_li.down('img');
    var groupVisible = group.toggle().visible();
    image.src = '/images/icon/group_' + (groupVisible ? 'open' : 'closed') + '.gif';
    return;
  }
  // Other click.  Let's select if we're on a valid item!
  if ('LI' != elt.tagName)
    elt = elt.up('li');
  if (!elt)
    return;
} // handleTreeClick
// load the observer
document.observe('dom:loaded', function() {
  $('kpi_tree').observe('click', handleTreeClick);
});
