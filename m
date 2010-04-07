From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] Add refcounts to LED target
Date: Wed, 07 Apr 2010 18:15:19 +0200
Message-ID: <4BBCAF97.6040806@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net> <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr> <4BADEE6A.5000103@shikadi.net> <alpine.LSU.2.01.100327125319
 0.1149@obet.zrqbmnf.qr> <4BAEB013.6060001@shikadi.net> <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50413 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab0DGQPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:15:21 -0400
In-Reply-To: <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2010-03-28 03:25, Adam Nielsen wrote:
> 
>> Add reference counting to the LED target so that multiple targets sharing the
>> same trigger don't cause any problems.
> 
> I also noticed one another thing: you don't increase the refcount while 
> xt_led_mutex is held. That means it is theoretically possible that you 
> do a lookup, then a destructor runs and frees the object, leading to 
> ++ledinternal->refcnt dereference an illegal ledinternal.

Indeed, I also noticed this. Basically, you need to make sure that

- the lookup and refcnt increase is atomic,
- the refcnt decrease and list deletion is atomic
- the lookup and list insertion is atomic (in case no trigger exists)

The remaining parts look fine to me, thanks.
