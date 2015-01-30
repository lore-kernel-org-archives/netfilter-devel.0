From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 3/4 v4] example: Parse and create netlink
 message using the new parsing functions.
Date: Fri, 30 Jan 2015 20:43:53 +0100
Message-ID: <20150130194353.GA23741@salvia>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
 <1422628525-28109-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51876 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbbA3Tkt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 14:40:49 -0500
Content-Disposition: inline
In-Reply-To: <1422628525-28109-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 30, 2015 at 03:35:24PM +0100, Alvaro Neira Ayuso wrote:
> +							   NFT_SET_ATTR_FAMILY),
> +					      type, seq++);
> +		nft_set_elems_nlmsg_build_payload(nlh, tmp);
> +		mnl_nlmsg_batch_next(batch);
> +		elem = nft_set_elems_iter_next(iter_elems);
> +	}
> +
> +	return 0;
> +}
> +
> +static int nft_ruleset_set(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd)
> +{
> +
> +	struct nlmsghdr *nlh;
> +	uint16_t type = 0, cmd = 0;
> +	struct nft_set *set;
> +
> +	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	if (set == NULL)
> +		return -1;
> +
> +	switch (ctx_cmd) {
> +	case NFT_CMD_ADD:
> +		cmd = NFT_MSG_NEWSET;

Please, choose variable name that stick to the semantics: this is nl_type.

> +		type = NLM_F_CREATE|NLM_F_ACK;

and this is nl_flags.

Then, you don't need that ctx_cmd and cmd. Make this change to all
similar functions in this code.

> +		break;
> +	case NFT_CMD_DELETE:
> +		cmd = NFT_MSG_DELSET;
> +		type = NLM_F_ACK;
> +		break;
> +	}
> +
> +	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +				      cmd,
> +				      nft_set_attr_get_u32(set,
> +							   NFT_SET_ATTR_FAMILY),
> +				      type,
> +				      seq++);
> +
> +	nft_set_nlmsg_build_payload(nlh, set);
> +
> +	mnl_nlmsg_batch_next(batch);
> +
> +	if (nft_ruleset_set_elems(ctx, ctx_cmd) < 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int nft_ruleset_rule(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd,
> +			    struct nft_rule *nlr)
> +{
> +	struct nlmsghdr *nlh;
> +	uint16_t type = 0, cmd = 0;
> +	struct nft_rule *rule;
> +
> +	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_RULE))
> +		rule = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
> +	else
> +		rule = nlr;
> +
> +	if (rule == NULL)
> +		return -1;
> +
> +	switch (ctx_cmd) {
> +	case NFT_CMD_ADD:
> +		cmd = NFT_MSG_NEWRULE;
> +		type = NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK;
> +		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);

This reminds me that we need a NFT_RULE_OF_NOHANDLE to skip exporting
the handling on demand via nft_rule_snprintf().
