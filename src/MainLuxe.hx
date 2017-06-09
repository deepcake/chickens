package;

import luxe.loading.ArcProgress;
import luxe.Color;
import luxe.GameConfig;
import luxe.Parcel;
import luxe.Rectangle;
import luxe.Screen.WindowEvent;
import luxe.States;
import luxe.Text;

using Log;

class MainLuxe extends luxe.Game {


	static public var states:States;

	var mon_text:Text;
	var log_text:Text;
	var info_text:Text;


	override public function config(config:GameConfig):GameConfig { // TODO move to config.json ?
		#if (web || mobile)
			config.window.fullscreen = true;
		#else
			config.window.width = 1280;
			config.window.height = 720;
		#end

		config.window.title = 'chickens';

		//config.preload.fonts.push( { id:'font.fnt' } );

		return config;
	}


	override function ready() {
		var logbat = Luxe.renderer.create_batcher( { name: 'log' } );
		var size = 14 * Luxe.screen.device_pixel_ratio;

		mon_text = new luxe.utils.LogText(true, true, size, new Color().rgb(Std.random(0xffffff)), logbat);
		log_text = new luxe.utils.LogText(false, false, size, new Color().rgb(Std.random(0xffffff)), logbat);

		Log.log('ready');

		var parcel = new Parcel( {
			load_time_spacing: .5,
			load_start_delay: .5,
			textures: [
				{ id: 'assets/sprites.png' },
			],
			texts: [
				{ id: 'assets/sprites.xml' },
			]
		} );

		new ArcProgress(parcel, new Color().rgb(Std.random(0xffffff)), start);
	}


	function start() {
		Builder.initialize();

		states = new States( { name: "states" } );
		states.add(new luxe.GameState());

		states.set("game");
	}


	override function update(dt:Float) {
		Log.track('dt', dt.fpretty(3));
		Log.track('render', '${Luxe.renderer.stats}');

		mon_text.text = Log.getTracks();
		log_text.text = Log.getLogs(50);
	}

	override function onwindowsized(e:WindowEvent) {
		Luxe.camera.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
	}

}
