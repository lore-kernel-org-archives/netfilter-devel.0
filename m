From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix set:list type crash when
 flush/dump set in parallel
Date: Thu, 10 Mar 2016 19:27:32 +0100
Message-ID: <20160310182732.GA21139@salvia>
References: <1456345166-23605-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1456345166-23605-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20160229122218.GA12101@salvia>
 <alpine.DEB.2.10.1602291325430.21350@blackhole.kfki.hu>
 <20160305123227.GA1758@salvia>
 <alpine.DEB.2.10.1603082004430.19980@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbcCJS1i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:27:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B6A18C9EDB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:27:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A324FDA8FB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:27:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0673DA390
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:27:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1603082004430.19980@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 08:27:30PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Sat, 5 Mar 2016, Pablo Neira Ayuso wrote:
> 
> > On Mon, Feb 29, 2016 at 01:47:59PM +0100, Jozsef Kadlecsik wrote:
> > > On Mon, 29 Feb 2016, Pablo Neira Ayuso wrote:
> > > 
> > > > On Wed, Feb 24, 2016 at 09:19:26PM +0100, Jozsef Kadlecsik wrote:
> > > > > Flushing/listing entries was not RCU safe, so parallel flush/dump
> > > > > could lead to kernel crash. Bug reported by Deniz Eren.
> > > > > 
> > > > > Fixes netfilter bugzilla id #1050.
> > > > > 
> > > > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > > ---
> > > > >  net/netfilter/ipset/ip_set_core.c     |  3 ++
> > > > >  net/netfilter/ipset/ip_set_list_set.c | 55 ++++++++++++++++-------------------
> > > > >  2 files changed, 28 insertions(+), 30 deletions(-)
> > > > > 
> > > > > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > > > > index 95db43f..7e6568c 100644
> > > > > --- a/net/netfilter/ipset/ip_set_core.c
> > > > > +++ b/net/netfilter/ipset/ip_set_core.c
> > > > > @@ -985,6 +985,9 @@ static int ip_set_destroy(struct net *net, struct sock *ctnl,
> > > > >  	if (unlikely(protocol_failed(attr)))
> > > > >  		return -IPSET_ERR_PROTOCOL;
> > > > >  
> > > > > +	/* Must wait for flush to be really finished in list:set */
> > > > > +	rcu_barrier();
> > > > 
> > > > Jozsef, are you sure you need this rcu_barrier()?
> > > > 
> > > > This is waiting for rcu callback completion (ie. decrement the set
> > > > reference counter and releasing the extension and object itself).
> > > 
> > > Yes, that's exactly what it's waiting for, in the case of sets which are 
> > > elements in set:list type of sets.
> > > 
> > > > The rcu read side should be safe when accessing old copies from the
> > > > dumping path when using call_rcu().
> > > 
> > > Three competing actions play role here: flush/delete, destroy, dumping. 
> > > The rcu_barrier() above waits for the flush/delete actions. The rcu read 
> > > side has access to the set id only and must lookup the set by id in order 
> > > to get the name, which is protected by a reference counter. The function 
> > > ip_set_name_byindex() intentionally checks that the reference counter 
> > > cannot be equal to zero and I believe it's an important internal sanity 
> > > checking and I don't want to remove it. The problem was that the reference 
> > > counter of the set was first decremented at flush/delete and so we could 
> > > get a BUG_ON() crash in ip_set_name_byindex() when an ongoing dumping was 
> > > processed. So the reference counter must be released last for a successful 
> > > parallel dumping. If rcu_barrier() was not added to the destroy path, a 
> > > "destroy" immediately following a "flush" can lead to the error "set is in 
> > > use, cannot delete". I tested it and couldn't find a simpler way.
> > 
> > ip_set_destroy() calls ip_set_destroy_set() which releases the set
> > object and its content without waiting for the rcu grace period. I
> > think readers (dump path) may still be walking on the set by when
> > you're releasing this object.
> > 
> > Our nfnetlink dump path is lockless (rcu read side protected), so we
> > unpublish the set object and release objects via rcu callback when
> > operating from the control plane.
> 
> Yes, but we are dealing with flush and then destroy, when the set we are 
> flushing is a list:set type of set where the elements are sets. It is not 
> possible to unpublish the flushed objects, because those are totally valid 
> sets.
> 
> Before I sent my patch I tested it without rcu_barrier() and the destroy 
> command failed (quite rightly) because 'Set is in use' - destroy has to 
> wait for flush to be completed anyway.

OK, thanks for explaining. I don't find any better way at this moment
to handle the interdependencies that the set:list type creates with
this elements that are actually sets, so this rcu_barrier() guarantees
the in-order set releasing that you need not to trigger the bug.
Sorry, I misunderstood the goal of this and I just wanted to make sure
this rcu_barrier() was not actually hiding a real problem.

I have pulled this into the nf-next tree, thanks for your patience.
