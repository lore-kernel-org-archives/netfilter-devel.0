From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Fri, 27 Nov 2015 08:47:18 +0000
Message-ID: <20151127084718.GD4263@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44388 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbK0IrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 03:47:22 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some more comments on use of the netlink functions below:

On 26.11, Florian Westphal wrote:
> +++ b/net/netfilter/nf_tables_trace.c
> @@ -0,0 +1,253 @@
> +static int trace_fill_header(struct sk_buff *nlskb, u16 type,
> +			     const struct sk_buff *skb,
> +			     int off, unsigned int len)
> +{
> +	struct nlattr *nla;
> +
> +	if (len == 0)
> +		return 0;
> +
> +	if (skb_tailroom(nlskb) < nla_total_size(len))
> +		return -1;
> +
> +	nla = (struct nlattr *)skb_put(nlskb, nla_total_size(len));
> +	nla->nla_type = type;
> +	nla->nla_len = nla_attr_size(len);

nla_reserve()? That will also take care of zeroing the padding.

> +
> +	if (skb_copy_bits(skb, off, nla_data(nla), len))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int nf_trace_fill_meta_info(struct sk_buff *nlskb,
> +				   const struct nft_pktinfo *pkt)
> +{
> +	if (pkt->in) {
> +		if (nla_put_be32(nlskb, NFTA_TRACE_IIF,
> +				 htonl(pkt->in->ifindex)))
> +			return -1;
> +
> +		/* needed for LL_HEADER decode */
> +		if (nla_put_be16(nlskb, NFTA_TRACE_IIFTYPE,
> +				 htons(pkt->in->type)))
> +			return -1;
> +	}
> +
> +	if (pkt->out &&
> +	    nla_put_be32(nlskb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int nf_trace_fill_ll_header(struct sk_buff *nlskb,
> +				   const struct sk_buff *skb)
> +{
> +	struct vlan_ethhdr veth;
> +	unsigned int len, off;
> +
> +	off = skb_mac_header(skb) - skb->data;

off is negative or zero, it should use a signed int I think.

> +
> +	if (skb_copy_bits(skb, off, &veth, ETH_HLEN))
> +		return -1;
> +
> +	veth.h_vlan_proto = skb->vlan_proto;
> +	veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
> +	veth.h_vlan_encapsulated_proto = skb->protocol;
> +
> +	len = min_t(unsigned int,
> +		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);

min_t(unsigned int, -off, NFT_TRACETYPE_LL_HSIZE) ?

> +
> +	if (WARN_ON_ONCE(len != ETH_HLEN))
> +		return -1;

Why the min_t at all if we fail on != ETH_HLEN? I'd simply check that
it is exactly ETH_HLEN before even starting copying.

> +
> +	len = sizeof(veth);
> +	if (skb_tailroom(nlskb) < nla_total_size(len))
> +		return -1;
> +
> +	return nla_put(nlskb, NFTA_TRACE_LL_HEADER, len, &veth);

nla_put() already checks the tailroom.

> +}
> +
> +static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
> +				  const struct nft_pktinfo *pkt)
> +{
> +	const struct sk_buff *skb = pkt->skb;
> +	unsigned int len = min_t(unsigned int,
> +				 pkt->xt.thoff - skb_network_offset(skb),
> +				 NFT_TRACETYPE_NETWORK_HSIZE);
> +	int off = skb_network_offset(skb);
> +
> +	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
> +		return -1;
> +
> +	len = min_t(unsigned int, skb->len - pkt->xt.thoff,
> +		    NFT_TRACETYPE_TRANSPORT_HSIZE);
> +
> +	if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
> +			      pkt->xt.thoff, len))
> +		return -1;
> +
> +	if (!skb_mac_header_was_set(skb))
> +		return 0;
> +
> +	if (skb_vlan_tag_get(skb))
> +		return nf_trace_fill_ll_header(nlskb, skb);
> +
> +	len = min_t(unsigned int,
> +		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
> +	off = skb_mac_header(skb) - skb->data;

Could again avoid the double calculation by using -off in min_t().

> +	return trace_fill_header(nlskb, NFTA_TRACE_LL_HEADER,
> +				 skb, off, len);
> +}
> +
> +static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
> +				    const struct nft_chain *chain)
> +{
> +	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
> +		return -1;
> +
> +	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);

I would not move simple stuff that is only used once like this to another
function. Easier to read if you don't have to jump around in the code.

> +}
> +
> +void nft_trace_notify(struct nft_traceinfo *info,
> +		      const struct nft_pktinfo *pkt)
> +{
> +	struct nfgenmsg *nfmsg;
> +	struct nlmsghdr *nlh;
> +	struct sk_buff *skb;
> +	unsigned int size;
> +	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_TRACE;
> +
> +	if (!nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTRACE))
> +		return;
> +
> +	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
> +		nla_total_size(NFT_TABLE_MAXNAMELEN) +
> +		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
> +		nla_total_size(sizeof(__be64)) +	/* rule handle */
> +		nla_total_size(sizeof(__be32)) +	/* trace type */
> +		nla_total_size(0) +			/* VERDICT, nested */
> +			nla_total_size(sizeof(u32)) +	/* verdict code */
> +			nla_total_size(NFT_CHAIN_MAXNAMELEN) + /* jump target */
> +		nla_total_size(sizeof(u32)) +		/* id */
> +		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
> +		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
> +		nla_total_size(NFT_TRACETYPE_TRANSPORT_HSIZE) +
> +		nla_total_size(sizeof(u32)) +		/* mark */
> +		nla_total_size(sizeof(u32)) +		/* iif */
> +		nla_total_size(sizeof(u32)) +		/* oif */
> +		nla_total_size(sizeof(__be16));		/* device type */
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
> +	nfmsg->res_id		= 0;
> +
> +	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(info->type)))
> +		goto nla_put_failure;
> +
> +	if (trace_fill_id(skb, (unsigned long)pkt->skb))
> +		goto nla_put_failure;
> +
> +	if (info->chain &&
> +	    nf_trace_fill_chain_info(skb, info->chain))
> +		goto nla_put_failure;
> +
> +	if (info->rule &&
> +	    nla_put_be64(skb, NFTA_TRACE_RULE_HANDLE,
> +			 cpu_to_be64(info->rule->handle)))
> +		goto nla_put_failure;
> +
> +	if ((info->type == NFT_TRACETYPE_RETURN ||
> +	     info->type == NFT_TRACETYPE_RULE) &&
> +	    nft_verdict_dump(skb, info->verdict, NFTA_TRACE_VERDICT))
> +		goto nla_put_failure;
> +
> +	if (pkt->skb->mark &&
> +	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
> +		goto nla_put_failure;
> +
> +	if (!info->packet_dumped) {
> +		if (nf_trace_fill_meta_info(skb, pkt))
> +			goto nla_put_failure;
> +
> +		if (nf_trace_fill_pkt_info(skb, pkt))
> +			goto nla_put_failure;
> +		info->packet_dumped = true;
> +	}
> +
> +	nlmsg_end(skb, nlh);
> +	nfnetlink_send(skb, pkt->net, 0, NFNLGRP_NFTRACE, 0, GFP_ATOMIC);
> +	return;
> +
> + nla_put_failure:
> +	WARN_ON_ONCE(1);
> +	kfree_skb(skb);
> +}
> +
> +void nft_trace_start(struct sk_buff *skb)
> +{
> +	u32 seq = atomic_inc_return(&trace_cnt) << NFT_ID_SKB_HASHBITS;
> +
> +	__this_cpu_write(trace_seq, seq);
> +	skb->nf_trace = 1;
> +}
