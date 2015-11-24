From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:22:45 +0100
Message-ID: <20151124102245.GD2683@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38284 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbbKXKWv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:22:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 597E0FEFA8
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:22:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 49AB3DA869
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:22:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 55B79DA85F
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:22:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448359331-12692-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:02:06AM +0100, Florian Westphal wrote:
> +void nf_tables_trace_notify(const struct nft_pktinfo *pkt,
> +			    const struct nft_chain *chain,
> +			    const struct nft_rule *rule,
> +			    u32 verdict,
> +			    enum nft_trace_types type)
> +{
> +	struct nfgenmsg *nfmsg;
> +	struct nlmsghdr *nlh;
> +	struct sk_buff *skb;
> +	unsigned int size;
> +	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_TRACE;
> +
> +	if (!nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
> +		return;
> +
> +	/* Unlike other notifiers we need GFP_ATOMIC so use actual size
> +	 * needed instead of NLMSG_GOODSIZE.
> +	 */
> +	size = nlmsg_total_size(sizeof(struct nfgenmsg))
> +		+ nla_total_size(sizeof(__be32))	/* trace type */
> +		+ nla_total_size(NFT_TABLE_MAXNAMELEN)
> +		+ nla_total_size(NFT_CHAIN_MAXNAMELEN)
> +		+ nla_total_size(sizeof(u32))	/* iif */
> +		+ nla_total_size(sizeof(u32))	/* oif */
> +		+ nla_total_size(sizeof(u32))	/* id */
> +		+ nla_total_size(sizeof(u32))	/* mark */
> +		+ nla_total_size(sizeof(u32))	/* verdict */
> +		+ nla_total_size(sizeof(__be64)); /* rule handle */
> +
> +	switch (type) {
> +	case NFT_TRACETYPE_PACKET:
> +		size += nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE)
> +			+ nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE)
> +			+ nla_total_size(NFT_TRACETYPE_LL_HSIZE)
> +			+ nla_total_size(sizeof(__be16)) /* vlan tag */
> +			+ nla_total_size(sizeof(__be16)) /* device type */
> +			+ nla_total_size(sizeof(__u8));  /* transport prot */
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	skb = nlmsg_new(size, GFP_ATOMIC);
> +	if (!skb)
> +		return;
> +
> +	nlh = nlmsg_put(skb, 0, 0, event, sizeof(struct nfgenmsg), 0);
> +	if (!nlh)
> +		goto nla_put_failure;
> +
> +	nfmsg = nlmsg_data(nlh);
> +	nfmsg->nfgen_family	= pkt->pf;
> +	nfmsg->version		= NFNETLINK_V0;
> +	nfmsg->res_id		= htons(pkt->net->nft.base_seq & 0xffff);
> +
> +	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(type)))
> +		goto nla_put_failure;
> +
> +	if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash32_ptr(pkt->skb))))
> +		goto nla_put_failure;
> +
> +	if (chain) {
> +		if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
> +			goto nla_put_failure;
> +		if (nla_put_string(skb, NFTA_TRACE_CHAIN, chain->name))
> +			goto nla_put_failure;
> +	}
> +
> +	if (rule && nla_put_be64(skb, NFTA_TRACE_RULE_HANDLE,
> +				 cpu_to_be64(rule->handle)))
> +		goto nla_put_failure;
> +
> +	if (pkt->in &&
> +	    nla_put_be32(skb, NFTA_TRACE_IIF, htonl(pkt->in->ifindex)))
> +		goto nla_put_failure;
> +	if (pkt->out &&
> +	    nla_put_be32(skb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> +		goto nla_put_failure;
> +	if (pkt->skb->mark &&
> +	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
> +		goto nla_put_failure;
> +
> +	switch (type) {
> +	case NFT_TRACETYPE_POLICY:
> +	case NFT_TRACETYPE_RETURN:
> +	case NFT_TRACETYPE_RULE:
> +		if (nla_put_be32(skb, NFTA_TRACE_VERDICT, htonl(verdict)))
> +			goto nla_put_failure;
> +		break;
> +	case NFT_TRACETYPE_PACKET:
> +		if (!trace_notify_put_packet(skb, pkt))
> +			goto nla_put_failure;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	nlmsg_end(skb, nlh);
> +	nfnetlink_send(skb, pkt->net, 0, NFNLGRP_NFTABLES, 0, GFP_ATOMIC);

BTW, do we really want to use the default NFNLGRP_NFTABLES group?

multicast group provide a simple way for filtering out what you don't
need from kernelspace. And you can still subscribe both groups
NFNLGRP_NFTABLES and NFNLGRP_NFTABLES_TRACE.

I'm telling this when thinking of nft-sync. Why should it be receiving
this spamming tracing events when it only cares about ruleset updates?

And specifically netlink bandwidth is limited from packet context.
