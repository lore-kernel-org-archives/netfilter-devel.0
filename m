From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 10:44:35 +0000
Message-ID: <20151124104434.GI2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44703 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbbKXKoj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:44:39 -0500
Content-Disposition: inline
In-Reply-To: <1448359331-12692-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
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

Minor style issue: we got rid of putting the operator on the next line
everywhere. Let's keep this consistent.
