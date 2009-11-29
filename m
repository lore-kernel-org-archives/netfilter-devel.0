From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sun, 29 Nov 2009 16:49:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49743 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbZK2PtA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:49:00 -0500
In-Reply-To: <4B125C18.7060802@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2009-11-29 12:33, Adam Nielsen wrote:

>>> static bool led_tg_check(const struct xt_tgchk_param *par)
>>> {
>>> 	struct xt_led_info *ledinfo = par->targinfo;
>>> -	struct xt_led_info_internal *ledinternal;
>>> +	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
>>> 	int err;
>>
>> You cannot rely on ledinfo->internal_data having any meaningful
>> value when iptables prepares the rule.
>
> Hmm ok, so in led_tg_check (the .checkentry function) how do you tell whether
> the xt_tgchk_param is pointing to an existing ruleset or not?  Or is it always
> referring to a new ruleset and you have to handle it yourself?

You always have to do a lookup on some structure that has xt_LED.ko 
lifetime (similar to what xt_recent/xt_rateest does).

> I guess my question comes from this point of view:
>
>  $ iptables -A scroll_lock -j LED --led-trigger-id http
>
> This calls led_tg_check() with a new xt_tgchk_param structure.
>
>  $ iptables -I INPUT 1 -p tcp --sport 80 -j scroll_lock
>
> Now led_tg_check() gets called again with an xt_tgchk_param structure
> containing the trigger name etc. even though this was not specified on the
> command line.  Where does that second xt_tgchk_param come from if it's not a
> pointer to the first one?

Running two iptables instances concurrently. Even without races like 
these, it would be a security violation to accept unknown pointers from 
userspace.
