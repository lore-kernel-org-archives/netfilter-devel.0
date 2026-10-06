Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239E03B6366;
	Tue,  6 Oct 2026 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791286775; cv=none; b=an6q1igxhRV3dGtzSECNBmlSnP71x98pbK/l0K997V86qg80JlzeF7zgQYSCTnOylQIiR+tV+zRaXI6lUCAQSgHlWRrhghxBXF02iwtnb6XaMeCCyOPCyWMgd1ZDtBGZJA2Sn3VHzOY74Ts6TqmvgciDRLvylXNKpYK6Csvt4w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791286775; c=relaxed/simple;
	bh=getqOmf4RtngWz7k/DIaTN5GwicvQPrBvs0oEYv+RbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEBY3dQgEaEzT72z2SCECJvpxDWiTB6HvxX6xl2u9Q6FHVTL8ha5s8XhSH2ngHPRgfDld4OVaRE+fW/hw6NO5lZ83j208Qisx7rbqZvomx8c70gi3B4NDfrCDk+J3EA2vG9rqfY7Iu2ekFBttTlVUUfTB0IlmL4G8Zi3fRfvdpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 76758603FB; Tue, 06 Oct 2026 13:39:23 +0200 (CEST)
Date: Tue, 6 Oct 2026 13:39:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
Message-ID: <asTd69Buuk6PisMl@strlen.de>
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>

Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com> wrote:
> Add support for using the ct expression in nftables netdev egress chains.
> This enables QoS policy enforcement at the netdev egress hook by
> allowing ct operations such as copying connmark to packet mark.

Ok so far.

> Add an explicit NFPROTO_NETDEV case in nf_ct_netns_get() and
> nf_ct_netns_put() that enables conntrack for IPv4, IPv6 and bridge when a
> ct expression is added to a netdev chain.

Why?  The egress chain is passive (its a 'read property off ct'). why
does it have to turn on conntrack, let alone for bridge too?

> Restrict ct expression use in the netdev family to egress hooks only, as
> the connection entry is not yet available at ingress.

This makes sense.

> Sharing this change as an RFC, to get feedback. The patch has been tested
> by configuring nft rules at netdev egress hook to set ct mark and copy
> ct mark into skb->mark. Also, the patch is validated at netdev ingress to
> ensure the nft rule with ct mark set action is rejected.
> 
> Signed-off-by: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
> ---
>  net/netfilter/nf_conntrack_proto.c | 26 ++++++++++++++++++++++++++
>  net/netfilter/nft_ct.c             | 22 ++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 7a40e4e0e33e..b8ee46262901 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -587,11 +587,36 @@ static int nf_ct_netns_inet_get(struct net *net)
>  int nf_ct_netns_get(struct net *net, u8 nfproto)
>  {
>  	int err;
> +	bool bridge_acquired = false;
>  
>  	switch (nfproto) {
>  	case NFPROTO_INET:
>  		err = nf_ct_netns_inet_get(net);
>  		break;
> +	case NFPROTO_NETDEV:
> +		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
> +		if (err < 0) {
> +			mutex_lock(&nf_ct_proto_mutex);
> +			if (nf_ct_bridge_info) {
> +				/* Module present but hook registration failed.*/
> +				mutex_unlock(&nf_ct_proto_mutex);
> +				return err;
> +			}
> +			mutex_unlock(&nf_ct_proto_mutex);
> +			/* Bridge module absent, netdev egress handles routed
> +			 * traffic too, bridge conntrack is only needed for
> +			 * bridged frames.
> +			 */
> +		} else {
> +			bridge_acquired = true;
> +		}
> +		err = nf_ct_netns_inet_get(net);
> +		if (err < 0) {
> +			if (bridge_acquired)
> +				nf_ct_netns_put(net, NFPROTO_BRIDGE);
> +			return err;
> +		}
> +		break;

I don't understand the need for this.  Conntrack needs to be enabled to
track, but your use case makes no sense if conntrack isn't being used
already.

> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 3c4c2faa7398..e90e73475b0c 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -649,6 +649,15 @@ static void nft_ct_get_destroy(const struct nft_ctx *ctx,
>  	nf_ct_netns_put(ctx->net, ctx->family);
>  }
>  
> +static int nft_ct_validate(const struct nft_ctx *ctx,
> +			   const struct nft_expr *expr)
> +{
> +	if (ctx->family != NFPROTO_NETDEV)
> +		return 0;
> +
> +	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_EGRESS);
> +}
> +
>  static void nft_ct_set_destroy(const struct nft_ctx *ctx,
>  			       const struct nft_expr *expr)
>  {
> @@ -732,6 +741,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
>  	.init		= nft_ct_get_init,
>  	.destroy	= nft_ct_get_destroy,
>  	.dump		= nft_ct_get_dump,
> +	.validate	= nft_ct_validate,
>  };

OK.

>  #ifdef CONFIG_MITIGATION_RETPOLINE
> @@ -742,6 +752,7 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
>  	.init		= nft_ct_get_init,
>  	.destroy	= nft_ct_get_destroy,
>  	.dump		= nft_ct_get_dump,
> +	.validate	= nft_ct_validate,
>  };
>  #endif

OK.
> @@ -752,9 +763,19 @@ static const struct nft_expr_ops nft_ct_set_ops = {
>  	.init		= nft_ct_set_init,
>  	.destroy	= nft_ct_set_destroy,
>  	.dump		= nft_ct_set_dump,
> +	.validate	= nft_ct_validate,
>  };

Not sure.  Whats the use case to set connmark, labels etc. at netdev
egress stage?  I think use case was to READ those at egress stage
to set skb->mark etc?

>  #ifdef CONFIG_NF_CONNTRACK_ZONES
> +static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
> +				    const struct nft_expr *expr)
> +{
> +	if (ctx->family == NFPROTO_NETDEV)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
>  static const struct nft_expr_ops nft_ct_set_zone_ops = {
>  	.type		= &nft_ct_type,
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
> @@ -762,6 +783,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
>  	.init		= nft_ct_set_init,
>  	.destroy	= nft_ct_set_destroy,
>  	.dump		= nft_ct_set_dump,
> +	.validate	= nft_ct_set_zone_validate,

Makes sense to reject it.
