Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9921D3C5;
	Tue, 13 Jan 2026 00:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263939; cv=none; b=Ym4v4620g79jiIqaPaKl1jDmzlVrLdGsLYPaqiKP5L1dX0N36vbncC5DXOtLP9AE5JaOJy1yy7K0oYmxTbyg6Qf0/BmEKrCG3zArnA+FQ9Eddhns+hPCCNFY0/AFh9zrooqQq3c8FOA5A9rbFtWUvKimWn1OGb37Z8f1AZhE4PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263939; c=relaxed/simple;
	bh=omfOKGePOgGno18vA5VYSUGhOionRWz3uDNe1lmf0jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0LQrlujBsxbV+7GVn3l7RbPKGGpJp+4+qCXW9POprlhB0STXKTBxghvAFDJReX7fZN5i6t7JEfYMw4OgYMaT4mBJ0RPOH5hZvUW4skWRqG+fKbXskT9bZSatNn6CP61FlPOrSLcHXY01wXcP8/+VOQIsxbOnJ+fNNalqDeVsZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VfFe2ubm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VfFe2ubm"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2E9AE600B5;
	Tue, 13 Jan 2026 01:25:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768263933;
	bh=4gZUSbQc7hX2kni+SSV8ol6CMbRg9ZQKOT5YCg79mTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VfFe2ubmcvju6dixtvOsxtjLPrVZyUK8yPthKPRG67eh72J2GoygXtjettUlQYpec
	 OTfLk/P7ollU6zekCauOqhFlnOwOs867YSaEiraaFlJxXU2DXvrXvjXGLjNX7mPNFl
	 Y4wdEuAQe5wO1Sw58NqZFF77Q5Clq4+kJTOS9slKGhYFCSptK0jpft7/qxzwGJyGQR
	 4XkPQPCBFD5/RhzNqbCxmBpYv2b1rQQ6XNEiQasaok4bZZTqmy39mdeYVoKTjKcPvf
	 hUD98d5eRgFj0tUvDGl/VdP0OcbLyqdiha2y3+Hr/oIZj+7XaB2YLFgWdv9HzetWrc
	 xg4zRlHjFv47g==
Date: Tue, 13 Jan 2026 01:25:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aWWQ-ooAmTIEhdHO@chamomile>
References: <20251122003720.16724-1-scott_mitchell@apple.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251122003720.16724-1-scott_mitchell@apple.com>

Hi Scott,

> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index 4aeffddb7586..3d0def310523 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -11,6 +11,7 @@
>  /* Each queued (to userspace) skbuff has one of these. */
>  struct nf_queue_entry {
>  	struct list_head	list;
> +	struct hlist_node	hash_node;
>  	struct sk_buff		*skb;
>  	unsigned int		id;
>  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index efcb7c044a74..bc296a17e5aa 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -107,6 +107,7 @@ enum nfqnl_attr_config {
>  	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
>  	NFQA_CFG_MASK,			/* identify which flags to change */
>  	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
> +	NFQA_CFG_HASH_SIZE,		/* __u32 hash table size (rounded to power of 2) */

This should use the rhashtable implementation, I don't find a good
reason why this is not used in first place for this enhancement.

>  	__NFQA_CFG_MAX
>  };
>  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 8b7b39d8a109..b142fac70ed9 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -46,7 +46,10 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #endif
>  
> -#define NFQNL_QMAX_DEFAULT 1024
> +#define NFQNL_QMAX_DEFAULT      1024
> +#define NFQNL_MIN_HASH_SIZE     16
> +#define NFQNL_DEFAULT_HASH_SIZE 1024
> +#define NFQNL_MAX_HASH_SIZE     131072
>  
>  /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
>   * includes the header length. Thus, the maximum packet length that we
> @@ -65,6 +68,7 @@ struct nfqnl_instance {
>  	unsigned int copy_range;
>  	unsigned int queue_dropped;
>  	unsigned int queue_user_dropped;
> +	unsigned int queue_hash_size;
>  
>  
>  	u_int16_t queue_num;			/* number of this queue */
> @@ -77,6 +81,8 @@ struct nfqnl_instance {
>  	spinlock_t	lock	____cacheline_aligned_in_smp;
>  	unsigned int	queue_total;
>  	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
> +	unsigned int	queue_hash_mask;
> +	struct hlist_head *queue_hash;
>  	struct list_head queue_list;		/* packets in queue */
>  };
>  
> @@ -95,6 +101,39 @@ static struct nfnl_queue_net *nfnl_queue_pernet(struct net *net)
>  	return net_generic(net, nfnl_queue_net_id);
>  }
>  
> +static inline unsigned int
> +nfqnl_packet_hash(u32 id, unsigned int mask)
> +{
> +	return id & mask;
> +}
> +
> +static inline u32
> +nfqnl_normalize_hash_size(u32 hash_size)
> +{
> +	/* Must be power of two for queue_hash_mask to work correctly.
> +	 * Avoid overflow of is_power_of_2 by bounding NFQNL_MAX_HASH_SIZE.
> +	 */
> +	BUILD_BUG_ON(!is_power_of_2(NFQNL_MIN_HASH_SIZE) ||
> +		     !is_power_of_2(NFQNL_DEFAULT_HASH_SIZE) ||
> +		     !is_power_of_2(NFQNL_MAX_HASH_SIZE) ||
> +		     NFQNL_MAX_HASH_SIZE > 1U << 31);
> +
> +	if (!hash_size)
> +		return NFQNL_DEFAULT_HASH_SIZE;
> +
> +	/* Clamp to valid range before power of two to avoid overflow */
> +	if (hash_size <= NFQNL_MIN_HASH_SIZE)
> +		return NFQNL_MIN_HASH_SIZE;
> +
> +	if (hash_size >= NFQNL_MAX_HASH_SIZE)
> +		return NFQNL_MAX_HASH_SIZE;
> +
> +	if (!is_power_of_2(hash_size))
> +		hash_size = roundup_pow_of_two(hash_size);
> +
> +	return hash_size;
> +}
> +
>  static inline u_int8_t instance_hashfn(u_int16_t queue_num)
>  {
>  	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
> @@ -114,13 +153,70 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
>  	return NULL;
>  }
>  
> +static int
> +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)

rhashtable can just handle this for you, then users do not need
to tune this hash_size parameter.

> +{
> +	struct hlist_head *new_hash, *old_hash;
> +	struct nf_queue_entry *entry;
> +	unsigned int h, hash_mask;
> +
> +	hash_size = nfqnl_normalize_hash_size(hash_size);
> +	if (hash_size == inst->queue_hash_size)
> +		return 0;
> +
> +	/* GFP_ATOMIC required: called under rcu_read_lock in nfqnl_recv_config.
> +	 * Using GFP_KERNEL_ACCOUNT would require refactoring lock placement.
> +	 */
> +	new_hash = kvmalloc_array(hash_size, sizeof(*new_hash), GFP_ATOMIC);
> +	if (!new_hash)
> +		return -ENOMEM;
> +
> +	hash_mask = hash_size - 1;
> +
> +	for (h = 0; h < hash_size; h++)
> +		INIT_HLIST_HEAD(&new_hash[h]);
> +
> +	spin_lock_bh(&inst->lock);
> +
> +	list_for_each_entry(entry, &inst->queue_list, list) {
> +		/* No hlist_del() since old_hash will be freed and we hold lock */
> +		h = nfqnl_packet_hash(entry->id, hash_mask);
> +		hlist_add_head(&entry->hash_node, &new_hash[h]);
> +	}
> +
> +	old_hash = inst->queue_hash;
> +	inst->queue_hash_size = hash_size;
> +	inst->queue_hash_mask = hash_mask;
> +	inst->queue_hash = new_hash;
> +
> +	spin_unlock_bh(&inst->lock);
> +
> +	kvfree(old_hash);
> +
> +	return 0;
> +}
> +
>  static struct nfqnl_instance *
> -instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
> +instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid,
> +		u32 hash_size)
>  {
>  	struct nfqnl_instance *inst;
> +	struct hlist_head *queue_hash;
>  	unsigned int h;
>  	int err;
>  
> +	hash_size = nfqnl_normalize_hash_size(hash_size);
> +
> +	/* GFP_ATOMIC required: called under rcu_read_lock in nfqnl_recv_config.
> +	 * Using GFP_KERNEL_ACCOUNT would require refactoring lock placement.
> +	 */
> +	queue_hash = kvmalloc_array(hash_size, sizeof(*queue_hash), GFP_ATOMIC);

If rhashtable is used, this can be allocate perns and then you avoid
this GFP_ATOMIC for each instance.

> +	if (!queue_hash)
> +		return ERR_PTR(-ENOMEM);
> +
> +	for (h = 0; h < hash_size; h++)
> +		INIT_HLIST_HEAD(&queue_hash[h]);
> +
>  	spin_lock(&q->instances_lock);
>  	if (instance_lookup(q, queue_num)) {
>  		err = -EEXIST;

