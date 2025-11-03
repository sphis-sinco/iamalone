package sphis.iamlo;

import flixel.FlxBasic;

class SlideEvent
{
	public var slide_length:Float = 1.0;

	public var objects:Array<FlxBasic> = [];

	public function new(slide_length:Float)
	{
		this.slide_length = slide_length;
	}

	public dynamic function init() {};

	public dynamic function create() {};

	public dynamic function update() {};
}
