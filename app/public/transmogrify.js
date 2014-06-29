$(function(){
  var toQueryString = function(object){
    return Object.keys(object).map(function(k){
      return [k, object[k]].join('=');
    }).join('&')
  }

  var encodeUrl = function(sUrl){
    url      = document.createElement('a');
    url.href = sUrl.href;
    delete sUrl.href;
    url.search = '?' + toQueryString(sUrl);
    url.href = '/v1/t/' + encodeURIComponent(btoa(url.href));
    return url.href;
  };

  $('img[tm]').each(function(i, img){
    $(img).attr('src', encodeUrl($(img).data()));
  });

  $('form').submit(function(e){
    e.preventDefault();
  });

  var tryItUpdate = function(e){
    var url = $(e.currentTarget.form).serializeJSON();
    for (k in url){
      if(url[k] === null || url[k] === undefined || url[k] == ''){
        delete(url[k]);
      }
    }
    $('#output').html($('<img>').attr('src', encodeUrl(url)));
  };

  $('form#tryIt input').change(tryItUpdate);
  $('form#tryIt select').change(tryItUpdate);

});
