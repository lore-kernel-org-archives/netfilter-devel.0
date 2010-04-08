From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: input-layer LEDs as LED-class devices (was: Add refcounts to
 LED target)
Date: Thu, 08 Apr 2010 13:15:16 +1000
Message-ID: <4BBD4A44.5010409@shikadi.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net> <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271940470.3068@obet.zrqbmnf.qr> <4BAEB7B1.6070209@shikadi.net> <alpine.LSU.2.01.1004041330180
 .22215@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:37559 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab0DHDPS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:15:18 -0400
In-Reply-To: <alpine.LSU.2.01.1004041330180.22215@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

>> I've uploaded the kernel module to make your keyboard LEDs accessible as LED
>> devices here: http://www.shikadi.net/files/kernel/leds-input-20100328.tar.bz2
> 
> I've got patches for that. (attached)

Thanks very much for taking the time to review it!  I've included your
changes, apparently I should look harder to see if the kernel already provides
a function before implementing it myself :-)

> And what I observed is that I get duplicated keypresses when there is
> network activity. (UP with CONFIG_PREEMPT=y.) Most likely because the
> i8042 keyboard is such a piece of legacy hardware that it is not
> worth investigating. I don't have any USB keyboard handy right now,
> so testing that needs to wait until after the holidays.

Did you try it with the iptables --led-delay option?  I've only tried it with
USB keyboards but that seems to be required for it to work smoothly
(--led-delay 1 is fine.)  Perhaps a higher delay value is needed for i8042
keyboards?

I'm wondering whether I should implement the delay in the module itself so
that the user doesn't have to worry about it, it just becomes a "slow" LED device.

> But other than that, does its job.

Glad to hear it!  Thanks again for the feedback.

Cheers,
Adam.
