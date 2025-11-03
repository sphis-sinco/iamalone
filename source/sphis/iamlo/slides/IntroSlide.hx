package sphis.iamlo.slides;

import flixel.FlxG;
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
				nicom.scale.set(1.1, 0.9);

				new FlxTimer().start((1 / FlxG.drawFramerate), function(timer:FlxTimer)
				{
					nicom.scale.set(1.3, 0.7);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 2, function(timer:FlxTimer)
				{
					nicom.scale.set(1.35, 0.65);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 4, function(timer:FlxTimer)
				{
					nicom.loadGraphic('assets/images/nicom-front-face-fear.png');
					nicom.scale.set(0.9, 1.1);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 5, function(timer:FlxTimer)
				{
					nicom.scale.set(1 - .5, 1.5);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 7, function(timer:FlxTimer)
				{
					nicom.scale.set(1 - .4, 1.4);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 9, function(timer:FlxTimer)
				{
					nicom.scale.set(1 - .2, 1.2);
				});
				new FlxTimer().start((1 / FlxG.drawFramerate) * 11, function(timer:FlxTimer)
				{
					nicom.scale.set(1, 1);
				});
			});
		};

		this.events = [event_1, event_2];
		
		this.press_key_to_continue = true;
		this.can_skip_before_end = true;

		super.create();
	}
}
