From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v2] Add refcounts to LED target
Date: Sun, 4 Apr 2010 13:30:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net>
 <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr> <4BADEE6A.5000103@shikadi.net>
 <alpine.LSU.2.01.1003271253190.1149@obet.zrqbmnf.qr> <4BAEB013.6060001@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52043 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0DDLaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Apr 2010 07:30:11 -0400
In-Reply-To: <4BAEB013.6060001@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-03-28 03:25, Adam Nielsen wrote:

>Add reference counting to the LED target so that multiple targets sharing the
>same trigger don't cause any problems.

I also noticed one another thing: you don't increase the refcount while 
xt_led_mutex is held. That means it is theoretically possible that you 
do a lookup, then a destructor runs and frees the object, leading to 
++ledinternal->refcnt dereference an illegal ledinternal.

Overall, it works pretty much ok.
