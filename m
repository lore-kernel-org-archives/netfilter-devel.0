From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sat, 27 Mar 2010 12:55:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003271253190.1149@obet.zrqbmnf.qr>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net>
 <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net>
 <4B1BB086.3030700@trash.net> <4BAB6CB2.3050904@trash.net> <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr>
 <4BADEE6A.5000103@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52429 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0C0LzJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Mar 2010 07:55:09 -0400
In-Reply-To: <4BADEE6A.5000103@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-03-27 12:39, Adam Nielsen wrote:

>Add reference counting to the LED target so that multiple targets sharing the
>same trigger don't cause any problems.
>
>I have attached a patch based on nf-next-2.6.  It
>adds the reference counting that was discussed and fixes a bug where it
>referenced a null string once the original table/rule was destroyed.
>
>I've tested it and it works well for me, so subject to any feedback I believe
>it is ready to be included.

You need to protect the list_add/list_del from concurrent operation.

You need to check the return value of

ledinternal->trigger_id = kzalloc(strlen(ledinfo->id) + 1, GFP_KERNEL);
