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

    var x_off = e.pageX >= 700 ? -375 : 25;

    if (e.pageY <= 500) {
        $('.info-item').css({
            left:  e.pageX+x_off,
            top:   e.pageY+25
        });
    } else {
        $('.info-item').css({
            left:  e.pageX+x_off,
            top:   e.pageY - 275
        });
    }
});

function copyIP(ip) {
    var element = document.getElementById("ip-text");

    if (element.innerHTML == "Copied!")
        return;

    element.innerHTML = "Copied!";

    const temp = document.createElement('textarea');
    temp.value = ip;
    document.body.appendChild(temp);
    temp.select();
    document.execCommand('copy');
    document.body.removeChild(temp);

    setTimeout(function () {
        element.innerHTML = ip;
    }, 2000)
}