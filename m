From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft netdev family bindings
Date: Tue, 9 Jun 2015 13:46:30 +0200
Message-ID: <20150609114630.GA2995@salvia>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
 <20150608114058.GA4165@salvia>
 <20150609092318.GA25651@acer.localdomain>
 <20150609105245.GA2811@salvia>
 <20150609105712.GA29356@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43966 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbbFILlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 07:41:19 -0400
Content-Disposition: inline
In-Reply-To: <20150609105712.GA29356@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 09, 2015 at 12:57:12PM +0200, Patrick McHardy wrote:
> On 09.06, Pablo Neira Ayuso wrote:
> > 
> > We can also achieve this sharing with the approach I describe above, I
> > don't see any limitation on that.
> 
> Its not a limitation, merely something that seems slightly inconsistent.
> The base chain definitions basically define the entry points and in this
> case we define them in two steps, unlike in the other cases.
> 
> It also matches better what we have in the kernel. Its actually the
> hooks that are per device and nothing else.

It's an abstraction so it's normal that we get out a bit from the hook
representation in the kernel. Chains are not a 1:1 map with the hook
object anyway.

I think this representation is a bit more compact:

table netdev global {
        device { eth0, eth1; }

        chain ingress {
                type filter hook ingress priority 0\;
                ... your rules here, no need for shared_chain ...
        }
}

than this:

table netdev global {
	chain eth0 {
		hook eth0 ingress;
		jump shared_chain;
	}
	chain eth1 {
		hook eth1 ingress;
		jump shared_chain;
	}
	chain shared_chain {
		... your rules here ...
	}
}

If we aim to also have an egress hooks as well, then this may look a
bit convoluted.

On the performance front, this also saves some extra overhead on the
packet path since we don't need the chain jump.
