// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery

$(window).load(function() {
    $(".server").mouseover(function () {
        if ($(window).width() <= 750)
            return;

        var server = this.id;

        $('#info-' + server).css({
            display: "block"
        });
    });

    $(".server").mouseout(function () {
        if ($(window).width() <= 750)
            return;

        var server = this.id;

        $('#info-' + server).css({
            display: "none"
        });
    });
});

$(document).on('mousemove', function(e){
    if ($(window).width() <= 750)
        return

    if (e.pageY <= 600) {
        $('.info-item').css({
            left:  e.pageX+25,
            top:   e.pageY+25
        });
    } else {
        $('.info-item').css({
            left:  e.pageX+25,
            top:   e.pageY - 275
        });
    }
});

//
// function displayInfo(e) {
//     $('#info').css({
//         left: e.pageX,
//         top: e.pageY
//     })
// }

// $(document).on('mousemove', function(e){
//     $('#your_div_id').css({
//         left:  e.pageX,
//         top:   e.pageY
//     });
// });
//
// var flag = false;
// $($wrapper).mouseover(function(){
//     flag = true;
//     TweenLite.to($circle,0.4,{scale:1,autoAlpha:1})
//     $($wrapper).on('mousemove', displayInfo);
// });
// $($wrapper).mouseout(function(){
//     flag = false;
//     TweenLite.to($circle,0.4,{scale:0.1,autoAlpha:0})
// });