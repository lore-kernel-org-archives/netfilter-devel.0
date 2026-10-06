Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B03DC85B;
	Tue,  6 Oct 2026 14:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791295465; cv=none; b=eXNMZi9u7QnyhC0cqdvqHC6mj5A9yE4kQX+pwY+alttd4avbC9Cr5W1XT5RzMwW48BkVDpmlmodzssyv1ByCs+jKgE0R4te8ew80gHW56EgFHaP7y7aojeJvNpfiv+JLeZSqlY5U5e6YFHPvU482K/72dbvVAObC0csPlwAicZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791295465; c=relaxed/simple;
	bh=zW/f6NHpiFuglww3DpdvHRsKCi9KuHwZe8xw4IlfWVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jL0MZpaC7Ou1/r7Yhd4Te6XXbugcGwl8CGWq17CqEhMiIrw29vcIcs1Iss4tLYE2voAx2WlBGVBg3j9A1j4xHibBCX64irmSmR+j8aSz0ICnd2gZD5W/JYGhxI3W2bDBVRZ6M3tpgxzJI5MVuPc1a65CBRvAlYpqwY/9BZ36CTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KDz9IuqW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KDz9IuqW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791295458;
	bh=4w9SVrSskqILHj8ealT02pPs99nrXYu+MDXFiDVU/8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDz9IuqWA/U2gLMcYfuTZazzHplxJD45K0IYkDib7g3V5E29TnXTIcqQpg4t/hqvc
	 THmqTc9vMZHy8gUEnRhiJjXQjsjOWQ9gEq6uRbWXdfZOZaTjtseM1J+GTpHWWG+TqK
	 SamcgeVijiUa93g39FJQLbizpfiF51sZoO2JV7iLgDmnTVeVp9qQYkpEFzCmivlc/m
	 wVPgLQNZoVYx3ESXP87wsk2B87TVG/t3wKwPWIYJx57lv81erNf/TNMTHwq/ws0qT6
	 uSRp8OlzJ/TDcxlJEXlOyk5wdWaPscW6/LUyQTnSfPzkT5n7g5/aJRoEHzCgNktfQ2
	 +yfu+rJ5tuU+Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3D44B600A7;
	Tue,  6 Oct 2026 16:04:18 +0200 (CEST)
Date: Tue, 6 Oct 2026 16:04:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
Cc: fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
Message-ID: <asT_37n_6viz9dJa@chamomile>
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>

On Tue, Oct 06, 2026 at 02:28:44PM +0530, Hari Chandrakanthan wrote:
> Add support for using the ct expression in nftables netdev egress chains.
> This enables QoS policy enforcement at the netdev egress hook by
> allowing ct operations such as copying connmark to packet mark.
> 
> Add an explicit NFPROTO_NETDEV case in nf_ct_netns_get() and
> nf_ct_netns_put() that enables conntrack for IPv4, IPv6 and bridge when a
> ct expression is added to a netdev chain.
> 
> Restrict ct expression use in the netdev family to egress hooks only, as
> the connection entry is not yet available at ingress.
> 
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

Hm. This is pulling in the bridge conntrack hooks.

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

And inet too.

I understand this is to deal with a situation where only ct rule is
placed in netdev/egress.

Is it really worth? I would expect users already have rules refering
to ct from either bridge and/or netdev would match here.

It looks a bit like too much to enable them all for the "a ct rule in
netdev/egress only".

Probably better solution would be to enable nf_conntrack_in() from the
netdev hook (just an earlier call), but this also needs to enable
packet defrag from there. Then, enabling all inet and bridge is not
required, because netdev/ingress would handle the creation/lookup of
the conntrack.

> +		if (err < 0) {
> +			if (bridge_acquired)
> +				nf_ct_netns_put(net, NFPROTO_BRIDGE);
> +			return err;
> +		}
> +		break;
>  	case NFPROTO_BRIDGE:
>  		err = nf_ct_netns_do_get(net, NFPROTO_BRIDGE);
>  		if (err < 0)
> @@ -615,6 +640,7 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
>  {
>  	switch (nfproto) {
>  	case NFPROTO_BRIDGE:
> +	case NFPROTO_NETDEV:
>  		nf_ct_netns_do_put(net, NFPROTO_BRIDGE);
>  		fallthrough;
>  	case NFPROTO_INET:
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
>  
>  #ifdef CONFIG_MITIGATION_RETPOLINE
> @@ -742,6 +752,7 @@ static const struct nft_expr_ops nft_ct_get_fast_ops = {
>  	.init		= nft_ct_get_init,
>  	.destroy	= nft_ct_get_destroy,
>  	.dump		= nft_ct_get_dump,
> +	.validate	= nft_ct_validate,
>  };
>  #endif
>  
> @@ -752,9 +763,19 @@ static const struct nft_expr_ops nft_ct_set_ops = {
>  	.init		= nft_ct_set_init,
>  	.destroy	= nft_ct_set_destroy,
>  	.dump		= nft_ct_set_dump,
> +	.validate	= nft_ct_validate,
>  };
>  
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
>  };
>  #endif
>  
> -- 
> 2.34.1
> 
