From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: iproute2: use automake
Date: Tue, 16 Nov 2010 07:58:51 -0800
Message-ID: <20101116075851.0de8d177@nehalam>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
	<20101115142600.66a7e3c3@nehalam>
	<alpine.LNX.2.01.1011152327430.3784@obet.zrqbmnf.qr>
	<20101115.175928.104078108.davem@davemloft.net>
	<alpine.LNX.2.01.1011161108330.25859@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:43027 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0KPP64 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:58:56 -0500
In-Reply-To: <alpine.LNX.2.01.1011161108330.25859@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 16 Nov 2010 11:09:06 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

> On Tuesday 2010-11-16 02:59, David Miller wrote:
> >
> >> Not using something standardized is an affront to distributors,
> >> and the build instructions just a sore for the eye:
> >
> >Making the build take 10 times longer is more of an affront
> >than what you accuse iproute2 of doing.
> >
> >Please do not do this, I absolutely hate working on source
> >trees that use this crap!
> >
> If you like cmake or another build system better, I'd have no problem 
> with that.

Until you make a convincing case that the existing infrastructure
is a problem, choosing an alternative solution is bogus.

All the fancy build systems are designed to solve the issue
of building one piece of software in multiple environments.
The iproute2 utilities only work on Linux and so far I haven't
had any major complaints from any distribution maintainer about it.

-- 
