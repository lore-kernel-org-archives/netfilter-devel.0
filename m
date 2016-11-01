From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: refine gc worker heuristics
Date: Tue, 1 Nov 2016 22:53:11 +0100
Message-ID: <20161101215311.GA17689@breakpoint.cc>
References: <1478030500-28981-1-git-send-email-fw@strlen.de>
 <1478033811.7065.357.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        nicolas.dichtel@6wind.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50308 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751022AbcKAVyy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 17:54:54 -0400
Content-Disposition: inline
In-Reply-To: <1478033811.7065.357.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2016-11-01 at 21:01 +0100, Florian Westphal wrote:
> >  	schedule_delayed_work(&gc_work->dwork, next_run);
> 
> 
> > @@ -993,6 +1029,7 @@ static void gc_worker(struct work_struct *work)
> >  static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
> >  {
> >  	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
> > +	gc_work->next_gc_run = GC_INTERVAL_MAX;
> >  	gc_work->exiting = false;
> >  }
> >  
> > @@ -1885,7 +1922,7 @@ int nf_conntrack_init_start(void)
> >  	nf_ct_untracked_status_or(IPS_CONFIRMED | IPS_UNTRACKED);
> >  
> >  	conntrack_gc_work_init(&conntrack_gc_work);
> > -	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL);
> > +	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL_MAX);
> >  
> >  	return 0;
> >  
> 
> 
> We might use system_long_wq instead of system_wq ?
> 
> queue_delayed_work(system_long_wq, ...)

Ok, I will change this for v2, thanks Eric.
