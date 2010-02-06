From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Sat, 6 Feb 2010 14:50:28 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002061447460.6911@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr> <20100205140021.GB21611@Chamillionaire.breakpoint.cc> <4B6C5231.7040702@pandora.be> <20100205.100241.17593999.davem@davemloft.net> <4B6D69D3.7050008@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, fw@strlen.de,
	netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47657 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0BFNua (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:50:30 -0500
In-Reply-To: <4B6D69D3.7050008@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-02-06 14:08, Bart De Schuymer wrote:
>David Miller schreef:
>>   
>>> At this time I am more in favor of fixing userland...
>>
>> Compatability issues between 32-bit and 64-bit interfaces
>> when running on a 64-bit kernel should _always_ be handled
>> in the kernel via the compat layer.
>>
>> Every attempt to do this in userspace somehow been ugly and has
>> utterly failed.
>
>I actually think the solution inside the ebtables userspace code is very
>simple and elegant. The extra code for userspace to fix the few ebtables
>matches that still have problems would be simple too.
>If I'd have known about this mandatory compat layer 7 years ago I
>wouldn't have bothered trying to fix it in userspace. A simple kernel
>patch of mine to get ebtables userspace running on a user32/kernel64
>system was accepted by you back in 2003
>(http://osdir.com/ml/linux.network.bridge.ebtables.devel/2003-07/msg00028.html).
>I can't tell how many of these systems are running ebtables but
>considering most of the functionality has been working on a
>user32/kernel64 system since 2004 I think it's safe to say that
>Florian's patch will break a few systems. Apart from this fact I have no
>objection to Florian's patch, although it seems strange that such a
>simple solution in userspace needs a large additional codebase in the
>kernel...
>I'm not familiar with the way this compat layer works, but is there a
>standard way to ensure that old ebtables binaries don't use the compat
>layer, while a new version of the userspace program would?

Xtables uses revisions, and extensions with problematic layouts
use match->compat_from_user that is non-NULL.
