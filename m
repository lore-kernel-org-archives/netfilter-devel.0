Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D187CC282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC1D21871
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404102AbfEXUja (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 16:39:30 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:52242 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404054AbfEXUja (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 16:39:30 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUGyM-0006jf-08; Fri, 24 May 2019 22:39:29 +0200
Date:   Fri, 24 May 2019 22:39:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 1/1] netfilter: nft_ct: add ct expectations
 support
Message-ID: <20190524203924.n3a6x5r66pssgmhu@salvia>
References: <20190523192211.25402-1-sveyret@gmail.com>
 <20190523192211.25402-2-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190523192211.25402-2-sveyret@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 23, 2019 at 09:22:11PM +0200, Stéphane Veyret wrote:
[...]
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index f043936763f3..d072d3c8e6bc 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -24,6 +24,7 @@
>  #include <net/netfilter/nf_conntrack_labels.h>
>  #include <net/netfilter/nf_conntrack_timeout.h>
>  #include <net/netfilter/nf_conntrack_l4proto.h>
> +#include <net/netfilter/nf_conntrack_expect.h>
>  
>  struct nft_ct {
>  	enum nft_ct_keys	key:8;
> @@ -790,6 +791,138 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +struct nft_ct_expect_obj {
> +	int		l3num;
> +	u8		l4proto;
> +	__be16		dport;
> +	u32		timeout;
> +	u8		size;

Nit: Reorder to punch out holes in the structure layout, and use
appropriate datatypes:

	u16		l3num;
	__be16		dport;
	u8		l4proto;
	u8		size;
	u32		timeout;

> +};
> +
> +static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
> +				  const struct nlattr * const tb[],
> +				  struct nft_object *obj)
> +{
> +	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +
> +	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
> +	    !tb[NFTA_CT_EXPECT_DPORT] ||
> +	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
> +	    !tb[NFTA_CT_EXPECT_SIZE])
> +		return -EINVAL;
> +
> +	priv->l3num = ctx->family;
> +	if (tb[NFTA_CT_EXPECT_L3PROTO])
> +		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
> +
> +	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
> +	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
> +	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
> +	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
> +
> +	return nf_ct_netns_get(ctx->net, ctx->family);
> +}
> +
> +static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
> +				       struct nft_object *obj)
> +{
> +	nf_ct_netns_put(ctx->net, ctx->family);
> +}
> +
> +static int nft_ct_expect_obj_dump(struct sk_buff *skb,
> +				  struct nft_object *obj, bool reset)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +
> +	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
> +	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
> +	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
> +	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
> +	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void nft_ct_expect_obj_eval(struct nft_object *obj,
> +				   struct nft_regs *regs,
> +				   const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +	struct nf_conntrack_expect *exp;
> +	enum ip_conntrack_info ctinfo;
> +	int dir;

Please use 'enum ip_conntrack_dir' instead of int for "dir".

> +	struct nf_conn *ct;
> +	struct nf_conn_help *ct_help;
> +	int l3num = priv->l3num;

Reverse xmas tree for variable definitions:

	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
	struct nf_conntrack_expect *exp;
	enum ip_conntrack_info ctinfo;
	struct nf_conn_help *help;
	int l3num = priv->l3num;
	struct nf_conn *ct;
	int dir;

From largest line to smallest.

> +
> +	/* Check ct exists and is tracked */

Please, remove comment. We only use comments when something is not
evident to the reader, as a last resort. This forces people to write
good code :-)

> +	ct = nf_ct_get(pkt->skb, &ctinfo);
> +	if (!ct || ctinfo == IP_CT_UNTRACKED) {
> +		regs->verdict.code = NFT_BREAK;
> +		return;
> +	}
> +	dir = CTINFO2DIR(ctinfo);
> +
> +	/* ct extention is required */
> +	ct_help = nfct_help(ct);
> +	if (!ct_help) {
> +		ct_help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> +	}

Remove curly braces for single statement.

Nitpick: I'd suggest you rename 'ct_help' to 'help', for consistency
with other existing codebase.

> +
> +	/* Did we reach the limit? */

No need for comment either.

> +	if (ct_help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
> +		regs->verdict.code = NF_DROP;

Probably just NFT_BREAK instead of NF_DROP ?

> +		return;
> +	}
> +
> +	/* If l3num is set to INET, use the current ct proto */

Remove comment.

> +	if (l3num == NFPROTO_INET) {
> +		l3num = nf_ct_l3num(ct);
> +	}

Remove curly for single statement, ie.g

        if (l3num == NFPROTO_INET)
                l3num = nf_ct_l3num(ct);

> +	/* Create expectation */

Remove comment.

> +	exp = nf_ct_expect_alloc(ct);
> +	if (exp == NULL) {
> +		regs->verdict.code = NF_DROP;

NF_DROP looks fine in this case, do not change it.

> +		return;
> +	}
> +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
> +		          &ct->tuplehash[!dir].tuple.src.u3,
> +		          &ct->tuplehash[!dir].tuple.dst.u3,
> +		          priv->l4proto, NULL, &priv->dport);
> +	exp->timeout.expires = jiffies + priv->timeout * HZ;
> +	if (nf_ct_expect_related(exp) != 0)
> +		regs->verdict.code = NF_DROP;
> +}
