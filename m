Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E0736EAAC
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786274708; cv=none; b=QPGvIBt2OBg17mX3bOlAumNvglpJlt7sv5l4ipjJKtokP4aSvHrw0i3eGV68kvyMhBpC0D560OPyO8qS6dmNYv1fPoO7WoVyKxOWY10ThIisRULe8/HHRdS4F7G9VZt0vJe0rUZKRC/O9lAbB2XfTZGXmHYOslqwn/ZkL0wUiXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786274708; c=relaxed/simple;
	bh=12pFZ5y8RWGwyQwZ6xToI/0KAl5eQS6yJxuis/D34aQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SF1zsa+A8RtRqeNNmpk1BNuIFumQhpkbdqKewklnZ6BoLbzwUm3FeuMFnQDtLAgO2YzUvmrHlMB70fnLfz6eJHZw1dn8X1/ButfF4ptVmUHzQKdj5NCBP5vG9L7z/nYGY49seIXX+Uz7fR60/Mjoc4mrtmY52PBQT29Hn8zeDKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4hHwK60CNgz7s7wb;
	Sun, 09 Aug 2026 13:15:06 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Jru4wB1q8lYd; Sun,  9 Aug 2026 13:15:04 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4hHwK40CWlz7s7wY;
	Sun, 09 Aug 2026 13:15:03 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id D5F99140E07; Sun,  9 Aug 2026 13:15:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id D4A4814015A;
	Sun,  9 Aug 2026 13:15:03 +0200 (CEST)
Date: Sun, 9 Aug 2026 13:15:03 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: remove need to allocate memory on
 delete operations
In-Reply-To: <20260804170214.27237-1-fw@strlen.de>
Message-ID: <abb4fda6-444f-2c79-573a-740529e468c9@netfilter.org>
References: <20260804170214.27237-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Tue, 4 Aug 2026, Florian Westphal wrote:

> Allocating mem via GFP_ATOMIC on delete is problematic, delete operations
> should always succedd.
> 
> Do in-place substitution:  When /cidr reaches 0 count (no more elements
> in the range), move ranges stores later in the array forward and keep
> the count 0 ones at the end.
> 
> INIT_CIDR() can then check count == 0 without a need to search
> next element in the array.
> 
> To avoid problems on weakly ordered architectures, pack the structure
> so it is only 32bit wide, then use READ/WRITE_ONCE to store both cidr
> and count atomically.
> 
> _add path is unchanged: like the del path it acquires set->lock, i.e.
> we are only writer.
> 
> Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Won't apply, this is supposed to go on top of the pending
>  nf PR.  In case that PR needs a v2, this could be squashed.
> 
>  net/netfilter/ipset/ip_set_hash_gen.h | 71 ++++++++++++++++-----------
>  1 file changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 784e6d4a00ea..b2089ff6f1dc 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -101,9 +101,10 @@ struct htable {
>  
>  /* Book-keeping of the prefixes added to the set */
>  struct net_prefix {
> -	u8 cidr;			/* the cidr value */
> -	u32 count;			/* number of elements of this cidr */
> +	u32 cidr:8;
> +	u32 count:24;
>  };
> +#define CIDR_MAX_COUNT ((1 << 24) - 1)

Could it be changed to

struct net_prefix {
     u64 cidr:8;
     u64 count:24;
};
#define CIDR_MAX_COUNT ((1 << 56) - 1)

(and the other required changes below)?

2**24 is a lot but still a reachable limit.
 
>  struct net_prefixes {
>  	struct rcu_head rcu;
> @@ -144,8 +145,11 @@ htable_size(u8 hbits)
>  #endif
>  
>  #define INIT_CIDR(n, host_mask) ({				\
> -	const struct net_prefixes *__n = rcu_dereference(n);		\
> -	DCIDR_PUT((__n)->len ? (__n)->nets[0].cidr : host_mask);\
> +	const struct net_prefixes *__n = rcu_dereference(n);	\
> +	struct net_prefix __p =					\
> +		__n->len ? READ_ONCE(__n->nets[0])		\
> +			 : (struct net_prefix){};		\
> +	DCIDR_PUT(__p.count ? __p.cidr : host_mask);		\
>  })
>  
>  #endif /* IP_SET_HASH_WITH_NETS */
> @@ -436,7 +440,10 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  		} else if (nets->nets[i].cidr < cidr) {
>  			found = i;
>  		} else if (nets->nets[i].cidr == cidr) {
> -			nets->nets[i].count++;
> +			if (nets->nets[i].count < CIDR_MAX_COUNT)
> +				nets->nets[i].count++;
> +			else
> +				ret = -EOVERFLOW;
>  			goto unlock;
>  		}
>  	}
> @@ -472,39 +479,43 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  static void
>  mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  {
> -	struct net_prefixes *nets, *tmp;
> -	u8 i, j, len = 0;
> +	struct net_prefixes *nets;
> +	struct net_prefix np;
>  	int found;
> +	u8 i, j;
> +
> +	BUILD_BUG_ON(sizeof(struct net_prefix) != sizeof(u32));
>  
>  	spin_lock_bh(&set->lock);
>  	nets = __ipset_dereference(h->rnets[n]);
>  	for (i = 0, found = -1; i < nets->len; i++) {
> -		if (nets->nets[i].count)
> -			len++;
> -		if (nets->nets[i].cidr == cidr)
> +		np = READ_ONCE(nets->nets[i]);
> +		if (np.count && np.cidr == cidr) {
> +			np.count--;
>  			found = i;
> +			break;
> +		}
>  	}
>  	if (unlikely(found == -1))
>  		goto unlock;
>  
> -	nets->nets[found].count--;
> -	if (nets->nets[found].count)
> -		goto unlock;
> -	len--;
> -	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
> -	if (!tmp)
> -		/* Leave a hole */
> +	if (np.count) {
> +		WRITE_ONCE(nets->nets[found], np);
>  		goto unlock;
> +	}
>  
> -	tmp->len = len;
>  	for (i = 0, j = 0; i < nets->len; i++) {
> -		if (!nets->nets[i].count || i == found)
> +		if (i == found)
>  			continue;
> -		tmp->nets[j].cidr = nets->nets[i].cidr;
> -		tmp->nets[j++].count = nets->nets[i].count;
> +
> +		np = READ_ONCE(nets->nets[i]);
> +		if (i != j)
> +			WRITE_ONCE(nets->nets[j], np);
> +		j++;
>  	}
> -	rcu_assign_pointer(h->rnets[n], tmp);
> -	kfree_rcu(nets, rcu);
> +
> +	while (j < nets->len)
> +		WRITE_ONCE(nets->nets[j++], (struct net_prefix){});
>  unlock:
>  	spin_unlock_bh(&set->lock);
>  }
> @@ -1381,17 +1392,21 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  	nets1 = rcu_dereference_bh(h->rnets[1]);
>  #endif
>  	for (j = 0; j < nets0->len && !multi; j++) {
> -		if (!nets0->nets[j].count)
> +		struct net_prefix p0 = READ_ONCE(nets0->nets[j]);
> +
> +		if (!p0.count)
>  			continue;
>  #if IPSET_NET_COUNT == 2
>  		mtype_data_reset_elem(d, &orig);
> -		mtype_data_netmask(d, nets0->nets[j].cidr, false);
> +		mtype_data_netmask(d, p0.cidr, false);
>  		for (k = 0; k < nets1->len && !multi; k++) {
> -			if (!nets1->nets[k].count)
> +			struct net_prefix p1 = READ_ONCE(nets1->nets[k]);
> +
> +			if (!p1.count)
>  				continue;
> -			mtype_data_netmask(d, nets1->nets[k].cidr, true);
> +			mtype_data_netmask(d, p1.cidr, true);
>  #else
> -		mtype_data_netmask(d, nets0->nets[j].cidr);
> +		mtype_data_netmask(d, p0.cidr);
>  #endif
>  		key = HKEY(d, h->initval, t->htable_bits);
>  		n = rcu_dereference_bh(hbucket(t, key));
> -- 

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
