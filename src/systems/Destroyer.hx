package systems;

import components.Kill;
import echo.System;
import echo.View;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Destroyer extends System {

	var view:View<{ d:Kill }>;

	override public function update(dt:Float) {
		var i = view.entities.length;
		while (--i > -1) {
			echo.remove(view.entities[i]);
		}
	}

}
