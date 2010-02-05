From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 05 Feb 2010 18:15:29 +0100
Message-ID: <4B6C5231.7040702@pandora.be>
References: <1265334195-28120-1-git-send-email-fw@strlen.de> <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr> <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:42583 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab0BERUf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:20:35 -0500
In-Reply-To: <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Florian,

First of all, thanks for pointing out these problems.

Florian Westphal schreef:
> Jan Engelhardt <jengelh@medozas.de> wrote:
>   
>> In a quick look, ebtables 2.0.8-2 seems to just work there in both
>> 32/64 and 64/64 [U/K-bitness] combinations:
>>     
> [..]
>   
>> So I wonder whether extra patches are really needed for x86_64.
>>     
>
> I did investigate the "lets pad the structures in userspace" scenario.
> It has two problems.
>
> First of all, support for a few targets/matches is missing.
>
>   
I would certainly accept patches to the userland code to fix these
remaining problems that I was unaware of. I don't have access to such a
machine.

> Second, the point is to run unmodified binaries with either a 32
> or 64 bit kernel without recompiling.
>
> Solving this transparently (i.e. same binary) would thus
> require a run-time check for the kernel architecture before the
> set/getsockopt can be made.
>
> As far as I could see this would require a lot of changes to the ebtables
> userland code base, too.
>   
Could you elaborate why having to distribute two compiled versions of
ebtables for different platform configurations is more overhead than the
overhead added by your kernel patches? Can't you decide on installation
time of the Linux system which binary to provide?
At this time I am more in favor of fixing userland...

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

