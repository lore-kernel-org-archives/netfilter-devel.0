Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD023C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 09:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96BF72054F
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 09:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfFXJpt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 05:45:49 -0400
Received: from mail.us.es ([193.147.175.20]:57084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfFXJpt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 05:45:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5FE911EF41
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2019 11:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1C2BDA720
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2019 11:45:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 97645DA704; Mon, 24 Jun 2019 11:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6D01DA704;
        Mon, 24 Jun 2019 11:45:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Jun 2019 11:45:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7C94540705C3;
        Mon, 24 Jun 2019 11:45:42 +0200 (CEST)
Date:   Mon, 24 Jun 2019 11:45:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190624094542.g5ljle3v5zm66eot@salvia>
References: <20190622165235.2276-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622165235.2276-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 22, 2019 at 06:52:36PM +0200, Fernando Fernandez Mancera wrote:
[...]
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> new file mode 100644
> index 000000000000..33c1318a7c6a
> --- /dev/null
> +++ b/net/netfilter/nft_synproxy.c
> @@ -0,0 +1,298 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/types.h>
> +#include <net/ip.h>
> +#include <net/tcp.h>
> +#include <net/netlink.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_synproxy.h>
> +#include <net/netfilter/nf_synproxy.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/nf_synproxy.h>
> +
> +struct nft_synproxy {
> +	struct nf_synproxy_info	info;
> +};
> +
> +static const struct nla_policy nft_synproxy_policy[NFTA_SYNPROXY_MAX + 1] = {
> +	[NFTA_SYNPROXY_MSS]		= { .type = NLA_U16 },
> +	[NFTA_SYNPROXY_WSCALE]		= { .type = NLA_U8 },
> +	[NFTA_SYNPROXY_FLAGS]		= { .type = NLA_U32 },
> +};
> +
> +static void nft_synproxy_tcp_options(struct synproxy_options *opts,
> +				     const struct tcphdr *tcp,
> +				     struct synproxy_net *snet,
> +				     struct nf_synproxy_info *info,
> +				     struct nft_synproxy *priv)
> +{
> +	this_cpu_inc(snet->stats->syn_received);
> +	if (tcp->ece && tcp->cwr)
> +		opts->options |= NF_SYNPROXY_OPT_ECN;
> +
> +	opts->options &= priv->info.options;
> +	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
> +		synproxy_init_timestamp_cookie(info, opts);
> +	else
> +		opts->options &= ~(NF_SYNPROXY_OPT_WSCALE |
> +				  NF_SYNPROXY_OPT_SACK_PERM |
> +				  NF_SYNPROXY_OPT_ECN);
> +}
> +
> +static void nft_synproxy_eval_v4(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt,
> +				 const struct tcphdr *tcp,
> +				 struct tcphdr *_tcph,
> +				 struct synproxy_options *opts)
> +{
> +	struct nft_synproxy *priv = nft_expr_priv(expr);
> +	struct nf_synproxy_info info = priv->info;
> +	struct net *net = nft_net(pkt);
> +	struct synproxy_net *snet = synproxy_pernet(net);
> +	struct sk_buff *skb = pkt->skb;
> +
> +	if (tcp->syn) {
> +		/* Initial SYN from client */
> +		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
> +		synproxy_send_client_synack(net, skb, tcp, opts);
> +		consume_skb(skb);
> +		regs->verdict.code = NF_STOLEN;
> +		return;
> +	} else if (tcp->ack) {
> +		/* ACK from client */
> +		if (synproxy_recv_client_ack(net, skb, tcp, opts,
> +					     ntohl(tcp->seq))) {
> +			consume_skb(skb);
> +			regs->verdict.code = NF_STOLEN;
> +		} else {
> +			regs->verdict.code = NF_DROP;
> +		}
> +		return;
> +	}
> +
> +	regs->verdict.code = NFT_CONTINUE;

No need for explicit NFT_CONTINUE, remove this line, this is the
implicit verdict (ie. if no verdict is specified, code is set to
NFT_CONTINUE).

Then, you can remove the "return;" in the branch above.

> +}
> +
> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
> +static void nft_synproxy_eval_v6(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt,
> +				 const struct tcphdr *tcp,
> +				 struct tcphdr *_tcph,
> +				 struct synproxy_options *opts)
> +{
> +	struct nft_synproxy *priv = nft_expr_priv(expr);
> +	struct nf_synproxy_info info = priv->info;
> +	struct net *net = nft_net(pkt);
> +	struct synproxy_net *snet = synproxy_pernet(net);
> +	struct sk_buff *skb = pkt->skb;
> +
> +	if (tcp->syn) {
> +		/* Initial SYN from client */
> +		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
> +		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
> +		consume_skb(skb);
> +		regs->verdict.code = NF_STOLEN;
> +		return;
> +	} else if (tcp->ack) {
> +		/* ACK from client */
> +		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
> +						  ntohl(tcp->seq))) {
> +			consume_skb(skb);
> +			regs->verdict.code = NF_STOLEN;
> +		} else {
> +			regs->verdict.code = NF_DROP;
> +		}
> +		return;
> +	}
> +
> +	regs->verdict.code = NFT_CONTINUE;

Same comment here.

> +}
> +#endif /* CONFIG_NF_TABLES_IPV6*/
> +
> +static void nft_synproxy_eval(const struct nft_expr *expr,
> +			      struct nft_regs *regs,
> +			      const struct nft_pktinfo *pkt)
> +{
> +	struct synproxy_options opts = {};
> +	struct sk_buff *skb = pkt->skb;
> +	int thoff = pkt->xt.thoff;
> +	const struct tcphdr *tcp;
> +	struct tcphdr _tcph;
> +

from here...

> +	tcp = skb_header_pointer(skb, pkt->xt.thoff,
> +				 sizeof(struct tcphdr),
> +				 &_tcph);

to here. Move this below...

> +	if (pkt->tprot != IPPROTO_TCP) {
> +		regs->verdict.code = NFT_BREAK;
> +		return;
> +	}
> +
> +	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +

Here. Place error check close to function call.

> +	if (!tcp) {
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
> +	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		nft_synproxy_eval_v4(expr, regs, pkt, tcp, &_tcph, &opts);
> +		return;
> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
> +	case htons(ETH_P_IPV6):
> +		nft_synproxy_eval_v6(expr, regs, pkt, tcp, &_tcph, &opts);
> +		return;
> +#endif
> +	}
> +	regs->verdict.code = NFT_BREAK;
> +}
> +
> +static int nft_synproxy_init(const struct nft_ctx *ctx,
> +			     const struct nft_expr *expr,
> +			     const struct nlattr * const tb[])
> +{
> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> +	struct nft_synproxy *priv = nft_expr_priv(expr);
> +	u32 flags;
> +	int err;
> +
> +	if (tb[NFTA_SYNPROXY_MSS])
> +		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
> +	if (tb[NFTA_SYNPROXY_WSCALE])
> +		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
> +	if (tb[NFTA_SYNPROXY_FLAGS]) {
> +		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
> +		if (flags != 0 && (flags & NF_SYNPROXY_OPT_MASK) == 0)
> +			return -EINVAL;
> +		priv->info.options = flags;
> +	}
> +
> +	err = nf_ct_netns_get(ctx->net, ctx->family);
> +	if (err)
> +		return err;
> +
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref4++;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6:
> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref6++;
> +		break;
> +	case NFPROTO_INET:
> +	case NFPROTO_BRIDGE:
> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref4++;
> +		snet->hook_ref6++;
> +		break;
> +#endif
> +	}
> +
> +	return 0;
> +
> +nf_ct_failure:
> +	nf_ct_netns_put(ctx->net, ctx->family);
> +	return err;
> +}
> +
> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
> +				 const struct nft_expr *expr)
> +{
> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> +
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6:
> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> +		break;
> +	case NFPROTO_INET:

missing
        case NFPROTO_BRIDGE:

> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> +		break;
> +#endif
> +	}
> +	nf_ct_netns_put(ctx->net, ctx->family);
> +}
> +
> +static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_synproxy *priv = nft_expr_priv(expr);
> +
> +	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, ntohs(priv->info.mss)) ||
> +	    nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->info.wscale) ||
> +	    nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, ntohl(priv->info.options)))
> +		goto nla_put_failure;
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
> +
> +static int nft_synproxy_validate(const struct nft_ctx *ctx,
> +				 const struct nft_expr *expr,
> +				 const struct nft_data **data)
> +{
> +	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
> +						    (1 << NF_INET_FORWARD));
> +}
> +
> +static struct nft_expr_type nft_synproxy_type;
> +static const struct nft_expr_ops nft_synproxy_ops = {
> +	.eval		= nft_synproxy_eval,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_synproxy)),
> +	.init		= nft_synproxy_init,
> +	.destroy	= nft_synproxy_destroy,
> +	.dump		= nft_synproxy_dump,
> +	.type		= &nft_synproxy_type,
> +	.validate	= nft_synproxy_validate,
> +};
> +
> +static struct nft_expr_type nft_synproxy_type __read_mostly = {
> +	.ops		= &nft_synproxy_ops,
> +	.name		= "synproxy",
> +	.owner		= THIS_MODULE,
> +	.policy		= nft_synproxy_policy,
> +	.maxattr	= NFTA_OSF_MAX,
> +};
> +
> +static int __init nft_synproxy_module_init(void)
> +{
> +	return nft_register_expr(&nft_synproxy_type);
> +}
> +
> +static void __exit nft_synproxy_module_exit(void)
> +{
> +	return nft_unregister_expr(&nft_synproxy_type);
> +}
> +
> +module_init(nft_synproxy_module_init);
> +module_exit(nft_synproxy_module_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
> +MODULE_ALIAS_NFT_EXPR("synproxy");
> -- 
> 2.20.1
> 
