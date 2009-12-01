From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Tue, 01 Dec 2009 11:05:53 +0100
Message-ID: <4B14EA81.5030603@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070104000702080809000706"
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZLAKFt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:05:49 -0500
In-Reply-To: <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070104000702080809000706
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Sunday 2009-11-29 12:33, Adam Nielsen wrote:
> 
>>>> static bool led_tg_check(const struct xt_tgchk_param *par)
>>>> {
>>>> 	struct xt_led_info *ledinfo = par->targinfo;
>>>> -	struct xt_led_info_internal *ledinternal;
>>>> +	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
>>>> 	int err;
>>> You cannot rely on ledinfo->internal_data having any meaningful
>>> value when iptables prepares the rule.
>> Hmm ok, so in led_tg_check (the .checkentry function) how do you tell whether
>> the xt_tgchk_param is pointing to an existing ruleset or not?  Or is it always
>> referring to a new ruleset and you have to handle it yourself?
> 
> You always have to do a lookup on some structure that has xt_LED.ko 
> lifetime (similar to what xt_recent/xt_rateest does).
> 
>> I guess my question comes from this point of view:
>>
>>  $ iptables -A scroll_lock -j LED --led-trigger-id http
>>
>> This calls led_tg_check() with a new xt_tgchk_param structure.
>>
>>  $ iptables -I INPUT 1 -p tcp --sport 80 -j scroll_lock
>>
>> Now led_tg_check() gets called again with an xt_tgchk_param structure
>> containing the trigger name etc. even though this was not specified on the
>> command line.  Where does that second xt_tgchk_param come from if it's not a
>> pointer to the first one?
> 
> Running two iptables instances concurrently. Even without races like 
> these, it would be a security violation to accept unknown pointers from 
> userspace.

Since this has already taken ages, I took the liberty of preparing
an example fix. Adam, please have a look at this and give it some
testing.

As usual when sharing state but not parameters between target
instances, there's a problem of potentially inconsistent parameters.
You can now create two rules refering to the same trigger, but
using different always_blink and delay parameters. You could
either catch this by storing a copy of the parameters in the
xt_led_info_internal struct and verifying their consistency, or ignore
it and have each rule modify the LED state using its own parameters.
Not sure which one makes more sense here.


--------------070104000702080809000706
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 8ff7843..1a6693f 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -31,12 +31,16 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
 MODULE_DESCRIPTION("Xtables: trigger LED devices on packet match");
 
+static LIST_HEAD(xt_led_triggers);
+
 /*
  * This is declared in here (the kernel module) only, to avoid having these
  * dependencies in userspace code.  This is what xt_led_info.internal_data
  * points to.
  */
 struct xt_led_info_internal {
+	struct list_head list;
+	int refcnt;
 	struct led_trigger netfilter_led_trigger;
 	struct timer_list timer;
 };
@@ -80,6 +84,17 @@ static void led_timeout_callback(unsigned long data)
 	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
 }
 
+static struct xt_led_info_internal *led_trigger_lookup(const char *name)
+{
+	struct xt_led_info_internal *ledinternal;
+
+	list_for_each_entry(ledinternal, &xt_led_triggers, list) {
+		if (!strcmp(name, ledinternal->netfilter_led_trigger.name))
+			return ledinternal;
+	}
+	return NULL;
+}
+
 static bool led_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_led_info *ledinfo = par->targinfo;
@@ -91,12 +106,19 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 		return false;
 	}
 
+	ledinternal = led_trigger_lookup(ledinfo->id);
+	if (ledinternal) {
+		ledinternal->refcnt++;
+		goto out;
+	}
+
 	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
 	if (!ledinternal) {
 		printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
 		return false;
 	}
 
+	ledinternal->refcnt = 1;
 	ledinternal->netfilter_led_trigger.name = ledinfo->id;
 
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
@@ -114,6 +136,8 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 		setup_timer(&ledinternal->timer, led_timeout_callback,
 			    (unsigned long)ledinfo);
 
+	list_add_tail(&ledinternal->list, &xt_led_triggers);
+out:
 	ledinfo->internal_data = ledinternal;
 
 	return true;
@@ -129,6 +153,10 @@ static void led_tg_destroy(const struct xt_tgdtor_param *par)
 	const struct xt_led_info *ledinfo = par->targinfo;
 	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
 
+	if (--ledinternal->refcnt)
+		return;
+
+	list_del(&ledinternal->list);
 	if (ledinfo->delay > 0)
 		del_timer_sync(&ledinternal->timer);
 

--------------070104000702080809000706--
