Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A37FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 11:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243228AbhLAL2S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 06:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbhLAL2R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 06:28:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A73C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 03:24:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1msNjK-000545-Gz; Wed, 01 Dec 2021 12:24:54 +0100
Date:   Wed, 1 Dec 2021 12:24:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
Message-ID: <20211201112454.GA2315@breakpoint.cc>
References: <20211121170514.2595-1-fw@strlen.de>
 <YZzrgVYskeXzLuM5@salvia>
 <20211123133045.GM6326@breakpoint.cc>
 <YaaYK9i2hixxbs70@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaaYK9i2hixxbs70@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I do not see how.
> 
> I started a patchset, but the single hashtable for every netns might
> defeat the batching, if there is a table per netns then it should be
> similar to 67cc570edaa0.

I see.

> > for going with 2m.
> 
> Default 2m is probably too large? This should be set at least to the
> UDP unreplied timeout, ie. 30s?

Perhaps but I don't think 30s is going to resolve the issue at hand
(burstiness).

> Probably set default scan interval to 20s and reduce it if there is
> workload coming in the next scan round? It is possible to count for
> the number of entries that will expired in the next round, if this
> represents a large % of entries, then reduce the scan interval of the
> vgarbage collector.

I don't see how thios helps, see below.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 770a63103c7a..3f6731a9c722 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -77,7 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
>  /* serialize hash resizes and nf_ct_iterate_cleanup */
>  static DEFINE_MUTEX(nf_conntrack_mutex);
>  
> -#define GC_SCAN_INTERVAL	(120u * HZ)
> +/* Scan every 20 seconds which is 2/3 of the UDP unreplied timeout. */
> +#define GC_SCAN_INTERVAL	(20u * HZ)
>  #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
>  
>  #define MIN_CHAINLEN	8u
> @@ -1418,12 +1419,22 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
>  	return false;
>  }
>  
> +static bool nf_ct_is_expired_next_run(const struct nf_conn *ct)
> +{
> +	unsigned long next_timestamp = nfct_time_stamp + GC_SCAN_INTERVAL;
> +
> +	return (__s32)(ct->timeout - next_timestamp) <= 0;
> +}

Ok.

>  static void gc_worker(struct work_struct *work)
>  {
> +	unsigned long next_run_expired_entries = 0, entries = 0, idle;
>  	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
>  	unsigned int i, hashsz, nf_conntrack_max95 = 0;
>  	unsigned long next_run = GC_SCAN_INTERVAL;
>  	struct conntrack_gc_work *gc_work;
> +	bool next_run_expired;
> +
>  	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
>  
>  	i = gc_work->next_bucket;
> @@ -1448,6 +1459,8 @@ static void gc_worker(struct work_struct *work)
>  			struct nf_conntrack_net *cnet;
>  			struct net *net;
>  
> +			next_run_expired = false;
> +			entries++;
>  			tmp = nf_ct_tuplehash_to_ctrack(h);
>  
>  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> @@ -1458,6 +1471,9 @@ static void gc_worker(struct work_struct *work)
>  			if (nf_ct_is_expired(tmp)) {
>  				nf_ct_gc_expired(tmp);
>  				continue;
> +			} else if (nf_ct_is_expired_next_run(tmp)) {
> +				next_run_expired = true;
> +				next_run_expired_entries++;

This means this expires within next 20s, but not now.

> @@ -1511,7 +1531,22 @@ static void gc_worker(struct work_struct *work)
>  	if (next_run) {
>  		gc_work->early_drop = false;
>  		gc_work->next_bucket = 0;
> +		/*
> +		 * Calculate gc workload for the next run, adjust the gc
> +		 * interval not to reap expired entries in bursts.
> +		 *
> +		 * Adjust scan interval linearly based on the percentage of
> +		 * entries that will expire in the next run. The scan interval
> +		 * is inversely proportional to the workload.
> +		 */
> +		if (entries == 0) {
> +			next_run = GC_SCAN_INTERVAL;
> +		} else {
> +			idle = 100u - (next_run_expired_entries * 100u / entries);
> +			next_run = GC_SCAN_INTERVAL * idle / 100u;

AFAICS we may now schedule next run for 'right now' even though that
would not find any expired entries (they might all have a timeout of
19s). Next round would reap no entries, then resched again immediately

(the nf_ct_is_expired_next_run expire count assumes next run is in
 20s, not before).

This would burn cycles for 19s before those entries can be expired.

Not sure how to best avoid this, perhaps computing the remaining avg timeout
of the nf_ct_is_expired_next_run() candidates would help?
