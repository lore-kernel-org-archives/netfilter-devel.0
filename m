From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 14:57:48 +0200
Message-ID: <20140925125748.GA26716@breakpoint.cc>
References: <20140925113237.GC25548@breakpoint.cc>
 <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51770 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbaIYM5u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:57:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> On Thu, 25 Sep 2014, Florian Westphal wrote:
> > Given following iptables ruleset:
> > -P FORWARD DROP
> > -A FORWARD -m sctp --dport 9 -j ACCEPT
> > -A FORWARD -p tcp --dport 80 -j ACCEPT
> > -A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT
> > 
> > One would assume that this allows SCTP on port 9 and TCP on port 80.
> > Unfortunately, if the SCTP conntrack module is not loaded, this allows
> > *all* SCTP communication to pass through, i.e. -p sctp -j ACCEPT,
> > which we think is a security issue.
> > 
> > This is because on the first SCTP packet on port 9, we create a dummy
> > "generic l4" conntrack entry without any port information (since
> > conntrack doesn't know how to extract this information).
> > 
> > All subsequent packets that are unknown will then be in established
> > state since they fallback to proto_generic and the tuple lookup will
> > match the 'generic' entry.
> > 
> > Unfortunately, the only reasonable fix seems to be to completely
> > disable generic protocol tracking, i.e. force all packets to be in
> > invalid state.
> > 
> > Joint work with Daniel Borkmann.
> 
> That means the generic connection tracking is completely thrown out, which 
> is totally backward incompatible and comes out of the blue for everyone 
> who relies on it (for example runs OSPF).

Yes, this is unfortunate.  I don't see any other way.
I consider the generic tracker to be broken-by-design.

When a protocol tracker, e.g. tcp, finds that the packet doesn't
meet some criteria, it will be in INVALID state.

But when we don't even know the l4 protocol we happily accept it via
NEW/ESTABLISHED?

That seems just wrong to me...

> I understand that this is the simplest way to handle the security issue, 
> but I also believe the price is too high. Why don't we check in the sctp 
> match that the conntrack module is loaded in? Something like
> 
> 	if (nf_conntrack_loaded_in &&
> 	    !nf_conntrack_proto_sctp_loaded_in &&
> 	     request_module("nf_conntrack_proto_sctp") < 0)
> 		return false;
> 
> in match_packet() so that it won't match if conntrack there but sctp 
> conntrack won't load.

Well, this would keep the issue open for all other protocols where
we have no specific tracker available.

Also, I don't want to force people to use sctp connection tracking --
stateless filtering should still work (perhaps I misread what you
said above).

The only other solution that I can think of is to alter the generic
tracker to try to auto-probe every incoming l4 protocol (and remember
which l4protos we already tried).  But I don't like that a lot either.

Regards,
Florian
