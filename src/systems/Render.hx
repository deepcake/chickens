package systems;

import echo.View;
import echo.System;
import luxe.Sprite;
import nape.phys.Body;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Render extends System {


	var view:View<{ b:Body, s:Sprite }>;


	@r function removeSprite(id:Int) {
		echo.getComponent(id, Sprite).destroy();
	}

	override public function update(dt:Float) {
		for (v in view) {

			if (v.s.flipx && v.b.velocity.x > 0) v.s.flipx = false;
			if (!v.s.flipx && v.b.velocity.x < 0) v.s.flipx = true;

			v.s.pos.x = v.b.position.x;
			v.s.pos.y = v.b.position.y;
			v.s.depth = Std.int(v.b.position.y);

		}
	}

}
