From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Mon, 22 Aug 2016 10:53:13 +0200
Message-ID: <20160822085313.GA6199@breakpoint.cc>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
 <1471606575-2197-3-git-send-email-fw@strlen.de>
 <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
 <20160819151642.GA11049@breakpoint.cc>
 <1471620263.29842.107.camel@edumazet-glaptop3.roam.corp.google.com>
 <20160819160446.GC11049@breakpoint.cc>
 <1471839211.14381.4.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34470 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752410AbcHVIxv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 04:53:51 -0400
Content-Disposition: inline
In-Reply-To: <1471839211.14381.4.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2016-08-19 at 18:04 +0200, Florian Westphal wrote:
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > On Fri, 2016-08-19 at 17:16 +0200, Florian Westphal wrote:
> > > 
> > > > Hmm, ____nf_conntrack_find caller needs to hold rcu_read_lock,
> > > > in case object is free'd SLAB_DESTROY_BY_RCU should delay actual release
> > > > of the page.
> > > 
> > > Well, point is that SLAB_DESTROY_BY_RCU means that we have no grace
> > > period, and object can be immediately reused and recycled.
> > > 
> > > @next pointer can definitely be overwritten.
> > 
> > I see.  Isn't that detected by the nulls magic (to restart
> > lookup if entry was moved to other chain due to overwritten next pointer)?
> 
> Well, you did not add the nulls magic in your code ;)

Oh.  Right, its indeed mising in the gc code.

> It might be fine, since it should be a rare event, and garbage
> collection is best effort, so you might add a comment in gc_worker() why
> it is probably overkill to restart the loop in this unlikely event.

Seems like a good idea, I will add it.

> BTW, maybe nf_conntrack_tuple_taken() should get the nulls magic check,
> as it is currently missing.

Good point, I will investigate.

Thanks Eric!
