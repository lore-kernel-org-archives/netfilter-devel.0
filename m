From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3] Add refcounts to LED target
Date: Thu, 08 Apr 2010 13:33:29 +0200
Message-ID: <4BBDBF09.6070403@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net> <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr> <4BADEE6A.5000103@shikadi.net> <alpine.LSU.2.01.100327125319
 0.1149@obet.zrqbmnf.qr> <4BAEB013.6060001@shikadi.net> <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr> <4BBCAF97.6040806@trash.net> <4BBD478F.4050208@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35430 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DHLdf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:33:35 -0400
In-Reply-To: <4BBD478F.4050208@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>>> I also noticed one another thing: you don't increase the refcount while 
>>> xt_led_mutex is held. That means it is theoretically possible that you 
>>> do a lookup, then a destructor runs and frees the object, leading to 
>>> ++ledinternal->refcnt dereference an illegal ledinternal.
> 
> Thanks both for your comments and explanations.  I've attached an updated
> patch, I hope this one addresses these issues.
> 
>> Indeed, I also noticed this. Basically, you need to make sure that
>>
>> - the lookup and refcnt increase is atomic,
>> - the refcnt decrease and list deletion is atomic
>> - the lookup and list insertion is atomic (in case no trigger exists)
> 
> I've moved the mutex around so that hopefully all these operations are now atomic.
> 
>> The remaining parts look fine to me, thanks.
> 
> Great, I hope you're happy with this one!

Looks good to me, thanks. Jan, any further issues from your side?
Otherwise I'll apply it.
