From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: refine gc worker heuristics,
 redux
Date: Thu, 19 Jan 2017 03:36:52 +0200
Message-ID: <87f65fc03fdfa4c2fc185551c7989c48@nuclearcat.com>
References: <1484701282-14758-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nuclearcat.com ([144.76.183.226]:39744 "EHLO nuclearcat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdASDKO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 22:10:14 -0500
In-Reply-To: <1484701282-14758-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-01-18 03:01, Florian Westphal wrote:
> This further refines the changes made to conntrack gc_worker in
> commit e0df8cae6c16 ("netfilter: conntrack: refine gc worker 
> heuristics").
> 
> The main idea of that change was to reduce the scan interval when 
> evictions
> take place.
> 
> However, on the reporters' setup, there are 1-2 million conntrack 
> entries
> in total and roughly 8k new (and closing) connections per second.
> 
> In this case we'll always evict at least one entry per gc cycle and 
> scan
> interval is always at 1 jiffy because of this test:
> 
>  } else if (expired_count) {
>      gc_work->next_gc_run /= 2U;
>      next_run = msecs_to_jiffies(1);
> 
> being true almost all the time.
> 
> Given we scan ~10k entries per run its clearly wrong to reduce interval
> based on nonzero eviction count, it will only waste cpu cycles since a 
> vast
> majorities of conntracks are not timed out.
> 
> Thus only look at the ratio (scanned entries vs. evicted entries) to 
> make
> a decision on whether to reduce or not.
> 
> Because evictor is supposed to only kick in when system turns idle 
> after
> a busy period, pick a high ratio -- this makes it 50%.  We thus keep
> the idea of increasing scan rate when its likely that table contains 
> many
> expired entries.
> 
> In order to not let timed-out entries hang around for too long
> (important when using event logging, in which case we want to timely
> destroy events), we now scan the full table within at most
> GC_MAX_SCAN_JIFFIES (16 seconds) even in worst-case scenario where all
> timed-out entries sit in same slot.
> 
> I tested this with a vm under synflood (with
> sysctl net.netfilter.nf_conntrack_tcp_timeout_syn_recv=3).
> 
> While flood is ongoing, interval now stays at its max rate
> (GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV -> 125ms).
> 
> With feedback from Nicolas Dichtel.
> 
> Reported-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Fixes: b87a2f9199ea82eaadc ("netfilter: conntrack: add gc worker to
> remove timed-out entries")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> this is on top of
> https://patchwork.ozlabs.org/patch/715850/
> ('netfilter: conntrack: remove GC_MAX_EVICTS break').

I confirm, patch completely fix issue.
