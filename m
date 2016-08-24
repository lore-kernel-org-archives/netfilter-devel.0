From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 4/7] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Wed, 24 Aug 2016 13:30:42 -0700
Message-ID: <1472070642.14381.120.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-5-git-send-email-fw@strlen.de>
         <1472060441.14381.106.camel@edumazet-glaptop3.roam.corp.google.com>
         <20160824201139.GA14379@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36544 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbcHXUmj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 16:42:39 -0400
Received: by mail-pa0-f67.google.com with SMTP id ez1so1777406pab.3
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 13:42:39 -0700 (PDT)
In-Reply-To: <20160824201139.GA14379@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 22:11 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> > > Conntrack gc worker to evict stale entries.
> > 
> > 
> > >  static struct nf_conn *
> > >  __nf_conntrack_alloc(struct net *net,
> > >  		     const struct nf_conntrack_zone *zone,
> > > @@ -1527,6 +1597,7 @@ static int untrack_refs(void)
> > >  
> > >  void nf_conntrack_cleanup_start(void)
> > >  {
> > > +	conntrack_gc_work.exiting = true;
> > >  	RCU_INIT_POINTER(ip_ct_attach, NULL);
> > >  }
> > >  
> > > @@ -1536,6 +1607,9 @@ void nf_conntrack_cleanup_end(void)
> > >  	while (untrack_refs() > 0)
> > >  		schedule();
> > >  
> > > +	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
> > > +	/* can be re-scheduled once */
> > 
> > Are you sure ?
> > 
> > As conntrack_gc_work.exiting = true, I do not see how this can happen ?
> 
> nf_conntrack_cleanup_start() sets exiting = true
> 
> current cpu blocks in
> 
> cancel_delayed_work_sync(&conntrack_gc_work.dwork);
> 
> Iff the work queue was running on other cpu but was already past
> gc_work->exiting check then when cancel_delayed_work_sync() (first one)
> returns it will have re-armed itself via schedule_delayed_work().
> 
> So I think the 2nd cancel_delayed_work_sync is needed.
> 
> Let me know if you'd like to see a v3 with more verbose
> comment about this.

If you were using cancel_delayed_work() (instead of
cancel_delayed_work_sync()) I would understand the concern.

But here you are using the thing that was designed to exactly avoid the
issue, of both work running on another cpu and/or re-arming itself.

If what you are saying was true, we would have to fix hundreds of
cancel_delayed_work_sync() call sites ...



