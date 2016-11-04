From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf v3] netfilter: conntrack: refine gc worker heuristics
Date: Fri, 4 Nov 2016 16:48:12 +0100
Message-ID: <0278811b-1a6f-8d27-eb38-685a4f9cc91d@6wind.com>
References: <1478250466-21157-1-git-send-email-fw@strlen.de>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38364 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932792AbcKDPsQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 11:48:16 -0400
Received: by mail-wm0-f46.google.com with SMTP id n67so58099261wme.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Nov 2016 08:48:15 -0700 (PDT)
In-Reply-To: <1478250466-21157-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 04/11/2016 à 10:07, Florian Westphal a écrit :
> Nicholas Dichtel says:
nit: it's Nicolas, without the 'h' ;-)

>   After commit b87a2f9199ea ("netfilter: conntrack: add gc worker to
>   remove timed-out entries"), netlink conntrack deletion events may be
>   sent with a huge delay.
> 
> Nicholas further points at this line:
Ditto.

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
Ditto.

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
Thank you for this work and you patience ;-)
With this patch, notifications in my tests are all sent with a delay < 20
seconds (before the patch, some of them was sent with a delay > 4 minutes). And
most of them < 10 seconds, which is far better than before.
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Also a small comment below.
> ---
>  v3:
>  - get rid of unused variable
>  - cap max interval at 2 seconds
>  - use 64 as divisor to give 2 minute worst-case behaviour
> 
>  With large conntrack table (bucket count > 2m) kworker now starts to
>  pop up in top, but, unfortunately I see no way to avoid this unless
>  we're willing to accept larger max timeouts.
> 
>  Only other alternatives are to either revert back to per-conntrack timers
>  or export max time as a sysctl so users could tune it accordingly.
> 
>  net/netfilter/nf_conntrack_core.c | 50 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 42 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index df2f5a3901df..e03a5e80fded 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -76,6 +76,7 @@ struct conntrack_gc_work {
>  	struct delayed_work	dwork;
>  	u32			last_bucket;
>  	bool			exiting;
> +	long			next_gc_run;
>  };
>  
>  static __read_mostly struct kmem_cache *nf_conntrack_cachep;
> @@ -83,9 +84,11 @@ static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
>  static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
>  static __read_mostly bool nf_conntrack_locks_all;
>  
> +/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
>  #define GC_MAX_BUCKETS_DIV	64u
> -#define GC_MAX_BUCKETS		8192u
> -#define GC_INTERVAL		(5 * HZ)
> +/* upper bound of scan intervals */
> +#define GC_INTERVAL_MAX		(2 * HZ)
> +/* maximum conntracks to evict per gc run */
>  #define GC_MAX_EVICTS		256u
>  
>  static struct conntrack_gc_work conntrack_gc_work;
> @@ -936,13 +939,14 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
>  static void gc_worker(struct work_struct *work)
>  {
>  	unsigned int i, goal, buckets = 0, expired_count = 0;
> -	unsigned long next_run = GC_INTERVAL;
> -	unsigned int ratio, scanned = 0;
>  	struct conntrack_gc_work *gc_work;
> +	unsigned int ratio, scanned = 0;
> +	unsigned long next_run;
>  
>  	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
>  
> -	goal = min(nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV, GC_MAX_BUCKETS);
> +	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
> +	next_run = gc_work->next_gc_run;
No need to set next_run here, it will be set later in any case.


Thank you,
Nicolas
