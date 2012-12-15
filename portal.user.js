// ==UserScript==
// @match http://portal/*
// @version 2.1
// ==/UserScript==

/**
 * Greasemonkey script to make the client services tab more usable when
 * viewing and creating new services.
 *
 * == Installation Instructions ==
 * ==
 * == Chrome:
 * == 1.) In a chrome tab, browse to the extensions page: chrome://chrome/extensions
 * == 1.) Drag file from explorer window onto extensions tab.
 * == 2.) Refresh portal window/tab and use
 * ==
 * == FireFox:
 * == 1.) Install Greasemonkey extension (http://www.greasespot.net/)
 * == 2.) Drag file from explorer window onto Browser window.
 * == 3.) Refresh portal window and use
 * ==
 * == IE:
 * == FU IE
 * ===============================
 */

// a function that loads jQuery and calls a callback function when jQuery has finished loading
function addJQuery(callback) {
	var script = document.createElement("script");
	script.setAttribute("src", "http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js");
	script.addEventListener('load', function() {
			var script = document.createElement("script");
			script.textContent = "(" + callback.toString() + ")();";
			document.body.appendChild(script);

			var style = document.createElement('style');

			style.textContent += "#content .box form#domain-form fieldset { position: relative; float: left; clear: left; width: 100%; margin: 0 0 -1em 0; padding: 0 0 1em 0; border-style: none; border-top: 1px solid #bfbab0; background-color: #f2efe9; } " +
								 "#content .box form#domain-form fieldset.alt {background-color: #e6e3dd; } " +
								 "#content .box form#domain-form legend { padding: 0; color: #000; font-weight: bold; } " +
								 "#content .box form#domain-form legend span { position: absolute; left: 0.74em; top: 0; margin-top: 0.5em; font-size: 135%; } " +
								 "#content .box form#domain-form fieldset ol { padding: 2.5em 1em 0 1em; list-style: none; } " +
								 "#content .box form#domain-form fieldset li { float: left; clear: left; width: 100%; padding-bottom: 0.5em; margin: 0; text-align: left; } " +
								 "#content .box form#domain-form label { float: left; width: 10em; margin-right: 1em; text-align: right; font-size: 115%; letter-spacing: -1px; font-weight: normal;} " +
								 "#content .box form#domain-form input { text-align: left; } " +
								 "#content .box form#domain-form input, #content .box form#domain-form textarea, #content .box form#domain-form select { padding: 3px; border: 1px solid #000; } " +
								 "#content .box form#domain-form textarea { min-height: 100px; width: 75%; max-width: 75%; } " +
								 "#content .box form#domain-form select#service-domain, #content .box form#domain-form select#service-name {margin-top: 0 !important; } " +
                                 "#admin #admin-info ul { font-size: 100%; clear: left; } " +
                                 "#admin #admin-info ul li { clear: left; width: 100%; } " +
								 "";
			document.head.appendChild(style);
			}, false);
	document.body.appendChild(script);
}

// the guts of this userscript
function main() {
	jQuery.noConflict();

    //  Create unique arrays of strings/integers
    Array.prototype.unique = function() {
        var arrVal = this;
        var uniqueArr = [];
        for (var i = arrVal.length; i--;) {
            var val = arrVal[i];
            if (jQuery.inArray(val,uniqueArr) === -1) {
                uniqueArr.unshift(val);
            }
        }

        return uniqueArr;
    }

    String.prototype.hashCode = function() {
        var hash = 0;
        if (this.length == 0) return hash;
        for (i = 0; i < this.length; i++) {
            char = this.charCodeAt(i);
            hash = ((hash<<5)-hash)+char;
            hash = hash & hash; // Convert to 32bit integer
        }
        return hash;
    }

	//	Make back up of original function
	var org_services_load_list = window.services_load_list;

    //  Just test to see if this dom nodes are present, if they are then we can inject filter by user functionality
    if (   jQuery('#admin-nav').length > 0
        && jQuery('#working-ticket-table').length > 0
    ) {

        //  Filter out a table by assigned user
        function filterTable(table, user)
        {
            var trs = jQuery(table + ' tr[id^="ticket"]');
            trs.each(function(event) { jQuery(this).show(); });

            if (user != 'all') {
                trs.each(function(event) {
                    if (jQuery(this).find('.usertag').html() != user) {
                        jQuery(this).hide();
                    }
                });
            }

        }

        function decimalToHexString(number)
        {
            if (number < 0) {
                number = 0xFFFFFFFF + number + 1;

            }

            return number.toString(16).toUpperCase().substring(0, 6);
        }

        function colorCodeTable(table)
        {
            var trs = jQuery(table + ' tr[id^="ticket"]');
            trs.each(function(event) {
                var user = jQuery(this).find('.usertag').html();
                jQuery(this).find('td').css('border', '2px solid #' + decimalToHexString(user.hashCode()));
            });
        }

        //  Get all the suers
        var users = [];
        jQuery('.usertag').each(function(event) {
            users.push(jQuery(this).html());
        });

        users = users.unique();

        //  Create the filter select shit
        //  Make sure to include an option for all you bitches.
        var userOptions = '<option value="all">All</option>';
        for (var i = users.length; i--;) {
           userOptions += '<option value="'+users[i]+'">'+users[i]+'</option>';
        }
        jQuery('<div id="admin-filter"><select id="filter-user">'+userOptions+'</select><input type="button" id="filter-user-button" value="Filter By User" /></div>').appendTo('#admin-nav');

        //  create events for clicking on users so they get filtered.
        jQuery('#filter-user-button').click(function(event) {
            var user = jQuery('#filter-user').val();

            filterTable('#working-ticket-table', user);
            filterTable('#ticket-queue-table', user);
            filterTable('#pending-tickets-table', user);
            filterTable('#hold-ticket-table', user);
        });
    }

    colorCodeTable('#working-ticket-table');
    colorCodeTable('#ticket-queue-table');
    colorCodeTable('#pending-tickets-table');
    colorCodeTable('#hold-ticket-table');

	//	Hijack function so we can modify ajax request success callback
	//	sorry jon.
	window.services_load_list = function () {
		new Ajax.Request(
			'services.asp',
			{
				parameters: 'act=list&current='+escape(current_service)+'&type='+services_current_type,
				method: 'get',
				onSuccess: function(res){
					$('services').innerHTML = res.responseText;
					var e = $('service-form');
					if (e) {
						var pos = Position.cumulativeOffset(e);
						window.scrollTo(0, pos[1]);
					}

					// scroll domain-form to top of viewport
					$domainForm = jQuery('#domain-form');
					if ($domainForm) {
						jQuery('html,body').animate({scrollTop: $domainForm.offset().top}, 500);
					}

					var $defList = jQuery('#domain-form dl'), $defListChildren;
					$defList.find('*').each(function(index) {
						jQuery(this).removeAttr('style');
					});

					//	Move dd into dt tag
					$defListChildren = $defList.children();
					jQuery.each($defListChildren, function() {
						if ('DD' == jQuery(this).get(0).nodeName) {
							jQuery(this).appendTo(jQuery(this).prev());
						}
					});
					//	make dt tag into li tag
					$defListChildren = $defList.children();
					jQuery.each($defListChildren, function() {
						var content = jQuery(this).html();
						jQuery(this).replaceWith(jQuery('<li/>').html(content));
					});
					//	make original dt tag child the label
					$defListChildren = $defList.children();
					jQuery.each($defListChildren, function() {
						var fChild = jQuery(this).find(':first-child'),
							lChild = jQuery(this).find(':last-child'),
							fChildContent,
							lChildContent;

						fChildContent = fChild.html();
						lChildContent = lChild.html();

						var id = lChild.find(':first-child').attr('id');
						if (id == undefined) {
							id = '';
						} else {
							id = ' for="' + id + '"';
						}

						fChild.remove();
						lChild.remove();
						jQuery('<label'+ id + '>' + fChildContent + '</label>').prependTo(jQuery(this));
                        //  Empty fields will choke and die, so if there is nothing
                        //  to append, just skip it
                        if ('&nbsp;' != lChildContent) {
                            jQuery(lChildContent).appendTo(jQuery(this));
                        }
					});

					var defListContent = $defList.html();
					$defList.replaceWith(jQuery('<ul/>').html(defListContent));
					jQuery('<fieldset><legend><span>Server Details</span></legend><ol></ol></fieldset>').insertBefore("#domain-form ul:first");
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset ol')); // domain name
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset ol')); // service name
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset ol')); // service status
					jQuery('#domain-form ul:first li:eq(1)').appendTo(jQuery('#domain-form fieldset ol')); // service type

					jQuery('<fieldset class="alt"><legend><span>Notes</span></legend><ol></ol></fieldset>').insertBefore("#domain-form ul:first");
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(1) ol')); // details
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(1) ol')); // admin details

					jQuery('<fieldset><legend><span>FTP Info</span></legend><ol></ol></fieldset>').insertBefore("#domain-form ul:first");
					jQuery('#domain-form ul:first li:nth-child(4)').appendTo(jQuery('#domain-form fieldset:eq(2) ol')); // url host
					jQuery('#domain-form ul:first li:nth-child(4)').appendTo(jQuery('#domain-form fieldset:eq(2) ol')); // login
					jQuery('#domain-form ul:first li:nth-child(4)').appendTo(jQuery('#domain-form fieldset:eq(2) ol')); // password

					jQuery('<fieldset class="alt"><legend><span>Billing</span></legend><ol></ol></fieldset>').insertBefore("#domain-form ul:first");
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(3) ol')); // billing item
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(3) ol')); // period
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(3) ol')); // amount
					jQuery('#domain-form ul:first li:first').appendTo(jQuery('#domain-form fieldset:eq(3) ol')); // show

					jQuery('#domain-form ul:first').remove();
				},
				onFailure: tickets_reportError
			}
		);
	}

    jQuery('select').css('font-size', '100%');
}

// load jQuery and execute the main function
addJQuery(main);
