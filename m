From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 5 Feb 2010 20:53:05 +0100
Message-ID: <20100205195305.GA25763@Chamillionaire.breakpoint.cc>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
 <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
 <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
 <4B6C5231.7040702@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44105 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848Ab0BETxG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:53:06 -0500
Content-Disposition: inline
In-Reply-To: <4B6C5231.7040702@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> Florian Westphal schreef:
> > Jan Engelhardt <jengelh@medozas.de> wrote:
> >   
> >> In a quick look, ebtables 2.0.8-2 seems to just work there in both
> >> 32/64 and 64/64 [U/K-bitness] combinations:
> >>     
> > [..]
> >   
> >> So I wonder whether extra patches are really needed for x86_64.
> >>     
> >
> > I did investigate the "lets pad the structures in userspace" scenario.
> > It has two problems.
> >
> > First of all, support for a few targets/matches is missing.
> >
> I would certainly accept patches to the userland code to fix these
> remaining problems that I was unaware of. I don't have access to such a
> machine.

If these CONFIG_COMPAT patches are not accepted I'll send userspace patches
for those targets/matches that I am aware of.

> > Second, the point is to run unmodified binaries with either a 32
> > or 64 bit kernel without recompiling.
> >
> > Solving this transparently (i.e. same binary) would thus
> > require a run-time check for the kernel architecture before the
> > set/getsockopt can be made.
> >
> > As far as I could see this would require a lot of changes to the ebtables
> > userland code base, too.
> >   
> Could you elaborate why having to distribute two compiled versions of
> ebtables for different platform configurations is more overhead than the
> overhead added by your kernel patches?

I just believe that userspace should not have to care about this kind of
issue, thats all.

> Can't you decide on installation
> time of the Linux system which binary to provide?

It should still work when the kernel is changed later.

The 'easiest' solution would be to ship both 64 and 32bit binaries
and have some wrapper that picks the right one depending on kernel.

But this has other issues (e.g. need for 64bit libc) or,
when using a statically linked binary, the drawback that you need to use
e.g. "6" instead of "tcp" due to missing libraries glibc wants to load
at run time.

But to be honest to me that cures the symptoms (userspace binary does
not work) and not the problem (kernel ABI incompatibility).

Regards, Florian
