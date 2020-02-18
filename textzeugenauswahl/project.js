function displayImage(element) {
  if (window.innerWidth > 768) {
    let pbs = $('body').find('.pagebreak a');
    let pos = pbs.index(element);
    viewer.goToPage(pos);
  }
}

function toggleTexts (element) {
  let witness = $(element).attr('id').substr(1),
      wit = $(".content[data-wit=" + witness + "]"),
      id = $("meta[name='id']").attr("content"),
      state = element.checked,
      displayed = [];
  $("#wdbContent").children("div[data-wit]").each(function(element){
    displayed.push($(element).data("wit"))
  });
  if (!state) {
    /* has been deactivated: hide */
    wit.toggle();
  } else if (wit.length > 0) {
    /* activated, text has already been loaded: show */
    wit.toggle();
  } else {
    /* activated, text has not been loaded: load and append */
    $.ajax({
      method: "get",
      url: "http://exist.ulb.tu-darmstadt.de:8080/exist/restxq/edoc/resource/view/" + id + ".html",
      data: { view: witness },
      success: function (data) {
        let content = $(data).find('.content')[0];
        $('#wdbContent').append(content);
        $("#wdbContent .fn_number").hover(mouseIn, mouseOut);
      }
    });
  }
}
