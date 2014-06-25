From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: conntrack: remove timer from ecache
 extension
Date: Wed, 25 Jun 2014 19:06:36 +0200
Message-ID: <20140625170636.GA16571@localhost>
References: <1402434776-23461-1-git-send-email-fw@strlen.de>
 <20140611085547.GA4131@localhost>
 <20140611092015.GA12405@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbaFYRGl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:06:41 -0400
Content-Disposition: inline
In-Reply-To: <20140611092015.GA12405@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, Jun 11, 2014 at 11:20:15AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Jun 10, 2014 at 11:12:56PM +0200, Florian Westphal wrote:
> > > This brings the (per-conntrack) ecache extension back to 24 bytes in size
> > > (was 152 byte on x86_64 with lockdep on).
> > > 
> > > When event delivery fails, re-delivery is attempted via work queue.
> > > 
> > > Redelivery is attempted at least every 0.1 seconds, but can happen
> > > more frequently if userspace is not congested.
> > > 
> > > The nf_ct_release_dying_list() function is removed.
> > > With this patch, ownership of the to-be-redelivered conntracks
> > > (on-dying-list-with-DYING-bit not yet set) is with the work queue,
> > > which will release the references once event is out.
> > 
> > I think we need to keep the nf_ct_release_dying_list(), otherwise we
> > will hit problems when destroying the kmem_cache, since the workqueue
> > may race with that, right?
> 
> Are you sure?
> 
> nf_ct_release_dying_list() looks broken to me, it _puts() entries
> it doesn't own (i.e. refcnt underflows when real owner _puts() entry).
> 
> In any case, nf_conntrack_cleanup_net_list() loops until
> net->ct.count is zero.  That should be enough, no?
> 
> If there are lot of entries with undelivered events the wait period should
> not be big; Since there are no listeners at this point the worker will be
> rescheduled for immediate reexecuition until it has put() all conntracks
> without DYING set.

Yes, there should be no listeners at this point since
nf_conntrack_netlink modules needs to be removed before nf_conntrack.

> nf_conntrack_ecache_pernet_fini() (which stops the work queue) is called
> after ct.count is 0 and before kmem_cache_destroy().  Looks good to me,
> did I miss something?

This patch looks good to me. I made some experiments again in my
testbed. I see no packet drops and the result of 'conntrack -L dying |
wc -l' per second shows small peaks of entries waiting in the dying
list to be delivered which is followed by empty lists by conntrackd at
some point. However, perhaps the per-second watch is not enough to get
a real evolution on how the dying list population evolves along time.

Anyway, I think this is good enough to get rid of the extra timer. We
can enqueue this patch to 3.17, unless you have any objection.

Let me know, thanks.
