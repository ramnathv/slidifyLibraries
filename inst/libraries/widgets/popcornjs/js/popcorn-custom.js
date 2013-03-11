function syncSlides(timings, pop) {
  for (var i = 1; i < timings.length; i++){
    var self = timings[i];
    var start  = Math.floor(self.time/1000),
        slide  = self.slide,
        action = self.action;
    switch (action){
    case "gotoSlide":
      pop.code({
        start: start,
        slideNumber: slide,
        onStart: function(options) {
          window.slidedeck.gotoSlide(options.slideNumber - 1);
        }
      });
      break;
    case "nextSlide":
      pop.code({
        start: start,
        onStart: function(options) {
          window.slidedeck.nextSlide();
        }
      });
      break;
    case "pause":
      pop.cue(start, function(){
        pop.pause();
      });
      break;
    };
  };
};

function handleDomLoadedExtra(pop) {
    var articles = document.getElementsByTagName('article');
    for (var i = 0; i < articles.length; ++i) {
      var article = articles[i];
      var timings = article.getAttribute("data-timings");
      if (timings != null) {
      var starts = timings.split(",");
      for (var j = 0; j < starts.length; ++j) {
        pop.code({
          start: parseInt(starts[j]),
          slideNumber: i,
          onStart: function(options) {
            window.slidedeck.gotoSlide(options.slideNumber);
          }
        });
      }
    }
  }
};