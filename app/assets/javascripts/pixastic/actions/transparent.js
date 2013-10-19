/*
 * Pixastic Lib - Desaturation filter - v0.1.1
 * Copyright (c) 2008 Jacob Seidelin, jseidelin@nihilogic.dk, http://blog.nihilogic.dk/
 * License: [http://www.pixastic.com/lib/license.txt]
 */

Pixastic.Actions.transparent = {

	process : function(params) {
		var useAverage = !!(params.options.white && params.options.white != "false");

		if (Pixastic.Client.hasCanvasImageData()) {
			var data = Pixastic.prepareData(params);
			var rect = params.options.rect;
			var w = rect.width;
			var h = rect.height;

			var p = w*h;
			var pix = p*4;

			if (useAverage) {
				while (p--) 
					data[(pix-=4) + 3] = (data[pix]+data[pix+1]+data[pix+2])/3
			} else {
				while (p--)
					data[(pix-=4) + 3] = 255 - (data[pix]+data[pix+1]+data[pix+2])/3
			}
			return true;
		} else if (Pixastic.Client.isIE()) {
			params.image.style.filter += " gray";
			return true;
		}
	},
	checkSupport : function() {
		return (Pixastic.Client.hasCanvasImageData() || Pixastic.Client.isIE());
	}
}
