package luxe.utils;

import luxe.Color;
import luxe.Text;
import luxe.Vector;
import phoenix.Batcher;

using Log;

/**
 * ...
 * @author https://github.com/wimcake
 */
class LogText extends Text {


	var margin = 3.0;

	var l:Bool;
	var t:Bool;


	public function new(l:Bool = true, t:Bool = true, size:Float = 14.0, ?color:Color, ?batch:Batcher, ?text:String) {
		this.l = l;
		this.t = t;
		super( {
			pos: new Vector(this.l ? margin : Luxe.screen.width - margin, this.t ? margin : Luxe.screen.height - margin),
			align: l ? left : right,
			align_vertical: t ? top : bottom,
			color: color.alt(new Color().rgb(0xf0f0f0)),
			//font: Luxe.resources.font('font.fnt'),
			point_size: size,
			batcher: batch.alt(Luxe.renderer.batcher),
			text: text.alt('...'),
		} );
	}

	override public function onwindowsized(e:luxe.Screen.WindowEvent) {
		this.pos.set_xy(this.l ? margin : Luxe.screen.width - margin, this.t ? margin : Luxe.screen.height - margin);
	}

}
