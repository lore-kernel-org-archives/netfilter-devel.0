Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07963C43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 13:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A952084E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 13:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="f75silCB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFUNBE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 09:01:04 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58098 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfFUNBE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 09:01:04 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id DBF591A2F9B;
        Fri, 21 Jun 2019 06:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1561122063; bh=lRQ4STQTnFesX3qTq68iwnFqmCby9exPuXqJoMVWp+8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=f75silCBzOUrz26S+ZX+/EoYDWcCUTA1o2gVQdBc5/GSn+9STl5ZwYJ/dGuaeSXYZ
         Z/AG2+3gYMxz8QC9s+Bh6FnkIrRkMdbBdJG8nEZ5PBmBPCPkhfcwwCxl/vPtor34KP
         Hkt7EpCYsOlGvYQlMw06cjftuJ6C4cQ8vohMbAYw=
X-Riseup-User-ID: 1AFDC3AF844E0EABBA06E5B85992B9172DA654F1AF9CD0B6255E1F8C130C8650
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id DBE4512091E;
        Fri, 21 Jun 2019 06:01:01 -0700 (PDT)
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: Add SYNPROXY support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190619180654.1432-1-ffmancera@riseup.net>
 <20190620141008.6dcgzgynbyfxkvf2@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <08de40dd-b7eb-0cbe-823d-1e8d9679a148@riseup.net>
Date:   Fri, 21 Jun 2019 15:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <20190620141008.6dcgzgynbyfxkvf2@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, comments below.

On 6/20/19 4:10 PM, Pablo Neira Ayuso wrote:
> On Wed, Jun 19, 2019 at 08:06:54PM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
>> new file mode 100644
>> index 000000000000..3ef7f1dc50be
>> --- /dev/null
>> +++ b/net/netfilter/nft_synproxy.c
>> @@ -0,0 +1,327 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
> 
> Remove empty line above.
> 
>> +#include <linux/types.h>
>> +
> 
> Same here.
> 
>> +#include <net/ip.h>
>> +#include <net/tcp.h>
>> +#include <net/netlink.h>
>> +
> 
> Same here.
> 
>> +#include <net/netfilter/nf_tables.h>
>> +#include <net/netfilter/nf_conntrack.h>
>> +#include <net/netfilter/nf_conntrack_ecache.h>
> 
> I don't think we need this ecache.h header.
> 
>> +#include <net/netfilter/nf_conntrack_extend.h>
> 
> You can remove _extend.h, already included by _synproxy.h
> 
>> +#include <net/netfilter/nf_conntrack_seqadj.h>
> 
> Do we need _seqadj.h?
> 

_seqadj it is requiered by nf_conntrack_synproxy.h. I suggest to move
this include statement there.

>> +#include <net/netfilter/nf_conntrack_synproxy.h>
>> +#include <net/netfilter/nf_synproxy.h>
>> +
> 
> remove empty line.
> 
>> +#include <linux/netfilter/nf_tables.h>
>> +#include <linux/netfilter/nf_SYNPROXY.h>
>> +
>> +struct nft_synproxy {
[...]
>> +
>> +	regs->verdict.code = NFT_CONTINUE;
>> +}
>> +
>> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
>> +static void nft_synproxy_eval_v6(const struct nft_expr *expr,
>> +				 struct nft_regs *regs,
>> +				 const struct nft_pktinfo *pkt)
>> +{
>> +	struct nft_synproxy *priv = nft_expr_priv(expr);
>> +	struct nf_synproxy_info info = priv->info;
>> +	struct synproxy_options opts = {};
>> +	struct net *net = nft_net(pkt);
>> +	struct synproxy_net *snet = synproxy_pernet(net);
>> +	struct sk_buff *skb = pkt->skb;
>> +	int thoff = pkt->xt.thoff;
>> +	const struct tcphdr *tcp;
>> +	struct tcphdr _tcph;
>> +
>> +	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
>> +		regs->verdict.code = NF_DROP;
>> +		return;
>> +	}
>> +
>> +	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
> 
> ip_hdrlen() won't fly for IPv6.
> 

I've decided to use pkt->xt.thoff instead of ip_hdrlen(skb) in order to
do it compatible with IPv4 and IPv6. Do you agree with that?

>> +				 sizeof(struct tcphdr), &_tcph);
>> +	if (!tcp) {
>> +		regs->verdict.code = NF_DROP;
>> +		return;
>> +	}
>> +
>> +	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
>> +		regs->verdict.code = NF_DROP;
>> +		return;
>> +	}
>> +
>> +	if (tcp->syn) {
> 
> From here...
> 
>> +		/* Initial SYN from client */
>> +		this_cpu_inc(snet->stats->syn_received);
>> +
>> +		if (tcp->ece && tcp->cwr)
>> +			opts.options |= NF_SYNPROXY_OPT_ECN;
>> +
>> +		opts.options &= priv->info.options;
>> +		if (opts.options & NF_SYNPROXY_OPT_TIMESTAMP)
>> +			synproxy_init_timestamp_cookie(&info, &opts);
>> +		else
>> +			opts.options &= ~(NF_SYNPROXY_OPT_WSCALE |
>> +					  NF_SYNPROXY_OPT_SACK_PERM |
>> +					  NF_SYNPROXY_OPT_ECN);
> 
> ... to here. Could you wrap this code into a function? eg.
> 
>         nft_synproxy_tcp_options(...);
> 
> that can be shared by v4 and v6.
> 
>> +
>> +		synproxy_send_client_synack_ipv6(net, skb, tcp, &opts);
>> +		consume_skb(skb);
>> +		regs->verdict.code = NF_STOLEN;
>> +		return;
>> +	} else if (tcp->ack) {
>> +		/* ACK from client */
>> +		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, &opts,
>> +						  ntohl(tcp->seq))) {
>> +			consume_skb(skb);
>> +			regs->verdict.code = NF_STOLEN;
>> +		} else {
>> +			regs->verdict.code = NF_DROP;
>> +		}
>> +		return;
>> +	}
>> +
>> +	regs->verdict.code = NFT_CONTINUE;
>> +}
>> +#endif /* CONFIG_NF_TABLES_IPV6*/
>> +
>> +static void nft_synproxy_eval(const struct nft_expr *expr,
>> +			      struct nft_regs *regs,
>> +			      const struct nft_pktinfo *pkt)
>> +{
>> +	struct sk_buff *skb = pkt->skb;
>> +	const struct tcphdr *tcp;
>> +	struct tcphdr _tcph;
>> +
>> +	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
>> +				 sizeof(struct tcphdr), &_tcph);
>> +	if (!tcp) {
>> +		regs->verdict.code = NFT_BREAK;
>> +		return;
>> +	}
> 
> Hm. You should check for pkt->tprot to check if this is really TCP
> before trying to fetch the tcp header.
>>> +	switch (skb->protocol) {
>> +	case htons(ETH_P_IP):
>> +		nft_synproxy_eval_v4(expr, regs, pkt);
>> +		return;
>> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
>> +	case htons(ETH_P_IPV6):
>> +		nft_synproxy_eval_v6(expr, regs, pkt);
>> +		return;
>> +#endif
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
> 
> You just:
> 
>                 return err;
> 
> here, if nf_ct_netns_get() fails.
> 
>> +
>> +	switch (ctx->family) {
>> +	case NFPROTO_IPV4:
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
> 
> Why this manual bump of the reference counter? Doesn't
> nf_synproxy_ipv4_init() deal with this?
>>> +		break;
>> +#if IS_ENABLED(IPV6)
>> +	case NFPROTO_IPV6:
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref6++;
>> +		break;
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
>> +		snet->hook_ref6++;
>> +		break;
>> +#endif
>> +	}
>> +
>> +	if (tb[NFTA_SYNPROXY_MSS])
>> +		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
>> +	if (tb[NFTA_SYNPROXY_WSCALE])
>> +		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
>> +	if (tb[NFTA_SYNPROXY_FLAGS]) {
>> +		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
>> +		if (flags != 0 && (flags & NF_SYNPROXY_OPT_MASK) == 0)
>> +			return -EINVAL;
> 
> This -EINVAL ignores error nf_ct_failure error path. I suggest you
> move this code up to the top of nft_synproxy_init(), before calling
> nf_ct_netns_get().
> 
>> +		priv->info.options = flags;
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
>> +#if IS_ENABLED(IPV6)
> 
> This should be CONFIG_IPV6, right?
> 

Yes, but I think we should check CONFIG_NF_TABLES_IPV6 instead. What do
you think?

>> +	case NFPROTO_IPV6:
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
>> +		break;
> 
> #endif
> 
> for IPV6 here.
> 
>> +	case NFPROTO_INET:
> 
> Missing NFPROTO_BRIDGE here.
> 
>> +		nf_synproxy_ipv4_fini(snet, ctx->net);
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
>> +		break;
>> +#endif
>> +	}
>> +	nf_ct_netns_put(ctx->net, ctx->family);
>> +}
>> +
>> +static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
>> +{
>> +	const struct nft_synproxy *priv = nft_expr_priv(expr);
>> +
>> +	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, ntohs(priv->info.mss)) ||
>> +	    nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->info.wscale) ||
>> +	    nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, ntohl(priv->info.options)))
>> +		goto nla_put_failure;
>> +
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

Thanks Pablo!
