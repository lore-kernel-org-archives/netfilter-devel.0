Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A950CC004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74277206DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfEEWvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 18:51:20 -0400
Received: from mail.us.es ([193.147.175.20]:52708 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfEEWvU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 18:51:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C8F811ED80
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:51:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38ECFDA705
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:51:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2E921DA703; Mon,  6 May 2019 00:51:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13C26DA705;
        Mon,  6 May 2019 00:51:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 00:51:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E519D4265A31;
        Mon,  6 May 2019 00:51:14 +0200 (CEST)
Date:   Mon, 6 May 2019 00:51:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
Message-ID: <20190505225114.pwpwckz2oauskkrf@salvia>
References: <20190505154016.3505-1-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190505154016.3505-1-sveyret@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 05, 2019 at 05:40:16PM +0200, Stéphane Veyret wrote:
> This patch allows to add, list and delete expectations via nft objref
> infrastructure and assigning these expectations via nft rule.

Please, add to your patch title your patch version, ie.

[PATCH nf-next,v2] nft_ct: add ct expectations support

Could you describe the usecase example for this infrastructure, please?

More comments below.

> Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  15 ++-
>  net/netfilter/nft_ct.c                   | 124 ++++++++++++++++++++++-
>  2 files changed, 136 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index f0cf7b0f4f35..0a3452ca684c 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -968,6 +968,7 @@ enum nft_socket_keys {
>   * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
>   * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
>   * @NFT_CT_ID: conntrack id
> + * @NFT_CT_EXPECT: connection tracking expectation
>   */
>  enum nft_ct_keys {
>  	NFT_CT_STATE,
> @@ -995,6 +996,7 @@ enum nft_ct_keys {
>  	NFT_CT_DST_IP6,
>  	NFT_CT_TIMEOUT,
>  	NFT_CT_ID,
> +	NFT_CT_EXPECT,

You don't this definition, or I don't find where this is used.

>  	__NFT_CT_MAX
>  };
>  #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
> @@ -1447,6 +1449,16 @@ enum nft_ct_timeout_timeout_attributes {
>  };
>  #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
>  
> +enum nft_ct_expectation_attributes {
> +	NFTA_CT_EXPECT_UNSPEC,
> +	NFTA_CT_EXPECT_L3PROTO,
> +	NFTA_CT_EXPECT_L4PROTO,
> +	NFTA_CT_EXPECT_DPORT,
> +	NFTA_CT_EXPECT_TIMEOUT,
> +	__NFTA_CT_EXPECT_MAX,
> +};
> +#define NFTA_CT_EXPECT_MAX	(__NFTA_CT_EXPECT_MAX - 1)
> +
>  #define NFT_OBJECT_UNSPEC	0
>  #define NFT_OBJECT_COUNTER	1
>  #define NFT_OBJECT_QUOTA	2
> @@ -1456,7 +1468,8 @@ enum nft_ct_timeout_timeout_attributes {
>  #define NFT_OBJECT_TUNNEL	6
>  #define NFT_OBJECT_CT_TIMEOUT	7
>  #define NFT_OBJECT_SECMARK	8
> -#define __NFT_OBJECT_MAX	9
> +#define NFT_OBJECT_CT_EXPECT	9
> +#define __NFT_OBJECT_MAX	10
>  #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
>  
>  /**
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index f043936763f3..06c13b2dfb78 100644
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
> @@ -790,6 +791,117 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +struct nft_ct_expect_obj {
> +	int			l3num;
> +	u8			l4proto;
> +	__be16		dport;
> +	u32			timeout;
> +};
> +
> +static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
> +				   const struct nlattr * const tb[],
> +				   struct nft_object *obj)
> +{
> +	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +	int ret;
> +
> +	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
> +	    !tb[NFTA_CT_EXPECT_DPORT])
> +		return -EINVAL;
> +
> +	priv->l3num = ctx->family;
> +	if (tb[NFTA_CT_EXPECT_L3PROTO])
> +		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
> +	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
> +
> +	priv->dportmin = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT_MIN]);

Where is NFTA_CT_EXPECT_DPORT_MIN defined? You don't check for this
attribute, it may not be present. Looks like a leftover?

> +
> +	priv->timeout = 0;
> +	if (tb[NFTA_CT_EXPECT_TIMEOUT])
> +		priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
> +
> +	ret = nf_ct_netns_get(ctx->net, ctx->family);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
> +				       struct nft_object *obj)
> +{
> +	nf_ct_netns_put(ctx->net, ctx->family);
> +}
> +
> +static int nft_ct_expect_obj_dump(struct sk_buff *skb,
> +				   struct nft_object *obj, bool reset)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +
> +	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
> +	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
> +	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
> +	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout))
> +	return -1

This won't compile, missing ';'. Also indentation.

> +
> +	return 0;
> +}
> +
> +static void nft_ct_expect_obj_eval(struct nft_object *obj,
> +				    struct nft_regs *regs,
> +				    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct = nf_ct_get(pkt->skb, ctinfo);
> +	int dir = CTINFO2DIR(ctinfo);
> +	struct nf_conntrack_expect *exp;
> +
> +	exp = nf_ct_expect_alloc(ct);
> +	if (exp == NULL) {
> +		nf_ct_helper_log(skb, ct, "cannot allocate expectation");
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
> +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
> +		&ct->tuplehash[!dir].tuple.src.u3, &ct->tuplehash[!dir].tuple.dst.u3,
> +		priv->l4proto, NULL, &priv->dport);

Coding style:

	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
                          &ct->tuplehash[!dir].tuple.src.u3,
                          &ct->tuplehash[!dir].tuple.dst.u3,
                          priv->l4proto, NULL, &priv->dport);

> +	if (priv->timeout)
> +		exp->timeout.expires = jiffies + priv->timeout * HZ;

timeout should be made mandatory? why check if it's set?

> +	if (nf_ct_expect_related(exp) != 0) {
> +		nf_ct_helper_log(skb, ct, "cannot add expectation");
> +		regs->verdict.code = NF_DROP;
> +	}
> +}
> +
> +static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
> +	[NFTA_CT_EXPECT_L3PROTO] = {.type = NLA_U16 },
> +	[NFTA_CT_EXPECT_L4PROTO] = {.type = NLA_U8 },
> +	[NFTA_CT_EXPECT_DPORT] = {.type = NLA_U16 },
> +	[NFTA_CT_EXPECT_TIMEOUT] = {.type = NLA_U32 },

I'd prefer:

	[NFTA_CT_EXPECT_L3PROTO]        = { .type = NLA_U16 },
	[NFTA_CT_EXPECT_L4PROTO]        = { .type = NLA_U8 },
	[NFTA_CT_EXPECT_DPORT]          = { .type = NLA_U16 },
	[NFTA_CT_EXPECT_TIMEOUT]        = { .type = NLA_U32 },

Thanks!
