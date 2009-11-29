From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sun, 29 Nov 2009 21:33:44 +1000
Message-ID: <4B125C18.7060802@shikadi.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3067 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZK2Ldm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:33:42 -0500
In-Reply-To: <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> static bool led_tg_check(const struct xt_tgchk_param *par)
>> {
>> 	struct xt_led_info *ledinfo = par->targinfo;
>> -	struct xt_led_info_internal *ledinternal;
>> +	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
>> 	int err;
>
> You cannot rely on ledinfo->internal_data having any meaningful
> value when iptables prepares the rule.

Hmm ok, so in led_tg_check (the .checkentry function) how do you tell whether 
the xt_tgchk_param is pointing to an existing ruleset or not?  Or is it always 
referring to a new ruleset and you have to handle it yourself?

I guess my question comes from this point of view:

   $ iptables -A scroll_lock -j LED --led-trigger-id http

This calls led_tg_check() with a new xt_tgchk_param structure.

   $ iptables -I INPUT 1 -p tcp --sport 80 -j scroll_lock

Now led_tg_check() gets called again with an xt_tgchk_param structure 
containing the trigger name etc. even though this was not specified on the 
command line.  Where does that second xt_tgchk_param come from if it's not a 
pointer to the first one?

Thanks,
Adam.
