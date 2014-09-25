From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 16:13:14 +0200
Message-ID: <20140925141314.GB26716@breakpoint.cc>
References: <20140925113237.GC25548@breakpoint.cc>
 <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu>
 <20140925125748.GA26716@breakpoint.cc>
 <alpine.DEB.2.10.1409251535470.14369@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51971 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaIYONR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:13:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409251535470.14369@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> On Thu, 25 Sep 2014, Florian Westphal wrote:
> 
> > > > Unfortunately, the only reasonable fix seems to be to completely
> > > > disable generic protocol tracking, i.e. force all packets to be in
> > > > invalid state.
> > > 
> > > That means the generic connection tracking is completely thrown out, which 
> > > is totally backward incompatible and comes out of the blue for everyone 
> > > who relies on it (for example runs OSPF).
> > 
> > Yes, this is unfortunate.  I don't see any other way.
> > I consider the generic tracker to be broken-by-design.
> > 
> > When a protocol tracker, e.g. tcp, finds that the packet doesn't
> > meet some criteria, it will be in INVALID state.
> > 
> > But when we don't even know the l4 protocol we happily accept it via
> > NEW/ESTABLISHED?
> > 
> > That seems just wrong to me...
> 
> Originally all protocol trackers were included in the conntrack module. 
> The whole issue comes from the fact that at present four ones can be in 
> modules and might not be loaded in. If the trackers work, then the whole 
> issue disappears.

I don't think so.  You'd actually have to implement trackers for all l4
protocols, and you'd need kernel where these are then also built.

> > Also, I don't want to force people to use sctp connection tracking --
> > stateless filtering should still work (perhaps I misread what you
> > said above).
> 
> Stateless filtering can be chosen by the user via CT and notrack.
> 
> With disabling generic tracking you force everyone to switch to stateless 
> filtering, without any other option.

How is generic tracking different from stateless filtering?
Its identical to

-p $proto -j ACCEPT

since the generic tracking entry doesn't contain any l4 lookup keys?
So I don't see any benefit from the generic tracker (except the
backwards compat issue, I agree, it is a problem)

> > The only other solution that I can think of is to alter the generic
> > tracker to try to auto-probe every incoming l4 protocol (and remember
> > which l4protos we already tried).  But I don't like that a lot either.
> 
> Four protocol trackers should be probed, so I'd favour the auto-probing 
> from the generic tracker.

Sure, if you absolutely disagree with me I will go for that and add
autoload to the generic  tracker.

But I don't like it, I feel its like band-aid solution.  And it has
severe side-effects:

No sctp conntracker available (CONFIG_NF_CT_PROTO_SCTP=n) or some
temporary issue when we tried to modprobe?
Too bad, your -p scpt --dport x + ESTABLISHED rule matches all flows.

Exploitable hole in the sctp conntracker?  Great, remote user can cause
it to be loaded automatically now.

Some other protocol where we don't have conntrack support?
Same, you get magic ESTABLISHED state everywhere...

I see no choice other than removing generic tracking.

Cheers,
Florian
