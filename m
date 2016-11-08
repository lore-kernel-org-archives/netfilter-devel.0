From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v4] netfilter: conntrack: refine gc worker heuristics
Date: Wed, 9 Nov 2016 00:04:20 +0100
Message-ID: <20161108230420.GA31369@salvia>
References: <1478274898-24605-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbcKHXEa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:04:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0190B392E17
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:04:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2E1CDA804
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:04:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8CC4DA804
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:04:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1478274898-24605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 04, 2016 at 04:54:58PM +0100, Florian Westphal wrote:
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

Applied, thanks a lot Florian.

Tunning this is the hard part of this new workqueue approach IMO, it
should be fine if we need more iterations to revisit this logic.
