Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9769F1A0BDA
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725356660; cv=none; b=Y7WJstmqaTYkvFKNcuac/VSi8DG18eaagVs3ZVL2F43seZYW0riW2MFRORpg4Bsrzxml5OpVjZeaeSZw8whDSip+BYyHZFBIqNP4X6i4xc+bbprDNgaj2YsQpqo4LqZhwuLJvGilCKVjLqkETlPFwdMwcUPTffZ+2x4ABkXEbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725356660; c=relaxed/simple;
	bh=WmKPv/6QYJjfqgO0dZG0Bk3NoY47L1xt54DiTmwIu5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUNtO4oJQKfF2HFDsI7djttt/fNT9ZcdluRZXCA7YpsG9VIqzqcsSKns4G4Cw4Lg6w7TOua9G48Jljv2DbjX0k2LIEKwEqVBGiLrgFGfUxT4UGL0GPBP680h1keWfvYvapn7pGuwKTX8jNnnJ6GzSBdZLYbq5gpbaToJSswzSkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GU0e0K69; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GU0e0K69"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mUiHkgbggxdkF1W8GbgcnGQ1rC6kzH43DuX7rTZVOnI=; b=GU0e0K69jgDcNrVhOc1TRfsfJu
	oxTdMvf8yRO0myynxKzrHwJ9NU65FL03AqPmi8Zxlomvc5lB4PoWoOGKrl7nFrBPxYGiLPFRTt6Sk
	U2PldsYD7bj313heUXiCCYLu4nbNrEzlsolP5Hu2H26f1n0PwAAPX1GKngTSWGVn5mayMjq+8V6Cz
	7Si9KRMG4VytK9uC3jmCLzgaXjgLiWctAPuLpxjc7LgDAEvEJ2ecGBZvxBEK2R4etHvFHeSbRGthr
	HT4hyDLRzM//pVnIrLDk8ySGVFJFTVY+T/reBNq+CyEuUQ5ujaCKCuOHZAr4MvcZgRtGxJJPoc0WN
	fPoJLiMw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1slQ53-000000000St-3BwW;
	Tue, 03 Sep 2024 11:44:09 +0200
Date: Tue, 3 Sep 2024 11:44:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 8/9] netfilter: nf_tables: zero timeout means
 element never times out
Message-ID: <ZtbaaZtN_gyXQOWW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20240902231726.171964-1-pablo@netfilter.org>
 <20240902231726.171964-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902231726.171964-8-pablo@netfilter.org>

On Tue, Sep 03, 2024 at 01:17:25AM +0200, Pablo Neira Ayuso wrote:
> This patch uses zero as timeout marker for those elements that never expire
> when the element is created.
> 
> If userspace provides no timeout for an element, then the default set
> timeout applies. However, if no default set timeout is specified and
> timeout flag is set on, then timeout extension is allocated and timeout
> is set to zero to allow for future updates.
> 
> Use of zero a never timeout marker has been suggested by Phil Sutter.
> 
> Note that, in older kernels, it is already possible to define elements
> that never expire by declaring a set with the set timeout flag set on
> and no global set timeout, in this case, new element with no explicit
> timeout never expire do not allocate the timeout extension, hence, they
> never expire. This approach makes it complicated to accomodate element
> timeout update, because element extensions do not support reallocations.
> Therefore, allocate the timeout extension and use the new marker for
> this case, but do not expose it to userspace to retain backward
> compatibility in the set listing.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: use zero timeout as marker for timeout never expires, as per Phil.
> 
>  include/net/netfilter/nf_tables.h        |  7 ++-
>  include/uapi/linux/netfilter/nf_tables.h |  2 +-
>  net/netfilter/nf_tables_api.c            | 57 +++++++++++++++---------
>  net/netfilter/nft_dynset.c               |  3 +-
>  4 files changed, 45 insertions(+), 24 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index a950a1f932bf..ef421c6bb715 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -828,8 +828,11 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
>  static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
>  					  u64 tstamp)
>  {
> -	return nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
> -	       time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
> +	if (!nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) ||
> +	    nft_set_ext_timeout(ext)->timeout == 0)
> +		return false;
> +
> +	return time_after_eq64(tstamp, READ_ONCE(nft_set_ext_timeout(ext)->expiration));
>  }
>  
>  static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 639894ed1b97..d6476ca5d7a6 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -436,7 +436,7 @@ enum nft_set_elem_flags {
>   * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
>   * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
>   * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
> - * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
> + * @NFTA_SET_ELEM_TIMEOUT: timeout value, zero means never times out (NLA_U64)
>   * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
>   * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
>   * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 4cf2162b0d07..4bba454eee4c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4582,6 +4582,10 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
>  	u64 ms = be64_to_cpu(nla_get_be64(nla));
>  	u64 max = (u64)(~((u64)0));
>  
> +	/* Zero timeout no allowed here. */
> +	if (ms == 0)
> +		return -ERANGE;
> +

This is not necessary, I think: The sanitization added in patch 1 makes
the function set result to 0 if ms == 0.

>  	max = div_u64(max, NSEC_PER_MSEC);
>  	if (ms >= max)
>  		return -ERANGE;
> @@ -5809,24 +5813,33 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
>  		goto nla_put_failure;
>  
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
> -		u64 expires, now = get_jiffies_64();
> +		u64 timeout = nft_set_ext_timeout(ext)->timeout;
> +		u64 set_timeout = READ_ONCE(set->timeout);
> +		__be64 msecs = 0;
>  
> -		if (nft_set_ext_timeout(ext)->timeout != READ_ONCE(set->timeout) &&
> -		    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
> -				 nf_jiffies64_to_msecs(nft_set_ext_timeout(ext)->timeout),
> -				 NFTA_SET_ELEM_PAD))
> -			goto nla_put_failure;
> +		if (set_timeout != timeout) {
> +			if (timeout)
> +				msecs = nf_jiffies64_to_msecs(timeout);

nf_jiffies64_to_msecs(0) == 0, right? So one may drop the 'if (timeout)'
clause.

>  
> -		expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
> -		if (time_before64(now, expires))
> -			expires -= now;
> -		else
> -			expires = 0;
> +			if (nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT, msecs,
> +					 NFTA_SET_ELEM_PAD))
> +				goto nla_put_failure;
> +		}
>  
> -		if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
> -				 nf_jiffies64_to_msecs(expires),
> -				 NFTA_SET_ELEM_PAD))
> -			goto nla_put_failure;
> +		if (timeout > 0) {
> +			u64 expires, now = get_jiffies_64();
> +
> +			expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
> +			if (time_before64(now, expires))
> +				expires -= now;
> +			else
> +				expires = 0;
> +
> +			if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
> +					 nf_jiffies64_to_msecs(expires),
> +					 NFTA_SET_ELEM_PAD))
> +				goto nla_put_failure;
> +		}
>  	}
>  
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
> @@ -6901,10 +6914,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
>  		if (!(set->flags & NFT_SET_TIMEOUT))
>  			return -EINVAL;
> -		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_TIMEOUT],
> -					    &timeout);
> -		if (err)
> -			return err;
> +
> +		timeout = be64_to_cpu(nla_get_be64(nla[NFTA_SET_ELEM_TIMEOUT]));
> +		if (timeout != 0) {
> +			err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_TIMEOUT],
> +						    &timeout);
> +			if (err)
> +				return err;
> +		}

Acknowledging that nf_msecs_to_jiffies64() outputs 0 (successfully) for
0 input, this folds down to:

|		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_TIMEOUT],
|					    &timeout);
|		if (err)
|			return err;

Cheers, Phil

>  	} else if (set->flags & NFT_SET_TIMEOUT &&
>  		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
>  		timeout = set->timeout;
> @@ -7009,7 +7026,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  			goto err_parse_key_end;
>  	}
>  
> -	if (timeout > 0) {
> +	if (set->flags & NFT_SET_TIMEOUT) {
>  		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
>  		if (err < 0)
>  			goto err_parse_key_end;
> diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> index 88ea2454c6df..e250183df713 100644
> --- a/net/netfilter/nft_dynset.c
> +++ b/net/netfilter/nft_dynset.c
> @@ -94,7 +94,8 @@ void nft_dynset_eval(const struct nft_expr *expr,
>  	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
>  			     expr, regs, &ext)) {
>  		if (priv->op == NFT_DYNSET_OP_UPDATE &&
> -		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
> +		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
> +		    nft_set_ext_timeout(ext)->timeout != 0) {
>  			timeout = priv->timeout ? : READ_ONCE(set->timeout);
>  			WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + timeout);
>  		}
> -- 
> 2.30.2
> 
> 
