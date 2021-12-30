var page = require('webpage').create();
page.open('http://localhost:82', function() {
    setTimeout(function() {
        page.render('./public/screenshot.png');
        phantom.exit();
    }, 200);
});

