From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 3/4 v7] example: Parse and create netlink
 message using the new parsing functions.
Date: Sun, 8 Feb 2015 22:10:18 +0100
Message-ID: <20150208211018.GD4711@salvia>
References: <1423229069-652-1-git-send-email-alvaroneay@gmail.com>
 <1423229069-652-3-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46662 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbbBHVHJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Feb 2015 16:07:09 -0500
Content-Disposition: inline
In-Reply-To: <1423229069-652-3-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 06, 2015 at 02:24:28PM +0100, Alvaro Neira Ayuso wrote:
> With this example, we can parse the elements in the ruleset and create the
> netlink message with the action associated. For example:
> 
> - Flush ruleset
> - Add, delete or flush tables/chains
> - Add, delete sets
> - Add, delete set elements
> - Add, delete, replace or prepend rules
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [no changes]
> 
>  examples/Makefile.am              |    4 +
>  examples/nft-ruleset-parse-file.c |  448 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 452 insertions(+)
>  create mode 100644 examples/nft-ruleset-parse-file.c
> 
> diff --git a/examples/Makefile.am b/examples/Makefile.am
> index fafcb76..e002d36 100644
> --- a/examples/Makefile.am
> +++ b/examples/Makefile.am
> @@ -22,6 +22,7 @@ check_PROGRAMS = nft-table-add		\
>  		 nft-set-elem-get	\
>  		 nft-set-elem-del	\
>  		 nft-ruleset-get	\
> +		 nft-ruleset-parse-file	\
>  		 nft-compat-get
>  
>  nft_table_add_SOURCES = nft-table-add.c
> @@ -90,5 +91,8 @@ nft_set_elem_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
>  nft_ruleset_get_SOURCES = nft-ruleset-get.c
>  nft_ruleset_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
>  
> +nft_ruleset_parse_file_SOURCES = nft-ruleset-parse-file.c
> +nft_ruleset_parse_file_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
> +
>  nft_compat_get_SOURCES = nft-compat-get.c
>  nft_compat_get_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
> diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
> new file mode 100644
> index 0000000..d2950c6
> --- /dev/null
> +++ b/examples/nft-ruleset-parse-file.c
> @@ -0,0 +1,448 @@
> +/*
> + * (C) 2014 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <stdlib.h>
> +#include <time.h>
> +#include <string.h>
> +#include <stddef.h>     /* for offsetof */
> +#include <netinet/in.h>
> +#include <netinet/ip.h>
> +#include <netinet/tcp.h>
> +#include <arpa/inet.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <errno.h>
> +
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nf_tables.h>
> +
> +#include <libmnl/libmnl.h>
> +#include <libnftnl/ruleset.h>
> +#include <libnftnl/table.h>
> +#include <libnftnl/chain.h>
> +#include <libnftnl/rule.h>
> +#include <libnftnl/set.h>
> +
> +struct mnl_nlmsg_batch *batch;
> +uint32_t seq;
> +
> +static int nft_ruleset_flush_rules(const struct nft_parse_ctx *ctx);
> +
> +static int nft_ruleset_set_elems(const struct nft_parse_ctx *ctx,
> +				 uint32_t cmd)
> +{
> +	struct nft_set_elems_iter *iter_elems;
> +	struct nft_set_elem *elem;
> +	struct nft_set *tmp;
> +	uint16_t nl_type = 0, nl_flags = 0;
> +	struct nlmsghdr *nlh;
> +	struct nft_set *set;
> +
> +	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	if (set == NULL)
> +		return -1;
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_type = NFT_MSG_NEWSETELEM;
> +		nl_flags = NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK;

The use of NLM_F_ACK for this example is OK, but in the nft import
support you will have to use batch_talk() instead that internally uses
select().

Note that this will generate an ACK message for each request. When
removing NLM_F_ACK, the kernel will only report when things go wrong.
So we skip a storm of ACK messages ;-).

> +		break;
> +	case NFT_CMD_DELETE:
> +		nl_type = NFT_MSG_DELSETELEM;
> +		nl_flags = NLM_F_ACK;
> +		break;

        default:
                return -1;

So you can remove the nl_type = 0 and nl_flags = 0.

> +	}
> +
> +	iter_elems = nft_set_elems_iter_create(set);
> +	elem = nft_set_elems_iter_next(iter_elems);
> +	while (elem != NULL) {
> +		tmp = nft_set_alloc();
> +		if (tmp == NULL)
> +			return -1;

tmp is not released, so I guess this is a leak.

Run the test with valgrind --leak-check=full to catch these problems.

> +
> +		nft_set_attr_set(tmp, NFT_SET_ATTR_TABLE,
> +				 nft_set_attr_get_str(set, NFT_SET_ATTR_TABLE));
> +		nft_set_attr_set(tmp, NFT_SET_ATTR_NAME,
> +				 nft_set_attr_get_str(set, NFT_SET_ATTR_NAME));
> +
> +		nft_set_elem_add(tmp, elem);
> +
> +		nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +					      nl_type,
> +					      nft_set_attr_get_u32(set,
> +							   NFT_SET_ATTR_FAMILY),
> +					      nl_flags, seq++);
> +		nft_set_elems_nlmsg_build_payload(nlh, tmp);
> +		mnl_nlmsg_batch_next(batch);
> +		elem = nft_set_elems_iter_next(iter_elems);
> +	}
> +
> +	return 0;
> +}
> +
> +static int nft_ruleset_set(const struct nft_parse_ctx *ctx, uint32_t cmd)
> +{
> +
> +	struct nlmsghdr *nlh;
> +	uint16_t nl_type = 0, nl_flags = 0;
> +	struct nft_set *set;
> +
> +	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	if (set == NULL)
> +		return -1;
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_type = NFT_MSG_NEWSET;
> +		nl_flags = NLM_F_CREATE|NLM_F_ACK;
> +		break;
> +	case NFT_CMD_DELETE:
> +		nl_type = NFT_MSG_DELSET;
> +		nl_flags = NLM_F_ACK;
> +		break;

Add also a default case here as I suggested above.

> +	}
> +
> +	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +				      nl_type,
> +				      nft_set_attr_get_u32(set,
> +							   NFT_SET_ATTR_FAMILY),
> +				      nl_flags,
> +				      seq++);
> +
> +	nft_set_nlmsg_build_payload(nlh, set);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	if (nft_ruleset_set_elems(ctx, cmd) < 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int nft_ruleset_rule(const struct nft_parse_ctx *ctx, uint32_t cmd,
> +			    struct nft_rule *nlr)
> +{
> +	struct nlmsghdr *nlh;
> +	uint16_t nl_type = 0, nl_flags = 0;
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
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_type = NFT_MSG_NEWRULE;
> +		nl_flags = NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK;
> +		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
> +		break;
> +	case NFT_CMD_DELETE:
> +		nl_type = NFT_MSG_DELRULE;
> +		nl_flags = NLM_F_ACK;
> +		break;
> +	case NFT_CMD_REPLACE:
> +		nl_type = NFT_MSG_NEWRULE;
> +		nl_flags = NLM_F_REPLACE|NLM_F_ACK;
> +		break;
> +	case NFT_CMD_INSERT:
> +		nl_type = NFT_MSG_NEWRULE;
> +		nl_flags = NLM_F_CREATE|NLM_F_ACK;
> +		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
> +		break;

Same here... and so on.

> +	}
> +
> +	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +				       nl_type,
> +				       nft_rule_attr_get_u32(rule,
> +							  NFT_RULE_ATTR_FAMILY),
> +				       nl_flags,
> +				       seq++);
> +
> +	nft_rule_nlmsg_build_payload(nlh, rule);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	nft_rule_free(rule);
> +	return 0;
> +}
> +
> +static int nft_ruleset_chain(const struct nft_parse_ctx *ctx, uint32_t cmd)
> +{
> +	struct nlmsghdr *nlh;
> +	uint16_t nl_type = 0, nl_flags = 0;
> +	struct nft_chain *chain;
> +
> +	chain = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
> +	if (chain == NULL)
> +		return -1;
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_type = NFT_MSG_NEWCHAIN;
> +		nl_flags = NLM_F_CREATE|NLM_F_ACK;
> +		break;
> +	case NFT_CMD_DELETE:
> +		nl_type = NFT_MSG_DELCHAIN;
> +		nl_flags = NLM_F_ACK;
> +		break;
> +	case NFT_CMD_FLUSH:
> +		return nft_ruleset_flush_rules(ctx);
> +	}
> +
> +	nft_chain_attr_unset(chain, NFT_CHAIN_ATTR_HANDLE);
> +	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +					nl_type,
> +					nft_chain_attr_get_u32(chain,
> +							 NFT_CHAIN_ATTR_FAMILY),
> +					nl_flags,
> +					seq++);
> +
> +	nft_chain_nlmsg_build_payload(nlh, chain);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	nft_chain_free(chain);
> +	return 0;
> +}
> +
> +static int nft_ruleset_table(const struct nft_parse_ctx *ctx, uint32_t cmd,
> +			     struct nft_table *nlt)
> +{
> +	struct nlmsghdr *nlh;
> +	uint16_t nl_type = 0, nl_flags = 0;
> +	struct nft_table *table;
> +
> +	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_TABLE))
> +		table = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
> +	else
> +		table = nlt;
> +
> +	if (table == NULL)
> +		return -1;
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_type = NFT_MSG_NEWTABLE;
> +		nl_flags = NLM_F_CREATE|NLM_F_ACK;
> +		break;
> +	case NFT_CMD_DELETE:
> +		nl_type = NFT_MSG_DELTABLE;
> +		nl_flags = NLM_F_ACK;
> +		break;
> +	case NFT_CMD_FLUSH:
> +		return nft_ruleset_flush_rules(ctx);
> +	}
> +
> +	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +					nl_type,
> +					nft_table_attr_get_u32(table,
> +							 NFT_TABLE_ATTR_FAMILY),
> +					nl_flags,
> +					seq++);
> +
> +	nft_table_nlmsg_build_payload(nlh, table);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	nft_table_free(table);
> +	return 0;
> +}
> +
> +static int nft_ruleset_flush_rules(const struct nft_parse_ctx *ctx)
> +{
> +	struct nft_rule *nlr;
> +	struct nft_table *nlt;
> +	struct nft_chain *nlc;
> +	uint32_t type;
> +
> +	nlr = nft_rule_alloc();
> +	if (nlr == NULL)
> +		return -1;
> +
> +	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
> +	switch (type) {
> +	case NFT_RULESET_TABLE:
> +		nlt = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
> +				  nft_table_attr_get(nlt, NFT_TABLE_ATTR_NAME));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
> +				nft_table_attr_get(nlt, NFT_TABLE_ATTR_FAMILY));
> +		break;
> +	case NFT_RULESET_CHAIN:
> +		nlc = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
> +				  nft_chain_attr_get(nlc,
> +						     NFT_CHAIN_ATTR_TABLE));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_CHAIN,
> +				  nft_chain_attr_get(nlc,
> +						     NFT_CHAIN_ATTR_NAME));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
> +				nft_chain_attr_get(nlc, NFT_TABLE_ATTR_FAMILY));
> +		break;
> +	}
> +
> +	return nft_ruleset_rule(ctx, NFT_CMD_DELETE, nlr);
> +}
> +
> +static int nft_ruleset_flush_ruleset(const struct nft_parse_ctx *ctx)
> +{
> +	struct nft_table *nlt;
> +
> +	nlt = nft_table_alloc();
> +	if (nlt == NULL)
> +		return -1;
> +
> +	return nft_ruleset_table(ctx, NFT_CMD_DELETE, nlt);
> +}
> +
> +static int ruleset_elems_cb(const struct nft_parse_ctx *ctx)
> +{
> +	uint32_t cmd;
> +	uint32_t type;
> +
> +	type = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
> +	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
> +
> +	switch (type) {
> +	case NFT_RULESET_TABLE:
> +		if (nft_ruleset_table(ctx, cmd, NULL) < 0)
> +			return -1;

You can get less lines of code with:

                err = nft_ruleset_table(...);

then... see below.

> +		break;
> +	case NFT_RULESET_CHAIN:
> +		if (nft_ruleset_chain(ctx, cmd) < 0)
> +			return -1;
> +		break;
> +	case NFT_RULESET_RULE:
> +		if (nft_ruleset_rule(ctx, cmd, NULL) < 0)
> +			return -1;
> +		break;
> +	case NFT_RULESET_SET:
> +		if (nft_ruleset_set(ctx, cmd) < 0)
> +			return -1;
> +		break;
> +	case NFT_RULESET_SET_ELEMS:
> +		if (nft_ruleset_set_elems(ctx, cmd) < 0)
> +			return -1;
> +		break;
> +	case NFT_RULESET_RULESET:
> +		if (nft_ruleset_flush_ruleset(ctx) < 0)
> +			return -1;
> +		break;
> +	}

        if (err < 0)
                return err;

> +	return 0;
> +}
