From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 14:49:16 +0000
Message-ID: <20151126144916.GJ16828@macbook.localdomain>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:36298 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476AbbKZOtV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 09:49:21 -0500
Content-Disposition: inline
In-Reply-To: <20151126143328.GC32716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > The way I see it we basically have two options for fixing this:
> > 
> > * disable the generic protocol entirely
> 
> That was the original v1 patch, BUT that means that we do not
> support NAT for protocols without l4 tracker anymore (which
> is why we did not remove generic protocol).

Yeah that is quite undesirable.

> > * add a helper for every protocol for which we support matching on the identity
> >   of a flow and load the helper automatically when conntrack is enabled and
> >   the match is used.
> 
> Yes, but that might take a while.

AFAICT we're only missing ah/esp/ipcomp, those should be relatively trivial
to add, if we agree that this is the way to go.

> The existing way (skip if module) is a compromise to attempt to not break
> existing setups.
> 
> If e.g. SCTP=n and user has -p sctp --dport 42 -j ACCEPT then all
> sctp packets will match the generic entry for sctp, i.e. the --dport 42
> is redundant if an ESTABLISHED accept catchall is used.
> Thats not nice, but the alternative is to break things when
> NAT is used for that protocol...
> 
> If we have SCTP=n and its not loaded, we skip the generic tracker and
> users need to load the extra module.  Granted, that breaks things as
> well in some cases, but at least thats fixable without 'rebuild
> kernel'...

Yeah, my main concern is that this requires the user to know about protocol
modules, details about how the distribution build the kernel etc. And the
main reason for this problem to exists is exactly because users *don't* know
about this, so I'm questioning whether this really solves it.

The =y case is easy, it will work. The =m case should probably at least be
handled automatically. And then =n case is impossible to solve correctly
and therefore probably should not be possible.

I agree with Pablo (in fact I might have convinced him of that :)) that
this stuff is *way* to modular and its not only completely useless in
many cases, as we see here it might even actively cause problems.

I think the question during configuration should be "SCTP support y/n/m".
We would then select the sctp match, build the SCTP conntrack into the
conntrack core the SCTP NAT into the NAT core and the problem can not
occur anymore. Same thing for other protocols. If the user selects n,
no SCTP conntrack, no SCTP match.

Alternatively, as I believe Pablo suggested, we can simply put all conntrack
modules inside the core.
