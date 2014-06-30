$(function(){
  //d1uwsxmus01xme.cloudfront.net
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
    url.href = 'http://d1uwsxmus01xme.cloudfront.net/v1/t/' + encodeURIComponent(btoa(url.href));
    return url.href;
  };

  var activateLinks = function(){
    $('a[open]').each(function(i, a){
      a = $(a)
      a.attr('href', a.find('img').attr('src'));
    });
  };

  var count = $('img[tm]').length;
  $('img[tm]').each(function(i, img){
    $(img).attr('src', encodeUrl($(img).data()));
    --count || activateLinks();
  })

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

  $('input[data-value]').each(function(i, input){
    var parser = document.createElement('a');
    parser.href = $(input).data('value');
    $(input).attr('value', parser.href);
  });

});
