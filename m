From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add refcounts to LED target
Date: Sun, 06 Dec 2009 14:24:22 +0100
Message-ID: <4B1BB086.3030700@trash.net>
References: <4A18A70F.50808@shikadi.net> <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr> <4A1DC798.1090604@shikadi.net> <4A26418C.5090707@trash.net> <4A265891.4050201@shikadi.net> <4AF2E8A5.7020409@trash.net> <4AF34C03.7020907@shikadi.net> <4AF43916.5010408@trash.net> <4B11D1B5.2060306@shikadi.net> <alpine.LSU.2.00.0911291055020.24432@obet.zrqbmnf.qr> <4B125C18.7060802@shikadi.net> <alpine.LSU.2.00.0911291646380.6794@obet.zrqbmnf.qr> <4B14EA81.5030603@trash.net> <4B1B82D5.2070607@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbZLFNYW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:24:22 -0500
In-Reply-To: <4B1B82D5.2070607@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>> Since this has already taken ages, I took the liberty of preparing
>> an example fix. Adam, please have a look at this and give it some
>> testing.
> 
> Well I'm afraid I can't see why, but for some reason once I add a second
> iptables rule with this target my kernel often locks up, hard (audio
> starts skipping, magic SysRq keys don't work) even if I don't have any
> actual LED devices on the system.  The first rule, even when attached to
> a LED device, seems to work fine.
> 
> I'll have to do some more debugging to see if I can figure out where
> it's locking up.

Its probably the timer, which uses the ledinfo of the first rule as
private data. Try passing ledinternal to the timer instead of ledinfo,
that should fix it.
