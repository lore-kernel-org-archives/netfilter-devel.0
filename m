From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft netdev family bindings
Date: Tue, 9 Jun 2015 12:52:45 +0200
Message-ID: <20150609105245.GA2811@salvia>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
 <20150608114058.GA4165@salvia>
 <20150609092318.GA25651@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55114 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbbFIKr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 06:47:29 -0400
Content-Disposition: inline
In-Reply-To: <20150609092318.GA25651@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 09, 2015 at 11:23:19AM +0200, Patrick McHardy wrote:
> On 08.06, Pablo Neira Ayuso wrote:
[...]
> > Then, the idea would to iterate over the list of netdevs that the user
> > indicates, eg.
> > 
> > table netdev ingress {
> >         device { eth0, eth1\; }
> > 
> >         ...
> > }
> > 
> > and register the same chain hooks for each device in the list.
> > 
> > I can go after this and cook a patch for this. The merge window is
> > still open so we can modify the semantics of the existing netlink
> > NFTA_TABLE_DEV attribute in David's net-next tree.
> 
> My idea was to have the base chains bind to a device, then we can
> create shared chains and jump to them from the base chain:
> 
> table netdev ingress {
> 	chain eth0 {
> 		hook eth0 ingress;
> 		jump shared_chain;
> 	}
> 	chain eth1 {
> 		hook eth1 ingress;
> 		jump shared_chain;
> 	}
> 	chain shared_chain {
> 		...
> 	}
> }
> 
> I think if we treat the table namespace global, than the hook and base
> chain is the natural place to specify the device since this is where
> the packets actually enter.

We can also achieve this sharing with the approach I describe above, I
don't see any limitation on that.

If the user doesn't want to share any set and chain, he creates a
separate table so there's a clear separation between namespaces.
Thus, we don't allow user to make convoluted configurations in
scenarios where he doesn't need to share anything.
