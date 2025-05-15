Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8C296713
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 09:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747303028; cv=none; b=dOVJ6wqcFFggfE/3khl7tHyTU1co+g1IO3n9sBavWp8+FGIsVuuOcYywvPLdLfXslELiuccN+uZnZUh5MXwas9Bxt9tlYosf6CXHrv3VwMI2QEGtaMq4Zt2cP+jL7P944kSxK/eFKLkKfwaRaPRIK1h9vVi/hpvzBmkjavuYQQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747303028; c=relaxed/simple;
	bh=fVco0j7FAZTUe2vGqxt/teK6z6YeKVUzg7BGvINrRKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbpufR+PxZJ8e2IVRShRIg7oRdim2fQoo+lUT3dg/fEP9AlAItg3gTZvIgc2qS63jCmS6dHfewsyEKX6xKvsAb7Kr1AHvhoPlpaz3Ju1xPLnKpV9ehY9mDu1/S8Ggs/iGUg0tySVxyy+GTHRWMXgcUTVilcDqUcpqKEoMth0Ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XE3/xLIx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XE3/xLIx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sHrj+tkaCXCVCxQ6rISdEyRs6l15jf0IMWDlLSWywNU=; b=XE3/xLIxRgxvsJHHbBHVcEjN0B
	fPaS7CVnAe09D/NhtMVjJZlRF1pSpkfW2mGrvoC7d2epaJCNjIHgKJPe/OERP3gMxIWrOYdyir4lf
	1/9iezjz7ylRlfV6euVSlOhYHB9U4DR6eZormPzi+p3AvqghaZJocj0xBBbl9Q8JCi105Qtbl1H9F
	ojg48ze1wOaTVCgB7lonY6lWfXMwa8xa5PdCYBzqu/qk+RgvaHpWIbNRUVgAcIhB8fMCpl7LvGu3q
	LPdRc91PPC1T9Dte7K2B1OXOAWZJ0VUH14DyWSWXUWfEqizgoK5jxXjz3AnCimy1xEeuiFJRUeMzN
	M3S0ihWA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFVKj-000000005kW-20gC;
	Thu, 15 May 2025 11:56:57 +0200
Date: Thu, 15 May 2025 11:56:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 1/6] netfilter: nf_tables: honor EINTR in
 ruleset validation from commit/abort path
Message-ID: <aCW6abGEveAcF1q3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250514214216.828862-1-pablo@netfilter.org>
 <20250514214216.828862-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514214216.828862-2-pablo@netfilter.org>

On Wed, May 14, 2025 at 11:42:11PM +0200, Pablo Neira Ayuso wrote:
> Do not return EAGAIN to replay the transaction if table validation
> reports EINTR. Abort the transaction and report EINTR error instead.
> 
> Fixes: 169384fbe851 ("netfilter: nf_tables: allow loop termination for pending fatal signal")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index b28f6730e26d..d5de843ee773 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9885,6 +9885,7 @@ static int nf_tables_validate(struct net *net)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
>  	struct nft_table *table;
> +	int err;
>  
>  	list_for_each_entry(table, &nft_net->tables, list) {
>  		switch (table->validate_state) {
> @@ -9894,15 +9895,24 @@ static int nf_tables_validate(struct net *net)
>  			nft_validate_state_update(table, NFT_VALIDATE_DO);
>  			fallthrough;
>  		case NFT_VALIDATE_DO:
> -			if (nft_table_validate(net, table) < 0)
> -				return -EAGAIN;
> +			err = nft_table_validate(net, table);
> +			if (err < 0) {
> +				if (err == EINTR)

This should be -EINTR here, I guess.

Cheers, Phil

> +					goto err_eintr;
>  
> +				return -EAGAIN;
> +			}
>  			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
>  			break;
>  		}
>  	}
>  
>  	return 0;
> +err_eintr:
> +	list_for_each_entry(table, &nft_net->tables, list)
> +		nft_validate_state_update(table, NFT_VALIDATE_SKIP);
> +
> +	return -EINTR;
>  }
>  
>  /* a drop policy has to be deferred until all rules have been activated,
> @@ -10710,7 +10720,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  	}
>  
>  	/* 0. Validate ruleset, otherwise roll back for error reporting. */
> -	if (nf_tables_validate(net) < 0) {
> +	err = nf_tables_validate(net);
> +	if (err < 0) {
> +		if (err == -EINTR)
> +			return -EINTR;
> +
>  		nft_net->validate_state = NFT_VALIDATE_DO;
>  		return -EAGAIN;
>  	}
> @@ -11054,9 +11068,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  	};
>  	int err = 0;
>  
> -	if (action == NFNL_ABORT_VALIDATE &&
> -	    nf_tables_validate(net) < 0)
> -		err = -EAGAIN;
> +	if (action == NFNL_ABORT_VALIDATE) {
> +		err = nf_tables_validate(net);
> +		if (err < 0 && err != -EINTR)
> +			err = -EAGAIN;
> +	}
>  
>  	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
>  					 list) {
> -- 
> 2.30.2
> 
> 
> 
