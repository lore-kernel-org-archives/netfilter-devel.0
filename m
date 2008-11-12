From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 12:53:02 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811121252140.17100@fbirervta.pbzchgretzou.qr>
References: <49196D12.1030803@shikadi.net> <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr> <491AB0C5.9030305@shikadi.net> <alpine.LNX.1.10.0811121157200.17100@fbirervta.pbzchgretzou.qr> <491AB9B3.5060207@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59485 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYKLLxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:53:05 -0500
In-Reply-To: <491AB9B3.5060207@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-12 12:10, Adam Nielsen wrote:
>
>> And it's solved, even without thinking of NULs or prefixes.
>
> Sorry, I thought you meant "please explain where the 26 comes from"

Yeah I really *did* wonder why it was 26... because the "perfect
layout" was only attainable with 27, and I would not see why
LED names were limited to 16 chars, unless of course, the LED
system has such a limitation.
