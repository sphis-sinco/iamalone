package sphis.iamlo.slides;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

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

			this.add(nicom);

			FlxTween.tween(nicom, {alpha: 1}, 1, {
				onComplete: function(tween:FlxTween)
				{
					trace("Tweened Nicom into view");
				},
				ease: FlxEase.sineInOut
			});
		}

		var event_2:SlideEvent = new SlideEvent(2.0);
		event_2.init = function()
		{
			var nicom:FlxSprite = cast event_1.getObject('nicom');

			event_2.addObject('nicom', nicom.clone());
		};
		event_2.create = function()
		{
			var nicom:FlxSprite = cast event_2.getObject('nicom');

			nicom.screenCenter();

			this.add(nicom);

			FlxTween.tween(nicom, {alpha: 0.75}, 1, {
				ease: FlxEase.sineInOut
			});
			new FlxTimer().start(1, function(timer:FlxTimer)
			{
				nicom.loadGraphic('assets/images/nicom-front-face-fear');
			});
		};

		this.events = [event_1, event_2];
		
		this.press_key_to_continue = true;
		this.can_skip_before_end = true;

		super.create();
	}
}
