From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Sat, 06 Feb 2010 14:08:35 +0100
Message-ID: <4B6D69D3.7050008@pandora.be>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>	<20100205140021.GB21611@Chamillionaire.breakpoint.cc>	<4B6C5231.7040702@pandora.be> <20100205.100241.17593999.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:50983 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab0BFNNn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:13:43 -0500
In-Reply-To: <20100205.100241.17593999.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller schreef:
> From: Bart De Schuymer <bdschuym@pandora.be>
> Date: Fri, 05 Feb 2010 18:15:29 +0100
>
>   
>> At this time I am more in favor of fixing userland...
>>     
>
> Compatability issues between 32-bit and 64-bit interfaces
> when running on a 64-bit kernel should _always_ be handled
> in the kernel via the compat layer.
>
> Every attempt to do this in userspace somehow been ugly and has
> utterly failed.
>   
I actually think the solution inside the ebtables userspace code is very
simple and elegant. The extra code for userspace to fix the few ebtables
matches that still have problems would be simple too.
If I'd have known about this mandatory compat layer 7 years ago I
wouldn't have bothered trying to fix it in userspace. A simple kernel
patch of mine to get ebtables userspace running on a user32/kernel64
system was accepted by you back in 2003
(http://osdir.com/ml/linux.network.bridge.ebtables.devel/2003-07/msg00028.html).
I can't tell how many of these systems are running ebtables but
considering most of the functionality has been working on a
user32/kernel64 system since 2004 I think it's safe to say that
Florian's patch will break a few systems. Apart from this fact I have no
objection to Florian's patch, although it seems strange that such a
simple solution in userspace needs a large additional codebase in the
kernel...
I'm not familiar with the way this compat layer works, but is there a
standard way to ensure that old ebtables binaries don't use the compat
layer, while a new version of the userspace program would? If all else
fails, we could do this with a special flag in struct
ebt_replace::valid_hooks, as this member has some unused bits.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

