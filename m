Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273400;
	b=Ha80w9ZdaKWrfaMU9oiblJLjfJWY8AwFnT7rrU5qwyuraIHKP3kdx2K9vjH0UxJ0z8mq
	 5IieKID8muuSqLcM9TJr6H+6P/fHvz/6TL0C/xDPrUnXXYj23yJEo1GTPmIdq0l7B379i
	 1BnWl4QnHY3tvrQHfvIxZUAgpam7jXXP2ANINDxJPUuwVVkmdLL1Mt6KJn0t9K4gvzNKN
	 Kfkj7VRF6aLV6gIqGp4lHAgV7/G8HMOgu+oSZQa0aDPEAsTkTtHWVIxoQdpVgpWNy21Fa
	 aCv/qnE0C2t8NrfoaGpQknEXT3ERO55wFYF8KcFblp8KxQZGqLjFbyBWdxiCUoYwHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273400;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=YcUfhOIcpg650Hvcj/zlkedg1l4tly63KyQy0kdeMI4=;
	b=MyY1V07BuZBj2UqNTIbADKzYXUEB6mQa5OAmxPXee4IZrDBcwcZv1FbN5FGdKfsKcgJf
	 kavZU5D7yueogaOlmfNITDJclE3EsMBTrqs1WDoZbg+qGGEPIWd8F15YbDBqszmv+8+9w
	 KrQTSckNFr0sgaiQN9LAZDo+1kApa0DyxQw9vfWTHQO/OW3gHFG6AswpuJY1o8/EEXeUC
	 e6TLceHf35B9b6VneJZRPUP3Ok8aZvwBVCKyhsuCTgq7xy7ko6kqL9giOx0JgfwUvEBDF
	 dc1zbNdbQQGkltRPX+bDX7u4E3FRwexSlzePHTfKV2mG/+AVj1hW8MW2YAzcEZ3nvhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cPk2XdNX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CAB71606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAB71606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cPk2XdNX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794273397;
	bh=YcUfhOIcpg650Hvcj/zlkedg1l4tly63KyQy0kdeMI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPk2XdNX6csL2vf2GYW1a55kwhIQigjQApl0P7G6tpLPaKqRfTls0PomeoG/HSiSi
	 x1lxGXHzMNscdC6Lu6OKwmYhsD3zGMqqngI/aJd/OladHUmYarcB9+KC0B7FgB0AME
	 6/boz51zXCxYhTNBXZxjeBShYqJ3gfWcvp9vh6lVzVDnFnP4CBntVo0i3cI92BKolI
	 8qcPJ9WQnAMfxrnZzEJvV/Jve7spTpbBDy5AS/BiNJQNfFOPuNovNlH6xx8BdHcbFS
	 bm76TKWCtYzsezkROXrMaoiCneHSybMJIMwW7rNb/EruRc+FD8FvYd+UIlWcUGv14V
	 3JlUK09DHNtgQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5D23560077;
	Tue, 10 Nov 2026 02:16:37 +0100 (CET)
Date: Tue, 10 Nov 2026 02:16:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nf_conntrack: limit expectation master
 chain depth
Message-ID: <avJwc2cVpp6-4wln@chamomile>
References: <20261103131849.25702-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103131849.25702-1-fw@strlen.de>

Hi Florian,

On Tue, Nov 03, 2026 at 02:18:49PM +0100, Florian Westphal wrote:
> A conntrack can point to a master conntrack, which itself may point to
> another master, and so on.  There is currently no bound on how deep this
> chain can grow.
> 
> Force a max depth in nf_ct_expect_alloc(): walk the master chain and
> reject allocation if it would exceed 2 levels of nesting.
> 
> Also add ctnetlink_find_get_master and use it so that ctnetlink create
> paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
> and returning a misleading -ENOMEM.
> 
> This prevents unbounded ct->master->master->... chains.

Would you post a v3 so there is a chance to pick it up again?

Thanks!

> Reported-by: Daehyeon Ko <4ncienth@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  V2: add a ":" in kdoc comment
> 
>  include/net/netfilter/nf_conntrack_helper.h | 15 +++++++++
>  net/netfilter/nf_conntrack_expect.c         | 15 +++++++--
>  net/netfilter/nf_conntrack_netlink.c        | 36 +++++++++++++++------
>  3 files changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 335b8c43694f..617178fd4d8b 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -29,6 +29,8 @@ enum nf_ct_helper_flags {
>  
>  #define NF_CT_HELPER_NAME_LEN	16
>  
> +#define NF_CT_MAX_EXPECT_CHAIN_LEN	2
> +
>  /* Must be kept in sync with the classes defined by helpers */
>  #define NF_CT_MAX_EXPECT_CLASSES	4
>  
> @@ -159,6 +161,19 @@ static inline void nf_ct_help_put(const struct nf_conn *ct)
>  		kfree_rcu(helper, rcu);
>  }
>  
> +static inline bool nf_ct_master_acceptable(const struct nf_conn *m)
> +{
> +	unsigned int depth = 0;
> +
> +	while (m->master) {
> +		if (++depth >= NF_CT_MAX_EXPECT_CHAIN_LEN)
> +			return false;
> +		m = m->master;
> +	}
> +
> +	return true;
> +}
> +
>  int nf_conntrack_helper_init(void);
>  void nf_conntrack_helper_fini(void);
>  
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 06242c86e1dc..62e434cd57c9 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -299,13 +299,22 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
>  
> -/* We don't increase the master conntrack refcount for non-fulfilled
> - * conntracks. During the conntrack destruction, the expectations are
> - * always killed before the conntrack itself */
> +/**
> + * nf_ct_expect_alloc - allocate a new conntrack expectation
> + * @me: The conntrack to be used as master.
> + *
> + * The master conntrack refcount is not incremented; expectations
> + * are always killed before the master conntrack is destroyed.
> + *
> + * Return: a new expectation on success or NULL on failure.
> + */
>  struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
>  {
>  	struct nf_conntrack_expect *new;
>  
> +	if (!nf_ct_master_acceptable(me))
> +		return NULL;
> +
>  	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
>  	if (!new)
>  		return NULL;
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1f8d94a05240..30428d520e43 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2231,6 +2231,26 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
>  	return 0;
>  }
>  
> +static struct nf_conn *
> +ctnetlink_find_get_master(struct net *net, const struct nf_conntrack_zone *zone,
> +			  const struct nf_conntrack_tuple *tuple)
> +{
> +	struct nf_conntrack_tuple_hash *master_h;
> +	struct nf_conn *master_ct;
> +
> +	master_h = nf_conntrack_find_get(net, zone, tuple);
> +	if (!master_h)
> +		return ERR_PTR(-ENOENT);
> +
> +	master_ct = nf_ct_tuplehash_to_ctrack(master_h);
> +	if (!nf_ct_master_acceptable(master_ct)) {
> +		nf_ct_put(master_ct);
> +		return ERR_PTR(-EMLINK);
> +	}
> +
> +	return master_ct;
> +}
> +
>  static struct nf_conn *
>  ctnetlink_create_conntrack(struct net *net,
>  			   const struct nf_conntrack_zone *zone,
> @@ -2356,7 +2376,6 @@ ctnetlink_create_conntrack(struct net *net,
>  	/* setup master conntrack: this is a confirmed expectation */
>  	if (cda[CTA_TUPLE_MASTER]) {
>  		struct nf_conntrack_tuple master;
> -		struct nf_conntrack_tuple_hash *master_h;
>  		struct nf_conn *master_ct;
>  
>  		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_MASTER,
> @@ -2364,12 +2383,11 @@ ctnetlink_create_conntrack(struct net *net,
>  		if (err < 0)
>  			goto err2;
>  
> -		master_h = nf_conntrack_find_get(net, zone, &master);
> -		if (master_h == NULL) {
> -			err = -ENOENT;
> +		master_ct = ctnetlink_find_get_master(net, zone, &master);
> +		if (IS_ERR(master_ct)) {
> +			err = PTR_ERR(master_ct);
>  			goto err2;
>  		}
> -		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
>  		__set_bit(IPS_EXPECTED_BIT, &ct->status);
>  		ct->master = master_ct;
>  	}
> @@ -3613,7 +3631,6 @@ ctnetlink_create_expect(struct net *net,
>  			u_int8_t u3, u32 portid, int report)
>  {
>  	struct nf_conntrack_tuple tuple, mask, master_tuple;
> -	struct nf_conntrack_tuple_hash *h = NULL;
>  	struct nf_conntrack_expect *exp;
>  	struct nf_conn *ct;
>  	int err;
> @@ -3633,10 +3650,9 @@ ctnetlink_create_expect(struct net *net,
>  		return err;
>  
>  	/* Look for master conntrack of this expectation */
> -	h = nf_conntrack_find_get(net, zone, &master_tuple);
> -	if (!h)
> -		return -ENOENT;
> -	ct = nf_ct_tuplehash_to_ctrack(h);
> +	ct = ctnetlink_find_get_master(net, zone, &master_tuple);
> +	if (IS_ERR(ct))
> +		return PTR_ERR(ct);
>  
>  	rcu_read_lock();
>  	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
> -- 
> 2.56.0
> 
> 
