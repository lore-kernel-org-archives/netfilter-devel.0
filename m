From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft netdev family bindings
Date: Tue, 9 Jun 2015 14:13:25 +0200
Message-ID: <20150609121325.GA8111@acer.localdomain>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
 <20150608114058.GA4165@salvia>
 <20150609092318.GA25651@acer.localdomain>
 <20150609105245.GA2811@salvia>
 <20150609105712.GA29356@acer.localdomain>
 <20150609114630.GA2995@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39389 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920AbbFIMN3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 08:13:29 -0400
Content-Disposition: inline
In-Reply-To: <20150609114630.GA2995@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.06, Pablo Neira Ayuso wrote:
> On Tue, Jun 09, 2015 at 12:57:12PM +0200, Patrick McHardy wrote:
> > On 09.06, Pablo Neira Ayuso wrote:
> > > 
> > > We can also achieve this sharing with the approach I describe above, I
> > > don't see any limitation on that.
> > 
> > Its not a limitation, merely something that seems slightly inconsistent.
> > The base chain definitions basically define the entry points and in this
> > case we define them in two steps, unlike in the other cases.
> > 
> > It also matches better what we have in the kernel. Its actually the
> > hooks that are per device and nothing else.
> 
> It's an abstraction so it's normal that we get out a bit from the hook
> representation in the kernel. Chains are not a 1:1 map with the hook
> object anyway.

The question is if its the correct abstraction, and I don't think so.
The device binding doesn't apply to sets, it doesn't apply to chains,
it doesn't apply to any table objects except for hooks, and this is
exactly where we already have the concept of a binding. I mean, the
binding is not even a binding. Nothing is bound to the device, it
is in fact a hook specification.

We even have the concept of multiple bindings by using multiple base
chains, which would have to be duplicated for your multiple device
binding idea.

> I think this representation is a bit more compact:
> 
> table netdev global {
>         device { eth0, eth1; }
> 
>         chain ingress {
>                 type filter hook ingress priority 0\;
>                 ... your rules here, no need for shared_chain ...
>         }
> }
> 
> than this:
> 
> table netdev global {
> 	chain eth0 {
> 		hook eth0 ingress;
> 		jump shared_chain;
> 	}
> 	chain eth1 {
> 		hook eth1 ingress;
> 		jump shared_chain;
> 	}
> 	chain shared_chain {
> 		... your rules here ...
> 	}
> }
> 
> If we aim to also have an egress hooks as well, then this may look a
> bit convoluted.
> 
> On the performance front, this also saves some extra overhead on the
> packet path since we don't need the chain jump.

It really depends. Assuming (which is not unlikely) that people will also
have device specific rules they will create extra chains per device
and jump to them. In the end, it really depends on the use case.
