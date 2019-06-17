Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBBDC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 19:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2639B2084B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 19:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="dzhRDghj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFQTtd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 15:49:33 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58066 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfFQTtc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 15:49:32 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 236B21A5A48;
        Mon, 17 Jun 2019 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1560800972; bh=o9YgNh9mMOt1a04FjizhK0Jtk3bNCcr6voMZnk5zyFw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dzhRDghjgMA0NpNWNDyl0aD0fxMhS+TJLMw0od+6CYszjZs2yfXWBj3+BzY2BWiaz
         ZZUwcsZ3qEspm8zcGhKUOYpp8S1c6xCwzb2aJkhAlV4SxLR4duo2WLBdkjmF+8JNsn
         Q05xKYUdUIQhCkPuptPKwjlvN/NjZOekzBbGHvPw=
X-Riseup-User-ID: 50697A0A7F0805593C88D3FC7B5195F7B17B811FD1BDA32088FE96F29562D0C0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 6AECC222BAE;
        Mon, 17 Jun 2019 12:49:31 -0700 (PDT)
Subject: Re: [PATCH nf-next WIP] netfilter: nf_tables: Add SYNPROXY support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190617103234.1357-1-ffmancera@riseup.net>
 <20190617103234.1357-2-ffmancera@riseup.net>
 <20190617154545.pr2nhk4itydcya3e@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <94f3c031-9952-f65a-6f8a-ef58de848217@riseup.net>
Date:   Mon, 17 Jun 2019 21:49:43 +0200
MIME-Version: 1.0
In-Reply-To: <20190617154545.pr2nhk4itydcya3e@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, comments below.

On 6/17/19 5:45 PM, Pablo Neira Ayuso wrote:
> On Mon, Jun 17, 2019 at 12:32:35PM +0200, Fernando Fernandez Mancera wrote:
>> Add SYNPROXY module support in nf_tables. It preserves the behaviour of the
>> SYNPROXY target of iptables but structured in a different way to propose
>> improvements in the future.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/uapi/linux/netfilter/nf_SYNPROXY.h |   4 +
>>  include/uapi/linux/netfilter/nf_tables.h   |  16 +
>>  net/netfilter/Kconfig                      |  11 +
>>  net/netfilter/Makefile                     |   1 +
>>  net/netfilter/nft_synproxy.c               | 328 +++++++++++++++++++++
>>  5 files changed, 360 insertions(+)
>>  create mode 100644 net/netfilter/nft_synproxy.c
>>
[...]
>> +
>> +static void nft_synproxy_eval(const struct nft_expr *expr,
>> +			      struct nft_regs *regs,
>> +			      const struct nft_pktinfo *pkt)
>> +{
> 
> You have to check if this is TCP traffic in first place, otherwise UDP
> packets may enter this path :-).
> 
>> +	switch (nft_pf(pkt)) {
>> +	case NFPROTO_IPV4:
>> +		nft_synproxy_eval_v4(expr, regs, pkt);
>> +		return;
>> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
>> +	case NFPROTO_IPV6:
>> +		nft_synproxy_eval_v6(expr, regs, pkt);
>> +		return;
>> +#endif
> 
> Please, use skb->protocol instead of nft_pf(), I would like we can use
> nft_synproxy from NFPROTO_NETDEV (ingress) and NFPROTO_BRIDGE families
> too.
> 

If I use skb->protocol no packet enters in the path. What do you
recommend me? Other than that, the rest of the suggestions are done and
it has been tested and it worked as expected. Thanks :-)

>> +	}
>> +	regs->verdict.code = NFT_BREAK;
>> +}
>> +
>> +static int nft_synproxy_init(const struct nft_ctx *ctx,
>> +			     const struct nft_expr *expr,
>> +			     const struct nlattr * const tb[])
>> +{
>> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
>> +	struct nft_synproxy *priv = nft_expr_priv(expr);
>> +	u32 flags;
>> +	int err;
>> +
>> +	err = nf_ct_netns_get(ctx->net, ctx->family);
>> +	if (err)
>> +		goto nf_ct_failure;
>> +
>> +	switch (ctx->family) {
>> +	case NFPROTO_IPV4:
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
>> +		break;
>> +	case NFPROTO_IPV6:
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref6++;
>> +		break;
>> +	case NFPROTO_INET:
> 
> Add NFPROTO_BRIDGE here too, ie.
> 
>         case NFPROTO_INET:
>         case NFPROTO_BRIDGE:
> 
> the code below will handle both cases: inet and bridge.
> 
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
>> +		snet->hook_ref6++;
>> +		break;
>> +	}
>> +
>> +	if (tb[NFTA_SYNPROXY_MSS])
>> +		priv->mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
>> +	if (tb[NFTA_SYNPROXY_WSCALE])
>> +		priv->wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
>> +	if (tb[NFTA_SYNPROXY_FLAGS]) {
>> +		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
>> +		if (flags != 0 && (flags & NF_SYNPROXY_FLAGMASK) == 0)
>> +			return -EINVAL;
>> +		priv->flags = flags;
>> +	}
>> +	return 0;
>> +
>> +nf_ct_failure:
>> +	nf_ct_netns_put(ctx->net, ctx->family);
>> +	return err;
>> +}
>> +
>> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
>> +				 const struct nft_expr *expr)
>> +{
>> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
>> +
>> +	switch (ctx->family) {
>> +	case NFPROTO_IPV4:
>> +		nf_synproxy_ipv4_fini(snet, ctx->net);
>> +		break;
>> +	case NFPROTO_IPV6:
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
>> +		break;
>> +	case NFPROTO_INET:
>> +		nf_synproxy_ipv4_fini(snet, ctx->net);
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
>> +		break;
>> +	}
>> +	nf_ct_netns_put(ctx->net, ctx->family);
>> +}
>> +
>> +static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
>> +{
>> +	const struct nft_synproxy *priv = nft_expr_priv(expr);
>> +
>> +	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, ntohs(priv->mss)))
>> +		goto nla_put_failure;
>> +
>> +	if (nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->wscale))
>> +		goto nla_put_failure;
>> +
>> +	if (nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, ntohl(priv->flags)))
> 
> Probably:
> 
> 	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, ntohs(priv->mss)) ||
>             nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->wscale) ||
>             nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, ntohl(priv->flags)))
> 		goto nla_put_failure;
> 
> so we save a bit of LoC.
> 
>> +	return 0;
>> +
>> +nla_put_failure:
>> +	return -1;
>> +}
>> +
>> +static int nft_synproxy_validate(const struct nft_ctx *ctx,
>> +				 const struct nft_expr *expr,
>> +				 const struct nft_data **data)
>> +{
>> +	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
>> +						    (1 << NF_INET_FORWARD));
>> +}
>> +
>> +static struct nft_expr_type nft_synproxy_type;
>> +static const struct nft_expr_ops nft_synproxy_ops = {
>> +	.eval		= nft_synproxy_eval,
>> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_synproxy)),
>> +	.init		= nft_synproxy_init,
>> +	.destroy	= nft_synproxy_destroy,
>> +	.dump		= nft_synproxy_dump,
>> +	.type		= &nft_synproxy_type,
>> +	.validate	= nft_synproxy_validate,
>> +};
>> +
>> +static struct nft_expr_type nft_synproxy_type __read_mostly = {
>> +	.ops		= &nft_synproxy_ops,
>> +	.name		= "synproxy",
>> +	.owner		= THIS_MODULE,
>> +	.policy		= nft_synproxy_policy,
>> +	.maxattr	= NFTA_OSF_MAX,
>> +};
>> +
>> +static int __init nft_synproxy_module_init(void)
>> +{
>> +	return nft_register_expr(&nft_synproxy_type);
>> +}
>> +
>> +static void __exit nft_synproxy_module_exit(void)
>> +{
>> +	return nft_unregister_expr(&nft_synproxy_type);
>> +}
>> +
>> +module_init(nft_synproxy_module_init);
>> +module_exit(nft_synproxy_module_exit);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
>> +MODULE_ALIAS_NFT_EXPR("synproxy");
>> -- 
>> 2.20.1
>>
