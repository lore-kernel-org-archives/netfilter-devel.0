From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Mon, 3 Dec 2012 15:23:24 +0100
Message-ID: <20121203142324.GA4892@1984>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
 <20121129224429.GB9370@1984>
 <alpine.DEB.2.00.1211302115000.16257@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2LCOXb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:23:31 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211302115000.16257@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 30, 2012 at 09:37:15PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Thu, 29 Nov 2012, Pablo Neira Ayuso wrote:
> 
> > On Thu, Nov 29, 2012 at 10:12:54PM +0100, Jozsef Kadlecsik wrote:
> > > Hi,
> > > 
> > > This is the second variant of the patch which addresses the route 
> > > changes affecting already masqueraded connections.
> > > 
> > > When the route changes (backup default route, VPNs), the packets are sent 
> > > out with wrong source address. The patch addresses the issue by comparing 
> > > the outgoing interface directly with the masquerade interface in the nat 
> > > table. It *is* MASQUERADE specific, so probably the inserted code could be 
> > > enclosed in a proper ifdef.
> > > 
> > > Events are inefficient, because it'd require scanning the whole conntrack 
> > > table at any route change and re-checking the route for all entry, which 
> > > is simply way too expensive.
> > 
> > I still have to waste the bullet of proposing to do this from
> > user-space.
> 
> :-)
>  
> > I think a new command for the conntrack utility to iterate over the
> > table and kill entries with wrong masq_index would be relatively
> > simple. You will have to pass the ifindex you want to compare from
> > user-space.
> 
> Unfortunately the userspace suffers the same problems than my first 
> attempt, the notification did:
> 
> - I'm not aware of any easy way to get "route changed" events in 
>   userspace: as far as I know routing daemons (quagga) or openvpn don't 
>   generate such things.
> - The event itself not enough, the related interface is required too.
> - The event and the interface is not enough, the exact rule should be
>   known otherwise the full routing table must be looked up.
> - The event, interface and exact rule is not enough, because even if
>   the rule matches a conntrack entry, it might be that the route for the 
>   entry did not change - so we have to look up the route table anyway.
> - We are back that actually the event is enough :-).
> 
> So in this case, if we can get such events (but how), we should have to 
> iterate over the whole conntrack table, whatever large it is, and execute 
> full route lookups for every element.
>  
> In my approach the route is already computed and we just verify runtime 
> that the outgoing interface corresponds to the one which was used at the 
> first packet.

OK, you convinced me. The last V4 patch looks very small to handle
this case. I'll take it.
