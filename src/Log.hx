package;
import haxe.Timer;
using StringTools;

/**
 * ...
 * @author https://github.com/wimcake
 */
class Log {


	static var INIT_STAMP = Timer.stamp();


	static var logs:Array<String> = [];

	static var tracks:Array<String> = [];
	static var tracksMap:Map<String, String> = new Map();


	static public var tracer:Dynamic = function(val:Dynamic) trace(val);


	static public function log(a:Dynamic) {
		if (tracer != null) tracer(a);
		logs.push(fpretty(Timer.stamp() - INIT_STAMP, 3) + ' : ' + Std.string(a));
	}

	static public function getLogs(?count:Int):String {
		var pos = Std.int(Math.max(0, logs.length - alt(count, logs.length)));
		var ret = '';
		for (i in pos...logs.length) ret += (ret.length > 0 ? '\n' : '') + logs[i];
		return ret;
	}


	static public function track(key:String, value:Dynamic) {
		if (!tracksMap.exists(key)) tracks.push(key);
		tracksMap[key] = Std.string(value);
	}

	static public function untrack(key:String) {
		if (tracksMap.exists(key)) {
			tracks.remove(key);
			tracksMap.remove(key);
		}
	}

	static public function getTracks():String {
		var ret = '';
		for (key in tracks) ret += (ret.length > 0 ? '\n' : '') + '$key: ${tracksMap[key]}';
		return ret;
	}


	static public function fpretty(x:Float, digits:Int = 1):String {
		var s = Std.string(x);
		var dotpos = s.indexOf('.');
		if (dotpos == -1) {
			return digits < 1 ? s : s + '.' + ''.rpad('0', digits);
		} else {
			return s.substring(0, dotpos) + (digits < 1 ? '' : '.' + s.substr(dotpos + 1, digits).rpad('0', digits));
		}
	}

	static public inline function alt<T>(x:Null<T>, a:T):T {
		return x == null ? a : x;
	}

}
