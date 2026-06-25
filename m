Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED8315793
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782418274; cv=none; b=AmUjFcdtayII43o9Q5T+sbDQ5EAQdiLvbQ76ATT79TADG1u/G/76R8N2wwK7IQrJv4NpOufoOosmEXjpBZ8a5wAuFh6hy0Im4CcylrfWy3SIl+fzdvuPfrzFitfmr0Tay23k/PR4fVvgrYopMNHSSkd9853GRPcLpJiV0Azhxx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782418274; c=relaxed/simple;
	bh=xcx94xTqhedDuAwP02NfWMGjfa7JMp0J8th2qy0AnYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qclX6QxGRD6A71i/sKdhnD1ONZVCgEO05mPasYk5OJBFfiHxgFRjPmIpQPeOqt+w+RTmW0UeIu0ARMbNtJRvXH7AZM8s8c/q87etEW38gQkVfXCEPv1Hgh7G3tJQ1J764eMGqDjp9eeUi132bXmCXXuKO/tzmqSfl3cVaZfHVHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OLiggJ/x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OLiggJ/x"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2179160195;
	Thu, 25 Jun 2026 22:11:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782418264;
	bh=r/xgqhjTKnGaLj6x5gLnLcoxAEo0dBeGFDvdw6cGVkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLiggJ/xgEF6yTQ7xXsLKWXM+RzYi5tNBkZqJ5aqv/YXiiKqclWCpf16oIwhpJZAx
	 7xBRqB4u09U4FDyNciF/ryw4Xkwuc0xv+IrXlJgx/e/DkodVaXbF5tthyxwLPZTvF1
	 FUlV6TjaBOTzHo0KdzRbwsyMauyerLXTNL8MS+NBo7MXzGJ5zldryEokHwsPfO8T33
	 8dGnysPxlUQDXwsMMzg5T4d5cH0SInsWJX+T9WXQbsDQ4P7QjMFUfXaj0RGnfwWcq0
	 cECrCX44kQKUah5jkDFc6AnUHo1QSQPbwwjKO94FC3ojIEZyuBMWsh9ylo+AhTTBwr
	 0SdAQJUXMhuLg==
Date: Thu, 25 Jun 2026 22:11:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: nft_fib: reject fib expression on the
 netdev egress hook
Message-ID: <aj2LVX4rz4C_Z9DJ@chamomile>
References: <ajxsjcDOnwllMfoR@strlen.de>
 <20260625122834.204088-1-theodorlarionov@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260625122834.204088-1-theodorlarionov@gmail.com>

Hi,

Comments below.

On Thu, Jun 25, 2026 at 03:28:34PM +0300, Theodor Arsenij Larionov-Trichkine wrote:
> A fib expression in a netdev egress base chain dereferences the input
> device nft_in(pkt), which is NULL on the transmit path, causing a
> NULL-ptr-deref at eval. nft_fib_validate() gates the chain hook with
> NF_INET_* masks, but a netdev chain's hook numbers come from a separate
> enum that aliases them (NF_NETDEV_EGRESS == NF_INET_LOCAL_IN == 1), so a
> netdev egress chain passes validation and then faults. Add a dedicated
> nft_fib_netdev_validate() restricting the netdev fib expression to
> NF_NETDEV_INGRESS, the only netdev hook with an input device, and
> restrict nft_fib_validate() to NFPROTO_IPV4/IPV6/INET so its NF_INET_*
> hook masks are never applied to another family's hook numbering.
>
> Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
> Link: https://lore.kernel.org/netfilter-devel/ajxsjcDOnwllMfoR@strlen.de/
> Signed-off-by: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
> ---
>  net/netfilter/nft_fib.c        | 9 +++++++++
>  net/netfilter/nft_fib_netdev.c | 8 +++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> index e048f05694cd..89555380f1c5 100644
> --- a/net/netfilter/nft_fib.c
> +++ b/net/netfilter/nft_fib.c
> @@ -31,6 +31,15 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
>  	const struct nft_fib *priv = nft_expr_priv(expr);
>  	unsigned int hooks;
>  
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +	case NFPROTO_INET:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
>  	switch (priv->result) {
>  	case NFT_FIB_RESULT_OIF:
>  	case NFT_FIB_RESULT_OIFNAME:
> diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
> index 3f3478abd845..c855c5dccd41 100644
> --- a/net/netfilter/nft_fib_netdev.c
> +++ b/net/netfilter/nft_fib_netdev.c
> @@ -50,6 +50,12 @@ static void nft_fib_netdev_eval(const struct nft_expr *expr,
>  	regs->verdict.code = NFT_BREAK;
>  }
>  
> +static int nft_fib_netdev_validate(const struct nft_ctx *ctx,
> +				   const struct nft_expr *expr)
> +{

Maybe this is missing:

        switch (priv->result) {
        case NFT_FIB_RESULT_OIF:
        case NFT_FIB_RESULT_OIFNAME:
                hooks = (1 << NF_NETDEV_INGRESS);
                break;
        case NFT_FIB_RESULT_ADDRTYPE:
                if (priv->flags & NFTA_FIB_F_IIF)
                        hooks = (1 << NF_NETDEV_INGRESS);
                else if (priv->flags & NFTA_FIB_F_OIF)
                        hooks = (1 << NF_NETDEV_EGRESS);
                else
                        hooks = (1 << NF_NETDEV_INGRESS) |
                                (1 << NF_NETDEV_EGRESS);
                break;
        default:
                return -EINVAL;
        }

> +	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_INGRESS);
> +}
> +
>  static struct nft_expr_type nft_fib_netdev_type;
>  static const struct nft_expr_ops nft_fib_netdev_ops = {
>  	.type		= &nft_fib_netdev_type,
> @@ -57,7 +63,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
>  	.eval		= nft_fib_netdev_eval,
>  	.init		= nft_fib_init,
>  	.dump		= nft_fib_dump,
> -	.validate	= nft_fib_validate,
> +	.validate	= nft_fib_netdev_validate,
>  };
>  
>  static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
> -- 
> 2.34.1
> 
