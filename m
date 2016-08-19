From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Fri, 19 Aug 2016 18:04:46 +0200
Message-ID: <20160819160446.GC11049@breakpoint.cc>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
 <1471606575-2197-3-git-send-email-fw@strlen.de>
 <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
 <20160819151642.GA11049@breakpoint.cc>
 <1471620263.29842.107.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57236 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753665AbcHSQEt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 12:04:49 -0400
Content-Disposition: inline
In-Reply-To: <1471620263.29842.107.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2016-08-19 at 17:16 +0200, Florian Westphal wrote:
> 
> > Hmm, ____nf_conntrack_find caller needs to hold rcu_read_lock,
> > in case object is free'd SLAB_DESTROY_BY_RCU should delay actual release
> > of the page.
> 
> Well, point is that SLAB_DESTROY_BY_RCU means that we have no grace
> period, and object can be immediately reused and recycled.
> 
> @next pointer can definitely be overwritten.

I see.  Isn't that detected by the nulls magic (to restart
lookup if entry was moved to other chain due to overwritten next pointer)?

I don't see a hlist_nulls_for_each_entry_rcu_safe variant like we have
for normal lists (list_for_each_entry_safe), do I need to add one?
Currently we have this:

rcu_read_lock()
____nf_conntrack_find
hlist_nulls_for_each_entry_rcu ...

 if (nf_ct_is_expired(ct)) { // lazy test, ct can be reused here
	 nf_ct_gc_expired(ct);
	 continue;
 }

nf_ct_gc_expired() does this:

static void nf_ct_gc_expired(struct nf_conn *ct)
{
        if (!atomic_inc_not_zero(&ct->ct_general.use))
                return;

        if (nf_ct_should_gc(ct))
                nf_ct_kill(ct);

        nf_ct_put(ct);

So we only nf_ct_kill when we have a reference
and we know ct is in hash (check is in nf_ct_should_gc()).

So once we put, the object can be released but the
next pointer is not altered.

In case ct object is reused right after this last
nf_ct_put it could be re-inserted already, e.g. into
dying list or back into hash table -- but is this a problem?

'dead' (non-recycled) element is cought by atomic_inc_not_zero
in nf_ct_gc_expired, about-to-inserted (not in hash) is detected
by nf_ct_should_gc() (it checks confirmed bit in ct->status),
already-inserted (in hashtable) would lead us to 'magically'
move to a different hash chain in hlist_nulls_for_each_entry_rcu.

But we would then hit the wrong nulls list terminator and restart
the traversal.

Does that make sense?
