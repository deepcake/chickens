package components;

@:forward(x, y, angle)
abstract Vel(nape.geom.Vec2) from nape.geom.Vec2 to nape.geom.Vec2 {
	inline public function new(x:Float = 0, y:Float = 0) this = nape.geom.Vec2.get(x, y);
}
