# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$("#film_title").autocomplete
		source: "autocomplete"
		select: (e, ui) ->
			$("#film_netflix_id").val ui.item.netflix_id