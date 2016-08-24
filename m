From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 4/7] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Wed, 24 Aug 2016 22:11:39 +0200
Message-ID: <20160824201139.GA14379@breakpoint.cc>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
 <1472039755-14267-5-git-send-email-fw@strlen.de>
 <1472060441.14381.106.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47410 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751702AbcHXULm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 16:11:42 -0400
Content-Disposition: inline
In-Reply-To: <1472060441.14381.106.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> > Conntrack gc worker to evict stale entries.
> 
> 
> >  static struct nf_conn *
> >  __nf_conntrack_alloc(struct net *net,
> >  		     const struct nf_conntrack_zone *zone,
> > @@ -1527,6 +1597,7 @@ static int untrack_refs(void)
> >  
> >  void nf_conntrack_cleanup_start(void)
> >  {
> > +	conntrack_gc_work.exiting = true;
> >  	RCU_INIT_POINTER(ip_ct_attach, NULL);
> >  }
> >  
> > @@ -1536,6 +1607,9 @@ void nf_conntrack_cleanup_end(void)
> >  	while (untrack_refs() > 0)
> >  		schedule();
> >  
> > +	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
> > +	/* can be re-scheduled once */
> 
> Are you sure ?
> 
> As conntrack_gc_work.exiting = true, I do not see how this can happen ?

nf_conntrack_cleanup_start() sets exiting = true

current cpu blocks in

cancel_delayed_work_sync(&conntrack_gc_work.dwork);

Iff the work queue was running on other cpu but was already past
gc_work->exiting check then when cancel_delayed_work_sync() (first one)
returns it will have re-armed itself via schedule_delayed_work().

So I think the 2nd cancel_delayed_work_sync is needed.

Let me know if you'd like to see a v3 with more verbose
comment about this.

Thanks!
