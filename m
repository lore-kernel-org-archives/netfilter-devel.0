Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFAF334C1D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536288; cv=none; b=rZVqaLwH0hN/ssyLgpBlaWdtzi6y2lxjMqtq4ENgqYQ+0utk2O9Anh+lZ6okpbS0mJIdPuyZHNrNgPsHnmA+KAqIidezSjVADUGYWXIaDw5XR1B1ZognOY05vxVLnHc/m3/YVUK382JvfnV+WzmyOUZYnR63+xrSgUUFRb95EZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536288; c=relaxed/simple;
	bh=tJSsxx4CDSbCJL3gG4agD8oqAQyvm7D38808iT8/uxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK71CqhiB3MOgyOWRzM3PAc8YpVl3fA5/wgaL8xfa6cY6vBkW+7to2yDxYD2GJZiXQU+kZbekutp5GyEtLfVk5S5TBxVaW5cqfjh/CCJo4gA3IvizXna6YF6h6dh+Gebdjwa/VwiFGw7f0HoFiot/9ChjtxmX4op19yDDn8ClAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=azshWmZ7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="azshWmZ7"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B422C600B9;
	Thu, 26 Mar 2026 15:44:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774536283;
	bh=LT1USPnTQr/js1REOlk+L3NcjQ3gB2VbFd30prEqnwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=azshWmZ7NVZi+Sb6UVKsVZq8ahRymT4+I57+5xyBUEbbMTjWpJnOF1SgcRqUIf8kF
	 t8Rup7nh4k+ZNwFCGaLb+tfrQ1rAtcEwb495CH04Fd8a1tvoo97n/bBSgg1h1ABnlQ
	 eRgEZycS4lclnDJB0IhxfyA7Rw7wnyaENkTihMur2QUjUyp2MAGWrOAFP4CVdHfqZR
	 WT9P4e3p32kWrwkm59y92pn/E5421Kev06zh00t9lEMealo6MYZtn3dcEC27FQ57wQ
	 l5I0Zyo1Y2ZZhTOt5BFy/giObOqgx2x/Whn75lEsh8gZ6aj7cSzQ7SrcdqaGCtODsx
	 TdPJPGQptwd1w==
Date: Thu, 26 Mar 2026 15:44:40 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net,v3 00/12] Netfilter for net
Message-ID: <acVGWE6APd2itKyu@chamomile>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <acUxw826gEzIv8Zp@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acUxw826gEzIv8Zp@strlen.de>

On Thu, Mar 26, 2026 at 02:16:51PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This is v3, I kept back an ipset fix and another to tigthen the xtables
> > interface to reject invalid combinations with the NFPROTO_ARP family.
> > They need a bit more discussion. I fixed the issues reported by AI on
> > patch 9 (add #ifdef to access ct zone, update nf_conntrack_broadcast
> > and patch 10 (use better Fixes: tag). Thanks!
> 
> Dropping netdev@.
> 
> I think the NFPROTO_ARP fix is legit.
> 
> If anything, we should also consider this (not even compile tested):

This chunk below looks easier to understand.

The issue can only happen from nft_compat, correct?

> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 53a614a0e3cd..39446edb0d70 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -778,6 +778,20 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
>  
>  static struct nft_expr_type nft_match_type;
>  
> +static bool is_valid_compat_family(u32 family)
> +{
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_ARP:
> +	case NFPROTO_BRIDGE:
> +	case NFPROTO_IPV6:
> +		return true;
> +	}
> +
> +	/* others are nftables only */
> +	return false;
> +}
> +
>  static const struct nft_expr_ops *
>  nft_match_select_ops(const struct nft_ctx *ctx,
>  		     const struct nlattr * const tb[])
> @@ -798,6 +812,9 @@ nft_match_select_ops(const struct nft_ctx *ctx,
>  	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
>  	family = ctx->family;
>  
> +	if (!is_valid_compat_family(family))
> +		return ERR_PTR(-EAFNOSUPPORT);
> +
>  	match = xt_request_find_match(family, mt_name, rev);
>  	if (IS_ERR(match))
>  		return ERR_PTR(-ENOENT);
> @@ -877,6 +894,9 @@ nft_target_select_ops(const struct nft_ctx *ctx,
>  	rev = ntohl(nla_get_be32(tb[NFTA_TARGET_REV]));
>  	family = ctx->family;
>  
> +	if (!is_valid_compat_family(family))
> +		return ERR_PTR(-EAFNOSUPPORT);
> +
>  	if (strcmp(tg_name, XT_ERROR_TARGET) == 0 ||
>  	    strcmp(tg_name, XT_STANDARD_TARGET) == 0 ||
>  	    strcmp(tg_name, "standard") == 0)
