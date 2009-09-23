From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons ACCOUNT - userspace
Date: Thu, 24 Sep 2009 01:56:12 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909240150350.30035@obet.zrqbmnf.qr>
References: <4ABA69F3.9010907@ttx.sk> <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?Vlado_Dr=C5=BE=C3=ADk?= <vlado@ttx.sk>,
	netfilter-devel@vger.kernel.org
To: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43433 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZIWX4M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:56:12 -0400
In-Reply-To: <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-09-23 22:11, Jan Rafaj wrote:
>
> I'm glad you find it useful, like me.
>
> I've originally submitted my ports of [ACCOUNT, ...]
> for inclusion to xtables-addons (Xt-a) few weeks ago. So far Jan Engelhardt,
> its maintainer, has added just the kernel part of ACCOUNT
> to Xt-a, perhaps due to lack of time and becouse he probably didnt want
> to delay release of Xt-a 1.18 .
>
> You may try to ask him about the current status of adding iptaccount
> as well as the other modules I "ported" (I'm looking forward to this too).
> From what I know the troublesome part is that I didnt do the ports
> in git, so he will need to pluck apart all my changes and stuff it
> into git as separate commits. (Next time - if there will be such time
> - I wont make this mistake again).

The troublesome part was the extra GNUmakefile.in you proposed
adding. I spent the last days on getting Automake back and not
having to use too many own makefiles, because that would lead
to an update nightmare. (Now it's all nice.)

Please test the latest ACCOUNT-e37985b.
