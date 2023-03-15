Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D4EC76195
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 10:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCOK75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCOK7w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 06:59:52 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EAD2E839
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 03:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tHBaLNXACh7wnxffLtL+dcjTk4X850rBy0MUbbZpLRs=; b=VS3KiD57ewIVYzdmSgNLWO7q34
        6CGWmyodJpHhCIwsXY+Z76sTrx1eG01k+NPFxbysR8fIIOe0GhI9G+qD2hfgZ/9fz/DJ2+2VFXRyu
        TNzVKPFrAwKCLO9Hr+Mptx1mLPQhIkj/UQQZPE/vGbp9tQOb82rgpo9FaWCBCXTscXgashxSb3TxZ
        V+VrzlkpVqtA78K6Wn+SoQ8ZJoWFQ6KjV0I20SqYmzZ+xO8/P2+Qi8rZEmZPd5sArAgX3kDn7GIhV
        mYa0eVcc/8EpIAkmp8c2GzNe91Q9mYI0H+e8Ad/IBjtzQBX1nSig7m4DZBTZ6MQ5/4I4CXPcEL9VA
        C0FLQFrw==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcOrD-009UoB-CI; Wed, 15 Mar 2023 10:59:47 +0000
Date:   Wed, 15 Mar 2023 10:59:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] NF NAT deduplication refactoring
Message-ID: <20230315105946.GA785278@celephais.dreamlands>
References: <20230313134649.186812-1-jeremy@azazel.net>
 <ZBBR/gcg6/Oiyq07@salvia>
 <ZBGc/uvjDp61RHay@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9S7/psnt/wjslfaI"
Content-Disposition: inline
In-Reply-To: <ZBGc/uvjDp61RHay@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9S7/psnt/wjslfaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-15, at 11:25:02 +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 14, 2023 at 11:52:49AM +0100, Pablo Neira Ayuso wrote:
> > May you submit v2 with these two changes?
>=20
> Something like this attached. It is doing all at once, but the patch
> looks relatively easier to follow.

Thanks for this.  I did make a start on v2, but yesterday was not very
productive.  I'll incorporate your suggestions and send it out later
to-day.

> I can also document the removal of WARN_ON() and the use of
> union nf_inet_addr newdst =3D {};
>=20
> I am adding the memset() on range, but that is defensive. Probably all
> memset() can just go away from the nftables nat code, but I need to
> double check.

Yeah, I didn't see anywhere that appeared to require the memset, which
is why I took it out, but I didn't trace the whole lifecycle of the
variable, so I may have missed something.

J.

> From b4e6d901cdf7f6adf43a66ec35829f6d90196326 Mon Sep 17 00:00:00 2001
> From: Jeremy Sowden <jeremy@azazel.net>
> Date: Mon, 13 Mar 2023 13:46:47 +0000
> Subject: [PATCH nf-next 1/2] netfilter: nft_redir: deduplicate eval call-=
backs
>=20
> `nf_nat_redirect_ipv4` takes a `struct nf_nat_ipv4_multi_range_compat`,
> but converts it internally to a `struct nf_nat_range2`.  Change the
> function to take the latter, factor out the code now shared with
> `nf_nat_redirect_ipv6`, move the conversion to the xt_REDIRECT module,
> and update the ipv4 range initialization in the nft_redir module.
>=20
> Replace a bare hex constant for 127.0.0.1 with a macro.
>=20
> nft_redir has separate ipv4 and ipv6 call-backs which share much of
> their code, and an inet one switch containing a switch that calls one of
> the others based on the family of the packet.  Merge the ipv4 and ipv6
> ones into the inet one in order to get rid of the duplicate code.
>=20
> Const-qualify the `priv` pointer since we don't need to write through
> it.
>=20
> Assign `priv->flags` to the range instead of OR-ing it in.
>=20
> Set the `NF_NAT_RANGE_PROTO_SPECIFIED` flag once during init, rather
> than on every eval.
>=20
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_nat_redirect.h |  3 +-
>  net/netfilter/nf_nat_redirect.c         | 70 +++++++++------------
>  net/netfilter/nft_redir.c               | 84 +++++++++----------------
>  net/netfilter/xt_REDIRECT.c             | 10 ++-
>  4 files changed, 71 insertions(+), 96 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_nat_redirect.h b/include/net/netfil=
ter/nf_nat_redirect.h
> index 2418653a66db..279380de904c 100644
> --- a/include/net/netfilter/nf_nat_redirect.h
> +++ b/include/net/netfilter/nf_nat_redirect.h
> @@ -6,8 +6,7 @@
>  #include <uapi/linux/netfilter/nf_nat.h>
> =20
>  unsigned int
> -nf_nat_redirect_ipv4(struct sk_buff *skb,
> -		     const struct nf_nat_ipv4_multi_range_compat *mr,
> +nf_nat_redirect_ipv4(struct sk_buff *skb, const struct nf_nat_range2 *ra=
nge,
>  		     unsigned int hooknum);
>  unsigned int
>  nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *ra=
nge,
> diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redir=
ect.c
> index f91579c821e9..083e534bded0 100644
> --- a/net/netfilter/nf_nat_redirect.c
> +++ b/net/netfilter/nf_nat_redirect.c
> @@ -10,6 +10,7 @@
> =20
>  #include <linux/if.h>
>  #include <linux/inetdevice.h>
> +#include <linux/in.h>
>  #include <linux/ip.h>
>  #include <linux/kernel.h>
>  #include <linux/netdevice.h>
> @@ -24,54 +25,55 @@
>  #include <net/netfilter/nf_nat.h>
>  #include <net/netfilter/nf_nat_redirect.h>
> =20
> +static unsigned int
> +nf_nat_redirect(struct sk_buff *skb, const struct nf_nat_range2 *range,
> +		const union nf_inet_addr *newdst)
> +{
> +	struct nf_nat_range2 newrange;
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct =3D nf_ct_get(skb, &ctinfo);
> +
> +	memset(&newrange, 0, sizeof(newrange));
> +	newrange.flags		=3D range->flags | NF_NAT_RANGE_MAP_IPS;
> +	newrange.min_addr	=3D *newdst;
> +	newrange.max_addr	=3D *newdst;
> +	newrange.min_proto	=3D range->min_proto;
> +	newrange.max_proto	=3D range->max_proto;
> +
> +	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
> +}
> +
>  unsigned int
> -nf_nat_redirect_ipv4(struct sk_buff *skb,
> -		     const struct nf_nat_ipv4_multi_range_compat *mr,
> +nf_nat_redirect_ipv4(struct sk_buff *skb, const struct nf_nat_range2 *ra=
nge,
>  		     unsigned int hooknum)
>  {
> -	struct nf_conn *ct;
> -	enum ip_conntrack_info ctinfo;
> -	__be32 newdst;
> -	struct nf_nat_range2 newrange;
> +	union nf_inet_addr newdst =3D {};
> =20
>  	WARN_ON(hooknum !=3D NF_INET_PRE_ROUTING &&
>  		hooknum !=3D NF_INET_LOCAL_OUT);
> =20
> -	ct =3D nf_ct_get(skb, &ctinfo);
> -	WARN_ON(!(ct && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D IP_CT_RELATED=
)));
> -
>  	/* Local packets: make them go to loopback */
>  	if (hooknum =3D=3D NF_INET_LOCAL_OUT) {
> -		newdst =3D htonl(0x7F000001);
> +		newdst.ip =3D htonl(INADDR_LOOPBACK);
>  	} else {
>  		const struct in_device *indev;
> =20
> -		newdst =3D 0;
> -
>  		indev =3D __in_dev_get_rcu(skb->dev);
>  		if (indev) {
>  			const struct in_ifaddr *ifa;
> =20
>  			ifa =3D rcu_dereference(indev->ifa_list);
>  			if (ifa)
> -				newdst =3D ifa->ifa_local;
> +				newdst.ip =3D ifa->ifa_local;
>  		}
> =20
> -		if (!newdst)
> +		if (!newdst.ip)
>  			return NF_DROP;
>  	}
> =20
> -	/* Transfer from original range. */
> -	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
> -	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
> -	newrange.flags	     =3D mr->range[0].flags | NF_NAT_RANGE_MAP_IPS;
> -	newrange.min_addr.ip =3D newdst;
> -	newrange.max_addr.ip =3D newdst;
> -	newrange.min_proto   =3D mr->range[0].min;
> -	newrange.max_proto   =3D mr->range[0].max;
> -
> -	/* Hand modified range to generic setup. */
> -	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
> +	return nf_nat_redirect(skb, range, &newdst);
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv4);
> =20
> @@ -81,14 +83,10 @@ unsigned int
>  nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *ra=
nge,
>  		     unsigned int hooknum)
>  {
> -	struct nf_nat_range2 newrange;
> -	struct in6_addr newdst;
> -	enum ip_conntrack_info ctinfo;
> -	struct nf_conn *ct;
> +	union nf_inet_addr newdst =3D {};
> =20
> -	ct =3D nf_ct_get(skb, &ctinfo);
>  	if (hooknum =3D=3D NF_INET_LOCAL_OUT) {
> -		newdst =3D loopback_addr;
> +		newdst.in6 =3D loopback_addr;
>  	} else {
>  		struct inet6_dev *idev;
>  		struct inet6_ifaddr *ifa;
> @@ -98,7 +96,7 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct =
nf_nat_range2 *range,
>  		if (idev !=3D NULL) {
>  			read_lock_bh(&idev->lock);
>  			list_for_each_entry(ifa, &idev->addr_list, if_list) {
> -				newdst =3D ifa->addr;
> +				newdst.in6 =3D ifa->addr;
>  				addr =3D true;
>  				break;
>  			}
> @@ -109,12 +107,6 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const stru=
ct nf_nat_range2 *range,
>  			return NF_DROP;
>  	}
> =20
> -	newrange.flags		=3D range->flags | NF_NAT_RANGE_MAP_IPS;
> -	newrange.min_addr.in6	=3D newdst;
> -	newrange.max_addr.in6	=3D newdst;
> -	newrange.min_proto	=3D range->min_proto;
> -	newrange.max_proto	=3D range->max_proto;
> -
> -	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
> +	return nf_nat_redirect(skb, range, &newdst);
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv6);
> diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
> index 5f7739987559..1d52a05a8b03 100644
> --- a/net/netfilter/nft_redir.c
> +++ b/net/netfilter/nft_redir.c
> @@ -64,6 +64,8 @@ static int nft_redir_init(const struct nft_ctx *ctx,
>  		} else {
>  			priv->sreg_proto_max =3D priv->sreg_proto_min;
>  		}
> +
> +		priv->flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
>  	}
> =20
>  	if (tb[NFTA_REDIR_FLAGS]) {
> @@ -99,25 +101,37 @@ static int nft_redir_dump(struct sk_buff *skb,
>  	return -1;
>  }
> =20
> -static void nft_redir_ipv4_eval(const struct nft_expr *expr,
> -				struct nft_regs *regs,
> -				const struct nft_pktinfo *pkt)
> +static void nft_redir_eval(const struct nft_expr *expr,
> +			   struct nft_regs *regs,
> +			   const struct nft_pktinfo *pkt)
>  {
> -	struct nft_redir *priv =3D nft_expr_priv(expr);
> -	struct nf_nat_ipv4_multi_range_compat mr;
> +	const struct nft_redir *priv =3D nft_expr_priv(expr);
> +	struct nf_nat_range2 range;
> =20
> -	memset(&mr, 0, sizeof(mr));
> +	memset(&range, 0, sizeof(range));
> +	range.flags =3D priv->flags;
>  	if (priv->sreg_proto_min) {
> -		mr.range[0].min.all =3D (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_min]);
> -		mr.range[0].max.all =3D (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_max]);
> -		mr.range[0].flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
> +		range.min_proto.all =3D (__force __be16)
> +			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
> +		range.max_proto.all =3D (__force __be16)
> +			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
>  	}
> =20
> -	mr.range[0].flags |=3D priv->flags;
> -
> -	regs->verdict.code =3D nf_nat_redirect_ipv4(pkt->skb, &mr, nft_hook(pkt=
));
> +	switch (nft_pf(pkt)) {
> +	case NFPROTO_IPV4:
> +		regs->verdict.code =3D nf_nat_redirect_ipv4(pkt->skb, &range,
> +							  nft_hook(pkt));
> +		break;
> +#ifdef CONFIG_NF_TABLES_IPV6
> +	case NFPROTO_IPV6:
> +		regs->verdict.code =3D nf_nat_redirect_ipv6(pkt->skb, &range,
> +							  nft_hook(pkt));
> +		break;
> +#endif
> +	default:
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
>  }
> =20
>  static void
> @@ -130,7 +144,7 @@ static struct nft_expr_type nft_redir_ipv4_type;
>  static const struct nft_expr_ops nft_redir_ipv4_ops =3D {
>  	.type		=3D &nft_redir_ipv4_type,
>  	.size		=3D NFT_EXPR_SIZE(sizeof(struct nft_redir)),
> -	.eval		=3D nft_redir_ipv4_eval,
> +	.eval		=3D nft_redir_eval,
>  	.init		=3D nft_redir_init,
>  	.destroy	=3D nft_redir_ipv4_destroy,
>  	.dump		=3D nft_redir_dump,
> @@ -148,28 +162,6 @@ static struct nft_expr_type nft_redir_ipv4_type __re=
ad_mostly =3D {
>  };
> =20
>  #ifdef CONFIG_NF_TABLES_IPV6
> -static void nft_redir_ipv6_eval(const struct nft_expr *expr,
> -				struct nft_regs *regs,
> -				const struct nft_pktinfo *pkt)
> -{
> -	struct nft_redir *priv =3D nft_expr_priv(expr);
> -	struct nf_nat_range2 range;
> -
> -	memset(&range, 0, sizeof(range));
> -	if (priv->sreg_proto_min) {
> -		range.min_proto.all =3D (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_min]);
> -		range.max_proto.all =3D (__force __be16)nft_reg_load16(
> -			&regs->data[priv->sreg_proto_max]);
> -		range.flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
> -	}
> -
> -	range.flags |=3D priv->flags;
> -
> -	regs->verdict.code =3D
> -		nf_nat_redirect_ipv6(pkt->skb, &range, nft_hook(pkt));
> -}
> -
>  static void
>  nft_redir_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr =
*expr)
>  {
> @@ -180,7 +172,7 @@ static struct nft_expr_type nft_redir_ipv6_type;
>  static const struct nft_expr_ops nft_redir_ipv6_ops =3D {
>  	.type		=3D &nft_redir_ipv6_type,
>  	.size		=3D NFT_EXPR_SIZE(sizeof(struct nft_redir)),
> -	.eval		=3D nft_redir_ipv6_eval,
> +	.eval		=3D nft_redir_eval,
>  	.init		=3D nft_redir_init,
>  	.destroy	=3D nft_redir_ipv6_destroy,
>  	.dump		=3D nft_redir_dump,
> @@ -199,20 +191,6 @@ static struct nft_expr_type nft_redir_ipv6_type __re=
ad_mostly =3D {
>  #endif
> =20
>  #ifdef CONFIG_NF_TABLES_INET
> -static void nft_redir_inet_eval(const struct nft_expr *expr,
> -				struct nft_regs *regs,
> -				const struct nft_pktinfo *pkt)
> -{
> -	switch (nft_pf(pkt)) {
> -	case NFPROTO_IPV4:
> -		return nft_redir_ipv4_eval(expr, regs, pkt);
> -	case NFPROTO_IPV6:
> -		return nft_redir_ipv6_eval(expr, regs, pkt);
> -	}
> -
> -	WARN_ON_ONCE(1);
> -}
> -
>  static void
>  nft_redir_inet_destroy(const struct nft_ctx *ctx, const struct nft_expr =
*expr)
>  {
> @@ -223,7 +201,7 @@ static struct nft_expr_type nft_redir_inet_type;
>  static const struct nft_expr_ops nft_redir_inet_ops =3D {
>  	.type		=3D &nft_redir_inet_type,
>  	.size		=3D NFT_EXPR_SIZE(sizeof(struct nft_redir)),
> -	.eval		=3D nft_redir_inet_eval,
> +	.eval		=3D nft_redir_eval,
>  	.init		=3D nft_redir_init,
>  	.destroy	=3D nft_redir_inet_destroy,
>  	.dump		=3D nft_redir_dump,
> diff --git a/net/netfilter/xt_REDIRECT.c b/net/netfilter/xt_REDIRECT.c
> index 353ca7801251..ff66b56a3f97 100644
> --- a/net/netfilter/xt_REDIRECT.c
> +++ b/net/netfilter/xt_REDIRECT.c
> @@ -46,7 +46,6 @@ static void redirect_tg_destroy(const struct xt_tgdtor_=
param *par)
>  	nf_ct_netns_put(par->net, par->family);
>  }
> =20
> -/* FIXME: Take multiple ranges --RR */
>  static int redirect_tg4_check(const struct xt_tgchk_param *par)
>  {
>  	const struct nf_nat_ipv4_multi_range_compat *mr =3D par->targinfo;
> @@ -65,7 +64,14 @@ static int redirect_tg4_check(const struct xt_tgchk_pa=
ram *par)
>  static unsigned int
>  redirect_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> -	return nf_nat_redirect_ipv4(skb, par->targinfo, xt_hooknum(par));
> +	const struct nf_nat_ipv4_multi_range_compat *mr =3D par->targinfo;
> +	struct nf_nat_range2 range =3D {
> +		.flags       =3D mr->range[0].flags,
> +		.min_proto   =3D mr->range[0].min,
> +		.max_proto   =3D mr->range[0].max,
> +	};
> +
> +	return nf_nat_redirect_ipv4(skb, &range, xt_hooknum(par));
>  }
> =20
>  static struct xt_target redirect_tg_reg[] __read_mostly =3D {
> --=20
> 2.30.2
>=20


--9S7/psnt/wjslfaI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQRpRwACgkQKYasCr3x
BA0q5RAAqc3XJmIN1fsPS2X6mBoPZRXGzPeAFEiT40GRTPwQiQJGrX6G7FbqEyKG
bi5C997/ph5te3BuPjqh9TfeXKBlDQvYjqDz6nuFvXJ9MDRC6LuHYtrgVyqBTlhE
H7Qvb/wd8u/wpnOaUvNIG7BADxiU2T08NL2MtBwR6LWyjcMBRTi27SHjRtqKDHeA
GqotqB8SBxNOkhBbAtLzJ2qK3BcrFrSUHky4gZ/9IBII5LOPoQbGdh5hLLm+fSLy
TGNbdJaRyFZTBnJyuLVhHqeVHuzWxSzPI5rxixhd7xnyBKpxP9+eaoW2d7tbGTSI
l+RRpTxhn6w/D1KPSk7u2AUtJS5LcIStFgyf3YL+j5qjorzdDUlEFxa4bdfmCHTK
B5pOe2mzuj7Up8a6qk6+NvjTOFD/L4+ELS9nHGGkoJrUCLkQIQ8nPDXfER8dXAn4
MmAPr4K0zjTJ6wGSGfrV7v2wIIfiFKAqGIbXN3tSyQ0v5Qhqnhx3Ero+tm5vDRpM
kweqohOoxu1jnWdmtWBei0Nc1vG+hjUGDhQYcGSn1vR4g3rra2s3+PoGqs4Vhy8g
O/wLtBj1wfSXPgfEaH8SW58yq12dqa8HX6ssHlbgt6ruwP8Tl7LcylhAFVuGkcha
VHYbCYMiw0PXNC/DEYlsblOk9gG5C5MpMivnGXim7AbVnN/Zb3g=
=0rzT
-----END PGP SIGNATURE-----

--9S7/psnt/wjslfaI--
