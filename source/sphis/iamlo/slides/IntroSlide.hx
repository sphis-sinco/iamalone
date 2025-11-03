package sphis.iamlo.slides;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class IntroSlide extends Slide
{
	override public function create()
	{
		var event_1:SlideEvent = new SlideEvent(1.0);
		event_1.init = function()
		{
			var nicom = new FlxSprite();
			nicom.loadGraphic('assets/images/nicom-front-face.png');

			event_1.addObject('nicom', nicom);
		};

		event_1.create = function()
		{
			var nicom:FlxSprite = cast event_1.getObject('nicom');

			nicom.alpha = 0;
			nicom.screenCenter();

			FlxTween.tween(nicom, {alpha: 1}, 1);
		}

		this.events.push(event_1);

		super.create();
	}
}
