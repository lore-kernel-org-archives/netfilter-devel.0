From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 5 Feb 2010 21:07:23 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002052059110.8804@obet.zrqbmnf.qr>
References: <1265334195-28120-1-git-send-email-fw@strlen.de> <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr> <20100205140021.GB21611@Chamillionaire.breakpoint.cc> <4B6C5231.7040702@pandora.be> <20100205195305.GA25763@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42727 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab0BEUHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:07:24 -0500
In-Reply-To: <20100205195305.GA25763@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-02-05 20:53, Florian Westphal wrote:
>
>> Can't you decide on installation
>> time of the Linux system which binary to provide?
>
>It should still work when the kernel is changed later.
>
>The 'easiest' solution would be to ship both 64 and 32bit binaries
>and have some wrapper that picks the right one depending on kernel.

Why ship two? There is a preferred userspace for each kernel
architecture (that I have seen). If you try to install ebtables on a
x86_64 distro, it generally offers you ebtables.x86_64.

>But this has other issues (e.g. need for 64bit libc) or,
>when using a statically linked binary, the drawback that you need to use
>e.g. "6" instead of "tcp" due to missing libraries glibc wants to load
>at run time.

Anything that is dlopened is not strictly required for execution.
