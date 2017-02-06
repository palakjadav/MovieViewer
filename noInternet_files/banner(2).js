var bannerboy = bannerboy || {};
bannerboy.main = function() {

	var width = 728;
	var height = 90;
	var banner = bannerboy.createElement({width: width, height: height, backgroundColor: "#fff", overflow: "hidden", cursor: "pointer", parent: document.getElementById("banner")});
	
	var imageMargin = 3
	var main_tl;

	var images = [
		"image_1.jpg", 
		"image_2.jpg", 
		"image_3.jpg", 
		"image_4.jpg", 
		"cta_arrow.png", 
		"cta_base.png", 
		"txt_1_2.png", 
		"txt_1_1.png", 
		"logo_squarespace_sm.png", 
		"logo_squarespace_lg.png", 
	];

	bannerboy.preloadImages(images, function() {

		/* Create elements
		================================================= */
		var images = createImages({
			images: ["image_1.jpg", "image_2.jpg", "image_3.jpg", "image_4.jpg"],
			loops: 3,
			margin: 3
		});

		var cta = bannerboy.createElement({left: 672, top: 29, width: 32, height: 31, parent: banner});
			var cta_arrow = bannerboy.createElement({backgroundImage: "cta_arrow.png", left: 12, top: 10, retina: true, parent: cta});
			var cta_base = bannerboy.createElement({backgroundImage: "cta_base.png", retina: true, parent: cta});
		var txt_1 = bannerboy.createElement({left: 408, top: 8, width: 267, height: 74, parent: banner});
				var txt_1_2 = bannerboy.createElement({backgroundImage: "txt_1_2.png", left: 434, top: 50, retina: true, parent: banner});
				var txt_1_1 = bannerboy.createElement({backgroundImage: "txt_1_1.png", retina: true, parent: txt_1});
		var logo_squarespace_sm = bannerboy.createElement({backgroundImage: "logo_squarespace_sm.png", left: 85, top: 35, retina: true, parent: banner});
		var logo_squarespace_lg = bannerboy.createElement({backgroundImage: "logo_squarespace_lg.png", left: 83, top: 33, retina: true, parent: banner});
		var border = bannerboy.createElement({id: "border", width: width, height: height, border: "solid 1px #696969", boxSizing: "border-box", parent: banner});
		
		/* Adjust elements
		================================================= */
		cta.set({overflow: "hidden"});

		/* Animations
		================================================= */

		// logo sm
		logo_squarespace_sm.tl_in = new BBTimeline()
		.from(logo_squarespace_sm, 4.2, {y: -images.positions[0], ease: Power3.easeInOut});

		// logo lg
		logo_squarespace_lg.tl_out = new BBTimeline()
		.to(logo_squarespace_lg, 1.8, {y: -height, ease: Power3.easeIn});

		// txt_1
		txt_1.tl_in = new BBTimeline()
		.from(txt_1_1, 0.5, {opacity: 0, y: 50, ease: Power1.easeOut})
		.offset(0.05)
		.from(txt_1_2, 0.5, {opacity: 0, y: 50, ease: Power1.easeOut});

		// cta
		cta.tl_in = new BBTimeline()
		.from(cta_base, 0.65, {scale: 0, ease: Power3.easeInOut})
		.offset(0.5)
		.from(cta_arrow, 0.45, {opacity: 0, ease: Power2.easeOut});

		/* Timeline
		================================================= */
		main_tl = new BBTimeline()
		.offset(0.8)

		.call(images.play)
		.add(logo_squarespace_sm.tl_in)
		.offset(0.14)
		.add(logo_squarespace_lg.tl_out)
		.chain(1.2)

		.add(txt_1.tl_in)
		.offset(0.1)
		.add(cta.tl_in)
		.chain(1.8)

		.call(images.play)
		.chain(5.4)
		.call(images.play);

		/* Interactions
		================================================= */
		banner.addEventListener("mouseenter", function() {
			return new BBTimeline()
			.to(cta_arrow, 0.2, {x: 50, ease: Power2.easeIn})
			.chain()
			.to(cta_arrow, 0.001, {x: -50})
			.chain()
			.to(cta_arrow, 0.2, {x: 0, ease: Power2.easeOut});
		});

		/* Helpers
		================================================= */
		function createImages(settings) {
			var container = bannerboy.createElement({width: width, height: height, parent: banner});
			container.positions = [];
			container.currentPosition = -1;

			var top = 0;
			var y = 0;
			var x = 0;

			for (var i = 0; i < settings.loops; i++) {
				for (var j = 0; j < settings.images.length; j++) {
					y = (height * j) + (settings.margin * j);
					var image = bannerboy.createElement({backgroundImage: settings.images[j], top: top, y: y, parent: container});
				}

				top += y + height + settings.margin;
				container.positions.push(-top + height + settings.margin);
			}

			container.play = function() {
				container.currentPosition++;

				return new BBTimeline()
				.to(container, 4.2, {y: container.positions[container.currentPosition], ease: Power3.easeInOut})
			}

			return container;
		}

		/* Scrubber
		================================================= */
		function scrubber(tl) {
			if (window.location.origin == "file://") {
				bannerboy.include(["../bannerboy_scrubber.min.js"], function() {
					if (bannerboy.scrubberController) bannerboy.scrubberController.create({"main timeline": tl});
				});
			}
		}
	});
};