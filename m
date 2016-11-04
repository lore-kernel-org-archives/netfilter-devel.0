From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf v4] netfilter: conntrack: refine gc worker heuristics
Date: Fri, 4 Nov 2016 17:16:52 +0100
Message-ID: <469da164-eaa5-8257-1099-cc9d7932fdff@6wind.com>
References: <1478274898-24605-1-git-send-email-fw@strlen.de>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36131 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934706AbcKDQQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 12:16:56 -0400
Received: by mail-wm0-f41.google.com with SMTP id p190so61192128wmp.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Nov 2016 09:16:55 -0700 (PDT)
In-Reply-To: <1478274898-24605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 04/11/2016 à 16:54, Florian Westphal a écrit :
> Nicolas Dichtel says:
>   After commit b87a2f9199ea ("netfilter: conntrack: add gc worker to
>   remove timed-out entries"), netlink conntrack deletion events may be
>   sent with a huge delay.
> 
> Nicolas further points at this line:
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
> So, after some discussion with Nicolas:
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
> Longest possible time period until an entry is evicted is now 2 minutes
> in worst case (entry expires right after it was deemed 'not expired').
> 
> Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>


Thank you,
Nicolas
