Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECECD125AC
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560121; cv=none; b=ceJyn6/Ru6afQ1f1B91b4x5PMBMid59KGPSU9RaOhGy2X7JAL/suS4Jdz98p4jCTEhagMf2xaWWCmLdFYtfHT0h5vMFmDoiy5gSGtSFS42nN2MK6W8R//quRPUUQzaa2/0+H/vYkYtMq/Ngy6/qkf85n+8JK0y7/VfKurxf2+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560121; c=relaxed/simple;
	bh=tcpslhVEL19sPud/Jqm2VepfPe7OQD0+L/VxP1MSpx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkUHw0kHzqDRkI+Fb5l4ofqQ2pqnXuYWAdIzgCFH3NrNKrml/paAlZE7nhea7n0TBsuhC2aEjqFWDsBsGcWxPlyY8unxjWYQowf+XbpQKB3PxTXbp/1JgvprYZ2Ivv9bidquNQoDDLv9+Scp+nrCSCzE3dwXfykNNS++m8ruz0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Iur3TfYi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Iur3TfYi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0Yf8LYvPVNDFjosErW3nfQYy8IRcI/Hw3316aHt4acg=; b=Iur3TfYiLG8YBkdHdxJPurdWXp
	G8+MefnfcU9NfHCecwypVuetiCmxOlNX4gE8YZjvj/Ih0mrU0RU2Sqo9Sr0D1HgHPA/edybavVXMk
	PG7Ba8CMmojqqvx1lW2dzoqyNMXIIwhfiwhgeTeIyl/HL1UPOM11mfkG5AiFCRw1wZpqAfAzbGaK1
	AdTnZIfQztMNOj9bLxwA/Lq6vxOhHibgI1k57nh6lGuKoQDA8/RoKOKYKzfz86h4e4ApJedTHTjfq
	XaIzWnH9MsDS+6Gz1SHBpIES6wH2n3Csq0MRY31yXIGif308Zuu2SM7yId5SVYdTBQX5NSnNHWyJX
	YL6TvL9Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sdsij-000000002oT-0bMp;
	Tue, 13 Aug 2024 16:41:57 +0200
Date: Tue, 13 Aug 2024 16:41:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/8] netfilter: nf_tables: reject element
 expiration with no timeout
Message-ID: <Zrtwtb1uxzLmnqEZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807142357.90493-3-pablo@netfilter.org>

On Wed, Aug 07, 2024 at 04:23:51PM +0200, Pablo Neira Ayuso wrote:
> If element timeout is unset and set provides no default timeout, the
> element expiration is silently ignored, reject this instead to let user
> know this is unsupported.
> 
> While at it, remove unnecesary notation to read default set timeout
> under mutex.

The sentence above is a left-over from splitting patches, right?

> Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0fb8f8f1ef66..79ab90069b84 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6920,6 +6920,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
>  		if (!(set->flags & NFT_SET_TIMEOUT))
>  			return -EINVAL;
> +		if (timeout == 0)
> +			return -EOPNOTSUPP;
> +
>  		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
>  					    &expiration);
>  		if (err)
> -- 
> 2.30.2
> 
> 
> 
