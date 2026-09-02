Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD801FC110
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 04:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788323552; cv=none; b=jx8f0ZDCcpJ5ax4R9F/VSrZjytRItCopb2CoQVavuoIdotC5eWNGZLTboTNNbEFSml8BUfTna2mMAPqEWp7LbfGrKXFcKoAfXF5CP5mSnXsRghbhhGWpccozZS/sjFZxswSKA4Ai7QELw8haYt+uNNwIoJ85d+bzOSHpaNtRic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788323552; c=relaxed/simple;
	bh=ag6wBx6EU6jpVF7fTQVV/XorcQjc/a5Dx3PiZH0js64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhMYu8179OXsL4615taJd1eyWD/Of8aEIhRYEaGYlh46DX+CrAZN1eWW4LpYxLMdEhMo9gd6baZEIM4UfRj6zZtI97MlyNrTLR896ara8zGHDXaOY7D/0Sz9eJY3eFkN+lH1r1Rn8SaUuHnfT67it/AuwMegSP8sIT/zZIpgnSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D689B60405; Wed, 02 Sep 2026 06:32:20 +0200 (CEST)
Date: Wed, 2 Sep 2026 06:32:20 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf v3 3/5] netfilter: ipset: replace internal hash table
 with rhashtable
Message-ID: <apem1I-sJWVSfMT8@strlen.de>
References: <20260828152256.8759-1-fw@strlen.de>
 <20260828152256.8759-4-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828152256.8759-4-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  v3:
>  serialize rhltable insertion with set->lock, else we can inject identical elements.
>  nit: also rename mtype_rht_size toke-replace
>  add kdoc comment to say that mtype_flush cannot guarantee set is empty
>  after flush (parallel re-add).
>  I ignored the LLM review wrt 'skipped elements' on set walks, with
>  parallel mutations (internal resizes, deletes) a stable walk would
>  require significantly more work, such as keeping elements on a
>  dedicated list.  It should be ok as-is.

[..]

> -/* Flush a hash type of set: destroy all elements */
> +/**
> + * mtype_flush() - Flush a hash set type by destroying all elements.
> + * @set: Pointer to the ip_set.
> + *
> + * Because other CPUs may concurrently insert new entries into the table
> + * while flush is in progress, there is no guarantee that the table will
> + * be empty upon return.
> + */
>  static void
>  mtype_flush(struct ip_set *set)
>  {
>  	struct htype *h = set->data;
> -#ifdef IP_SET_HASH_WITH_NETS
> -	struct net_prefixes *nets;
> -#endif
> -	struct htable *t;
> -	struct hbucket *n;
> -	u32 r, i;
> -
> -	t = ipset_dereference_nfnl(h->table);
> -	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
> -		spin_lock_bh(&t->hregion[r].lock);
> -		for (i = ahash_bucket_start(r, t->htable_bits);
> -		     i < ahash_bucket_end(r, t->htable_bits); i++) {
> -			n = __ipset_dereference(hbucket(t, i));
> -			if (!n)
> +	struct rhashtable_iter hti;
> +	struct mtype_rht_elem *e;
> +	unsigned int dropped;
> +
> +	ipset_hash_walk_enter(h, &hti);
> +restart:
> +	dropped = 0;
> +	rhashtable_walk_start(&hti);
> +
> +	while ((e = rhashtable_walk_next(&hti))) {
> +		if (IS_ERR(e)) {
> +			if (PTR_ERR(e) == -EAGAIN)
>  				continue;
> -			if (set->extensions & IPSET_EXT_DESTROY)
> -				mtype_ext_cleanup(set, n);
> -			/* FIXME: use slab cache */
> -			rcu_assign_pointer(hbucket(t, i), NULL);
> -			kfree_rcu(n, rcu);
> +			break;
> +		}
> +		if (ipset_hash_remove(h, e))
> +			continue; /* Concurrent delete? skip */
> +		mtype_del_cidr_all(set, h, &e->elem);
> +		ip_set_ext_destroy(set, &e->elem);
> +		kfree_rcu(e, rcu);
> +
> +		if (dropped++ > 128 && need_resched()) {
> +			rhashtable_walk_stop(&hti);
> +			cond_resched();
> +			goto restart;

As expected this triggers reject patterns in LLM.

I can go back to v1, which had no restart, which in turn triggered
'softirq lockup with large sets' reject patterns, but doesn't have
the "may skip elements" "problem".

Or we delay this while I work on an rhashtable_flush() that can
detach internal hash memory from the rhashtable set to avoid this.

I have no idea what the best course of action is here, but adding
an extra data structure (list for instance) is something I want to
avoid.

All other LLM comments were, as far as I could tell, hallucinations.
