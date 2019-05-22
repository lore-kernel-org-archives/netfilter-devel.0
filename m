Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E786AC072A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB95C20821
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbfEVIqW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 04:46:22 -0400
Received: from mail.us.es ([193.147.175.20]:42354 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbfEVIqW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 04:46:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A7D8120041
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 10:46:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4807FDA714
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 10:46:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2F018DA7B6; Wed, 22 May 2019 10:46:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1017DA706;
        Wed, 22 May 2019 10:46:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 May 2019 10:46:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BE00A4265A31;
        Wed, 22 May 2019 10:46:15 +0200 (CEST)
Date:   Wed, 22 May 2019 10:46:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v3] netfilter: nft_ct: add ct expectations support
Message-ID: <20190522084615.tyjlorqfxyz5p2c2@salvia>
References: <20190517164031.8536-1-sveyret@gmail.com>
 <20190517164031.8536-2-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190517164031.8536-2-sveyret@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 17, 2019 at 06:40:29PM +0200, Stéphane Veyret wrote:
> This patch allows to add, list and delete expectations via nft objref
> infrastructure and assigning these expectations via nft rule.
> 
> This allows manual port triggering when no helper is defined to manage a
> specific protocol. For example, if I have an online game which protocol
> is based on initial connection to TCP port 9753 of the server, and where
> the server opens a connection to port 9876, I can set rules as follow:
> 
> table ip filter {
>     ct expectation mygame {
>         protocol udp;
>         dport 9876;

I think we should set a maximum number of expectations to be created,
as a mandatory field, eg.

          size 10;

>     }
> 
>     chain input {
>         type filter hook input priority 0; policy drop;
>         tcp dport 9753 ct expectation set "mygame";
>     }
> 
>     chain output {
>         type filter hook output priority 0; policy drop;
>         udp dport 9876 ct status expected accept;
>     }
> }
[...]
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index f043936763f3..d01cb175ab30 100644
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
> @@ -790,6 +791,114 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
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
> +		!tb[NFTA_CT_EXPECT_DPORT] ||
> +		!tb[NFTA_CT_EXPECT_TIMEOUT])

Coding style: Align parameter to parens:

	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
            !tb[NFTA_CT_EXPECT_DPORT] ||
            !tb[NFTA_CT_EXPECT_TIMEOUT])
		return -EINVAL;

> +	priv->l3num = ctx->family;

priv->l3num is only set and never used, remove it. You'll also have to
remove NFTA_CT_EXPECT_L3PROTO.

> +	if (tb[NFTA_CT_EXPECT_L3PROTO])
> +		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
> +
> +	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
> +	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
> +	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
> +
> +	ret = nf_ct_netns_get(ctx->net, ctx->family);

Just:

        return nf_ct_netns_get(ctx->net, ctx->family);

should be fine.

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
> +		nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
> +		nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
> +		nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout))
> +	return -1;

Coding style: Align parameter to parens:

	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
            nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
            nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
            nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout))
                return -1;

> +	return 0;
> +}
> +
> +static void nft_ct_expect_obj_eval(struct nft_object *obj,
> +				    struct nft_regs *regs,
> +				    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
> +	int dir = CTINFO2DIR(ctinfo);
> +	struct nf_conntrack_expect *exp;

Please, revert xmas tree for variable definitions, ie.

	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
	struct nf_conntrack_expect *exp;
	enum ip_conntrack_info ctinfo;
	int dir = CTINFO2DIR(ctinfo);
	struct nf_conn *ct;

Then, you have to check if ct is unset or is untrackedie.

        ct = nf_ct_get(pkt->skb, &ctinfo);
        if (!ct || ctinfo == IP_CT_UNTRACKED)
                goto err;

        ...
err:
        regs->verdict.code = NFT_BREAK;

> +	nf_ct_helper_ext_add(ct, GFP_ATOMIC);

I think you don't need nf_ct_helper_ext_add(...);

> +	exp = nf_ct_expect_alloc(ct);
> +	if (exp == NULL) {
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
> +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
> +		&ct->tuplehash[!dir].tuple.src.u3,
> +		&ct->tuplehash[!dir].tuple.dst.u3,
> +		priv->l4proto, NULL, &priv->dport);

Coding style: Align parameter to parens:

	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
                          &ct->tuplehash[!dir].tuple.src.u3,
                          &ct->tuplehash[!dir].tuple.dst.u3,
                          priv->l4proto, NULL, &priv->dport);

> +	exp->timeout.expires = jiffies + priv->timeout * HZ;
> +
> +	if (nf_ct_expect_related(exp) != 0) {
> +		regs->verdict.code = NF_DROP;
> +	}

No need for curly braces here, with single statement, the following is
fine:

	if (nf_ct_expect_related(exp) != 0)
                regs->verdict.code = NF_DROP;

Thanks for submitting your patch.
