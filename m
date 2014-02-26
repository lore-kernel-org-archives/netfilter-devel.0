From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH v2 6/6] src: add events reporting
Date: Wed, 26 Feb 2014 18:19:50 +0100
Message-ID: <20140226171950.GC22731@localhost>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
 <20140226161015.18974.17832.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35479 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaBZRUB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:20:01 -0500
Content-Disposition: inline
In-Reply-To: <20140226161015.18974.17832.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 05:10:15PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds a basic events reporting option to nft.
> 
> The syntax is:
>  % nft monitor [added|deleted] [tables|chains|rules|sets] [xml|json]
                  ^-----------^
In conntrack, we use "new" and "destroy", perhaps Patrick has a better
idea on how a nice syntax would be or he likes it already.

More comments below.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/mnl.h     |    3 
>  include/netlink.h |    8 +
>  include/rule.h    |    3 
>  src/evaluate.c    |    1 
>  src/mnl.c         |   45 ++++-
>  src/netlink.c     |  474 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/parser.y      |   75 ++++++++
>  src/rule.c        |   26 +++
>  src/scanner.l     |    5 +
>  9 files changed, 621 insertions(+), 19 deletions(-)
> 
> diff --git a/include/mnl.h b/include/mnl.h
> index f4de27d..ece7ee7 100644
> --- a/include/mnl.h
> +++ b/include/mnl.h
> @@ -67,4 +67,7 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
>  
>  struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
>  					 uint32_t family);
> +int mnl_nft_event_listener(struct mnl_socket *nf_sock,
> +			   int (*cb)(const struct nlmsghdr *nlh, void *data),
> +			   void *cb_data);
>  #endif /* _NFTABLES_MNL_H_ */
> diff --git a/include/netlink.h b/include/netlink.h
> index 4e3f8aa..627b25c 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -142,4 +142,12 @@ extern int netlink_io_error(struct netlink_ctx *ctx,
>  extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
>  						const struct handle *h,
>  						const struct location *loc);
> +struct netlink_mon_handler {
> +	uint32_t		selector;
> +	uint32_t		format;
> +	struct netlink_ctx	*ctx;
> +	const struct location	*loc;
> +};
> +
> +extern int netlink_monitor(struct netlink_mon_handler *monhandler);
>  #endif /* NFTABLES_NETLINK_H */
> diff --git a/include/rule.h b/include/rule.h
> index 9791cea..52e2aaa 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -210,6 +210,7 @@ extern void set_print_plain(const struct set *s);
>   * @CMD_FLUSH:		flush container
>   * @CMD_RENAME:		rename object
>   * @CMD_EXPORT:		export the ruleset in a given format
> + * @CMD_MONITOR:	event listener
>   */
>  enum cmd_ops {
>  	CMD_INVALID,
> @@ -221,6 +222,7 @@ enum cmd_ops {
>  	CMD_FLUSH,
>  	CMD_RENAME,
>  	CMD_EXPORT,
> +	CMD_MONITOR,
>  };
>  
>  /**
> @@ -276,6 +278,7 @@ struct cmd {
>  	};
>  	const void		*arg;
>  	uint32_t		format;
> +	uint32_t		mon_selector;

Perhap call this monitor_flags ?

>  };
>  
>  extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
> diff --git a/src/evaluate.c b/src/evaluate.c
> index f10d0d9..914ea23 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1410,6 +1410,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_FLUSH:
>  	case CMD_RENAME:
>  	case CMD_EXPORT:
> +	case CMD_MONITOR:
>  		return 0;
>  	default:
>  		BUG("invalid command operation %u\n", cmd->op);
> diff --git a/src/mnl.c b/src/mnl.c
> index e825fb0..7e34b31 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -34,24 +34,16 @@ uint32_t mnl_seqnum_alloc(void)
>  }
>  
>  static int
> -mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
> -	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
> +mnl_talk_recv(struct mnl_socket *nf_sock, int seqnum, uint32_t portid,

You can already obtain the portid via:

        mnl_socket_get_portid(nf_sock)

so you can save that parameter.

seqnum should be uint32_t

> +	      int (*cb)(const struct nlmsghdr *nlh, void *data),
> +	      void *cb_data)
>  {
> -	char buf[MNL_SOCKET_BUFFER_SIZE];
> -	uint32_t portid = mnl_socket_get_portid(nf_sock);
>  	int ret;
> -
> -#ifdef DEBUG
> -	if (debug_level & DEBUG_MNL)
> -		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
> -#endif
> -
> -	if (mnl_socket_sendto(nf_sock, data, len) < 0)
> -		return -1;
> +	char buf[MNL_SOCKET_BUFFER_SIZE];
>  
>  	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
>  	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, cb, cb_data);
> +		ret = mnl_cb_run(buf, ret, seqnum, portid, cb, cb_data);
>  		if (ret <= 0)
>  			goto out;
>  
> @@ -64,6 +56,23 @@ out:
>  	return ret;
>  }
>  
> +static int
> +mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
> +	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
> +{
> +	uint32_t portid = mnl_socket_get_portid(nf_sock);
> +
> +#ifdef DEBUG
> +	if (debug_level & DEBUG_MNL)
> +		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
> +#endif
> +
> +	if (mnl_socket_sendto(nf_sock, data, len) < 0)
> +		return -1;
> +
> +	return mnl_talk_recv(nf_sock, seq, portid, cb, cb_data);
> +}
> +
>  /*
>   * Batching
>   */
> @@ -805,3 +814,13 @@ out:
>  	nft_ruleset_free(rs);
>  	return NULL;
>  }
> +
> +/*
> + * events
> + */
> +int mnl_nft_event_listener(struct mnl_socket *nf_sock,
> +			   int (*cb)(const struct nlmsghdr *nlh, void *data),
> +			   void *cb_data)
> +{
> +	return mnl_talk_recv(nf_sock, 0, 0, cb, cb_data);
> +}
> diff --git a/src/netlink.c b/src/netlink.c
> index 43af5d1..c7532eb 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -20,6 +20,7 @@
>  #include <libnftnl/chain.h>
>  #include <libnftnl/expr.h>
>  #include <libnftnl/set.h>
> +#include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <linux/netfilter.h>
>  
> @@ -32,6 +33,7 @@
>  #include <erec.h>
>  
>  static struct mnl_socket *nf_sock;
> +static struct mnl_socket *nf_mon_sock;
>  
>  const struct input_descriptor indesc_netlink = {
>  	.name	= "netlink",
> @@ -42,12 +44,18 @@ const struct location netlink_location = {
>  	.indesc	= &indesc_netlink,
>  };
>  
> -static void __init netlink_open_sock(void)
> +static struct mnl_socket *nfsock_open(void)
>  {
> -	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
> -	if (nf_sock == NULL)
> +	struct mnl_socket *s = mnl_socket_open(NETLINK_NETFILTER);
> +	if (s == NULL)
>  		memory_allocation_error();

I think you can add:

void __noreturn netlink_open_error(void)
{
        fprintf(stderr, "Failed to open netlink: %s\n", strerror(errno));
        exit(NFT_EXIT_NONL);
}

You'll need to add NFT_EXIT_NONL.

That should help people to diagnose problems (missing modules / broken
built / no netlink support for some reason).

> +	return s;
> +}
> +
> +static void __init netlink_open_sock(void)
> +{
> +	nf_sock = nfsock_open();
>  	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
>  	mnl_batch_init();
>  }
> @@ -55,6 +63,13 @@ static void __init netlink_open_sock(void)
>  static void __exit netlink_close_sock(void)
>  {
>  	mnl_socket_close(nf_sock);
> +	if (nf_mon_sock)
> +		mnl_socket_close(nf_mon_sock);
> +}
> +
> +static void netlink_open_mon_sock(void)
> +{
> +	nf_mon_sock = nfsock_open();
>  }
>  
>  int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
> @@ -1047,3 +1062,456 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
>  
>  	return rs;
>  }
> +
> +static void netlink_events_printf_wrapper(const char *content,
> +					  uint32_t format, int type)
> +{
> +	const char *type_str = "unknown";
> +
> +	switch (type) {
> +	case NFT_MSG_NEWTABLE:
> +	case NFT_MSG_NEWCHAIN:
> +	case NFT_MSG_NEWSET:
> +	case NFT_MSG_NEWRULE:
> +		type_str = "add";
> +		break;
> +	case NFT_MSG_DELTABLE:
> +	case NFT_MSG_DELCHAIN:
> +	case NFT_MSG_DELSET:
> +	case NFT_MSG_DELRULE:
> +		type_str = "del";
> +		break;
> +	}
> +
> +	switch (format) {
> +	case NFT_OUTPUT_XML:
> +		printf("<event><type>%s</type>"
> +		       "<nftables>%s</nftables></event>\n",
> +		       type_str, content);
> +		break;
> +	case NFT_OUTPUT_JSON:
> +		printf("{event:{type:\"%s\",{\"nftables\":[\"%s\"]}}}\n",
> +		       type_str, content);
> +		break;
> +	default:
> +		BUG("Unknown monitor output format.\n");
> +	}
> +}
> +
> +static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
> +				   struct netlink_mon_handler *monh)
> +{
> +	struct nft_table *nlt;
> +	uint32_t family;
> +	char buf[4096];
> +
> +	nlt = nft_table_alloc();
> +	if (nlt == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				"Could not parse table: %s",
> +				strerror(errno));

I really think the only way to hit problems here is that someone
accidentally broke the ABI in the kernel, ie. someone changes
NFTA_TABLE_FLAGS from u32 to u64, which is illegal. So I would be more
agressive here, stop the process and spot an error message "Someone
broke the netlink ABI: Fix your kernel urgently".

BTW, I just noticed a bug in libnfntnl when looking into this:

int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
{
        struct nlattr *tb[NFTA_TABLE_MAX+1] = {};
        struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);

        mnl_attr_parse(nlh, sizeof(*nfg), nft_table_parse_attr_cb, tb);
        ...

We have to check if mnl_attr_parse() returns an error, which means
that it failed to validate and retrieve the attributes.

Same thing in all _nlmsg_parse() calls.

> +		goto err;
> +	}
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (type == NFT_MSG_NEWTABLE)
> +			printf("add table ");
> +		else
> +			printf("delete table ");
> +
> +		family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
> +
> +		printf("%s %s\n", family2str(family),
> +		       nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
> +	} else {
> +		nft_table_snprintf(buf, sizeof(buf), nlt, monh->format, 0);
> +		netlink_events_printf_wrapper(buf, monh->format, type);
> +	}
> +
> +err:
> +	nft_table_free(nlt);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
> +				   struct netlink_mon_handler *monh)
> +{
> +	struct nft_chain *nlc;
> +	struct chain *c;
> +	uint32_t family;
> +	char buf[4096];
> +
> +	nlc = nft_chain_alloc();
> +	if (nlc == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_chain_nlmsg_parse(nlh, nlc) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				 "Could not parse chain: %s",
> +				 strerror(errno));
> +		goto out;
> +	}
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (type == NFT_MSG_NEWCHAIN) {
> +			printf("add ");
> +			c = netlink_delinearize_chain(monh->ctx, nlc);
> +			chain_print_plain(c);
> +			chain_free(c);
> +		} else {
> +			family = nft_chain_attr_get_u32(nlc,
> +							NFT_CHAIN_ATTR_FAMILY);
> +			printf("delete chain %s %s %s\n", family2str(family),
> +			       nft_chain_attr_get_str(nlc,
> +						      NFT_CHAIN_ATTR_TABLE),
> +			       nft_chain_attr_get_str(nlc,
> +						      NFT_CHAIN_ATTR_NAME));
> +		}
> +	} else {
> +		nft_chain_snprintf(buf, sizeof(buf), nlc, monh->format, 0);
> +		netlink_events_printf_wrapper(buf, monh->format, type);
> +	}
> +
> +out:
> +	nft_chain_free(nlc);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
> +				 struct netlink_mon_handler *monh)
> +{
> +	struct nft_set *nls;
> +	struct set *set;
> +	uint32_t family, flags;
> +	char buf[4096];
> +
> +	nls = nft_set_alloc();
> +	if (nls == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_set_nlmsg_parse(nlh, nls) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				 "Could not parse set: %s",
> +				 strerror(errno));
> +		goto out;
> +	}
> +
> +	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
> +	if (flags & SET_F_ANONYMOUS)
> +		goto out;
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (type == NFT_MSG_NEWSET) {
> +			printf("add ");
> +			set = netlink_delinearize_set(monh->ctx, nls);
> +			set_print_plain(set);
> +			set_free(set);
> +		} else {
> +			family = nft_set_attr_get_u32(nls,
> +						      NFT_SET_ATTR_FAMILY);
> +			printf("delete set %s %s %s",
> +			       family2str(family),
> +			       nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE),
> +			       nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
> +		}
> +
> +		printf("\n");
> +
> +	} else {
> +		nft_set_snprintf(buf, sizeof(buf), nls, monh->format, 0);
> +		netlink_events_printf_wrapper(buf, monh->format, type);
> +	}
> +
> +out:
> +	nft_set_free(nls);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
> +				  struct netlink_mon_handler *monh)
> +{
> +	struct nft_rule *nlr;
> +	struct rule *r;
> +	char buf[4096];
> +	uint32_t fam;
> +	const char *family;
> +	const char *table;
> +	const char *chain;
> +	uint64_t handle;
> +
> +	nlr = nft_rule_alloc();
> +	if (nlr == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_rule_nlmsg_parse(nlh, nlr) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				 "Could not parse rule: %s",
> +				 strerror(errno));
> +		goto out;
> +	}
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		fam = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
> +		family = family2str(fam);
> +		table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
> +		chain = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN);
> +		handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
> +
> +		if (type == NFT_MSG_NEWRULE) {
> +			r = netlink_delinearize_rule(monh->ctx, nlr);
> +			printf("add rule %s %s %s", family, table, chain);
> +			rule_print(r);
> +			rule_free(r);
> +			goto out;
> +		}
> +
> +		printf("delete rule %s %s %s handle %u\n",
> +		       family, table, chain, (unsigned int)handle);
> +	} else {
> +		nft_rule_snprintf(buf, sizeof(buf), nlr, monh->format, 0);
> +		netlink_events_printf_wrapper(buf, monh->format, type);
> +	}
> +
> +out:
> +	nft_rule_free(nlr);
> +	return MNL_CB_OK;
> +}
> +
> +static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
> +					  const struct nlmsghdr *nlh)
> +{
> +	struct nft_table *nlt;
> +	struct table *t;
> +
> +	nlt = nft_table_alloc();
> +	if (nlt == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				"Could not parse table: %s",
> +				strerror(errno));
> +		goto out;
> +	}
> +
> +	t = netlink_delinearize_table(monh->ctx, nlt);
> +	table_add_hash(t);
> +
> +out:
> +	nft_table_free(nlt);
> +}
> +
> +static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
> +					  const struct nlmsghdr *nlh)
> +{
> +	struct nft_table *nlt;
> +	struct table *t;
> +	struct handle h;
> +
> +	nlt = nft_table_alloc();
> +	if (nlt == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				"Could not parse table: %s",
> +				strerror(errno));
> +		goto out;
> +	}
> +
> +	h.family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
> +	h.table = nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME);
> +
> +	t = table_lookup(&h);
> +	if (t == NULL)
> +		goto out;
> +
> +	list_del(&t->list);
> +	table_free(t);
> +
> +out:
> +	nft_table_free(nlt);
> +}
> +
> +static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
> +					const struct nlmsghdr *nlh)
> +{
> +	struct nft_set *nls;
> +	struct netlink_ctx set_tmpctx;
> +	LIST_HEAD(msgs);
> +	struct table *t;
> +	struct set *s;
> +	uint32_t flags;
> +
> +	nls = nft_set_alloc();
> +	if (nls == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_set_nlmsg_parse(nlh, nls) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				"Could not parse set: %s",
> +				strerror(errno));
> +		goto out;
> +	}
> +
> +	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
> +	if (!(flags & SET_F_ANONYMOUS))
> +		goto out;
> +
> +	memset(&set_tmpctx, 0, sizeof(set_tmpctx));
> +	init_list_head(&set_tmpctx.list);
> +	init_list_head(&msgs);
> +	set_tmpctx.msgs = &msgs;
> +	s = netlink_delinearize_set(&set_tmpctx, nls);
> +
> +	/* XXXX */
> +	sleep(1);
> +
> +	/* only way, by now, to know set_elems (no set_elem events) */
> +	if (netlink_get_setelems(&set_tmpctx, &s->handle, monh->loc, s) < 0)
> +		goto out;
> +
> +	set_print(s);
> +
> +	t = table_lookup(&s->handle);
> +	if (t == NULL)
> +		goto out;
> +
> +	set_add_hash(s, t);
> +out:
> +	nft_set_free(nls);
> +}
> +
> +static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
> +					 const struct nlmsghdr *nlh)
> +{
> +	struct nft_rule *nlr;
> +	struct handle th;
> +	struct nft_rule_expr_iter *nlrei;
> +	struct nft_rule_expr *nlre;
> +	const char *expr_name, *set_name;
> +	struct table *t;
> +	struct set *s;
> +
> +	nlr = nft_rule_alloc();
> +	if (nlr == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_rule_nlmsg_parse(nlh, nlr) < 0) {
> +		netlink_io_error(monh->ctx, monh->loc,
> +				 "Could not parse rule: %s",
> +				 strerror(errno));
> +		goto out;
> +	}
> +
> +	th.table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
> +	th.family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
> +	t = table_lookup(&th);
> +	if (t == NULL)
> +		goto out;
> +
> +

remove extra line here.

> +	nlrei = nft_rule_expr_iter_create(nlr);
> +	if (nlrei == NULL)
> +		memory_allocation_error();
> +
> +	nlre = nft_rule_expr_iter_next(nlrei);
> +	while (nlre != NULL) {
> +		expr_name = nft_rule_expr_get_str(nlre,
> +						  NFT_RULE_EXPR_ATTR_NAME);
> +		if (strcmp(expr_name, "lookup") != 0)
> +			goto next;
> +
> +		set_name = nft_rule_expr_get_str(nlre, NFT_EXPR_LOOKUP_SET);
> +		s = set_lookup(t, set_name);
> +		if (s == NULL)
> +			goto next;
> +
> +		list_del(&s->list);
> +		set_free(s);
> +next:
> +		nlre = nft_rule_expr_iter_next(nlrei);
> +	}
> +	nft_rule_expr_iter_destroy(nlrei);
> +
> +out:
> +	nft_rule_free(nlr);
> +}
> +
> +static void netlink_events_cache_update(struct netlink_mon_handler *monh,
> +					const struct nlmsghdr *nlh, int type)
> +{
> +	/* cache only needed when monitoring new rules in def. output format */
> +	if (!(monh->selector & (1 << NFT_MSG_NEWRULE)) &&
> +	    (monh->format != NFT_OUTPUT_DEFAULT))
> +		return;
> +
> +	switch (type) {
> +	case NFT_MSG_NEWTABLE:
> +		netlink_events_cache_addtable(monh, nlh);
> +		break;
> +	case NFT_MSG_DELTABLE:
> +		netlink_events_cache_deltable(monh, nlh);
> +		break;
> +	case NFT_MSG_NEWSET:
> +		netlink_events_cache_addset(monh, nlh);
> +		break;
> +	case NFT_MSG_DELRULE:
> +		/* there are no notification for anon-set deletion */
> +		netlink_events_cache_delsets(monh, nlh);
> +		break;
> +	}
> +}
> +
> +static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	int ret = MNL_CB_OK;
> +	int type = nlh->nlmsg_type & 0xFF;
> +	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
> +
> +	netlink_events_cache_update(monh, nlh, type);
> +
> +	if (!(monh->selector & (1 << type)))
> +		return ret;
> +
> +	switch (type) {
> +	case NFT_MSG_NEWTABLE:
> +	case NFT_MSG_DELTABLE:
> +		ret = netlink_events_table_cb(nlh, type, monh);
> +		break;
> +	case NFT_MSG_NEWCHAIN:
> +	case NFT_MSG_DELCHAIN:
> +		ret = netlink_events_chain_cb(nlh, type, monh);
> +		break;
> +	case NFT_MSG_NEWSET:
> +	case NFT_MSG_DELSET:
> +		ret = netlink_events_set_cb(nlh, type, monh);
> +		break;
> +	case NFT_MSG_NEWRULE:
> +	case NFT_MSG_DELRULE:
> +		ret = netlink_events_rule_cb(nlh, type, monh);
> +		break;
> +	default:
> +		BUG("Unknow event received from kernel.\n");
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +int netlink_monitor(struct netlink_mon_handler *monhandler)
> +{
> +	netlink_open_mon_sock();
> +
> +	if (mnl_socket_bind(nf_mon_sock, (1 << (NFNLGRP_NFTABLES-1)),
> +			    MNL_SOCKET_AUTOPID) < 0)
> +		return netlink_io_error(monhandler->ctx, monhandler->loc,
> +					"Could not bind to netlink socket %s",
> +					strerror(errno));
> +
> +	return mnl_nft_event_listener(nf_mon_sock, netlink_events_cb,
> +				      monhandler);
> +}
> diff --git a/src/parser.y b/src/parser.y
> index b3acc74..a154696 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -163,12 +163,16 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %token TABLE			"table"
>  %token TABLES			"tables"
>  %token CHAIN			"chain"
> +%token CHAINS			"chains"
>  %token RULE			"rule"
> +%token RULES			"rules"
>  %token SETS			"sets"
>  %token SET			"set"
>  %token ELEMENT			"element"
>  %token MAP			"map"
>  %token HANDLE			"handle"
> +%token ADDED			"added"
> +%token DELETED			"deleted"
>  %token INET			"inet"
>  
> @@ -181,6 +185,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %token RENAME			"rename"
>  %token DESCRIBE			"describe"
>  %token EXPORT			"export"
> +%token MONITOR			"monitor"
>  
>  %token ACCEPT			"accept"
>  %token DROP			"drop"
> @@ -361,8 +366,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %type <cmd>			line
>  %destructor { cmd_free($$); }	line
>  
> -%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
> -%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
> +%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
> +%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
>  
>  %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
>  %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
> @@ -485,7 +490,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %destructor { expr_free($$); }	ct_expr
>  %type <val>			ct_key
>  
> -%type <val>			export_format
> +%type <val>			export_format	output_format	mon_selector
>  
>  %%
>  
> @@ -585,6 +590,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
>  			|	FLUSH		flush_cmd	{ $$ = $2; }
>  			|	RENAME		rename_cmd	{ $$ = $2; }
>  			|	EXPORT		export_cmd	{ $$ = $2; }
> +			|	MONITOR		monitor_cmd	{ $$ = $2; }
>  			|	DESCRIBE	primary_expr
>  			{
>  				expr_describe($2);
> @@ -752,6 +758,69 @@ export_cmd		:	export_format
>  			}
>  			;
>  
> +monitor_cmd		:	mon_selector	output_format
> +			{
> +				struct handle h = { .family = NFPROTO_UNSPEC };
> +				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
> +				$$->mon_selector = $1;
> +				$$->format = $2;
> +			}
> +			;
> +
> +mon_selector		:	/* empty */
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);

Not sure if anyone commented on this, I prefer two lines here. I tend
to stop reading when I find semi-colon.

> +				$$ |= (1 << NFT_MSG_NEWSET);	$$ |= (1 << NFT_MSG_DELSET);
> +				$$ |= (1 << NFT_MSG_NEWCHAIN);	$$ |= (1 << NFT_MSG_DELCHAIN);
> +				$$ |= (1 << NFT_MSG_NEWTABLE);	$$ |= (1 << NFT_MSG_DELTABLE);
> +			}
> +			|	ADDED
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);
> +				$$ |= (1 << NFT_MSG_NEWSET);
> +				$$ |= (1 << NFT_MSG_NEWCHAIN);
> +				$$ |= (1 << NFT_MSG_NEWTABLE);
> +			}
> +			|	DELETED
> +			{
> +				$$ |= (1 << NFT_MSG_DELRULE);
> +				$$ |= (1 << NFT_MSG_DELSET);
> +				$$ |= (1 << NFT_MSG_DELCHAIN);
> +				$$ |= (1 << NFT_MSG_DELTABLE);
> +			}
> +			|	TABLES
> +			{
> +				$$ |= (1 << NFT_MSG_NEWTABLE);	$$ |= (1 << NFT_MSG_DELTABLE);
> +			}
> +			|	ADDED 	TABLES 	{	$$ |= (1 << NFT_MSG_NEWTABLE); }
> +			|	DELETED	TABLES	{	$$ |= (1 << NFT_MSG_DELTABLE); }
> +			|	CHAIN
> +			{
> +				$$ |= (1 << NFT_MSG_NEWCHAIN);	$$ |= (1 << NFT_MSG_DELCHAIN);
> +			}
> +			|	ADDED	CHAINS	{	$$ |= (1 << NFT_MSG_NEWCHAIN); }
> +			|	DELETED	CHAINS	{	$$ |= (1 << NFT_MSG_DELCHAIN); }
> +			|	SET
> +			{
> +				$$ |= (1 << NFT_MSG_NEWSET);	$$ |= (1 << NFT_MSG_DELSET);
> +			}
> +			|	ADDED	SETS	{	$$ |= (1 << NFT_MSG_NEWSET); }
> +			|	DELETED SETS	{	$$ |= (1 << NFT_MSG_DELSET); }
> +			|	RULE
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);
> +			}
> +			|	ADDED 	RULES	{	$$ |= (1 << NFT_MSG_NEWRULE); }
> +			|	DELETED RULES	{	$$ |= (1 << NFT_MSG_DELRULE); }
> +			;
> +
> +output_format		:	/* empty */
> +			{
> +				$$ = NFT_OUTPUT_DEFAULT;
> +			}
> +			|	export_format
> +			;
> +
>  table_block_alloc	:	/* empty */
>  			{
>  				$$ = table_alloc();
> diff --git a/src/rule.c b/src/rule.c
> index d8a065a..72fc306 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -799,6 +799,30 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
>  	return 0;
>  }
>  
> +static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
> +{
> +	struct table *t, *nt;
> +	struct netlink_mon_handler monhandler;
> +
> +	/* cache only needed if monitoring new rules in def. output format */
> +	if ((cmd->mon_selector & (1 << NFT_MSG_NEWRULE)) &&
> +	    (cmd->format == NFT_OUTPUT_DEFAULT)) {
> +		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
> +			return -1;
> +
> +		list_for_each_entry_safe(t, nt, &ctx->list, list) {
> +			table_add_hash(t);
> +		}
> +	}
> +
> +	monhandler.selector = cmd->mon_selector;
> +	monhandler.format = cmd->format;
> +	monhandler.ctx = ctx;
> +	monhandler.loc = &cmd->location;
> +
> +	return netlink_monitor(&monhandler);
> +}
> +
>  int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
>  {
>  	switch (cmd->op) {
> @@ -818,6 +842,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
>  		return do_command_rename(ctx, cmd);
>  	case CMD_EXPORT:
>  		return do_command_export(ctx, cmd);
> +	case CMD_MONITOR:
> +		return do_command_monitor(ctx, cmd);
>  	default:
>  		BUG("invalid command object type %u\n", cmd->obj);
>  	}
> diff --git a/src/scanner.l b/src/scanner.l
> index 45c6476..59aee8a 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -232,12 +232,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "table"			{ return TABLE; }
>  "tables"		{ return TABLES; }
>  "chain"			{ return CHAIN; }
> +"chains"		{ return CHAINS; }
>  "rule"			{ return RULE; }
> +"rules"			{ return RULES; }
>  "sets"			{ return SETS; }
>  "set"			{ return SET; }
>  "element"		{ return ELEMENT; }
>  "map"			{ return MAP; }
>  "handle"		{ return HANDLE; }
> +"added"			{ return ADDED; }
> +"deleted"		{ return DELETED; }
>  
>  "accept"		{ return ACCEPT; }
>  "drop"			{ return DROP; }
> @@ -256,6 +260,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "flush"			{ return FLUSH; }
>  "rename"		{ return RENAME; }
>  "export"		{ return EXPORT; }
> +"monitor"		{ return MONITOR; }
>  
>  "position"		{ return POSITION; }
>  
> 
