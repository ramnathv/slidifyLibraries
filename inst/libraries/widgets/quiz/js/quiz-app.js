// Initialize Quiz
function initialize_quiz(){
  // add class information to options
  $('.quiz').find('li').addClass('quiz-option')
  $('.quiz').find('li:has(em)').addClass('quiz-answer')
  
  $('li.quiz-answer em').replaceWith(function(){
     return $(this).contents()
  })
 
  // show answer in modal box. 
  // requires bootbox to be enabled
  $(".quiz-show-answer").click(function(e){
    e.preventDefault();
    var val = $(this).siblings('div.quiz-explanation').html();
    bootbox.alert(val);
  }); 
  
  // bind submit compare buttons
  $("a.submitCompare").bind('click', submitCompare)
  $("a.clearSubmitCompare").bind('click', clearSubmitCompare)
  
  // initialize quiz
  $.quiz();
}

function submitCompare(e){
  e.preventDefault();
  var studentAns = $(this).siblings('textarea').val();
  if (studentAns.length < 50){
    bootbox.alert("Please type your answer (at least 50 characters)")
  } else {
    bootbox.alert($(this).data('title'));
  }
};

function clearSubmitCompare(e){
  e.preventDefault();
  $(this).siblings('textarea.submitCompare').val("")
};

$(document).ready(function(){
 initialize_quiz();
})
