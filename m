From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC libnftnl PATCH 1/2] src: add mnlio API functions
Date: Wed, 12 Feb 2014 15:03:52 +0100
Message-ID: <20140212140352.GA20679@localhost>
References: <20140205191711.9979.23980.stgit@nfdev.cica.es>
 <20140205191746.9979.44016.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44214 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaBLOEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:04:02 -0500
Content-Disposition: inline
In-Reply-To: <20140205191746.9979.44016.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Wed, Feb 05, 2014 at 08:17:47PM +0100, Arturo Borrero Gonzalez wrote:
> These functions are likely to be used by all userspace programs to interact
> with the nftables kernel subsystem.
> 
> Lets put in the library, so: its easy to maintain, we can save lots of LOCs,
> programmers can easily learn how to work with nftables, etc..

See comments below.

[...]

> +void nft_mnlio_batch_put(struct mnl_nlmsg_batch *batch, int type,
> +			 uint32_t seqnum)
> +{
> +	struct nlmsghdr *nlh;
> +	struct nfgenmsg *nfg;
> +
> +	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
> +	nlh->nlmsg_type = type;
> +	nlh->nlmsg_flags = NLM_F_REQUEST;
> +	nlh->nlmsg_seq = seqnum;
> +
> +	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> +	nfg->nfgen_family = AF_INET;
> +	nfg->version = NFNETLINK_V0;
> +	nfg->res_id = NFNL_SUBSYS_NFTABLES;
> +
> +	mnl_nlmsg_batch_next(batch);
> +}
> +EXPORT_SYMBOL(nft_mnlio_batch_put);

You can rename and export this as: nft_batch_nlmsg_build_hdr, it
should take a 'void *buf' instead of struct mnl_nlmsg_batch *batch, so
we don't force people to use libmnl batching infrastructure. The type
should be uint16_t. Add this function to src/batch.c.

> +/*
> + * Rule
> + */
> +int nft_mnlio_rule_add(struct nft_rule *nlr, unsigned int flags,

use fixed types, ie. uint32_t instead of unsigned int.

> +		       struct mnl_nlmsg_batch *batch)

use void *buf instead of the struct mnl_nlmsg_batch *batch, so we can
pass a simple char buf[...] or mnl_nlmsg_batch_current(batch).

> +{
> +	struct nlmsghdr *nlh;
> +
> +	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +			NFT_MSG_NEWRULE,
> +			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
> +			NLM_F_CREATE | flags, nft_mnlio_seqnum_alloc());
                        ^----------^
                   no assumptions on any flag, just pass flags.

> +
> +	nft_rule_nlmsg_build_payload(nlh, nlr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(nft_mnlio_rule_add);

Rename this function to nft_rule_build_msg, add it to src/rule.c

[...]
> +int nft_mnlio_rule_del(struct nft_rule *nlr, unsigned int flags,
> +		       struct mnl_nlmsg_batch *batch)

similar comments like in nft_mnlio_rule_add.

> +{
> +	struct nlmsghdr *nlh;
> +
> +	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +			NFT_MSG_DELRULE,
> +			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
> +			0, nft_mnlio_seqnum_alloc());
> +
> +	nft_rule_nlmsg_build_payload(nlh, nlr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(nft_mnlio_rule_del);
>
[...]
>
> +int nft_mnlio_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
> +			unsigned int flags)

> +
> +{
> +	char buf[MNL_SOCKET_BUFFER_SIZE];
> +	struct nlmsghdr *nlh;
> +
> +	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
> +			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
> +			NLM_F_CREATE | NLM_F_ACK | flags, seq);
> +	nft_chain_nlmsg_build_payload(nlh, nlc);

Better add nft_chain_build_msg, similar to nft_rule_build_msg.

Same with tables, rules and so on.

> +
> +	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);

So remove this _talk call. Thus, the netlink interaction is decoupled,
which is more flexible when doing complex stuff.

Let's start with those functions first, you can send incremental
patches for other functions that you're including in this patch that
you believe that can be useful to others so we can discuss them.

I detected problems in the rulelist to batch handling in your patch,
you may run out of the batch boundary that may lead to a memory
corruption.
