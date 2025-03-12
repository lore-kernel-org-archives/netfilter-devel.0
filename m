Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA531CB501
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741798491; cv=none; b=ZT8ibPUcv8xgMhe9d6VKvKfmrPWPCGV5JraRRQw9m04guzc3vhZGbUDZHMQt0GbCy+MN0iFTUWPkzaWQ8a4kXmNFl2bsumxixG9iCbFm8V+wLuC47ns1dE811BayG2AMTmeND/bUw0WTIvzJMCUMJ9UEHeUQg6TBtchNBqvPIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741798491; c=relaxed/simple;
	bh=vZSyateFS+e1iETeIRpV7aKf0KTIhiP/2jQE6F7KEsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRC5g2I/LjeKt+ipuOi53YcvRXVEgwyTWJ05a8FD5oClzjvqqo8X3Z09z1dfhPiQwf/cv8ekptQnmpwlcZktLgK2HZYam76BmqGmdGR0DJqjK7LSlEOd1NL5yy1z1Pc6z/k5K6M0oYu0JuCV9iZ/7pwAXzlvgirPeUUvIofxwxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MzQaqE2V; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mptvZDfh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MzQaqE2V";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mptvZDfh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5185D60293; Wed, 12 Mar 2025 17:54:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741798481;
	bh=KZ5JqLSA+kDM/cREBJHbv3iNGijVSKgjHqGJ36VpQNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MzQaqE2V802RAr75cHQbb7HMGegppL1n5d2rTYLa/DpPyVMDRlcnrX49qFIzIQemL
	 0RXGRT6tBkZ9toT0IC4jYuMOhL96Kdh6b+B4wyXe1xrfrvQQn47hav+AuHBQ7XqpsA
	 CCKIdhq3ng67dPQZyV0QZytgnrL8y6mMfn/5dd4du/nluR9FWLhO8VM/MmViAozj0H
	 +98rJ2oRVYPMNXEBZ1tJR0TXXxHmUz7JNJUt5n/Zpfwbt0izW/tGq8JayMN7DQZiA4
	 vW22X/Dt0tKxdymVrnOn8//jNEWc+wuoyiyV186mK/NSjTR60hnPp+XlHaAHnRX4JM
	 9tkEsXtarNenw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 728B560293;
	Wed, 12 Mar 2025 17:54:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741798480;
	bh=KZ5JqLSA+kDM/cREBJHbv3iNGijVSKgjHqGJ36VpQNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mptvZDfhSNV4Hh0aRB1sjYzxFCxQlMvm2GkGseXcZESql8j+RtdYxn5ha7mtYekHB
	 3FEPqllHXL/lmaD6XQ3cGd5l+8J8v2GvbrJgtarkkSzYqRRfxIfGwfN9aZE0wXAmDM
	 bV6GXngqKkb2nZqkvT96obJr4R369a6YyjBDl6PrejdIU+ZI47pSzUEMrr/rcc0yMc
	 BDN4iV89VraPSpbqeGEYXRwyJb2KYFONUmUYS1LrZJuasGJGGAUBDhuSMS641/FXM1
	 W3hugLpyCn3LFZxlXrEPJn0BHMFcP2WWY6x+aBvieUUVupSmOsUSIxZA8aU+9Vz3cH
	 olQK/2rxgk+Jw==
Date: Wed, 12 Mar 2025 17:54:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: speed up reads from
 nf_conntrack proc file
Message-ID: <Z9G8TcHOTdn7LBsj@calendula>
References: <20250211130313.31433-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250211130313.31433-1-fw@strlen.de>

Hi Florian,

a few comments below.

On Tue, Feb 11, 2025 at 02:03:06PM +0100, Florian Westphal wrote:
> Dumping all conntrack entries via proc interface can take hours due to
> linear search to skip entries dumped so far in each cycle.
> 
> Apply same strategy used to speed up ipvs proc reading done in
> commit 178883fd039d ("ipvs: speed up reads from ip_vs_conn proc file")
> to nf_conntrack.
> 
> Note that the ctnetlink interface doesn't suffer from this problem.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_standalone.c | 73 +++++++++++++------------
>  1 file changed, 38 insertions(+), 35 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 502cf10aab41..2a79e690470a 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -98,51 +98,34 @@ struct ct_iter_state {
>  	struct seq_net_private p;
>  	struct hlist_nulls_head *hash;
>  	unsigned int htable_size;
> +	unsigned int skip_elems;
>  	unsigned int bucket;
>  	u_int64_t time_now;
>  };
>  
> -static struct hlist_nulls_node *ct_get_first(struct seq_file *seq)
> +static struct nf_conntrack_tuple_hash *ct_get_next(struct ct_iter_state *st)
>  {
> -	struct ct_iter_state *st = seq->private;
> +	struct nf_conntrack_tuple_hash *h;
>  	struct hlist_nulls_node *n;
> +	unsigned int i;
>  
> -	for (st->bucket = 0;
> -	     st->bucket < st->htable_size;
> -	     st->bucket++) {
> -		n = rcu_dereference(
> -			hlist_nulls_first_rcu(&st->hash[st->bucket]));
> -		if (!is_a_nulls(n))
> -			return n;
> -	}
> -	return NULL;
> -}
> +	for (i = st->bucket; i < st->htable_size; i++) {
> +		unsigned int skip = 0;
>  
> -static struct hlist_nulls_node *ct_get_next(struct seq_file *seq,
> -				      struct hlist_nulls_node *head)
> -{
> -	struct ct_iter_state *st = seq->private;
> +		hlist_nulls_for_each_entry(h, n, &st->hash[i], hnnode) {

                hlist_nulls_for_each_entry_rcu ?

> +			if (skip >= st->skip_elems) {
> +				st->bucket = i;
> +				return h;
> +			}
>  
> -	head = rcu_dereference(hlist_nulls_next_rcu(head));
> -	while (is_a_nulls(head)) {
> -		if (likely(get_nulls_value(head) == st->bucket)) {
> -			if (++st->bucket >= st->htable_size)
> -				return NULL;
> +			++skip;
>  		}
> -		head = rcu_dereference(
> -			hlist_nulls_first_rcu(&st->hash[st->bucket]));

This does not rewind if get_nulls_value(head) != st->bucket),
not needed anymore?

> -	}
> -	return head;
> -}
>  
> -static struct hlist_nulls_node *ct_get_idx(struct seq_file *seq, loff_t pos)
> -{
> -	struct hlist_nulls_node *head = ct_get_first(seq);
> +		st->skip_elems = 0;
> +	}
>  
> -	if (head)
> -		while (pos && (head = ct_get_next(seq, head)))
> -			pos--;
> -	return pos ? NULL : head;
> +	st->bucket = i;
> +	return NULL;
>  }
>  
>  static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
> @@ -154,13 +137,33 @@ static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
>  	rcu_read_lock();
>  
>  	nf_conntrack_get_ht(&st->hash, &st->htable_size);
> -	return ct_get_idx(seq, *pos);
> +
> +	if (*pos == 0) {
> +		st->skip_elems = 0;
> +		st->bucket = 0;
> +	}
> +
> +	return ct_get_next(st);
>  }
>  
>  static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
>  {
> +	struct nf_conntrack_tuple_hash *h = v;
> +	struct ct_iter_state *st = s->private;
> +	struct hlist_nulls_node *n;
> +
>  	(*pos)++;
> -	return ct_get_next(s, v);
> +
> +	/* more on same hash chain? */
> +	n = rcu_dereference(hlist_nulls_next_rcu(&h->hnnode));
> +	if (n && !is_a_nulls(n)) {
> +		st->skip_elems++;
> +		return hlist_nulls_entry(n, struct nf_conntrack_tuple_hash, hnnode);
> +	}
> +
> +	st->skip_elems = 0;
> +	st->bucket++;
> +	return ct_get_next(st);
>  }
>  
>  static void ct_seq_stop(struct seq_file *s, void *v)
> -- 
> 2.45.3
> 
> 
