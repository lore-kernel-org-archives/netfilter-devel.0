From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: input-layer LEDs as LED-class devices (was: Add refcounts to
 LED target)
Date: Thu, 8 Apr 2010 10:03:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004080957240.12178@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net>
 <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271940470.3068@obet.zrqbmnf.qr> <4BAEB7B1.6070209@shikadi.net>
 <alpine.LSU.2.01.1004041330180.22215@obet.zrqbmnf.qr> <4BBD4A44.5010409@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49776 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab0DHIDL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:03:11 -0400
In-Reply-To: <4BBD4A44.5010409@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-08 05:15, Adam Nielsen wrote:
>
>> And what I observed is that I get duplicated keypresses when there is
>> network activity. (UP with CONFIG_PREEMPT=y.) Most likely because the
>> i8042 keyboard is such a piece of legacy hardware that it is not
>> worth investigating. I don't have any USB keyboard handy right now,
>> so testing that needs to wait until after the holidays.
>
>Did you try it with the iptables --led-delay option?

Yes.

I would assume that the key repeat happens whenever the LED is
changed *and* I happen to press a key at the same time. This event
happening is IMO independent of the led-delay option, as the LED
state could change either by a delay-induced LED_OFF, or by a new
packet arriving.

> I've only tried it with
>USB keyboards but that seems to be required for it to work smoothly
>(--led-delay 1 is fine.)  Perhaps a higher delay value is needed for i8042
>keyboards?
>
>I'm wondering whether I should implement the delay in the module
>itself so that the user doesn't have to worry about it, it just
>becomes a "slow" LED device.

As long as you don't sleep in interrupt context ;-)

