From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sat, 27 Mar 2010 14:05:46 +1000
Message-ID: <4BAD841A.9060103@shikadi.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net> <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:51335 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0C0EYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:24:42 -0400
In-Reply-To: <4BAB6E70.8090605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> I've waited patiently for about a year for this simple problem to
>>> get fixed. Unless I see a patch in time for 2.6.34, I'll remove
>>> the LED module again.

I'm really sorry about this, I'll try my best to get this problem fixed in the
next couple of days so it can be finally done and dusted.

Which git repo should I base my patch off?  I was using nf-next-2.6 but this
seems like it's older than the latest 2.6.33.1 release (nf-next-2.6 is missing
an XT_ALIGN at the end which is in 2.6.33.1.)

>> I want to give this a look, but I notice there's no iptables module
>> files for xt_LED yet either.
> 
> Correct, I didn't add it while this was still unfixed to keep
> the possibility of removing the module again. You should be able
> to find it in the mailing list archives.

I can post this again if you'd like to take a look.  I also have a kernel
module that makes your keyboard LEDs available as LED devices if you want to
test it out too.  (I could certainly use some feedback on that!)

Thanks,
Adam.
