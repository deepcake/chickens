package luxe.systems;

import echo.View;
import echo.System;
import luxe.Color;
import nape.phys.Body;

/**
 * ...
 * @author https://github.com/wimcake
 */
class NapeImmediateDrawer extends System {


	var view:View<{ b:Body, c:Color }>;

	var solidNonsensors:Bool;

	var batcher:phoenix.Batcher;


	public function new(solidNonsensors:Bool = false) {
		Luxe.physics.nape.draw = false;
		this.solidNonsensors = solidNonsensors;
		batcher = Luxe.renderer.create_batcher( { name: 'napedebug', layer: 5 } );
	}

	override public function update(dt:Float) {
		for (v in view) {
			for (sh in v.b.shapes) {
				if (sh.isCircle()) luxe.NapeDraw.cir(sh.castCircle, v.c, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
				else luxe.NapeDraw.pol(sh.castPolygon, v.c, (solidNonsensors ? !sh.sensorEnabled : false), batcher, true, false);
			}
		}
	}

}
