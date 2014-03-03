$(function(){
    $('table td.account').hover(function(){
        $.get('/users/userinfo/'+$(this).attr('data-id'), function(data){
            $("#userinfo").remove();
            $(document.body).append(data);
        }, 'html');
    }, function(){
        $("#userinfo").remove();
    });
});