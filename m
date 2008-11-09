From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Sun, 9 Nov 2008 14:36:01 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811091429280.12658@fbirervta.pbzchgretzou.qr>
References: <4916E4F0.8010507@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49421 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYKINgE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:36:04 -0500
In-Reply-To: <4916E4F0.8010507@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-11-09 14:26, Adam Nielsen wrote:

> Kernel module providing implementation of LED netfilter target.  Each
> instance of the target appears as a led-trigger device, which can be
> associated with one or more LEDs in /sys/class/leds/

Heh I thought I've seen everything, but this was yet unseen :)

> +	  To compile it as a module, choose M here.  If unsure, say N.

I think this historical line is now redundant, especially when
every single option has it.

> +#define DRVNAME	"xt_LED"

Drop DRVNAME, you can use the predefined KBUILD_MODNAME.

> +#define DRVMSG	DRVNAME ": "
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
> +MODULE_DESCRIPTION("Xtables: trigger LED devices on packet match");
> +
> +struct xt_led_info {
> +	char id[26];  /* Unique ID for this trigger in the LED class */
> +	int delay;    /* Delay until LED is switched off again after trigger */

Please, no variadic-size types as per
http://jengelh.medozas.de/Netfilter_Modules.pdf .

> +/* If the LED is currently on, it could be some time before it
> +   switches off again.  Another matching packet has arrived
> +   though, so uncommenting the code below will briefly turn the
> +   LED off to signal the new packet.  It will be switched on
> +   again below, then stay on for the full timeout again.  The
> +   code is currently commented out, because it can make the LED
> +   flicker when lots of packets arrive, which defeats the
> +   purpose of having the delay... */

Well that could be a feature in itself. After all, network
switches flicker a lot too :)

> +static void led_timeout_callback(unsigned long data)
> +{
> +	struct xt_led_info *ledinfo = (struct xt_led_info *)data;
> +	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
> +
> +	/* If the timer has expired while we're changing the state, then don't
> +	   interfere.  We also don't want to twiddle with anything after the
> +	   mutex is unlocked, because by then a new timeout will have been
> +	   set. */
> +	if (mutex_is_locked(&ledinternal->led_changing_state)) return;
\n
> +	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
> +	return;
> +}
> +
> +static bool led_tg_check(const struct xt_tgchk_param *par)
> +{
> +	/*noconst*/ struct xt_led_info *ledinfo = par->targinfo;
> +	struct xt_led_info_internal *ledinternal;
> +
> +	if (ledinfo->id[0] == 0) {
'\0'
> +		printk(DRVMSG "No 'id' parameter given.\n");

printks are missing a KERN_ level.

> +		return false;
> +	}
> +
> +	/* See if we need to set up a timer */
> +	if (ledinfo->delay > 0) {
> +		setup_timer(&ledinternal->timer, led_timeout_callback,
> +			(unsigned long) ledinfo);
> +	}

-{}

> +static void led_tg_destroy(const struct xt_tgdtor_param *par)
> +{
> +	const struct xt_led_info *ledinfo = par->targinfo;
> +	/*noconst*/struct xt_led_info_internal *ledinternal =
> ledinfo->internal_data;
> +
> +	printk(DRVMSG "Unregistering led trigger \"%s\".\n",
> +		ledinternal->netfilter_led_trigger.name);
> +
> +	if (ledinfo->delay > 0)
> +		del_timer_sync(&ledinternal->timer);
> +
> +	led_trigger_unregister(&ledinternal->netfilter_led_trigger);
> +	kfree(ledinternal);
> +	return;
> +}

-return

> +static struct xt_target led_tg_reg __read_mostly = {
> +	.name = "LED",
> +	.revision = 0,
> +	.family = NFPROTO_UNSPEC,
> +	.target = led_tg,
> +	.targetsize = sizeof(struct xt_led_info),

XT_ALIGN(sizeof(..)).

> +	.checkentry = led_tg_check,
> +	.destroy = led_tg_destroy,
> +	.me = THIS_MODULE,
> +};
> +
> +static int __init led_tg_init(void)
> +{
> +	printk(KERN_NOTICE DRVMSG "Registering LED netfilter target\n");
> +	return xt_register_target(&led_tg_reg);
> +}
> +
> +static void __exit led_tg_exit(void)
> +{
> +	printk(KERN_NOTICE DRVMSG "Unregistering LED netfilter target\n");
> +	xt_unregister_target(&led_tg_reg);
> +	return;
> +}
> +
> +module_init(led_tg_init);
> +module_exit(led_tg_exit);

Looks good :)
Though I wonder when I will ever have a desktop PC with LEDs
driven by the led subsystem...
