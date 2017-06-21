package systems;

import echo.View;
import echo.System;
import nape.phys.Body;
import components.Status;

/**
 * ...
 * @author https://github.com/wimcake
 */
class NapeDebugDraw extends System {


	var solidNonsensors:Bool;

	#if luxe var batcher:phoenix.Batcher; #end


	public function new(solidNonsensors:Bool = false) {
		this.solidNonsensors = solidNonsensors;
		#if luxe 
			Luxe.physics.nape.draw = false;
			batcher = Luxe.renderer.create_batcher( { name: 'napedebug', layer: 5 } );
		#end
	}

	#if luxe
	@u inline function draw_body(dt:Float, b:Body) {
		var color = new luxe.Color().rgb(0xf0f0f0);
		for (sh in b.shapes) {
			if (sh.isCircle()) luxe.utils.NapeDrawer.cir(sh.castCircle, color, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
			else luxe.utils.NapeDrawer.pol(sh.castPolygon, color, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
		}
	}
	#end

}
