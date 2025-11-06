Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2813B284
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762393189; cv=none; b=d2uvllZU1eUfoXGQouyklAnPTIDCsNyrSWIJkfMlq9lphkSkC3jYTNitGYQcpeWaMeN7e7F8F7bRqVUeXWQbSP6nSAUzpMs/W8eYua2ZACpnDnvnX7m5I94dTd0QBHNmkD+nAq31bVckv7pGMd7unCYSAz47dkzDv6uh+QXnQso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762393189; c=relaxed/simple;
	bh=ZtsLFkZia/oMZALrQQVSIxqq44NUbSTZ0GScix5xnis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kir8jCnBrK/5jO0wnoxKVaRwBwj5EjT1+KnJgOpNSdJcsPV3PyeS1ZvMN66TtmChx/F8wkaQ1/7Fc3SJ3ydZ1HAJauVjZC5aP24DXZJXXbKzj2EfeSyJyKUe/OjKTwDwhp/0+t6egImOKErBtIX6qFu8zmpoOUKSKC0c0bTHl1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 37AA3602E2; Thu,  6 Nov 2025 02:39:44 +0100 (CET)
Date: Thu, 6 Nov 2025 02:39:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, aconole@redhat.com,
	echaudro@redhat.com, i.maximets@ovn.org, dev@openvswitch.org
Subject: Re: [PATCH 1/3 nf-next] netfilter: nf_conncount: only track
 connection if it is not confirmed
Message-ID: <aQv8YE3sZ1Rp1iYG@strlen.de>
References: <20251106005557.3849-1-fmancera@suse.de>
 <20251106005557.3849-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106005557.3849-2-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Since commit d265929930e2 ("netfilter: nf_conncount: reduce unnecessary
> GC") if nftables/iptables connlimit is used without a check for new
> connections there can be duplicated entries tracked.
> 
> Pass the nf_conn struct directly to the nf_conncount API and check
> whether the connection is confirmed or not inside nf_conncount_add(). If
> the connection is confirmed, skip it.

I think there is a bit too much noise here, can this be
split in several chunks?

> -unsigned int nf_conncount_count(struct net *net,
> +unsigned int nf_conncount_count(struct net *net, const struct nf_conn *ct,
>  				struct nf_conncount_data *data,
> -				const u32 *key,
> -				const struct nf_conntrack_tuple *tuple,
> -				const struct nf_conntrack_zone *zone);
> +				const u32 *key);

nf_conn *ct has pitfalls that I did not realize earlier.
Current code is also buggy in that regard.
Maybe we need additional function to ease this for callers.

See below.
> +static int __nf_conncount_add(const struct nf_conn *ct,
> +			      struct nf_conncount_list *list)
>  {
>  	const struct nf_conntrack_tuple_hash *found;
>  	struct nf_conncount_tuple *conn, *conn_n;
> +	const struct nf_conntrack_tuple *tuple;
> +	const struct nf_conntrack_zone *zone;
>  	struct nf_conn *found_ct;
>  	unsigned int collect = 0;
>  
> +	if (!ct || nf_ct_is_confirmed(ct))
> +		return -EINVAL;
> +

When is the caller expected to pass a NULL ct?
Maybe this just misses a comment.

> index fc35a11cdca2..e815c0235b62 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c
> @@ -24,28 +24,35 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
>  					 const struct nft_pktinfo *pkt,
>  					 const struct nft_set_ext *ext)
>  {
> -	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
> -	const struct nf_conntrack_tuple *tuple_ptr;
> +	struct nf_conntrack_tuple_hash *h;
>  	struct nf_conntrack_tuple tuple;
>  	enum ip_conntrack_info ctinfo;
>  	const struct nf_conn *ct;
>  	unsigned int count;
> -
> -	tuple_ptr = &tuple;
> +	int err;
>  
>  	ct = nf_ct_get(pkt->skb, &ctinfo);
> -	if (ct != NULL) {
> -		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> -		zone = nf_ct_zone(ct);
> -	} else if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
> -				      nft_pf(pkt), nft_net(pkt), &tuple)) {
> -		regs->verdict.code = NF_DROP;
> -		return;
> +	if (!ct) {
> +		if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
> +				       nft_pf(pkt), nft_net(pkt), &tuple)) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}
> +
> +		h = nf_conntrack_find_get(nft_net(pkt), &nf_ct_zone_dflt, &tuple);
> +		if (!h) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}
> +		ct = nf_ct_tuplehash_to_ctrack(h);

This ct had its refcount incremented.

I also see that this shared copypaste with xtables.
Would it be possible to pass 'const struct sk_buff *'
and let the nf_conncount core handle this internally?

nf_conncount_add(net, pf, skb, priv->list);

which does:
	ct = nf_ct_get(skb, &ctinfo);
	if (ct && !nf_ct_is_template(ct))
		return __nf_conncount_add(ct, list);

	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), pf, net,
				&tuple))
		return -ERR;

	if (ct)	/* its a template, so do lookup in right zone */
		zone = nf_ct_zone(ct);
	else
		zone = &nf_ct_zone_dflt;

	h = nf_conntrack_find_get(nft_net(pkt), zone, &tuple);
	if (!h)
		return -ERR;

	ct = nf_ct_tuplehash_to_ctrack(h);

	err = __nf_conncount_add(ct, list);

	nf_ct_put(ct):

	return err;

I.e., the existing nf_conncount_add() becomes a helper that takes
a ct, as you have already proposed, but its renamed and turned into
an internal helper so frontends don't need to duplicate tuple lookup.

Alternatively, no need to rename it and instead add a new API call
that takes the ct argument, e.g. 'nf_conncount_add_ct' or whatever,
and then make nf_conncount_add() internal in a followup patch.

> +		h = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);

We should not restrict the lookup to the default zone,
but we should follow what the template (if any) says.

I under-estimated the work to get this right, I think this is too much
code to copypaste between nft+xt frontends.  Sorry for making that
suggestion originally.
