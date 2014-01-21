From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH] src: add export operation
Date: Tue, 21 Jan 2014 14:51:33 +0000
Message-ID: <20140121145131.GA6302@macbook.localnet>
References: <20140121140545.27264.82385.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40035 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaAUOvm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:51:42 -0500
Content-Disposition: inline
In-Reply-To: <20140121140545.27264.82385.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:05:45PM +0100, Arturo Borrero Gonzalez wrote:
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 2eb00b6..b4c84b1 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -1,6 +1,8 @@
>  #ifndef __LINUX_NETFILTER_H
>  #define __LINUX_NETFILTER_H
>  
> +#include <netinet/in.h>
> +#include <arpa/inet.h>

You shouldn't add anything to this file, its copied from the kernel and
this will get lost once its updated.

> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -1,6 +1,8 @@
>  #ifndef NFTABLES_NETLINK_H
>  #define NFTABLES_NETLINK_H
>  
> +#include <libnftnl/common.h>
> +#include <libnftnl/ruleset.h>

Is this really needed in the header file? I don't see any new types being
used.

>  #include <libnftnl/table.h>
>  #include <libnftnl/chain.h>
>  #include <libnftnl/rule.h>
> @@ -136,4 +138,7 @@ extern int netlink_batch_send(struct list_head *err_list);
>  extern int netlink_io_error(struct netlink_ctx *ctx,
>  			    const struct location *loc, const char *fmt, ...);
>  
> +extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
> +						const struct handle *h,
> +						const struct location *loc);
>  #endif /* NFTABLES_NETLINK_H */
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -247,6 +249,7 @@ enum cmd_obj {
>   * @seqnum:	sequence number to match netlink errors
>   * @union:	object
>   * @arg:	argument data
> + * @format:	info about the output format (enum nft_output_type)
>   */
>  struct cmd {
>  	struct list_head	list;
> @@ -264,6 +267,7 @@ struct cmd {
>  		struct table	*table;
>  	};
>  	const void		*arg;
> +	uint32_t		format;

No enum defined for this?

> index b867902..11487e7 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -9,6 +9,8 @@
>   */
>  
>  #include <libmnl/libmnl.h>
> +#include <libnftnl/common.h>
> +#include <libnftnl/ruleset.h>
>  #include <libnftnl/table.h>
>  #include <libnftnl/chain.h>
>  #include <libnftnl/rule.h>
> @@ -645,7 +647,8 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
>  
>  	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
>  				      NLM_F_DUMP|NLM_F_ACK, seq);
> -	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
> +	if (table != NULL)
> +		nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
>  	nft_set_nlmsg_build_payload(nlh, s);
>  	nft_set_free(s);
>  
> @@ -733,3 +736,62 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
>  
>  	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
>  }
> +
> +/*
> + * ruleset
> + */
> +struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
> +					 uint32_t family)
> +{
> +	struct nft_ruleset *rs;
> +	struct nft_table_list *t;
> +	struct nft_chain_list *c;
> +	struct nft_set_list *sl;
> +	struct nft_set_list_iter *i;
> +	struct nft_set *s;
> +	struct nft_rule_list *r;
> +	int ret = 0;
> +
> +	rs = nft_ruleset_alloc();
> +	if (rs == NULL)
> +		memory_allocation_error();
> +
> +	t = mnl_nft_table_dump(nf_sock, family);
> +	if (t != NULL)
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
> +
> +	c = mnl_nft_chain_dump(nf_sock, family);
> +	if (c != NULL)
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
> +
> +	sl = mnl_nft_set_dump(nf_sock, family, NULL);
> +	if (sl != NULL) {
> +		i = nft_set_list_iter_create(sl);
> +		s = nft_set_list_iter_next(i);
> +		while (s != NULL) {
> +			ret = mnl_nft_setelem_get(nf_sock, s);
> +			if (ret != 0)
> +				goto out;
> +
> +			s = nft_set_list_iter_next(i);
> +		}
> +		nft_set_list_iter_destroy(i);
> +
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
> +	}
> +
> +	r = mnl_nft_rule_dump(nf_sock, family);
> +	if (r != NULL)
> +		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
> +
> +	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST))
> +	    && !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST))
> +	    && !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST))
> +	    && !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)))

Please keep those && at the end of each line, I'd prefer to have a
consistent style throughout the code.

> +		goto out;
> +
> +	return rs;
> +out:
> +	nft_ruleset_free(rs);
> +	return NULL;
> +}
> diff --git a/src/netlink.c b/src/netlink.c
> index 7f69995..d6de8d9 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -19,7 +19,7 @@
>  #include <libnftnl/expr.h>
>  #include <libnftnl/set.h>
>  #include <linux/netfilter/nf_tables.h>
> -
> +#include <linux/netfilter.h>

Seems this is where you should add those includes you added to netfilter.h?

>  #include <nftables.h>
>  #include <netlink.h>
>  #include <mnl.h>
> @@ -1048,3 +1048,17 @@ int netlink_batch_send(struct list_head *err_list)
>  {
>  	return mnl_batch_talk(nf_sock, err_list);
>  }
> +
> +struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
> +					 const struct handle *h,
> +					 const struct location *loc)
> +{
> +	struct nft_ruleset *rs;
> +
> +	rs = mnl_nft_ruleset_dump(nf_sock, h->family);
> +	if (rs == NULL)
> +		netlink_io_error(ctx, loc, "Could not receive ruleset: %s",
> +				 strerror(errno));
> +
> +	return rs;
> +}
> diff --git a/src/parser.y b/src/parser.y
> index 345d8d0..fff63d3 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -19,6 +19,8 @@
>  #include <linux/netfilter/nf_tables.h>
>  #include <linux/netfilter/nf_conntrack_tuple_common.h>
>  
> +#include <libnftnl/common.h>
> +

>From nftables POV, this is just as external as any of the preceeding
includes, so you don't need to add a separate section for libnftnl.

>  #include <rule.h>
>  #include <statement.h>
>  #include <expression.h>

> +export_cmd		:	export_format
> +			{
> +				struct handle h = { .family = NFPROTO_UNSPEC };
> +				$$ = cmd_alloc(CMD_EXPORT, 0, &h, &@$, NULL);

Just for consistency, please add a CMD_OBJ_RULESET.

> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -18,6 +18,10 @@
>  #include <statement.h>
>  #include <rule.h>
>  #include <utils.h>
> +#include <netlink.h>
> +
> +#include <libnftnl/common.h>
> +#include <libnftnl/ruleset.h>

Same comment as for parser.y.

>  
>  #include <netinet/ip.h>
>  #include <linux/netfilter.h>
> @@ -431,6 +435,10 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
>  void cmd_free(struct cmd *cmd)
>  {
>  	handle_free(&cmd->handle);
> +
> +	if (cmd->op == CMD_EXPORT)
> +		goto free;
> +

Why do we need this? Both data and arg should be NULL anyway.

>  	if (cmd->data != NULL) {
>  		switch (cmd->obj) {
>  		case CMD_OBJ_SETELEM:
> @@ -453,6 +461,7 @@ void cmd_free(struct cmd *cmd)
>  		}
>  	}
>  	xfree(cmd->arg);
> +free:
>  	xfree(cmd);
>  }
>  
