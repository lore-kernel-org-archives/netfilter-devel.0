From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 21:37:15 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211302115000.16257@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu> <20121129224429.GB9370@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53342 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2K3UhS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:37:18 -0500
In-Reply-To: <20121129224429.GB9370@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, 29 Nov 2012, Pablo Neira Ayuso wrote:

> On Thu, Nov 29, 2012 at 10:12:54PM +0100, Jozsef Kadlecsik wrote:
> > Hi,
> > 
> > This is the second variant of the patch which addresses the route 
> > changes affecting already masqueraded connections.
> > 
> > When the route changes (backup default route, VPNs), the packets are sent 
> > out with wrong source address. The patch addresses the issue by comparing 
> > the outgoing interface directly with the masquerade interface in the nat 
> > table. It *is* MASQUERADE specific, so probably the inserted code could be 
> > enclosed in a proper ifdef.
> > 
> > Events are inefficient, because it'd require scanning the whole conntrack 
> > table at any route change and re-checking the route for all entry, which 
> > is simply way too expensive.
> 
> I still have to waste the bullet of proposing to do this from
> user-space.

:-)
 
> I think a new command for the conntrack utility to iterate over the
> table and kill entries with wrong masq_index would be relatively
> simple. You will have to pass the ifindex you want to compare from
> user-space.

Unfortunately the userspace suffers the same problems than my first 
attempt, the notification did:

- I'm not aware of any easy way to get "route changed" events in 
  userspace: as far as I know routing daemons (quagga) or openvpn don't 
  generate such things.
- The event itself not enough, the related interface is required too.
- The event and the interface is not enough, the exact rule should be
  known otherwise the full routing table must be looked up.
- The event, interface and exact rule is not enough, because even if
  the rule matches a conntrack entry, it might be that the route for the 
  entry did not change - so we have to look up the route table anyway.
- We are back that actually the event is enough :-).

So in this case, if we can get such events (but how), we should have to 
iterate over the whole conntrack table, whatever large it is, and execute 
full route lookups for every element.
 
In my approach the route is already computed and we just verify runtime 
that the outgoing interface corresponds to the one which was used at the 
first packet.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
