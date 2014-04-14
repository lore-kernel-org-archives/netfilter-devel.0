From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 8/8] src: add events reporting
Date: Mon, 14 Apr 2014 14:28:26 +0200
Message-ID: <20140414122826.GA21947@localhost>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
 <20140414101746.5018.46169.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaDNMbs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:31:48 -0400
Content-Disposition: inline
In-Reply-To: <20140414101746.5018.46169.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 12:17:46PM +0200, Arturo Borrero Gonzalez wrote:
> diff --git a/src/mnl.c b/src/mnl.c
> index e825fb0..1e8eaf2 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -34,24 +34,16 @@ uint32_t mnl_seqnum_alloc(void)
>  }
>  
>  static int
> -mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
> -	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
> +mnl_talk_recv(struct mnl_socket *nf_sock, uint32_t seqnum, uint32_t portid,
> +	      int (*cb)(const struct nlmsghdr *nlh, void *data),
> +	      void *cb_data)

Please, now that you're revisiting this, rename it to:

nft_mnl_recv()

and while at it rename mnl_talk() to nft_mnl_talk().

I would like to avoid a clash with some new function in libmnl in the
future. That name selection I made was not very good idea indeed.

Thanks.

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
> index 5a9e42e..d5b84fa 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -21,6 +21,7 @@
>  #include <libnftnl/chain.h>
>  #include <libnftnl/expr.h>
>  #include <libnftnl/set.h>
> +#include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <linux/netfilter.h>
>  
> @@ -33,6 +34,7 @@
>  #include <erec.h>
>  
>  static struct mnl_socket *nf_sock;
> +static struct mnl_socket *nf_mon_sock;
>  
>  const struct input_descriptor indesc_netlink = {
>  	.name	= "netlink",
> @@ -43,12 +45,18 @@ const struct location netlink_location = {
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
>  		netlink_open_error();
>  
> +	return s;
> +}
> +
> +static void __init netlink_open_sock(void)
> +{
> +	nf_sock = nfsock_open();
>  	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
>  	mnl_batch_init();
>  }
> @@ -56,6 +64,20 @@ static void __init netlink_open_sock(void)
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
> +}
> +
> +void __noreturn netlink_abi_error(void)
> +{
> +	fprintf(stderr, "E: Contact urgently your Linux kernel vendor. "
> +		"Netlink ABI is broken: %s\n", strerror(errno));
> +	exit(NFT_EXIT_FAILURE);
>  }
>  
>  int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
> @@ -1062,3 +1084,529 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
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
> +	case NFT_MSG_NEWSETELEM:
> +		type_str = "add";
> +		break;
> +	case NFT_MSG_DELTABLE:
> +	case NFT_MSG_DELCHAIN:
> +	case NFT_MSG_DELSET:
> +	case NFT_MSG_DELRULE:
> +	case NFT_MSG_DELSETELEM:
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

This chunk, I'd like to see it in the library.

> +static struct nft_table *netlink_nlmsghdr2nltable(const struct nlmsghdr *nlh)

Perhaps netlink_table_alloc(const struct nlmsghdr *nlh) ?

> +{
> +	struct nft_table *nlt = nft_table_alloc();
> +	if (nlt == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_table_nlmsg_parse(nlh, nlt) < 0)
> +		netlink_abi_error();
> +
> +	return nlt;
> +}
> +
> +static struct nft_chain *netlink_nlmsghdr2nlchain(const struct nlmsghdr *nlh)

netlink_chain_alloc ?

> +{
> +	struct nft_chain *nlc = nft_chain_alloc();
> +	if (nlc == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_chain_nlmsg_parse(nlh, nlc) < 0)
> +		netlink_abi_error();
> +
> +	return nlc;
> +}
> +
> +static struct nft_set *netlink_nlmsghdr2nlset(const struct nlmsghdr *nlh)
> +{

netlink_set_alloc

> +	struct nft_set *nls = nft_set_alloc();
> +	if (nls == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_set_nlmsg_parse(nlh, nls) < 0)
> +		netlink_abi_error();
> +
> +	return nls;
> +}
> +
> +static struct nft_set *netlink_nlmsghdr2nlsetelem(const struct nlmsghdr *nlh)

netlink_setelem_alloc

> +{
> +	struct nft_set *nls = nft_set_alloc();
> +	if (nls == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_set_elems_nlmsg_parse(nlh, nls) < 0)
> +		netlink_abi_error();
> +
> +	return nls;
> +}
> +
> +static struct nft_set_elem *netlink_nlset_first_elem(struct nft_set *nls)
> +{
> +	struct nft_set_elems_iter *nlsei;
> +	struct nft_set_elem *nlse;

I remember you asked to have this in the library, go ahead add some
helper there.

Otherwise, rename this to netlink_set_get_first_elem?

> +
> +	/* only first, useful for set_elem event reporting from kernel */
> +	nlsei = nft_set_elems_iter_create(nls);
> +	if (nlsei == NULL)
> +		memory_allocation_error();
> +
> +	nlse = nft_set_elems_iter_cur(nlsei);
> +	if (nlse == NULL)
> +		memory_allocation_error();
> +
> +	nft_set_elems_iter_destroy(nlsei);
> +
> +	return nlse;
> +}
> +
> +static struct nft_rule *netlink_nlmsghdr2nlrule(const struct nlmsghdr *nlh)
> +{
> +	struct nft_rule *nlr = nft_rule_alloc();
> +	if (nlr == NULL)
> +		memory_allocation_error();
> +
> +	if (nft_rule_nlmsg_parse(nlh, nlr) < 0)
> +		netlink_abi_error();
> +
> +	return nlr;
> +}
> +
> +static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
> +				   struct netlink_mon_handler *monh)
> +{
> +	uint32_t family;
> +	char buf[4096];
> +	struct nft_table *nlt = netlink_nlmsghdr2nltable(nlh);
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (type == NFT_MSG_NEWTABLE)
> +			printf("add table ");
> +		else
> +			printf("delete table ");

You have to check nlh->nlmsg_flags & NLM_F_EXCL here to catch table
updates.

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
> +	nft_table_free(nlt);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
> +				   struct netlink_mon_handler *monh)
> +{
> +	struct chain *c;
> +	uint32_t family;
> +	char buf[4096];
> +	struct nft_chain *nlc = netlink_nlmsghdr2nlchain(nlh);
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (type == NFT_MSG_NEWCHAIN) {

Same thing here, catch chain updates.

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
> +	nft_chain_free(nlc);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
> +				 struct netlink_mon_handler *monh)
> +{
> +	struct set *set;
> +	uint32_t family, flags;
> +	char buf[4096];
> +	struct nft_set *nls = netlink_nlmsghdr2nlset(nlh);
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
> +static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
> +				     struct netlink_mon_handler *monh)
> +{
> +	struct nft_set_elem *nlse;
> +	struct set *dummyset;
> +	struct set *set;
> +	const char *setname, *table;
> +	uint32_t family;
> +	char buf[4096];
> +	struct nft_set *nls = netlink_nlmsghdr2nlsetelem(nlh);
> +
> +	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
> +	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
> +	family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
> +
> +	set = set_lookup_global(family, table, setname);
> +	if (set == NULL) {
> +		fprintf(stderr, "W: Received event for an unknown set.");
> +		goto out;
> +	}
> +
> +	if (monh->format == NFT_OUTPUT_DEFAULT) {
> +		if (set->flags & SET_F_ANONYMOUS)
> +			goto out;
> +
> +		nlse = netlink_nlset_first_elem(nls);
> +
> +		/* we want to 'delinearize' the set_elem, but don't modify the
> +		 * original cached set. This path is only used by named sets,
> +		 * so use a dummy set.
> +		 */
> +		dummyset = set_alloc(monh->loc);
> +		dummyset->keytype = set->keytype;
> +		dummyset->datatype = set->datatype;
> +		dummyset->init = set_expr_alloc(monh->loc);
> +
> +		if (netlink_delinearize_setelem(nlse, dummyset) < 0) {
> +			set_free(dummyset);
> +			goto out;
> +		}
> +
> +		if (type == NFT_MSG_NEWSETELEM)
> +			printf("add ");
> +		else
> +			printf("delete ");
> +
> +		printf("element %s %s %s ", family2str(family), table, setname);
> +		expr_print(dummyset->init);
> +		printf("\n");
> +
> +		set_free(dummyset);
> +	} else {
> +		nft_set_snprintf(buf, sizeof(buf), nls, monh->format, 0);
> +		netlink_events_printf_wrapper(buf, monh->format, type);
> +	}
> +
> +out:
> +	/* nlse is freed here */
> +	nft_set_free(nls);
> +	return MNL_CB_OK;
> +}
> +
> +static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
> +				  struct netlink_mon_handler *monh)
> +{
> +	struct rule *r;
> +	char buf[4096];
> +	uint32_t fam;
> +	const char *family;
> +	const char *table;
> +	const char *chain;
> +	uint64_t handle;
> +	struct nft_rule *nlr = netlink_nlmsghdr2nlrule(nlh);
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
> +
> +			printf("add rule %s %s %s", family, table, chain);
> +			rule_print(r);
> +			printf("\n");
> +
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
> +	struct table *t;
> +	struct nft_table *nlt = netlink_nlmsghdr2nltable(nlh);
> +
> +	t = netlink_delinearize_table(monh->ctx, nlt);
> +	table_add_hash(t);
> +
> +	nft_table_free(nlt);
> +}
> +
> +static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
> +					  const struct nlmsghdr *nlh)
> +{
> +	struct table *t;
> +	struct handle h;
> +	struct nft_table *nlt = netlink_nlmsghdr2nltable(nlh);
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
> +	struct set *s;
> +	LIST_HEAD(msgs);
> +	struct table *t;
> +	struct netlink_ctx set_tmpctx;
> +	struct nft_set *nls = netlink_nlmsghdr2nlset(nlh);
> +
> +	memset(&set_tmpctx, 0, sizeof(set_tmpctx));
> +	init_list_head(&set_tmpctx.list);
> +	init_list_head(&msgs);
> +	set_tmpctx.msgs = &msgs;
> +
> +	s = netlink_delinearize_set(&set_tmpctx, nls);
> +	s->init = set_expr_alloc(monh->loc);
> +
> +	t = table_lookup(&s->handle);
> +	if (t == NULL) {
> +		fprintf(stderr, "W: Unable to cache set: table not found.\n");
> +		goto out;
> +	}
> +
> +	set_add_hash(s, t);
> +out:
> +	nft_set_free(nls);
> +}
> +
> +static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
> +					    const struct nlmsghdr *nlh)
> +{
> +	struct set *set;
> +	struct nft_set_elem *nlse;
> +	const char *table, *setname;
> +	struct nft_set *nls = netlink_nlmsghdr2nlsetelem(nlh);
> +
> +	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
> +	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
> +
> +	set = set_lookup_global(nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
> +				table, setname);
> +	if (set == NULL) {
> +		fprintf(stderr,
> +			"W: Unable to cache set_elem. Set not found.\n");
> +		goto out;
> +	}
> +
> +	nlse = netlink_nlset_first_elem(nls);
> +
> +	if (netlink_delinearize_setelem(nlse, set) < 0)
> +		fprintf(stderr,
> +			"W: Unable to cache set_elem. Delinearize failed.\n");
> +out:
> +	/* nlse is freed inside nft_set_free() */
> +	nft_set_free(nls);
> +}
> +
> +static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
> +					 const struct nlmsghdr *nlh)
> +{
> +	struct set *s;
> +	uint32_t family;
> +	struct nft_rule_expr *nlre;
> +	struct nft_rule_expr_iter *nlrei;
> +	const char *expr_name, *set_name, *table;
> +	struct nft_rule *nlr = netlink_nlmsghdr2nlrule(nlh);
> +
> +	nlrei = nft_rule_expr_iter_create(nlr);
> +	if (nlrei == NULL)
> +		memory_allocation_error();
> +
> +	family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
> +	table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
> +
> +	nlre = nft_rule_expr_iter_next(nlrei);
> +	while (nlre != NULL) {
> +		expr_name = nft_rule_expr_get_str(nlre,
> +						  NFT_RULE_EXPR_ATTR_NAME);
> +		if (strcmp(expr_name, "lookup") != 0)
> +			goto next;
> +
> +		set_name = nft_rule_expr_get_str(nlre, NFT_EXPR_LOOKUP_SET);
> +		s = set_lookup_global(family, table, set_name);
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
> +	nft_rule_free(nlr);
> +}
> +
> +static void netlink_events_cache_update(struct netlink_mon_handler *monh,
> +					const struct nlmsghdr *nlh, int type)
> +{
> +	if (!monh->cache_needed)
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
> +	case NFT_MSG_NEWSETELEM:
> +		netlink_events_cache_addsetelem(monh, nlh);
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
> +	if (!(monh->monitor_flags & (1 << type)))
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
> +	case NFT_MSG_DELSET:		/* nft {add|delete} set */
> +		ret = netlink_events_set_cb(nlh, type, monh);
> +		break;
> +	case NFT_MSG_NEWSETELEM:
> +	case NFT_MSG_DELSETELEM:	/* nft {add|delete} element */
> +		ret = netlink_events_setelem_cb(nlh, type, monh);
> +		break;
> +	case NFT_MSG_NEWRULE:
> +	case NFT_MSG_DELRULE:
> +		ret = netlink_events_rule_cb(nlh, type, monh);
> +		break;
> +	default:
> +		BUG("Unknow event received from netlink.\n");
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
> index af34857..4f6b59b 100644
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
>  
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
> @@ -362,8 +367,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
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
> @@ -491,7 +496,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %destructor { expr_free($$); }	ct_expr
>  %type <val>			ct_key
>  
> -%type <val>			export_format
> +%type <val>			export_format	output_format	monitor_flags
>  
>  %%
>  
> @@ -591,6 +596,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
>  			|	FLUSH		flush_cmd	{ $$ = $2; }
>  			|	RENAME		rename_cmd	{ $$ = $2; }
>  			|	EXPORT		export_cmd	{ $$ = $2; }
> +			|	MONITOR		monitor_cmd	{ $$ = $2; }
>  			|	DESCRIBE	primary_expr
>  			{
>  				expr_describe($2);
> @@ -758,6 +764,84 @@ export_cmd		:	export_format
>  			}
>  			;
>  
> +monitor_cmd		:	monitor_flags	output_format
> +			{
> +				struct handle h = { .family = NFPROTO_UNSPEC };
> +				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
> +				$$->monitor_flags = $1;
> +				$$->format = $2;
> +			}
> +			;
> +
> +monitor_flags		:	/* empty */
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);
> +				$$ |= (1 << NFT_MSG_DELRULE);
> +				$$ |= (1 << NFT_MSG_NEWSET);
> +				$$ |= (1 << NFT_MSG_DELSET);
> +				$$ |= (1 << NFT_MSG_NEWSETELEM);
> +				$$ |= (1 << NFT_MSG_DELSETELEM);
> +				$$ |= (1 << NFT_MSG_NEWCHAIN);
> +				$$ |= (1 << NFT_MSG_DELCHAIN);
> +				$$ |= (1 << NFT_MSG_NEWTABLE);
> +				$$ |= (1 << NFT_MSG_DELTABLE);
> +			}
> +			|	ADDED
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);
> +				$$ |= (1 << NFT_MSG_NEWSET);
> +				$$ |= (1 << NFT_MSG_NEWSETELEM);
> +				$$ |= (1 << NFT_MSG_NEWCHAIN);
> +				$$ |= (1 << NFT_MSG_NEWTABLE);
> +			}
> +			|	DELETED
> +			{
> +				$$ |= (1 << NFT_MSG_DELRULE);
> +				$$ |= (1 << NFT_MSG_DELSET);
> +				$$ |= (1 << NFT_MSG_DELSETELEM);
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
> +			|	SETS
> +			{
> +				$$ |= (1 << NFT_MSG_NEWSET);	$$ |= (1 << NFT_MSG_DELSET);
> +			}
> +			|	ADDED	SETS 	{ 	$$ |= (1 << NFT_MSG_NEWSET); }
> +			|	DELETED SETS	{	$$ |= (1 << NFT_MSG_DELSET); }
> +			|	RULE
> +			{
> +				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);
> +			}
> +			|	ADDED 	RULES	{	$$ |= (1 << NFT_MSG_NEWRULE); }
> +			|	DELETED RULES	{	$$ |= (1 << NFT_MSG_DELRULE); }
> +			|	ELEMENTS
> +			{
> +				$$ |= (1 << NFT_MSG_NEWSETELEM);
> +				$$ |= (1 << NFT_MSG_DELSETELEM);
> +			}
> +			|	ADDED	ELEMENTS	{	$$ |= (1 << NFT_MSG_NEWSETELEM); }
> +			|	DELETED ELEMENTS	{	$$ |= (1 << NFT_MSG_DELSETELEM); }
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
> index 858149e..43a3e11 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -77,6 +77,22 @@ void set_free(struct set *set)
>  	xfree(set);
>  }
>  
> +struct set *set_clone(const struct set *set)
> +{
> +	struct set *newset = set_alloc(&set->location);
> +
> +	newset->list = set->list;
> +	handle_merge(&newset->handle, &set->handle);
> +	newset->flags = set->flags;
> +	newset->keytype = set->keytype;
> +	newset->keylen = set->keylen;
> +	newset->datatype = set->datatype;
> +	newset->datalen = set->datalen;
> +	newset->init = expr_clone(set->init);
> +
> +	return newset;
> +}
> +
>  void set_add_hash(struct set *set, struct table *table)
>  {
>  	list_add_tail(&set->list, &table->sets);
> @@ -93,6 +109,22 @@ struct set *set_lookup(const struct table *table, const char *name)
>  	return NULL;
>  }
>  
> +struct set *set_lookup_global(uint32_t family, const char *table,
> +			      const char *name)
> +{
> +	struct handle h;
> +	struct table *t;
> +
> +	h.family = family;
> +	h.table = table;
> +
> +	t = table_lookup(&h);
> +	if (t == NULL)
> +		return NULL;
> +
> +	return set_lookup(t, name);
> +}
> +
>  struct print_fmt_options {
>  	const char	*tab;
>  	const char	*nl;
> @@ -808,6 +840,61 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
>  	return 0;
>  }
>  
> +static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
> +{
> +	struct table *t, *nt;
> +	struct set *s, *ns;
> +	struct netlink_ctx set_ctx;
> +	LIST_HEAD(msgs);
> +	struct handle set_handle;
> +	struct netlink_mon_handler monhandler;
> +
> +	/* cache only needed if monitoring:
> +	 *  - new rules in default format
> +	 *  - new elements
> +	 */
> +	if (((cmd->monitor_flags & (1 << NFT_MSG_NEWRULE)) &&
> +	    (cmd->format == NFT_OUTPUT_DEFAULT)) ||
> +	    (cmd->monitor_flags & (1 << NFT_MSG_NEWSETELEM)))
> +		monhandler.cache_needed = true;
> +	else
> +		monhandler.cache_needed = false;
> +
> +	if (monhandler.cache_needed) {
> +		memset(&set_ctx, 0, sizeof(set_ctx));
> +		init_list_head(&msgs);
> +		set_ctx.msgs = &msgs;
> +
> +		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
> +			return -1;
> +
> +		list_for_each_entry_safe(t, nt, &ctx->list, list) {
> +			set_handle.family = t->handle.family;
> +			set_handle.table = t->handle.table;
> +
> +			init_list_head(&set_ctx.list);
> +
> +			if (netlink_list_sets(&set_ctx, &set_handle,
> +					      &cmd->location) < 0)
> +				return -1;
> +
> +			list_for_each_entry_safe(s, ns, &set_ctx.list, list) {
> +				s->init = set_expr_alloc(&cmd->location);
> +				set_add_hash(s, t);
> +			}
> +
> +			table_add_hash(t);
> +		}
> +	}
> +
> +	monhandler.monitor_flags = cmd->monitor_flags;
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
> @@ -827,6 +914,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
>  		return do_command_rename(ctx, cmd);
>  	case CMD_EXPORT:
>  		return do_command_export(ctx, cmd);
> +	case CMD_MONITOR:
> +		return do_command_monitor(ctx, cmd);
>  	default:
>  		BUG("invalid command object type %u\n", cmd->obj);
>  	}
> diff --git a/src/scanner.l b/src/scanner.l
> index 47c5933..26b4737 100644
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

I think Patrick asked to use "new" instead of "added" and "destroy"
instead of "deleted" IIRC.

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
>  "comment"		{ return COMMENT; }
> 
