From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 14/16] xtables: Support pure nft
 expressions for DNAT extension
Date: Fri, 9 Aug 2013 23:56:11 +0200
Message-ID: <20130809215611.GC7102@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-15-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48831 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031243Ab3HIV4h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:56:37 -0400
Content-Disposition: inline
In-Reply-To: <1376055090-26551-15-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:31:28PM +0300, Tomasz Bursztyka wrote:
> Add the support for DNAT xtables extensions to be expressed directly into
> pure nft expression and not more via the compatible expression "target".
> Provide also the function to register the different pattern of such
> extension when expressed purely in nft so it can be parsed back, and the
> memory blob can be recreated. Given callback from the core will then
> feed the command structure relevantly.
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  extensions/libipt_DNAT.c | 221 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 221 insertions(+)
> 
> diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
> index ff18799..f6f0769 100644
> --- a/extensions/libipt_DNAT.c
> +++ b/extensions/libipt_DNAT.c
> @@ -7,6 +7,7 @@
>  #include <limits.h> /* INT_MAX in ip_tables.h */
>  #include <linux/netfilter_ipv4/ip_tables.h>
>  #include <linux/netfilter/nf_nat.h>
> +#include <linux/netfilter/nf_tables.h>
>  
>  enum {
>  	O_TO_DEST = 0,
> @@ -242,6 +243,224 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
>  	}
>  }
>  
> +static struct nft_rule_expr *
> +add_nat_data(struct nft_rule *rule, int reg, uint32_t data)
> +{
> +	struct nft_rule_expr *expr;
> +
> +	expr = nft_rule_expr_alloc("immediate");
> +	if (expr == NULL)
> +		return NULL;
> +
> +	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DREG, reg);
> +	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DATA, data);
> +
> +	nft_rule_add_expr(rule, expr);
> +
> +	return expr;
> +}
> +
> +static int add_nat_expr(struct nft_rule *rule,
> +			const struct nf_nat_ipv4_range *r)
> +{
> +	struct nft_rule_expr *nat_expr;
> +	int registers = 1;
> +
> +	nat_expr = nft_rule_expr_alloc("nat");
> +	if (nat_expr == NULL)
> +		return -1;
> +
> +	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_TYPE, NFT_NAT_DNAT);
> +	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_FAMILY, AF_INET);
> +
> +	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
> +		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_ADDR_MIN,
> +				      registers);
> +		if (add_nat_data(rule, registers, r->min_ip) == NULL)
> +			goto error;
> +		registers++;
> +
> +		if (r->max_ip != r->min_ip) {
> +			nft_rule_expr_set_u32(nat_expr,
> +					      NFT_EXPR_NAT_REG_ADDR_MAX,
> +					      registers);
> +			if (add_nat_data(rule, registers, r->max_ip) == NULL)
> +				goto error;
> +			registers++;
> +		}
> +	}
> +
> +	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
> +		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_PROTO_MIN,
> +				      registers);
> +		if (add_nat_data(rule, registers,
> +					ntohs(r->min.tcp.port)) == NULL)
> +			goto error;
> +		registers++;
> +
> +		if (r->max.tcp.port != r->min.tcp.port) {
> +			nft_rule_expr_set_u32(nat_expr,
> +					      NFT_EXPR_NAT_REG_PROTO_MAX,
> +					      registers);
> +			if (add_nat_data(rule, registers,
> +					ntohs(r->max.tcp.port)) == NULL)
> +				goto error;
> +		}
> +	}
> +
> +	nft_rule_add_expr(rule, nat_expr);
> +
> +	return 0;
> +
> +error:
> +	nft_rule_expr_free(nat_expr);
> +	return -1;
> +}
> +
> +static int DNAT_to_nft(struct nft_rule *rule, struct xt_entry_target *target)
> +{
> +	const struct ipt_natinfo *info = (const void *)target;
> +	int i;
> +
> +	for (i = 0; i < info->mr.rangesize; i++) {
> +		if (add_nat_expr(rule, &info->mr.range[i]) < 0)
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void get_nat_port(struct nft_rule_expr *expr, uint16_t *data)
> +{
> +	uint32_t value;
> +
> +	value = nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_DATA);
> +	*data = htons((uint16_t) value);
> +}
> +
> +static int DNAT_parse_nft(struct nft_trans_rule_context *rule_ctx,
> +			  struct nft_trans_instruction_context *first,
> +			  struct nft_trans_instruction_context *last,
> +			  nft_trans_parse_callback_f user_cb,
> +			  void *user_data)
> +{
> +	struct nft_rule_expr *e_nat, *e;
> +	struct nf_nat_ipv4_range range;
> +	struct ipt_natinfo *info;
> +	uint32_t type, reg;
> +
> +	if (user_cb == NULL)
> +		return -1;
> +
> +	e_nat = nft_trans_instruction_context_get_expr(last);
> +
> +	if (!nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_TYPE))
> +		return -1;
> +
> +	type = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_TYPE);
> +	if (type != NFT_NAT_DNAT)
> +		return -1;
> +
> +	if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_ADDR_MIN)) {
> +		range.flags |= NF_NAT_RANGE_MAP_IPS;
> +
> +		reg = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_REG_ADDR_MIN);
> +		e = nft_trans_instruction_context_get_register(last, reg);
> +		range.min_ip = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_DATA);
> +
> +		if (nft_rule_expr_is_set(e_nat,	NFT_EXPR_NAT_REG_ADDR_MAX)) {
> +			reg = nft_rule_expr_get_u32(e_nat,
> +						NFT_EXPR_NAT_REG_ADDR_MAX);
> +			e = nft_trans_instruction_context_get_register(last, reg);
> +			range.max_ip = nft_rule_expr_get_u32(e,
> +							NFT_EXPR_IMM_DATA);
> +		} else
> +			range.max_ip = range.min_ip;
> +	}
> +
> +	if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_PROTO_MIN)) {
> +		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> +
> +		reg = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_REG_PROTO_MIN);
> +		e = nft_trans_instruction_context_get_register(last, reg);
> +		get_nat_port(e, &range.min.tcp.port);
> +
> +		if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_PROTO_MAX)) {
> +			reg = nft_rule_expr_get_u32(e_nat,
> +						NFT_EXPR_NAT_REG_PROTO_MAX);
> +			e = nft_trans_instruction_context_get_register(last, reg);
> +			get_nat_port(e, &range.max.tcp.port);
> +		} else
> +			range.max.tcp.port = range.min.tcp.port;
> +	}

This approach results in a fairly large parsing function. Note that
we'll have similar functions in SNAT and DNAT both for ipv4 and ipv6.
We have to find a better way to avoid bloating the existing
extensions.

> +
> +	info = calloc(1, sizeof(struct ipt_natinfo));
> +	if (info == NULL)
> +		return -1;
> +
> +	info = append_range(NULL, &range);
> +	if (user_cb("DNAT", &info->t, user_data) != 0) {
> +		free(info);
> +		return -1;
> +	}

The current kernels only support nat rangesize of 1 element, so no
need for this append_range handling.
