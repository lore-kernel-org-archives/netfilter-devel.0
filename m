From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: refine gc worker heuristics,
 redux
Date: Mon, 16 Jan 2017 18:33:49 +0100
Message-ID: <20170116173349.GA12001@breakpoint.cc>
References: <1484564166-5886-1-git-send-email-fw@strlen.de>
 <1fa618d3-4c2a-72f1-d5f8-ddfadc6ad029@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        nuclearcat@nuclearcat.com
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51224 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750777AbdAPReE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 12:34:04 -0500
Content-Disposition: inline
In-Reply-To: <1fa618d3-4c2a-72f1-d5f8-ddfadc6ad029@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> Le 16/01/2017 à 11:56, Florian Westphal a écrit :
> > This further refines the changes made to conntrack gc_worker in
> > commit e0df8cae6c16 ("netfilter: conntrack: refine gc worker heuristics").
> > 
> > The main of this change is to reduce the scan interval when evictions
> > take place.
> > 
> > However, on the reporters' setup, there are 1-2 Million conntrack entries
> > in total, and roughly 8k new connections per second.
> > 
> > In this case we'll always evict at least one entry per gc cycle and scan
> > interval is always at 1 jiffy.
> > 
> > Given we scan ~10k entries per run its clearly wrong to reduce interval
> > based on number of evictions, it will only waste cpu cycles.
> > 
> > Thus only look at the ratio (scanned entries vs. evicted entries) to make
> > a decision on whether to reduce or not.
> > 
> > Given the fact that evictor is supposed to only kick in when system turns
> > idle after a busy period, we should pick a high ratio -- this makes it 50%.
> > 
> > Also, get rid of GC_MAX_EVICTS.  Instead of breaking loop and instant
> > resched, just don't bother checking this at all (the loop calls
> > cond_resched for every bucket anyway).
> > 
> > Removal of GC_MAX_EVICTS was suggested by Nicolas in the past; I
> > should have listened.
> I (still) agree with that part, maybe it could be done in another patch.

Done.

> > Fixes: b87a2f9199ea82eaadc ("netfilter: conntrack: add gc worker to remove timed-out entries")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> With that patch, it's worse than before. I regularly have a delay > 30 seconds
> in my tests (this was infrequent before the patch).

:-/

We could lower the ratio of course, but under synflood with 3 second syn_recv timeout
I get a scan/evict ratio of ~15%, and we should not schedule worker all the time in that case.

> A solution, to fix the balance between cpu cycles consumption and short ct
> events delays may be to introduce a new sysctl which allows the user to choose
> between two predefined configs: short delay or long delay for ct events.
> Even if I don't like this, maybe it could be acceptable with a default value set
> to 'short delay'.

TBH in that case I'd prefer to just give up, and change worker to this:

        for (i = 0; i < nf_conntrack_htable_size; i++) {
         [..]
                hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
                        tmp = nf_ct_tuplehash_to_ctrack(h);

                        if (nf_ct_is_expired(tmp)) {
                                nf_ct_gc_expired(tmp);
                                continue;
                        }
                }
	[..]
             cond_resched_rcu_qs();
        }

        if (!gc_work->exiting)
                queue_delayed_work(system_long_wq, &gc_work->dwork, nf_conntrack_gc_interval);
}

Where nf_conntrack_gc_interval gets exported to userspace (in milliseconds),
with a default set e.g. to one minute.

Obvious downside: with low setting like 1 second we'll do frequent
rescan of entire table.

