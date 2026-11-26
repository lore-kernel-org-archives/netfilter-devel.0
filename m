Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795653994;
	b=OJeNmLCsIZBbTi5Gp3ohcTnHyBL0c/RFbO3I/pSideQqcDnQf+TZFUv2zc+Rr/AL/Tws
	 NscJ+lulqIFk4TW41L9YIACsy48uL8t4Yl0B3KNkYwCIKhssGdoeq7KkqqVygk4p4PPsw
	 vEDhwIBnkKF0Nlx+OmjJW/Vb+e9Fae7eVegGsybN+fWwpfWzcSpMWeER6dQun3vKDBBjc
	 98F41tLveH6mwXQ6s2x5TJMZz5lzOeRnrVobIonB9jp2zIH0PHjJJqj5M5XKCXSkNFR/Z
	 XH3ZWbsKo7pdPL/nF7IpcD0wMW0mT1jGNJ8T6AfDacvFLecLAsSMry3sFDE/Aj5wyoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795653994;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=cHuMljsdgpY/oo3u3axM4HlD/5jgiqU3cgnHwAtQXnE=;
	b=XtcPCf3UjPnnvj8FPohXH1K46i1EoVrtxK1dwpZhsq+9gLVw5BE8lETUORp2A68kDsJa
	 zvdRF8MpRlaipbbHJx26ajryJdRrbGPMD1Dy7+h9CCz10o33NvKb/UXyJ3RVi26xIEJEj
	 siwH6BVXve8ho/7NRU3rgYXv5eolOg6+bvZ0enrgkGt9lM+p2aUIN9KKfKh9TUPEtwoOA
	 xZL/Bn7RTXDPK2hNxq1SBshvoABTCjUj80lGarTgep880Ir3MtCUv8QfSxHEZCLWT7DxH
	 gHRAbSwVHByw3NjiYq8O1QhACCmpcqRKSg2prI+XEZclj1qcTT2y8sDcWtXL9KVDm/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Y5cBjPSO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 040C6606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 00:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 040C6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Y5cBjPSO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795653992;
	bh=cHuMljsdgpY/oo3u3axM4HlD/5jgiqU3cgnHwAtQXnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5cBjPSOlRJdEO7BCQenyhQ/Jx4y7HOIutsHQyIIHk6cOJvDfZ3TrjQOAu/eeETT3
	 ZCFA3lL5Gb9SU+wWZ4McG9QaMp7Z2s0I9Ja9DZWD4TNUsU8USj0nqKS/7irCpoWF1o
	 AxvQq/2ea1O2uHrBk8o2nwTYdlN5hnWa8OOi+RQw9xEM6J+K4bsBLVlkcH1N9BT03G
	 TNmIg2QMeT1OktQrByYICnOpEf9pKvleZ+cT8sLC/7L8KjoGS0btKMLt8ARNgosBwh
	 OfxUHaadgfSGOHw/qv27vSTmlXxpPHu7IqUazfNeUMycnCuk18eBQu+Yt75mM667Wu
	 8pRLJuQPg2T2A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DBCB260056;
	Thu, 26 Nov 2026 01:46:31 +0100 (CET)
Date: Thu, 26 Nov 2026 01:46:28 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zach Loafman <zml@zml.net>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH] netfilter: nft_dynset: check extension template errors
Message-ID: <aweBZHiTptFcPUI8@chamomile>
References: <20261126001556.69645-1-zml@zml.net>
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
In-Reply-To: <20261126001556.69645-1-zml@zml.net>

On Wed, Nov 25, 2026 at 04:15:56PM -0800, Zach Loafman wrote:
> nft_dynset_init() currently adds expressions before timeout metadata and
> ignores all nft_set_ext_add_length() errors.
> 
> For a map with 64-byte keys, 64-byte values and two packet-limit

Hm. What 64-byte key and 64-byte value do you have in mind in a real
world scenario?

> expressions, the template is 264 bytes long before timeout is added.  The
> timeout start therefore cannot be represented in the extension's u8
> offset and nft_set_ext_add_length() returns -EINVAL.
>
> Ignoring this error
> leaves the timeout offset unset, so packet-created elements do not expire
> automatically.
> 
> Add timeout before expressions, as the control-plane element constructor
> does.  This places timeout at offset 144 and expressions at offset 160; the
> resulting 280-byte total remains valid because only individual extension
> starts and lengths are u8.  Propagate errors from every template builder so
> layouts rejected by those builders fail construction and use the existing
> expression unwind.

That's funny way to fix this issue.

> With a 30-second default set timeout, a raw nfnetlink reproducer creates
> the rule and inserts elements on both the unpatched and patched kernels.
> The unpatched element dump lacks EXPIRATION; the patched dump includes it.
> The missing extension also prevents the element from expiring during
> normal set expiration and garbage collection.

This all sounds as a theoretical issue found by LLM. This does not
sound as nf.git material.

LLM can just fix stuff right with oneliners, anything else is simply
crap.

> This fixes incorrect element lifetime and resource retention.  No
> memory-safety primitive has been identified.
>
> Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
> Signed-off-by: Zach Loafman <zml@zml.net>
> 
> ---
>  net/netfilter/nft_dynset.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> index fa4da694e92d..8fc2ec2212f4 100644
> --- a/net/netfilter/nft_dynset.c
> +++ b/net/netfilter/nft_dynset.c
> @@ -120,7 +120,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
>  		regs->verdict.code = NFT_BREAK;
>  }
>  
> -static void nft_dynset_ext_add_expr(struct nft_dynset *priv)
> +static int nft_dynset_ext_add_expr(struct nft_dynset *priv)
>  {
>  	u8 size = 0;
>  	int i;
> @@ -128,8 +128,8 @@ static void nft_dynset_ext_add_expr(struct nft_dynset *priv)
>  	for (i = 0; i < priv->num_exprs; i++)
>  		size += priv->expr_array[i]->ops->size;
>  
> -	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPRESSIONS,
> -			       sizeof(struct nft_set_elem_expr) + size);
> +	return nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPRESSIONS,
> +				      sizeof(struct nft_set_elem_expr) + size);
>  }
>  
>  static struct nft_expr *
> @@ -317,16 +317,29 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
>  	}
>  
>  	nft_set_ext_prepare(&priv->tmpl);
> -	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
> -	if (set->flags & NFT_SET_MAP)
> -		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_DATA, set->dlen);
> +	err = nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
> +	if (err < 0)
> +		goto err_expr_free;
>  
> -	if (priv->num_exprs)
> -		nft_dynset_ext_add_expr(priv);
> +	if (set->flags & NFT_SET_MAP) {
> +		err = nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_DATA,
> +					     set->dlen);
> +		if (err < 0)
> +			goto err_expr_free;
> +	}
>  
>  	if (set->flags & NFT_SET_TIMEOUT &&
> -	    (timeout || READ_ONCE(set->timeout)))
> -		nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
> +	    (timeout || READ_ONCE(set->timeout))) {
> +		err = nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
> +		if (err < 0)
> +			goto err_expr_free;
> +	}
> +
> +	if (priv->num_exprs) {
> +		err = nft_dynset_ext_add_expr(priv);
> +		if (err < 0)
> +			goto err_expr_free;
> +	}
>  
>  	priv->timeout = timeout;
>  
> -- 
> 2.52.0
