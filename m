From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v4] New netfilter target to trigger LED devices
Date: Thu, 12 Feb 2009 06:27:40 +0100
Message-ID: <4993B34C.1020307@trash.net>
References: <49934702.9060909@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, rpurdie@linux.intel.com
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZBLF1q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:27:46 -0500
In-Reply-To: <49934702.9060909@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
> +static unsigned int
> +led_tg(struct sk_buff *skb, const struct xt_target_param *par)
> +{
> +    const struct xt_led_info *ledinfo = par->targinfo;
> +    /*noconst*/struct xt_led_info_internal *ledinternal = 
> ledinfo->internal_data;
> +
> +    /*
> +     * Make sure the timer callback doesn't go switching the LED off while
> +     * we're figuring out what to do
> +     */
> +    if (ledinfo->delay > 0) {
> +        mutex_lock(&ledinternal->led_changing_state);

You can't use a mutex here, this might be running in softirq context.
Is locking necessary at all? Whats the worst that might happen? The
LED might forget to blink once? :)

> +static bool led_tg_check(const struct xt_tgchk_param *par)
> +{
> +    /*noconst*/ struct xt_led_info *ledinfo = par->targinfo;
> +    struct xt_led_info_internal *ledinternal;
> +    int err;
> +
> +    if (ledinfo->id[0] == '\0') {
> +        printk(KERN_CRIT KBUILD_MODNAME ": No 'id' parameter given.\n");
> +        return false;
> +    }

I guess KERN_ERR or default level is enough.

> +    if (!(ledinternal = kzalloc(sizeof(struct xt_led_info_internal), 
> GFP_KERNEL))) {
> +        printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
> +        return false;
> +    }

Please seperate assignments from comparisons.

> +
> +    ledinternal->netfilter_led_trigger.name = ledinfo->id;
> +    mutex_init(&ledinternal->led_changing_state);
> +
> +    printk(KERN_NOTICE KBUILD_MODNAME ": Adding led trigger \"%s\"\n",
> +        ledinfo->id);

Too noisy, no printks except errors please.

> +
> +    err = led_trigger_register(&ledinternal->netfilter_led_trigger);
> +    if (err) {
> +        printk(KERN_CRIT KBUILD_MODNAME
> +            ": led_trigger_register() failed\n");
> +        if (err == -EEXIST) {
> +            printk(KERN_CRIT KBUILD_MODNAME
> +                ": Trigger name is already in use.\n");
> +        }
> +        goto exit_alloc;
> +    }
> +
> +    /* See if we need to set up a timer */
> +    if (ledinfo->delay > 0)
> +        setup_timer(&ledinternal->timer, led_timeout_callback,
> +            (unsigned long) ledinfo);
> +
> +    ledinfo->internal_data = ledinternal;
> +
> +    return true;
> +
> +exit_alloc:
> +    kfree(ledinternal);
> +
> +    return false;
> +}
> +
> +static void led_tg_destroy(const struct xt_tgdtor_param *par)
> +{
> +    const struct xt_led_info *ledinfo = par->targinfo;
> +    /*noconst*/struct xt_led_info_internal *ledinternal = 
> ledinfo->internal_data;
> +
> +    printk(KERN_NOTICE KBUILD_MODNAME ": Removing led trigger \"%s\"\n",
> +        ledinternal->netfilter_led_trigger.name);
> +
> +    if (ledinfo->delay > 0)
> +        del_timer_sync(&ledinternal->timer);
> +
> +    led_trigger_unregister(&ledinternal->netfilter_led_trigger);
> +    kfree(ledinternal);
> +}

> +
> +static int __init led_tg_init(void)
> +{
> +    printk(KERN_NOTICE KBUILD_MODNAME ": Registering LED netfilter 
> target\n");

This is too noisy, please remove this.

> +    return xt_register_target(&led_tg_reg);
> +}
> +
> +static void __exit led_tg_exit(void)
> +{
> +    printk(KERN_NOTICE KBUILD_MODNAME ": Unregistering LED netfilter 
> target\n");
> +    xt_unregister_target(&led_tg_reg);
> +}
> 
