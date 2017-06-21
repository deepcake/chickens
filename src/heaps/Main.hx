package hp;

class Main extends hxd.App {


	override function init() {
		//Builder.initialize();

		var a = new h2d.Anim(hxd.Res.sprites.getAnim("chicken_fly"), 25);
		s2d.addChild(a);
	}

	override function update(dt:Float) {
		//Builder.echo.update(dt);
	}


	static public function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}
