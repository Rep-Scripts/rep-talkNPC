var nameNPC = '';
let elements = {};
$(function() {
    window.addEventListener('message', function(e) {
        var eventData = e.data;
        if (eventData.type == 'show') {
            $("body").show();
            nameNPC = eventData.npcName;
            $("#npc-name").html(nameNPC);
            $(".message-wrapper").empty();
            $(".menu-body").empty();
            elements = eventData.elements
            for (let i = 0; i < eventData.elements.length; i++) {
                $(".menu-body").append('<div class="menu-element" data-event="'+ eventData.elements[i].value +'">'+ eventData.elements[i].label +'</div>')
            }
            addMesage(eventData.msg, eventData.from)
        } else if (eventData.type == 'updatemenu') {
            elements = eventData.elements
            $(".menu-body").empty();
            for (let i = 0; i < eventData.elements.length; i++) {
                $(".menu-body").append('<div class="menu-element" data-event="'+ eventData.elements[i].value +'">'+ eventData.elements[i].label +'</div>')
            }
        } else if (eventData.type == 'addmsg') {
            addMesage(eventData.msg, eventData.from)
        } else if (eventData.type == 'close') {
            $("body").hide();
        }
    });
    $("body").on("keyup", function (e) {
        if (e.which == 27) {
            $("body").hide();
            $.post('https://rep-talknpc/close');
        };
    });
});

$(document).on('click', '.menu-element', function(e){
    e.preventDefault();
    var id = $(this).data('event');
    addMesage(elements[id - 1].label, 'player');
    $.post('https://rep-talknpc/click',JSON.stringify({
        value: id,
    }));
});

function addMesage(msg, from) {
    if(from == 'npc') {   
        $(".message-wrapper").append('<div class="menu-message left"><div class="bubble-bottom"></div><div class="message-content">' + msg + '</div> <div class="message-owner">'+ nameNPC +'</div></div>');
    } else {
        $(".message-wrapper").append('<div class="menu-message right"><div class="bubble-bottom"></div><div class="message-content">' + msg + '</div><div class="message-owner">Player</div></div>');
    }  
};

