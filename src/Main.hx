package;

import luxe.loading.ArcProgress;
import luxe.Color;
import luxe.Entity;
import luxe.Ev;
import luxe.GameConfig;
import luxe.Input;
import luxe.Parcel;
import luxe.Rectangle;
import luxe.Screen.WindowEvent;
import luxe.States;
import luxe.Text;
import luxe.Vector;

using Log;

class Main extends luxe.Game {


	static public var states:States;

	var toptext:Text;
	var bottext:Text;
	var rbottext:Text;


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

		toptext = new luxe.LogText(true, true, size, new Color().rgb(Std.random(0xffffff)), logbat);
		bottext = new luxe.LogText(true, false, size, new Color().rgb(Std.random(0xffffff)), logbat);

		rbottext = new luxe.LogText(false, false, size, new Color().rgb(Std.random(0xffffff)), logbat);
		rbottext.text = '[R] to reload scene; [Q/A] to add/remove chicken; [D] to enable/disable debug nape draw';

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
		states = new States( { name: "states" } );
		states.add(new Game());

		states.set("game");
	}


	override function update(dt:Float) {
		Log.track('dt', dt.fpretty(3));
		Log.track('render', '${Luxe.renderer.stats}');

		toptext.text = Log.getTracks();
		bottext.text = Log.getLogs(25);
	}

	override function onwindowsized(e:WindowEvent) {
		Luxe.camera.viewport = new luxe.Rectangle(0, 0, e.x, e.y);
	}

}
