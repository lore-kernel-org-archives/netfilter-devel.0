Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E391CA9EAE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 03:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D182086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 03:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfJWDhO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:37:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:21575 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbfJWDhO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 23:37:14 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 09DBA41878;
        Wed, 23 Oct 2019 11:37:11 +0800 (CST)
Subject: Re: [PATCH nf-next,RFC 2/2] netfilter: nf_tables: add encapsulation
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
References: <20191022154733.8789-1-pablo@netfilter.org>
 <20191022154733.8789-3-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <cfba375a-4714-0934-e32b-a30ce278a9e5@ucloud.cn>
Date:   Wed, 23 Oct 2019 11:37:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022154733.8789-3-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzI6MTo*ETg4SB8qFBMRI0op
        Fy1PCjlVSlVKTkxKQ0tKQ0hKT0lKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTE1ITjcG
X-HM-Tid: 0a6df6b096eb2086kuqy09dba41878
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 10/22/2019 11:47 PM, Pablo Neira Ayuso wrote:
> This patch adds encapsulation support through the encapsulation object,
> that specifies the encapsulation policy.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  40 +++++-
>  net/netfilter/nft_encap.c                | 224 ++++++++++++++++++++++++++++++-
>  2 files changed, 262 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 25e26340a0ba..e5997a13ba71 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1484,7 +1484,8 @@ enum nft_ct_expectation_attributes {
>  #define NFT_OBJECT_SECMARK	8
>  #define NFT_OBJECT_CT_EXPECT	9
>  #define NFT_OBJECT_SYNPROXY	10
> -#define __NFT_OBJECT_MAX	11
> +#define NFT_OBJECT_ENCAP	11
> +#define __NFT_OBJECT_MAX	12
>  #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
>  
>  /**
> @@ -1629,6 +1630,43 @@ enum nft_encap_type {
>  	NFT_ENCAP_VLAN	= 0,
>  };
>  
> +enum nft_encap_op {
> +	NFT_ENCAP_ADD	= 0,
> +	NFT_ENCAP_UPDATE,
> +};
> +
> +/**
> + * enum nft_encap_vlan_attributes - nf_tables VLAN encapsulation expression netlink attributes
> + *
> + * @NFTA_ENCAP_VLAN_ID: VLAN id (NLA_U16)
> + * @NFTA_ENCAP_VLAN_PROTO: VLAN protocol (NLA_U16)
> + * @NFTA_ENCAP_VLAN_PRIO: VLAN priority (NLA_U8)
> + */
> +enum nft_encap_vlan_attributes {
> +	NFTA_ENCAP_VLAN_UNSPEC,
> +	NFTA_ENCAP_VLAN_ID,
> +	NFTA_ENCAP_VLAN_PROTO,
> +	NFTA_ENCAP_VLAN_PRIO,
> +	__NFTA_ENCAP_VLAN_MAX
> +};
> +#define NFTA_ENCAP_VLAN_MAX	(__NFTA_ENCAP_VLAN_MAX - 1)
> +
> +/**
> + * enum nft_encap_attributes - nf_tables encapsulation expression netlink attributes
> + *
> + * @NFTA_ENCAP_TYPE: encapsulation type (NLA_U32)
> + * @NFTA_ENCAP_OP: encapsulation operation (NLA_U32)
> + * @NFTA_ENCAP_DATA: encapsulation data (NLA_NESTED)
> + */
> +enum nft_encap_attributes {
> +	NFTA_ENCAP_UNSPEC,
> +	NFTA_ENCAP_TYPE,
> +	NFTA_ENCAP_OP,
> +	NFTA_ENCAP_DATA,
> +	__NFTA_ENCAP_MAX
> +};
> +#define NFTA_ENCAP_MAX	(__NFTA_ENCAP_MAX - 1)
> +
>  /**
>   * enum nft_decap_attributes - nf_tables decapsulation expression netlink attributes
>   *
> diff --git a/net/netfilter/nft_encap.c b/net/netfilter/nft_encap.c
> index 657a62e4c283..13643b3daf85 100644
> --- a/net/netfilter/nft_encap.c
> +++ b/net/netfilter/nft_encap.c
> @@ -2,6 +2,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/if_vlan.h>
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
> @@ -101,14 +102,235 @@ static struct nft_expr_type nft_decap_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +struct nft_encap {
> +	enum nft_encap_type	type;
> +	enum nft_encap_op	op;
> +
> +	union {
> +		struct {
> +			__u16	id;
> +			__be16	proto;
> +			__u8	prio;
> +		} vlan;
> +	};
> +};
> +
> +static u16 nft_encap_vlan_tci(struct nft_encap *priv)
> +{
> +	return priv->vlan.id | (priv->vlan.prio << VLAN_PRIO_SHIFT);
> +}
> +
> +static int nft_encap_vlan_eval(struct nft_encap *priv,
> +			       struct nft_regs *regs,
> +			       const struct nft_pktinfo *pkt)
> +{
> +	struct sk_buff *skb = pkt->skb;
> +	int err;
> +	u16 tci;
> +
> +	switch (priv->op) {
> +	case NFT_ENCAP_ADD:
> +		err = skb_vlan_push(skb, priv->vlan.proto,
> +				    nft_encap_vlan_tci(priv));
> +		if (err)
> +			return err;
> +		break;
> +	case NFT_ENCAP_UPDATE:
> +		if (!skb_vlan_tagged(skb))
> +			return -1;
> +
> +		err = 0;
> +		if (skb_vlan_tag_present(skb)) {
> +			tci = skb_vlan_tag_get(skb);
> +			__vlan_hwaccel_clear_tag(skb);
> +		} else {
> +			err = __skb_vlan_pop(skb, &tci);
> +		}
> +		if (err)
> +			return err;
> +
> +		tci = (tci & ~VLAN_VID_MASK) | priv->vlan.id;
> +		if (priv->vlan.prio) {
> +			tci &= ~VLAN_PRIO_MASK;
> +			tci |= priv->vlan.prio << VLAN_PRIO_SHIFT;
> +		}
> +
> +		__vlan_hwaccel_put_tag(skb, priv->vlan.proto, tci);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void nft_encap_obj_eval(struct nft_object *obj,
> +			       struct nft_regs *regs,
> +			       const struct nft_pktinfo *pkt)
> +{
> +	struct nft_encap *priv = nft_obj_data(obj);
> +	int err;
> +
> +	switch (priv->type) {
> +	case NFT_ENCAP_VLAN:
> +		err = nft_encap_vlan_eval(priv, regs, pkt);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		err = -1;
> +	}
> +
> +	if (err < 0)
> +		regs->verdict.code = NFT_BREAK;
> +}
> +
> +static const struct nla_policy nft_encap_vlan_policy[NFTA_ENCAP_VLAN_MAX + 1] = {
> +	[NFTA_ENCAP_VLAN_ID]	= { .type = NLA_U16 },
> +	[NFTA_ENCAP_VLAN_PROTO]	= { .type = NLA_U16 },
> +	[NFTA_ENCAP_VLAN_PRIO]	= { .type = NLA_U8 },
> +};
> +
> +static int nft_encap_vlan_parse(const struct nlattr *attr,
> +				struct nft_encap *priv)
> +{
> +	struct nlattr *tb[NFTA_ENCAP_VLAN_MAX + 1];
> +	int err;
> +
> +	err = nla_parse_nested_deprecated(tb, NFTA_ENCAP_VLAN_MAX, attr,
> +					  nft_encap_vlan_policy, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[NFTA_ENCAP_VLAN_PRIO] ||
> +	    !tb[NFTA_ENCAP_VLAN_PROTO] ||
> +	    !tb[NFTA_ENCAP_VLAN_ID])
> +		return -EINVAL;
> +
> +	priv->vlan.id = ntohs(nla_get_be16(tb[NFTA_ENCAP_VLAN_ID]));
> +	priv->vlan.proto = nla_get_be16(tb[NFTA_ENCAP_VLAN_PROTO]);

Maybe it is better to check the vlan.proto is ETH_P_8021Q or ETH_P_8021AD?

> +	priv->vlan.prio = nla_get_u8(tb[NFTA_ENCAP_VLAN_PRIO]);
> +
> +	return 0;
> +}
> +
> +static int nft_encap_obj_init(const struct nft_ctx *ctx,
> +			      const struct nlattr * const tb[],
> +			      struct nft_object *obj)
> +{
> +	struct nft_encap *priv = nft_obj_data(obj);
> +	int err = 0;
> +
> +	if (!tb[NFTA_ENCAP_TYPE] ||
> +	    !tb[NFTA_ENCAP_OP])
> +		return -EINVAL;
> +
> +	priv->type = ntohl(nla_get_be32(tb[NFTA_ENCAP_TYPE]));
> +	priv->op = ntohl(nla_get_be32(tb[NFTA_ENCAP_OP]));
> +
> +	switch (priv->type) {
> +	case NFT_ENCAP_VLAN:
> +		if (priv->op != NFT_ENCAP_ADD &&
> +		    priv->op != NFT_ENCAP_UPDATE)
> +			return -EOPNOTSUPP;
> +
> +		err = nft_encap_vlan_parse(tb[NFTA_ENCAP_DATA], priv);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
>
