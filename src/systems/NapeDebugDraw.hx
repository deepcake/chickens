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


	var view:View<{ b:Body }>;
	var solidNonsensors:Bool;

	#if luxe var batcher:phoenix.Batcher; #end


	public function new(solidNonsensors:Bool = false) {
		this.solidNonsensors = solidNonsensors;
		#if luxe 
			Luxe.physics.nape.draw = false;
			batcher = Luxe.renderer.create_batcher( { name: 'napedebug', layer: 5 } );
		#end
	}

	override public function update(dt:Float) {
		for (v in view) {
			for (sh in v.b.shapes) {
				#if luxe
					var color = (echo.hasComponent(v.id, Status) && echo.getComponent(v.id, Status).interactingBodies.length > 0) ? new luxe.Color().rgb(0xf00000) : new luxe.Color().rgb(0xf0f0f0);
					if (sh.isCircle()) lx.utils.NapeDrawer.cir(sh.castCircle, color, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
					else lx.utils.NapeDrawer.pol(sh.castPolygon, color, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
				#end
			}
		}
	}

}
