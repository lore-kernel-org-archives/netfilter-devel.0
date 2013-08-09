From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 04/16] nft: Integrate nft
 translator engine in current core
Date: Fri, 9 Aug 2013 23:24:54 +0200
Message-ID: <20130809212454.GA7102@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-5-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47480 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031121Ab3HIVZG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:25:06 -0400
Content-Disposition: inline
In-Reply-To: <1376055090-26551-5-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Fri, Aug 09, 2013 at 04:31:18PM +0300, Tomasz Bursztyka wrote:
[...]
> +static int nft_parse_ip_addresses(struct nft_trans_rule_context *rule_ctx,
> +				  struct nft_trans_instruction_context *first,
> +				  struct nft_trans_instruction_context *last,
> +				  nft_trans_parse_callback_f user_cb,
> +				  void *user_data)
> +{
> +	struct nft_to_cs_data *i2cs = user_data;
> +	struct nft_rule_expr *e1, *e2;
> +	struct nft_family_ops *ops;
> +	uint32_t offset;
> +
> +	e1 = nft_trans_instruction_context_get_expr(first);
> +	if (!nft_rule_expr_is_set(e1, NFT_EXPR_PAYLOAD_OFFSET))
> +		return -1;
> +
> +	offset = nft_rule_expr_get_u32(e1, NFT_EXPR_PAYLOAD_OFFSET);
> +	ops = nft_family_ops_lookup(i2cs->family);
> +
> +	first = nft_trans_instruction_context_get_next(first);
> +	e1 = nft_trans_instruction_context_get_expr(first);
> +	e2 = nft_trans_instruction_context_get_expr(last);
> +
> +	ops->parse_payload(e1, e2, i2cs->cs, offset);
> +
> +	return 0;
> +}
> +
[...]
> +static struct nft_trans_instruction nft_ipt_io_ifs = {
> +	.instructions = nft_ipt_io_ifs_instructions,
> +	.function = nft_parse_io_ifs,
> +};
> +
> +static enum nft_instruction nft_ipt_ip_addr_instructions_1[] = {
> +	NFT_INSTRUCTION_PAYLOAD, NFT_INSTRUCTION_CMP,
> +	NFT_INSTRUCTION_MAX,
> +};
> +
> +static struct nft_trans_instruction nft_ipt_ip_addr_1 = {
> +	.instructions = nft_ipt_ip_addr_instructions_1,
> +	.function = nft_parse_ip_addresses,
> +};
> +
> +static enum nft_instruction nft_ipt_ip_addr_instructions_2[] = {
> +	NFT_INSTRUCTION_PAYLOAD, NFT_INSTRUCTION_BITWISE, NFT_INSTRUCTION_CMP,
> +	NFT_INSTRUCTION_MAX,
> +};

If I understood this correctly, your approach uses the array of
instructions above as keys to look up for the corresponding parser. In
that case, I'm afraid that this engine won't cover the complexity of
the payload instructions since we'll end up having *a lot* of matching
combinations that will overlap in your tree. You cannot resolve that
ambiguity problem of what parser needs to be invoked without looking
at other information that is contained in the instruction, eg. payload
base and offset.

Regards.
