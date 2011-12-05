(function( $ ){
	
	$.fn.callme = function( options ) {
	
	// 	test = app:9996101245
	// 	prod = app:9996162282
	
		var thisPhone = this, dispatcher = $({}), callMeOptions = {}, phono, call, mysession;
		var attendees = {"data" : []}
		var settings = {
			apikey : "",
			dialpad: true,
			togglemic: true,
			togglemute: true,
			slideopen: true,
			buttontext: "loading...",
			buttontextready: "Call me",
			numbertodial: "app:9996162282"
    	};
    	
    	if(options) { 
	    	//lowercase all options passed in
	    	$.each(options, function(k,v){
	    		callMeOptions[k.toLowerCase()] = v;
	    	});
    	}
    	    	
    	return this.each(function(){
    		
    		if ( options ) { 
        		$.extend( settings, callMeOptions );
      		}
      		
      		var phone = buildPhone( settings );
      		
      		$(this).append(phone);
      		
      		// event handlers
      		phone.find(".phono-digit").bind({
      			mouseenter: function(){
      				$(this).addClass("ui-state-hover");
      			},
      			mouseleave: function(){
      				$(this).removeClass("ui-state-hover");
      			},
      			mousedown: function(){
      				$(this).addClass("ui-state-active");
      			},
      			mouseup: function(){
      				$(this).removeClass("ui-state-active");
      			},
      			click: function(e){
      				if( call )
      					call.digit( $(this).attr("title") );
      				e.preventDefault();
      			}
      		});
      		
      		phone.find(".phono-mic-toggle").bind({
      			click: function(){
      				(this.checked)? phono.phone.headset(true): phono.phone.headset(false);
      			}
      		});
      		phone.find(".phono-mute-toggle").bind({
      			click: function(){
      				(this.checked)? call.mute(true): call.mute(false);
      			}
      		});

      		
      		dispatcher.bind({
      			// phono is ready, bind events to the call button
      			phonoReady: function(){
      				var btn = phone.find("a.phono-phone-button");
      				btn.bind({
      					click: function(e){
      						(call) ? hangUpCall(settings, phone) : makeCall(settings, phone);
      						e.preventDefault();
      					}
      				});
      				
      				btn.text(settings.buttontextready);
      			}
      		});

    		// initialize phono 
    		phono = $.phono({
        		apiKey: settings.apikey,
        		onReady: function(){
        			dispatcher.trigger("phonoReady");
					mysession = this.sessionId;
					$.ajax({ url: '/api/update_phonoaddress', data: { 'mysession': this.sessionId}, type: 'get' })
        		},
        		phone: {
					onDisconnect: function(event) {
				    	hangUpCall(settings, phone);
					}
				},
				messaging: {
				    onMessage: function(event) {
				       var message = event.message;
						// message is formatted as username:photourl:jid:status (joined, dropped, etc.)
						
						var body = message.body
						var split = body.split('~');
						var datausername = split[0];
						var dataphotourl = split[1];
						var datajid = split[2];
						var datastatus = split[3];
						
						// alert("Message from: " + message.from + "\n" + datausername + "-" + dataphotourl + "-" + datajid + "-" + datastatus );
				       // alert("Message from: " + message.from + "\n" + message.body );											 
						
						if(datastatus == 'joined'){
							// 	attendees.data.push({"username" : datausername,"photo" : dataphotourl, "jid" : datajid})
							
							// Add Avatar of new attendee to organizer's page
							$("#attendees").append('<div id="' + datausername + '"><img src="' + dataphotourl + '" width="50" height="50"align="left" ></div>');
							
							// Add Mute link/checkbox next to avatar
							$("#" + datausername).append('<div id="' + datausername + 'mute"><input class="phono-user-mute-' + datausername + '" type="checkbox"> mute</div>');

							$('.phono-user-mute-' + datausername).bind('click', function() {
								(this.checked)? phono.messaging.send( datajid, datausername + '~photo~' + datajid + '~mute'): phono.messaging.send( datajid, datausername + '~photo~' + datajid + '~unmute');
							});

							// Add Hangup link/checkbox next to avatar
							$("#" + datausername).append('<div id="' + datausername + 'hangup"><input class="phono-user-hangup-' + datausername + '" type="checkbox"> hangup</div><br/>');

							$('.phono-user-hangup-' + datausername).bind('click', function() {
								phono.messaging.send( datajid, datausername + '~photo~' + datajid + '~hangup');
							});

																		      		
							// Play sound when new attendee joins conference
							try { $("#audio_new_pm")[0].play(); } catch(e) {}
							// try { $("#audio_msg")[0].play(); } catch(e) {}
						}
						if(datastatus == 'left'){
							// 	// attendees.data.pop({"username" : datausername,"photo" : dataphotourl, "jid" : datajid})
							$("#" + datausername).remove();
							try { $("#audio_msg")[0].play(); } catch(e) {}
						}
						if(datastatus == 'mute'){
							$(".phono-mute-toggle-hldr").remove();							
							call.mute(true);
						}
						if(datastatus == 'unmute'){
							$(".phono-mute-toggle-hldr").remove();							
							call.mute(false);
						}
						if(datastatus == 'hangup'){
							call.hangup();
						}
				
				    }
				  }
      		});
    		
    	});

		// function muteAttendee( username, jid ){
		// 	// phono.messaging.send( jid, username + '~photo~' + jid + '~mute');
		// 	alert('test');
		// };
    	
    	function buildPhone( settings ){
    		var phoneHldr = $( "<div/>")
    			.addClass("phono-hldr ui-widget ui-corner-all");
    			
    		var phoneContent = $("<div/>")
    			.addClass("ui-widget-content ui-corner-all")
    			.css("padding","2px")
    			.appendTo(phoneHldr);
    			
    		var statusLink = $("<a>")
    			.attr("href","#")
    			.addClass("phono-phone-button ui-widget-header ui-corner-all")
    			.css({
    				"text-align":"center",
    				"display":"block",
    				"padding":"8px 10px",
    				"text-decoration":"none"
    			})
    			.html(settings.buttontext)
    			.appendTo(phoneContent);
    			
    		if ( settings.togglemic ){
    			var micToggle = $("<div/>")
    				.addClass("phono-mic-toggle-hldr")
    				.css({
    					"margin":"5px 0",
    					"font-size":"75%",
    					"text-align":"center"
    				})
    				.html("<input class='phono-mic-toggle' type='checkbox'/><img src='/assets/headphones.png' width='32'> Wearing a headset?")
    				.appendTo(phoneContent);
    				
    			if(settings.slideopen)
    				micToggle.css("display","none");
    		}

    		if ( settings.togglemute ){
    			var muteToggle = $("<div/>")
    				.addClass("phono-mute-toggle-hldr")
    				.css({
    					"margin":"5px 0",
    					"font-size":"75%",
    					"text-align":"center"
    				})
    				.html("<input class='phono-mute-toggle' type='checkbox'/><img src='/assets/microphone.png' width='32'> Mute?")
    				.appendTo(phoneContent);
    				
    			if(settings.slideopen)
    				muteToggle.css("display","none");
    		}
    		
    		if( settings.dialpad ){
    			var digitTblHldr = $("<div/>")
    				.addClass("phono-digit-hldr")
    				.appendTo(phoneContent);
    				
    			if(settings.slideopen)
    				digitTblHldr.css("display","none");
    			
    			var digitTbl = $( "<table/>" )
    				.addClass( "phono-digits-tbl" )
    				.css({
    					"width": "100%"
    				})
    				.appendTo( digitTblHldr );
    				
    			var digits = [
    				{key:"1", value:"&nbsp;"},
    				{key:"2", value:"ABC"},
    				{key:"3", value:"DEF"},
    				{key:"4", value:"GHI"},
    				{key:"5", value:"JKL"},
    				{key:"6", value:"MNO"},
    				{key:"7", value:"PQRS"},
    				{key:"8", value:"TUV"},
    				{key:"9", value:"WXYZ"},
    				{key:"*", value:"&nbsp;"},
    				{key:"0", value:"+"},
    				{key:"#", value:"&nbsp;"}
    			];
    			
    			var tblRows = $("<tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr>")
    				.appendTo(digitTbl);
    			
    			$.each(tblRows.find("td"), function( i, el ) { 
    				var digitObj = digits[i];
    				$(el).css({
    						"padding":"1px",
    						"vertical-align":"top",
    						"width":"33%"
    					});
    				
    				var digit = $( "<a/> ")
    				    .addClass( "phono-digit ui-state-default ui-corner-all" )
    				    .attr("title", digitObj.key)
    				    .attr("href","#")
    				    .css({
    				    	"padding":"3px",
    				    	"display":"block",
    				    	"text-align":"center",
    				    	"text-decoration":"none",
    				    	"font-size":"90%"
    				    })
    				    .html( digitObj.key )
    				    .appendTo( el );
    				    
    				var digitText = $("<span>")
    					.css({
    						"display":"block",
    						"font-size":"60%"
    					})
    					.html(digitObj.value)
    					.appendTo(digit);
    			});	
    		}
    		return phoneHldr;
    	}
    	
    	function makeCall(settings, phone){
    		phoneBtn = phone.find(".phono-phone-button");
    		phoneBtn.text("Calling...");
    		
    		if( settings.togglemic && settings.slideopen )
    			phone.find(".phono-mic-toggle-hldr").slideDown();
    		if( settings.togglemute && settings.slideopen )
    			phone.find(".phono-mute-toggle-hldr").slideDown();
    		if( settings.dialpad && settings.slideopen )
    			phone.find(".phono-digit-hldr").slideDown();
    			
    		call = phono.phone.dial(settings.numbertodial, {
            	tones: true,
				headers: [{
				           name:"x-username",
				           value: settings.username
				         },
						{
				           name:"x-myusername",
				           value: settings.myusername
				         },
						{
				           name:"x-myphoto",
				           value: settings.myphoto
				         },
						{
				           name:"x-myjid",
				           value: mysession
				         }],
            	onAnswer: function(event) {	
				    phoneBtn.text("CLICK TO HANGUP");
            	},
            	onHangup: function() {
				    hangUpCall(settings, phone);
					$("#attendees").empty();
					try { $("#audio_msg")[0].play(); } catch(e) {}
					
            	},
            	onDisconnect: function() {
				    hangUpCall(settings, phone);						
					$("#attendees").empty();
					try { $("#audio_msg")[0].play(); } catch(e) {}
            	}
        	});
    	}
    	
    	function hangUpCall(settings, phone){
    		if(call){
    			call.hangup();
    			call = null;
    		}
    		phone.find(".phono-phone-button").text(settings.buttontextready);
    		
    		if( settings.togglemic && settings.slideopen )
    			phone.find(".phono-mic-toggle-hldr").slideUp();
    		if( settings.togglemute && settings.slideopen )
    			phone.find(".phono-mute-toggle-hldr").slideUp();
    		if( settings.dialpad && settings.slideopen )
    			phone.find(".phono-digit-hldr").slideUp();
    	}
	
	};
	
})( jQuery );

// function muteAttendee( username, jid ){
// 	$.phono.messaging.send( jid, username + '~photo~' + jid + '~mute');
// 	// alert('test');
// };
