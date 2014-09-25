From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 15:47:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409251535470.14369@blackhole.kfki.hu>
References: <20140925113237.GC25548@breakpoint.cc> <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu> <20140925125748.GA26716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:34957 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaIYNrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:47:01 -0400
In-Reply-To: <20140925125748.GA26716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 25 Sep 2014, Florian Westphal wrote:

> > > Unfortunately, the only reasonable fix seems to be to completely
> > > disable generic protocol tracking, i.e. force all packets to be in
> > > invalid state.
> > 
> > That means the generic connection tracking is completely thrown out, which 
> > is totally backward incompatible and comes out of the blue for everyone 
> > who relies on it (for example runs OSPF).
> 
> Yes, this is unfortunate.  I don't see any other way.
> I consider the generic tracker to be broken-by-design.
> 
> When a protocol tracker, e.g. tcp, finds that the packet doesn't
> meet some criteria, it will be in INVALID state.
> 
> But when we don't even know the l4 protocol we happily accept it via
> NEW/ESTABLISHED?
> 
> That seems just wrong to me...

Originally all protocol trackers were included in the conntrack module. 
The whole issue comes from the fact that at present four ones can be in 
modules and might not be loaded in. If the trackers work, then the whole 
issue disappears.
 
> Also, I don't want to force people to use sctp connection tracking --
> stateless filtering should still work (perhaps I misread what you
> said above).

Stateless filtering can be chosen by the user via CT and notrack.

With disabling generic tracking you force everyone to switch to stateless 
filtering, without any other option.

> The only other solution that I can think of is to alter the generic
> tracker to try to auto-probe every incoming l4 protocol (and remember
> which l4protos we already tried).  But I don't like that a lot either.

Four protocol trackers should be probed, so I'd favour the auto-probing 
from the generic tracker.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
