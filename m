From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 libnftnl 1/3] src: add trace infrastructure support
Date: Thu, 26 Nov 2015 22:11:37 +0000
Message-ID: <20151126221137.GA10961@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbbKZWLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 17:11:47 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
>   - add NFTNL_TRACE_QUEUE_ID to obtain nfqueue number
>   - NF_VERDICT is normalized in this case, i.e.
>   if verdict from kernel is '42 << 16 | NF_QUEUE', make
>   NF_QUEUE the verdict and put the queue number ->queue_id, accessible
>   via NFTNL_TRACE_QUEUE_ID.
> 
> +static int nftnl_trace_parse_verdict_cb(const struct nlattr *attr, void *data)
> +{
> +	int type = mnl_attr_get_type(attr);
> +	const struct nlattr **tb = data;
> +
> +	switch (type) {
> +	case NFTA_VERDICT_CODE:
> +		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
> +			abi_breakage();
> +		tb[type] = attr;
> +		break;
> +	case NFTA_VERDICT_CHAIN:
> +		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
> +			abi_breakage();
> +		tb[type] = attr;
> +		break;
> +	}
> +
> +	return MNL_CB_OK;
> +}
> +
> +static void
> +nftnl_trace_parse_verdict(const struct nlattr *attr, struct nftnl_trace *t)
> +{
> +	struct nlattr *tb[NFTA_VERDICT_MAX+1];
> +
> +	mnl_attr_parse_nested(attr, nftnl_trace_parse_verdict_cb, tb);
> +
> +	if (!tb[NFTA_VERDICT_CODE])
> +		abi_breakage();
> +
> +	t->verdict = ntohl(mnl_attr_get_u32(tb[NFTA_VERDICT_CODE]));
> +	t->flags |= (1 << NFTNL_TRACE_VERDICT);
> +
> +	switch (t->verdict) {
> +	case NFT_GOTO: /* fallthough */
> +	case NFT_JUMP:
> +		if (!tb[NFTA_VERDICT_CHAIN])
> +			abi_breakage();
> +		t->jump_target = strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
> +		if (t->jump_target)
> +			t->flags |= (1 << NFTNL_TRACE_JUMP_TARGET);
> +		break;
> +	case NFT_RETURN: /* all other NFT_* cases fall through */
> +	case NFT_CONTINUE:
> +	case NFT_BREAK:
> +		break;
> +	case NF_ACCEPT: /* standard verdicts fall though */
> +	case NF_DROP:
> +	case NF_STOLEN:
> +	case NF_REPEAT:
> +	case NF_STOP:
> +		break;
> +	default: /* Unknown NF_ verdict, or verdict contains extra data */
> +		switch (t->verdict & NF_VERDICT_MASK) {
> +		case NF_QUEUE:
> +			t->queue_id = t->verdict >> 16;
> +			t->verdict = NF_QUEUE;
> +			t->flags |= (1 << NFTNL_TRACE_QUEUE_ID);
> +			break;
> +		}
> +		break;
> +	}
> +}

This doesn't handle NF_DROP_ERRNO() codes. I would suggest using
nftnl_parse_verdict() and struct nftnl_data_reg so we have a common
interface for verdicts. Mid term I'd prefer if we pass around verdict
structs and have an interface for those instead of having
IMM_VERDICT/IMM_CHAIN, SET_ELEM_VERDICT/SET_ELEM_CHAIN, ...

Regarding the NFTNL_TRACE_QUEUE_ID, I'm not convinced this is a good
way to go. We'd need another NFTNL_TRACE_DROP_VERDICT_ERRNO or something
like that, and the user needs to make another distinction on which further
attributes to get based on the verdict itself. It seems easier to just
decode it in the user and don't try to put too much knowledge in the
library, it's after all just meant for communication.
