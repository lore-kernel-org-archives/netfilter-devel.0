From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Sun, 21 Aug 2016 21:13:31 -0700
Message-ID: <1471839211.14381.4.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
         <1471606575-2197-3-git-send-email-fw@strlen.de>
         <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
         <20160819151642.GA11049@breakpoint.cc>
         <1471620263.29842.107.camel@edumazet-glaptop3.roam.corp.google.com>
         <20160819160446.GC11049@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36132 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbcHVENe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 00:13:34 -0400
Received: by mail-pf0-f195.google.com with SMTP id y134so5516196pfg.3
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2016 21:13:34 -0700 (PDT)
In-Reply-To: <20160819160446.GC11049@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-08-19 at 18:04 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Fri, 2016-08-19 at 17:16 +0200, Florian Westphal wrote:
> > 
> > > Hmm, ____nf_conntrack_find caller needs to hold rcu_read_lock,
> > > in case object is free'd SLAB_DESTROY_BY_RCU should delay actual release
> > > of the page.
> > 
> > Well, point is that SLAB_DESTROY_BY_RCU means that we have no grace
> > period, and object can be immediately reused and recycled.
> > 
> > @next pointer can definitely be overwritten.
> 
> I see.  Isn't that detected by the nulls magic (to restart
> lookup if entry was moved to other chain due to overwritten next pointer)?

Well, you did not add the nulls magic in your code ;)

It might be fine, since it should be a rare event, and garbage
collection is best effort, so you might add a comment in gc_worker() why
it is probably overkill to restart the loop in this unlikely event.

BTW, maybe nf_conntrack_tuple_taken() should get the nulls magic check,
as it is currently missing.




