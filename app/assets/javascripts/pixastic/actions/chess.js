/*
 * Pixastic Lib - Desaturation filter - v0.1.1
 * Copyright (c) 2008 Jacob Seidelin, jseidelin@nihilogic.dk, http://blog.nihilogic.dk/
 * License: [http://www.pixastic.com/lib/license.txt]
 */

Pixastic.Actions.chess = {

	process : function(params) {
		var size = 50;
		if (params.options.size)
		      	size = params.options.size;

		if (Pixastic.Client.hasCanvasImageData()) {
			var data = Pixastic.prepareData(params);
			var rect = params.options.rect;
			var w = rect.width;
			var h = rect.height;

			var p = w*h;
			var pix = p*4;

			var line = 0, column = 0;
                        black_or_white = false;
			var last_column = -1;
			while (p--) { 
				line++;
				if (line >= w) {
					line = 0;
					column++;
				}
				invert = ((line % size) == 0);
			       	if ((column % size) == 0 && last_column != column) {
					last_column = column;
					invert = !invert;
				}
				if (invert)
					black_or_white = !black_or_white
				data[(pix-=4) + 3] = black_or_white ? 255 : 0;
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
