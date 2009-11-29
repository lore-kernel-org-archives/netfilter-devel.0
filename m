From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sun, 29 Nov 2009 11:12:41 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60333 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZK2KMg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2009 05:12:36 -0500
In-Reply-To: <4B11D1B5.2060306@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-11-29 02:43, Adam Nielsen wrote:
>
>>>> Just wondering whether there's still hope for this issue to get fixed.
>>>>
>>>> I haven't added the LED extension to iptables yet, so if there's no
>>>> interest in fixing this, we can remove the LED target again.
>
> I am relying on the xt_tgchk_param passed to the .checkentry function being
> zero'd out the first time.  One of the members is a pointer which becomes valid
> when the LED trigger is created, and I'm assuming if that pointer is NULL then
> the LED trigger hasn't yet been created.  Providing that iptables sets this
> field to NULL before the first call, and leaves it unchanged when replacing
> rules/tables then it will work fine.
>
>@@ -83,43 +84,52 @@ static void led_timeout_callback(unsigned long data)
> static bool led_tg_check(const struct xt_tgchk_param *par)
> {
> 	struct xt_led_info *ledinfo = par->targinfo;
>-	struct xt_led_info_internal *ledinternal;
>+	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
> 	int err;

You cannot rely on ledinfo->internal_data having any meaningful
value when iptables prepares the rule.

1. iptables1 loads ruleset (-j LED exists somewhere)
2. someone does -A INPUT something
3. iptables1 blocks for some reason (say, DNS..)
		4. iptables2 loads ruleset (-j LED exists)
		5. someone does -D .. -j LED
		6. iptables2 submits ruleset
7. iptables1 becomes runnable again and submits ruleset

 -> ledinfo->internal_data now points to a freed area.
