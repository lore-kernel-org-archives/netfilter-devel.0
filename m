From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: refine gc worker heuristics
Date: Thu, 3 Nov 2016 17:03:19 +0100
Message-ID: <9b8a1258-1ecd-daf8-ffd2-1acc70e2ebbb@6wind.com>
References: <1478127895-32540-1-git-send-email-fw@strlen.de>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35983 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932994AbcKCQDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 12:03:23 -0400
Received: by mail-wm0-f50.google.com with SMTP id p190so342800401wmp.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Nov 2016 09:03:22 -0700 (PDT)
In-Reply-To: <1478127895-32540-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 03/11/2016 à 00:04, Florian Westphal a écrit :
> Nicholas Dichtel says:
>   After commit b87a2f9199ea ("netfilter: conntrack: add gc worker to
>   remove timed-out entries"), netlink conntrack deletion events may be
>   sent with a huge delay.
> 
> Nicholas further points at this line:
> 
>   goal = min(nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV, GC_MAX_BUCKETS);
> 
> and indeed, this isn't optimal at all.  Rationale here was to ensure that
> we don't block other work items for too long, even if
> nf_conntrack_htable_size is huge.  But in order to have some guarantee
> about maximum time period where a scan of the full conntrack table
> completes we should always use a fixed slice size, so that once every
> N scans the full table has been examined at least once.
> 
> We also need to balance this vs. the case where the system is either idle
> (i.e., conntrack table (almost) empty) or very busy (i.e. eviction happens
> from packet path).
> 
> So, after some discussion with Nicholas:
> 
> 1. want hard guarantee that we scan entire table at least once every X s
> -> need to scan fraction of table (get rid of upper bound)
> 
> 2. don't want to eat cycles on idle or very busy system
> -> increase interval if we did not evict any entries
> 
> 3. don't want to block other worker items for too long
> -> make fraction really small, and prefer small scan interval instead
> 
> 4. Want reasonable short time where we detect timed-out entry when
> system went idle after a burst of traffic, while not doing scans
> all the time.
> -> Store next gc scan in worker, increasing delays when no eviction
> happened and shrinking delay when we see timed out entries.
> 
> The old gc interval is turned into a max number, scans can now happen
> every jiffy if stale entries are present.
> 
> Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Change since v1: use system_long_wq instead of normal system wq (suggested by
>  Eric Dumazet).
> 
>  Nicholas is currently away; I would like to get his feedback on this one
>  before it gets applied.
Thank you for the update.
With that patch, some events still have a delay > 2 minutes, which I think is
too much.

If I'm not wrong, the worst delay with this patch is:
10 (GC_INTERVAL_MAX) + 0,001 + 5,001 + 5,002 + 5,003 + ... +  6,024 (= 5 secs +
1024 mecs)
  = 10 + 0,001 + 5x1024 + (1 + 2 + 3 + ... 1024)/1000
  = 10 + 0,001 + 5x1024 + (1024x1023/2)/1000
  = 5653,77 seconds
  = 94 minutes

I take the case where gc_work->next_gc_run == GC_INTERVAL_MAX (10 seconds), then
an entry is evicted (gc_work->next_gc_run /= 2U; (=> 5 seconds) and next_run is
set to 0,001 seconds) and the next entry to evict needs a full table scan, ie
1024 (GC_MAX_BUCKETS_DIV) rounds (we add 1 msecs at each round).

Even if we start from a delay of 0, to perform a full scan we need:
1 + 2 + 3 + ... 1024 = 1024x1023/2 = 523776 msecs ~= 8,7 minutes

Previously (in private discussions), you propose a algorithm which guarantee a
full table scan in a predefined delay. A "good" solution may have such guarantee.

Regards,
Nicolas
