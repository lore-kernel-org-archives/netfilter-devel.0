Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853D57C717
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193864; cv=none; b=XTMPkB12NojLcpEW/q5FBS/2OZOG5xj1fU9Z8442TtgdCGJLElHkbCT4Mcrw4mutgXgocWF8X4xkQGpc8lxhfCwzKRyyujhXzwpyeWVwY9vG5WjzafKLP/776pFNDn4ldA04gntvyyU3rH2AakCZhfYnr8xAQufqPOKogr8Ph3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193864; c=relaxed/simple;
	bh=dm8vd2cI3IUcKAZDac4ATBd+yxjevNaW1HPKDV7P9qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfNaLfaTaViltrucL+LcxMB1PdJClrBcYj9es/EkN8uuRJYUVA3gPoNtjrAWYqLM1IL0pqLNulscbc9xIAwBuKl3Bj+Hngf0W128HFLpnjhc++ueMy0yxluC3pO812ctJy6ZSUAuBOpOQrdCIjuzxBB5ud1WrgPlbseVB8F8A9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VuliulrX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VuliulrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790193847;
	bh=dLX+ymAYvRUZ+S3EvpBiKRDHW+hFKALLHbxrPXgihec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VuliulrXO8F08pdjs6DvM7GHeKY+MzeG+wuFLCqsruQcNbyqON92lTLsT2UamJe8p
	 lyo0sftQDkWtV1wa8S900M+LRnFvmwLFur9wld/R51GRLq/aKV289LfKtsGgZF3Qe7
	 jK1aQFQiKZ2orrOTo9/L/9ELrBUhLoiQ+KjX0SgX6ZFKAQUqYK5nB22p+1D5fajcmt
	 VzhDsO/gQn1+xhSZFt8sA7sWx4u/oHUSVqLZAfFU4oHR6YyxbPFGpNwIItnwtCrioV
	 0Gtz175V6zj2FUKYSzbBr/jGWYSmqXK3ZsChoTVyP7kyZzzyecdE7PboQoCi95ClcR
	 6IPLyAbk7QbgA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9EA906005D;
	Wed, 23 Sep 2026 22:04:07 +0200 (CEST)
Date: Wed, 23 Sep 2026 22:04:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf,v3] netfilter: nfnetlink_queue: hash queue instance by
 portid too
Message-ID: <arQwtSh6BNUZ8BsJ@chamomile>
References: <20260923184047.48492-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260923184047.48492-1-pablo@netfilter.org>

On Wed, Sep 23, 2026 at 08:40:46PM +0200, Pablo Neira Ayuso wrote:
> netlink_release() calls netlink_remove() before delivering the
> NETLINK_URELEASE event. And a new queue instance can be created before
> delivering such NETLINK_URELEASE event. This allows for two different
> queue instances with the same portid to co-exist for a little while.
> Since the instance that is going away is destroyed by portid via netlink
> notifier, both the newly created instance and the one that is going away
> with the same portid are destroyed.

It seems I cannot fix this in this way. I forgot same socket can be
bound to several queues.

> Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: - use siphash instead of lazy hash
>     - fix incorrect hlist and wrong instance_lookup_by_portid()
> 
>  net/netfilter/nfnetlink_queue.c | 36 +++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index c727668b0c5b..a2086c192063 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -69,6 +69,7 @@
>  
>  struct nfqnl_instance {
>  	struct hlist_node hlist;		/* global list of queues */
> +	struct hlist_node hlist_portid;		/* global list of queues, by portid */
>  	struct rhashtable nfqnl_packet_map;
>  	struct rcu_work	rwork;
>  
> @@ -96,11 +97,13 @@ typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
>  
>  static struct workqueue_struct *nfq_cleanup_wq __read_mostly;
>  static unsigned int nfnl_queue_net_id __read_mostly;
> +static siphash_aligned_key_t nfnl_queue_hash_key;
>  
>  #define INSTANCE_BUCKETS	16
>  struct nfnl_queue_net {
>  	spinlock_t instances_lock;
>  	struct hlist_head instance_table[INSTANCE_BUCKETS];
> +	struct hlist_head instance_table_portid[INSTANCE_BUCKETS];
>  };
>  
>  static struct nfnl_queue_net *nfnl_queue_pernet(struct net *net)
> @@ -113,6 +116,15 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
>  	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
>  }
>  
> +static inline u8 instance_portid_hashfn(u32 portid)
> +{
> +	u64 hash = siphash_1u32(portid, &nfnl_queue_hash_key);
> +
> +	net_get_random_once(&nfnl_queue_hash_key, sizeof(nfnl_queue_hash_key));
> +
> +	return reciprocal_scale(hash, INSTANCE_BUCKETS);
> +}
> +
>  static const struct rhashtable_params nfqnl_rhashtable_params = {
>  	.head_offset = offsetof(struct nf_queue_entry, hash_node),
>  	.key_offset = offsetof(struct nf_queue_entry, id),
> @@ -136,6 +148,20 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
>  	return NULL;
>  }
>  
> +static struct nfqnl_instance *
> +instance_lookup_by_portid(struct nfnl_queue_net *q, u32 portid)
> +{
> +	struct nfqnl_instance *inst;
> +	struct hlist_head *head;
> +
> +	head = &q->instance_table_portid[instance_portid_hashfn(portid)];
> +	hlist_for_each_entry(inst, head, hlist_portid) {
> +		if (inst->peer_portid == portid)
> +			return inst;
> +	}
> +	return NULL;
> +}
> +
>  static struct nfqnl_instance *
>  instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  {
> @@ -160,7 +186,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  		goto out_free;
>  
>  	spin_lock(&q->instances_lock);
> -	if (instance_lookup(q, queue_num)) {
> +	if (instance_lookup(q, queue_num) ||
> +	    unlikely(instance_lookup_by_portid(q, portid))) {
>  		err = -EEXIST;
>  		goto out_unlock;
>  	}
> @@ -172,6 +199,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  
>  	h = instance_hashfn(queue_num);
>  	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
> +	h = instance_portid_hashfn(portid);
> +	hlist_add_head(&inst->hlist_portid, &q->instance_table_portid[h]);
>  
>  	spin_unlock(&q->instances_lock);
>  
> @@ -208,6 +237,7 @@ static void
>  __instance_destroy(struct nfqnl_instance *inst)
>  {
>  	hlist_del_rcu(&inst->hlist);
> +	hlist_del(&inst->hlist_portid);
>  
>  	INIT_RCU_WORK(&inst->rwork, instance_destroy_work);
>  	queue_rcu_work(nfq_cleanup_wq, &inst->rwork);
> @@ -2119,8 +2149,10 @@ static int __net_init nfnl_queue_net_init(struct net *net)
>  	unsigned int i;
>  	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
>  
> -	for (i = 0; i < INSTANCE_BUCKETS; i++)
> +	for (i = 0; i < INSTANCE_BUCKETS; i++) {
>  		INIT_HLIST_HEAD(&q->instance_table[i]);
> +		INIT_HLIST_HEAD(&q->instance_table_portid[i]);
> +	}
>  
>  	spin_lock_init(&q->instances_lock);
>  
> -- 
> 2.47.3
> 
> 
