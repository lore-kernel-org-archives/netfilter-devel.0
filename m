From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2 8/8] src: add events reporting
Date: Wed, 16 Apr 2014 18:43:17 +0200
Message-ID: <20140416164256.5952.95010.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55429 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751045AbaDPQnW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:43:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a basic events reporting option to nft.

The syntax is:
 % nft monitor [new|destroy] [tables|chains|rules|sets|elements] [xml|json]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: Move code to libnftnl. Allow multiple set_elem in a single event.
    Rename functions. Rename options to [new|destroy].
    Handle chain/table updates.
 include/mnl.h     |    3 
 include/netlink.h |   10 +
 include/rule.h    |    6 +
 src/evaluate.c    |    1 
 src/mnl.c         |   10 +
 src/netlink.c     |  547 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser.y      |   90 ++++++++-
 src/rule.c        |   89 +++++++++
 src/scanner.l     |    5 
 9 files changed, 755 insertions(+), 6 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index f4de27d..ece7ee7 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -67,4 +67,7 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
+int mnl_nft_event_listener(struct mnl_socket *nf_sock,
+			   int (*cb)(const struct nlmsghdr *nlh, void *data),
+			   void *cb_data);
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 1fb0356..eca4a48 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -136,6 +136,7 @@ extern void netlink_dump_expr(struct nft_rule_expr *nle);
 extern void netlink_dump_set(struct nft_set *nls);
 
 extern int netlink_batch_send(struct list_head *err_list);
+extern void netlink_abi_error(void) __noreturn;
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
 extern void netlink_open_error(void) __noreturn;
@@ -143,4 +144,13 @@ extern void netlink_open_error(void) __noreturn;
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
+struct netlink_mon_handler {
+	uint32_t		monitor_flags;
+	uint32_t		format;
+	struct netlink_ctx	*ctx;
+	const struct location	*loc;
+	bool			cache_needed;
+};
+
+extern int netlink_monitor(struct netlink_mon_handler *monhandler);
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 6c373e6..da604a5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -195,8 +195,11 @@ struct set {
 extern struct set *set_alloc(const struct location *loc);
 extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
+extern struct set *set_clone(const struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
+extern struct set *set_lookup_global(uint32_t family, const char *table,
+				     const char *name);
 extern void set_print(const struct set *set);
 extern void set_print_plain(const struct set *s);
 
@@ -212,6 +215,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
+ * @CMD_MONITOR:	event listener
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -223,6 +227,7 @@ enum cmd_ops {
 	CMD_FLUSH,
 	CMD_RENAME,
 	CMD_EXPORT,
+	CMD_MONITOR,
 };
 
 /**
@@ -278,6 +283,7 @@ struct cmd {
 	};
 	const void		*arg;
 	uint32_t		format;
+	uint32_t		monitor_flags;
 };
 
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
diff --git a/src/evaluate.c b/src/evaluate.c
index dc4406c..2330bbb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1428,6 +1428,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
+	case CMD_MONITOR:
 		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
diff --git a/src/mnl.c b/src/mnl.c
index c034961..4d60d64 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -813,3 +813,13 @@ out:
 	nft_ruleset_free(rs);
 	return NULL;
 }
+
+/*
+ * events
+ */
+int mnl_nft_event_listener(struct mnl_socket *nf_sock,
+			   int (*cb)(const struct nlmsghdr *nlh, void *data),
+			   void *cb_data)
+{
+	return nft_mnl_recv(nf_sock, 0, 0, cb, cb_data);
+}
diff --git a/src/netlink.c b/src/netlink.c
index 10951f9..22150f2 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -21,6 +21,8 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/common.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
 
@@ -33,6 +35,7 @@
 #include <erec.h>
 
 static struct mnl_socket *nf_sock;
+static struct mnl_socket *nf_mon_sock;
 
 const struct input_descriptor indesc_netlink = {
 	.name	= "netlink",
@@ -43,12 +46,18 @@ const struct location netlink_location = {
 	.indesc	= &indesc_netlink,
 };
 
-static void __init netlink_open_sock(void)
+static struct mnl_socket *nfsock_open(void)
 {
-	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
-	if (nf_sock == NULL)
+	struct mnl_socket *s = mnl_socket_open(NETLINK_NETFILTER);
+	if (s == NULL)
 		netlink_open_error();
 
+	return s;
+}
+
+static void __init netlink_open_sock(void)
+{
+	nf_sock = nfsock_open();
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 	mnl_batch_init();
 }
@@ -56,6 +65,20 @@ static void __init netlink_open_sock(void)
 static void __exit netlink_close_sock(void)
 {
 	mnl_socket_close(nf_sock);
+	if (nf_mon_sock)
+		mnl_socket_close(nf_mon_sock);
+}
+
+static void netlink_open_mon_sock(void)
+{
+	nf_mon_sock = nfsock_open();
+}
+
+void __noreturn netlink_abi_error(void)
+{
+	fprintf(stderr, "E: Contact urgently your Linux kernel vendor. "
+		"Netlink ABI is broken: %s\n", strerror(errno));
+	exit(NFT_EXIT_FAILURE);
 }
 
 int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
@@ -1062,3 +1085,521 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 
 	return rs;
 }
+
+static struct nft_table *netlink_table_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_table *nlt = nft_table_alloc();
+	if (nlt == NULL)
+		memory_allocation_error();
+
+	if (nft_table_nlmsg_parse(nlh, nlt) < 0)
+		netlink_abi_error();
+
+	return nlt;
+}
+
+static struct nft_chain *netlink_chain_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_chain *nlc = nft_chain_alloc();
+	if (nlc == NULL)
+		memory_allocation_error();
+
+	if (nft_chain_nlmsg_parse(nlh, nlc) < 0)
+		netlink_abi_error();
+
+	return nlc;
+}
+
+static struct nft_set *netlink_set_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_set *nls = nft_set_alloc();
+	if (nls == NULL)
+		memory_allocation_error();
+
+	if (nft_set_nlmsg_parse(nlh, nls) < 0)
+		netlink_abi_error();
+
+	return nls;
+}
+
+static struct nft_set *netlink_setelem_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_set *nls = nft_set_alloc();
+	if (nls == NULL)
+		memory_allocation_error();
+
+	if (nft_set_elems_nlmsg_parse(nlh, nls) < 0)
+		netlink_abi_error();
+
+	return nls;
+}
+
+static struct nft_rule *netlink_rule_alloc(const struct nlmsghdr *nlh)
+{
+	struct nft_rule *nlr = nft_rule_alloc();
+	if (nlr == NULL)
+		memory_allocation_error();
+
+	if (nft_rule_nlmsg_parse(nlh, nlr) < 0)
+		netlink_abi_error();
+
+	return nlr;
+}
+
+static uint32_t netlink_msg2nftnl_of(uint32_t msg)
+{
+	switch (msg) {
+	case NFT_MSG_NEWTABLE:
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_NEWRULE:
+		return NFT_OF_EVENT_NEW;
+	case NFT_MSG_DELTABLE:
+	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DELSET:
+	case NFT_MSG_DELSETELEM:
+	case NFT_MSG_DELRULE:
+		return NFT_OF_EVENT_DEL;
+	}
+
+	return 0;
+}
+
+static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
+				   struct netlink_mon_handler *monh)
+{
+	uint32_t family;
+	struct nft_table *nlt = netlink_table_alloc(nlh);
+
+	if (monh->format == NFT_OUTPUT_DEFAULT) {
+		if (type == NFT_MSG_NEWTABLE) {
+			if (nlh->nlmsg_flags & NLM_F_EXCL)
+				printf("update table ");
+			else
+				printf("add table ");
+		} else {
+			printf("delete table ");
+		}
+
+		family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
+
+		printf("%s %s\n", family2str(family),
+		       nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
+	} else {
+		nft_table_fprintf(stdout, nlt, monh->format,
+				  netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+	}
+
+	nft_table_free(nlt);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
+				   struct netlink_mon_handler *monh)
+{
+	struct chain *c;
+	uint32_t family;
+	struct nft_chain *nlc = netlink_chain_alloc(nlh);
+
+	if (monh->format == NFT_OUTPUT_DEFAULT) {
+		if (type == NFT_MSG_NEWCHAIN) {
+			if (nlh->nlmsg_flags & NLM_F_EXCL)
+				printf("update ");
+			else
+				printf("add ");
+
+			c = netlink_delinearize_chain(monh->ctx, nlc);
+			chain_print_plain(c);
+			chain_free(c);
+		} else {
+			family = nft_chain_attr_get_u32(nlc,
+							NFT_CHAIN_ATTR_FAMILY);
+			printf("delete chain %s %s %s\n", family2str(family),
+			       nft_chain_attr_get_str(nlc,
+						      NFT_CHAIN_ATTR_TABLE),
+			       nft_chain_attr_get_str(nlc,
+						      NFT_CHAIN_ATTR_NAME));
+		}
+	} else {
+		nft_chain_fprintf(stdout, nlc, monh->format,
+				  netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+	}
+
+	nft_chain_free(nlc);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
+				 struct netlink_mon_handler *monh)
+{
+	struct set *set;
+	uint32_t family, flags;
+	struct nft_set *nls = netlink_set_alloc(nlh);
+
+	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	if (flags & SET_F_ANONYMOUS)
+		goto out;
+
+	if (monh->format == NFT_OUTPUT_DEFAULT) {
+		if (type == NFT_MSG_NEWSET) {
+			printf("add ");
+			set = netlink_delinearize_set(monh->ctx, nls);
+			set_print_plain(set);
+			set_free(set);
+		} else {
+			family = nft_set_attr_get_u32(nls,
+						      NFT_SET_ATTR_FAMILY);
+			printf("delete set %s %s %s",
+			       family2str(family),
+			       nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE),
+			       nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+		}
+
+		printf("\n");
+
+	} else {
+		nft_set_fprintf(stdout, nls, monh->format,
+				netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+	}
+
+out:
+	nft_set_free(nls);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
+				     struct netlink_mon_handler *monh)
+{
+	struct nft_set_elem *nlse;
+	struct nft_set_elems_iter *nlsei;
+	struct set *dummyset;
+	struct set *set;
+	const char *setname, *table;
+	uint32_t family;
+	struct nft_set *nls = netlink_setelem_alloc(nlh);
+
+	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
+	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
+	family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+
+	set = set_lookup_global(family, table, setname);
+	if (set == NULL) {
+		fprintf(stderr, "W: Received event for an unknown set.");
+		goto out;
+	}
+
+	if (monh->format == NFT_OUTPUT_DEFAULT) {
+		if (set->flags & SET_F_ANONYMOUS)
+			goto out;
+
+		/* we want to 'delinearize' the set_elem, but don't
+		 * modify the original cached set. This path is only
+		 * used by named sets, so use a dummy set.
+		 */
+		dummyset = set_alloc(monh->loc);
+		dummyset->keytype = set->keytype;
+		dummyset->datatype = set->datatype;
+		dummyset->init = set_expr_alloc(monh->loc);
+
+		nlsei = nft_set_elems_iter_create(nls);
+		if (nlsei == NULL)
+			memory_allocation_error();
+
+		nlse = nft_set_elems_iter_next(nlsei);
+		while (nlse != NULL) {
+			if (netlink_delinearize_setelem(nlse, dummyset) < 0) {
+				set_free(dummyset);
+				nft_set_elems_iter_destroy(nlsei);
+				goto out;
+			}
+			nlse = nft_set_elems_iter_next(nlsei);
+		}
+		nft_set_elems_iter_destroy(nlsei);
+
+		if (type == NFT_MSG_NEWSETELEM)
+			printf("add ");
+		else
+			printf("delete ");
+
+		printf("element %s %s %s ", family2str(family), table, setname);
+		expr_print(dummyset->init);
+		printf("\n");
+
+		set_free(dummyset);
+	} else {
+		nft_set_fprintf(stdout, nls, monh->format,
+				netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+	}
+
+out:
+	nft_set_free(nls);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
+				  struct netlink_mon_handler *monh)
+{
+	struct rule *r;
+	uint32_t fam;
+	const char *family;
+	const char *table;
+	const char *chain;
+	uint64_t handle;
+	struct nft_rule *nlr = netlink_rule_alloc(nlh);
+
+	if (monh->format == NFT_OUTPUT_DEFAULT) {
+		fam = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+		family = family2str(fam);
+		table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
+		chain = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN);
+		handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
+
+		if (type == NFT_MSG_NEWRULE) {
+			r = netlink_delinearize_rule(monh->ctx, nlr);
+
+			printf("add rule %s %s %s", family, table, chain);
+			rule_print(r);
+			printf("\n");
+
+			rule_free(r);
+			goto out;
+		}
+
+		printf("delete rule %s %s %s handle %u\n",
+		       family, table, chain, (unsigned int)handle);
+	} else {
+		nft_rule_fprintf(stdout, nlr, monh->format,
+				 netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+	}
+
+out:
+	nft_rule_free(nlr);
+	return MNL_CB_OK;
+}
+
+static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
+					  const struct nlmsghdr *nlh)
+{
+	struct table *t;
+	struct nft_table *nlt = netlink_table_alloc(nlh);
+
+	t = netlink_delinearize_table(monh->ctx, nlt);
+	table_add_hash(t);
+
+	nft_table_free(nlt);
+}
+
+static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
+					  const struct nlmsghdr *nlh)
+{
+	struct table *t;
+	struct handle h;
+	struct nft_table *nlt = netlink_table_alloc(nlh);
+
+	h.family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
+	h.table = nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME);
+
+	t = table_lookup(&h);
+	if (t == NULL)
+		goto out;
+
+	list_del(&t->list);
+	table_free(t);
+
+out:
+	nft_table_free(nlt);
+}
+
+static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
+					const struct nlmsghdr *nlh)
+{
+	struct set *s;
+	LIST_HEAD(msgs);
+	struct table *t;
+	struct netlink_ctx set_tmpctx;
+	struct nft_set *nls = netlink_set_alloc(nlh);
+
+	memset(&set_tmpctx, 0, sizeof(set_tmpctx));
+	init_list_head(&set_tmpctx.list);
+	init_list_head(&msgs);
+	set_tmpctx.msgs = &msgs;
+
+	s = netlink_delinearize_set(&set_tmpctx, nls);
+	s->init = set_expr_alloc(monh->loc);
+
+	t = table_lookup(&s->handle);
+	if (t == NULL) {
+		fprintf(stderr, "W: Unable to cache set: table not found.\n");
+		goto out;
+	}
+
+	set_add_hash(s, t);
+out:
+	nft_set_free(nls);
+}
+
+static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
+					    const struct nlmsghdr *nlh)
+{
+	struct set *set;
+	struct nft_set_elem *nlse;
+	struct nft_set_elems_iter *nlsei;
+	const char *table, *setname;
+	struct nft_set *nls = netlink_setelem_alloc(nlh);
+
+	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
+	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
+
+	set = set_lookup_global(nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				table, setname);
+	if (set == NULL) {
+		fprintf(stderr,
+			"W: Unable to cache set_elem. Set not found.\n");
+		goto out;
+	}
+
+	nlsei = nft_set_elems_iter_create(nls);
+	if (nlsei == NULL)
+		memory_allocation_error();
+
+	nlse = nft_set_elems_iter_next(nlsei);
+	while (nlse != NULL) {
+		if (netlink_delinearize_setelem(nlse, set) < 0) {
+			fprintf(stderr,
+				"W: Unable to cache set_elem. "
+				"Delinearize failed.\n");
+			nft_set_elems_iter_destroy(nlsei);
+			goto out;
+		}
+		nlse = nft_set_elems_iter_next(nlsei);
+	}
+	nft_set_elems_iter_destroy(nlsei);
+
+out:
+	nft_set_free(nls);
+}
+
+static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
+					 const struct nlmsghdr *nlh)
+{
+	struct set *s;
+	uint32_t family;
+	struct nft_rule_expr *nlre;
+	struct nft_rule_expr_iter *nlrei;
+	const char *expr_name, *set_name, *table;
+	struct nft_rule *nlr = netlink_rule_alloc(nlh);
+
+	nlrei = nft_rule_expr_iter_create(nlr);
+	if (nlrei == NULL)
+		memory_allocation_error();
+
+	family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+	table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
+
+	nlre = nft_rule_expr_iter_next(nlrei);
+	while (nlre != NULL) {
+		expr_name = nft_rule_expr_get_str(nlre,
+						  NFT_RULE_EXPR_ATTR_NAME);
+		if (strcmp(expr_name, "lookup") != 0)
+			goto next;
+
+		set_name = nft_rule_expr_get_str(nlre, NFT_EXPR_LOOKUP_SET);
+		s = set_lookup_global(family, table, set_name);
+		if (s == NULL)
+			goto next;
+
+		list_del(&s->list);
+		set_free(s);
+next:
+		nlre = nft_rule_expr_iter_next(nlrei);
+	}
+	nft_rule_expr_iter_destroy(nlrei);
+
+	nft_rule_free(nlr);
+}
+
+static void netlink_events_cache_update(struct netlink_mon_handler *monh,
+					const struct nlmsghdr *nlh, int type)
+{
+	if (!monh->cache_needed)
+		return;
+
+	switch (type) {
+	case NFT_MSG_NEWTABLE:
+		netlink_events_cache_addtable(monh, nlh);
+		break;
+	case NFT_MSG_DELTABLE:
+		netlink_events_cache_deltable(monh, nlh);
+		break;
+	case NFT_MSG_NEWSET:
+		netlink_events_cache_addset(monh, nlh);
+		break;
+	case NFT_MSG_NEWSETELEM:
+		netlink_events_cache_addsetelem(monh, nlh);
+		break;
+	case NFT_MSG_DELRULE:
+		/* there are no notification for anon-set deletion */
+		netlink_events_cache_delsets(monh, nlh);
+		break;
+	}
+}
+
+static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
+{
+	int ret = MNL_CB_OK;
+	int type = nlh->nlmsg_type & 0xFF;
+	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
+
+	netlink_events_cache_update(monh, nlh, type);
+
+	if (!(monh->monitor_flags & (1 << type)))
+		return ret;
+
+	switch (type) {
+	case NFT_MSG_NEWTABLE:
+	case NFT_MSG_DELTABLE:
+		ret = netlink_events_table_cb(nlh, type, monh);
+		break;
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_DELCHAIN:
+		ret = netlink_events_chain_cb(nlh, type, monh);
+		break;
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_DELSET:		/* nft {add|delete} set */
+		ret = netlink_events_set_cb(nlh, type, monh);
+		break;
+	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_DELSETELEM:	/* nft {add|delete} element */
+		ret = netlink_events_setelem_cb(nlh, type, monh);
+		break;
+	case NFT_MSG_NEWRULE:
+	case NFT_MSG_DELRULE:
+		ret = netlink_events_rule_cb(nlh, type, monh);
+		break;
+	default:
+		BUG("Unknow event received from netlink.\n");
+		break;
+	}
+
+	return ret;
+}
+
+int netlink_monitor(struct netlink_mon_handler *monhandler)
+{
+	netlink_open_mon_sock();
+
+	if (mnl_socket_bind(nf_mon_sock, (1 << (NFNLGRP_NFTABLES-1)),
+			    MNL_SOCKET_AUTOPID) < 0)
+		return netlink_io_error(monhandler->ctx, monhandler->loc,
+					"Could not bind to netlink socket %s",
+					strerror(errno));
+
+	return mnl_nft_event_listener(nf_mon_sock, netlink_events_cb,
+				      monhandler);
+}
diff --git a/src/parser.y b/src/parser.y
index de5c0ed..c87c01c 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -163,12 +163,16 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token TABLE			"table"
 %token TABLES			"tables"
 %token CHAIN			"chain"
+%token CHAINS			"chains"
 %token RULE			"rule"
+%token RULES			"rules"
 %token SETS			"sets"
 %token SET			"set"
 %token ELEMENT			"element"
 %token MAP			"map"
 %token HANDLE			"handle"
+%token NEW			"new"
+%token DESTROY			"destroy"
 
 %token INET			"inet"
 
@@ -181,6 +185,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
+%token MONITOR			"monitor"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -362,8 +367,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
@@ -491,7 +496,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format
+%type <val>			export_format	output_format	monitor_flags
 
 %%
 
@@ -591,6 +596,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
+			|	MONITOR		monitor_cmd	{ $$ = $2; }
 			|	DESCRIBE	primary_expr
 			{
 				expr_describe($2);
@@ -758,6 +764,84 @@ export_cmd		:	export_format
 			}
 			;
 
+monitor_cmd		:	monitor_flags	output_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
+				$$->monitor_flags = $1;
+				$$->format = $2;
+			}
+			;
+
+monitor_flags		:	/* empty */
+			{
+				$$ |= (1 << NFT_MSG_NEWRULE);
+				$$ |= (1 << NFT_MSG_DELRULE);
+				$$ |= (1 << NFT_MSG_NEWSET);
+				$$ |= (1 << NFT_MSG_DELSET);
+				$$ |= (1 << NFT_MSG_NEWSETELEM);
+				$$ |= (1 << NFT_MSG_DELSETELEM);
+				$$ |= (1 << NFT_MSG_NEWCHAIN);
+				$$ |= (1 << NFT_MSG_DELCHAIN);
+				$$ |= (1 << NFT_MSG_NEWTABLE);
+				$$ |= (1 << NFT_MSG_DELTABLE);
+			}
+			|	NEW
+			{
+				$$ |= (1 << NFT_MSG_NEWRULE);
+				$$ |= (1 << NFT_MSG_NEWSET);
+				$$ |= (1 << NFT_MSG_NEWSETELEM);
+				$$ |= (1 << NFT_MSG_NEWCHAIN);
+				$$ |= (1 << NFT_MSG_NEWTABLE);
+			}
+			|	DESTROY
+			{
+				$$ |= (1 << NFT_MSG_DELRULE);
+				$$ |= (1 << NFT_MSG_DELSET);
+				$$ |= (1 << NFT_MSG_DELSETELEM);
+				$$ |= (1 << NFT_MSG_DELCHAIN);
+				$$ |= (1 << NFT_MSG_DELTABLE);
+			}
+			|	TABLES
+			{
+				$$ |= (1 << NFT_MSG_NEWTABLE);	$$ |= (1 << NFT_MSG_DELTABLE);
+			}
+			|	NEW 	TABLES 	{	$$ |= (1 << NFT_MSG_NEWTABLE); }
+			|	DESTROY	TABLES	{	$$ |= (1 << NFT_MSG_DELTABLE); }
+			|	CHAIN
+			{
+				$$ |= (1 << NFT_MSG_NEWCHAIN);	$$ |= (1 << NFT_MSG_DELCHAIN);
+			}
+			|	NEW	CHAINS	{	$$ |= (1 << NFT_MSG_NEWCHAIN); }
+			|	DESTROY	CHAINS	{	$$ |= (1 << NFT_MSG_DELCHAIN); }
+			|	SETS
+			{
+				$$ |= (1 << NFT_MSG_NEWSET);	$$ |= (1 << NFT_MSG_DELSET);
+			}
+			|	NEW	SETS 	{ 	$$ |= (1 << NFT_MSG_NEWSET); }
+			|	DESTROY SETS	{	$$ |= (1 << NFT_MSG_DELSET); }
+			|	RULE
+			{
+				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);
+			}
+			|	NEW 	RULES	{	$$ |= (1 << NFT_MSG_NEWRULE); }
+			|	DESTROY RULES	{	$$ |= (1 << NFT_MSG_DELRULE); }
+			|	ELEMENTS
+			{
+				$$ |= (1 << NFT_MSG_NEWSETELEM);
+				$$ |= (1 << NFT_MSG_DELSETELEM);
+			}
+			|	NEW	ELEMENTS	{	$$ |= (1 << NFT_MSG_NEWSETELEM); }
+			|	DESTROY ELEMENTS	{	$$ |= (1 << NFT_MSG_DELSETELEM); }
+			;
+
+output_format		:	/* empty */
+			{
+				$$ = NFT_OUTPUT_DEFAULT;
+			}
+			|	export_format
+			;
+
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
diff --git a/src/rule.c b/src/rule.c
index 858149e..43a3e11 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -77,6 +77,22 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
+struct set *set_clone(const struct set *set)
+{
+	struct set *newset = set_alloc(&set->location);
+
+	newset->list = set->list;
+	handle_merge(&newset->handle, &set->handle);
+	newset->flags = set->flags;
+	newset->keytype = set->keytype;
+	newset->keylen = set->keylen;
+	newset->datatype = set->datatype;
+	newset->datalen = set->datalen;
+	newset->init = expr_clone(set->init);
+
+	return newset;
+}
+
 void set_add_hash(struct set *set, struct table *table)
 {
 	list_add_tail(&set->list, &table->sets);
@@ -93,6 +109,22 @@ struct set *set_lookup(const struct table *table, const char *name)
 	return NULL;
 }
 
+struct set *set_lookup_global(uint32_t family, const char *table,
+			      const char *name)
+{
+	struct handle h;
+	struct table *t;
+
+	h.family = family;
+	h.table = table;
+
+	t = table_lookup(&h);
+	if (t == NULL)
+		return NULL;
+
+	return set_lookup(t, name);
+}
+
 struct print_fmt_options {
 	const char	*tab;
 	const char	*nl;
@@ -808,6 +840,61 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *t, *nt;
+	struct set *s, *ns;
+	struct netlink_ctx set_ctx;
+	LIST_HEAD(msgs);
+	struct handle set_handle;
+	struct netlink_mon_handler monhandler;
+
+	/* cache only needed if monitoring:
+	 *  - new rules in default format
+	 *  - new elements
+	 */
+	if (((cmd->monitor_flags & (1 << NFT_MSG_NEWRULE)) &&
+	    (cmd->format == NFT_OUTPUT_DEFAULT)) ||
+	    (cmd->monitor_flags & (1 << NFT_MSG_NEWSETELEM)))
+		monhandler.cache_needed = true;
+	else
+		monhandler.cache_needed = false;
+
+	if (monhandler.cache_needed) {
+		memset(&set_ctx, 0, sizeof(set_ctx));
+		init_list_head(&msgs);
+		set_ctx.msgs = &msgs;
+
+		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+			return -1;
+
+		list_for_each_entry_safe(t, nt, &ctx->list, list) {
+			set_handle.family = t->handle.family;
+			set_handle.table = t->handle.table;
+
+			init_list_head(&set_ctx.list);
+
+			if (netlink_list_sets(&set_ctx, &set_handle,
+					      &cmd->location) < 0)
+				return -1;
+
+			list_for_each_entry_safe(s, ns, &set_ctx.list, list) {
+				s->init = set_expr_alloc(&cmd->location);
+				set_add_hash(s, t);
+			}
+
+			table_add_hash(t);
+		}
+	}
+
+	monhandler.monitor_flags = cmd->monitor_flags;
+	monhandler.format = cmd->format;
+	monhandler.ctx = ctx;
+	monhandler.loc = &cmd->location;
+
+	return netlink_monitor(&monhandler);
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
@@ -827,6 +914,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_rename(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
+	case CMD_MONITOR:
+		return do_command_monitor(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 47c5933..53e2498 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -232,12 +232,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "table"			{ return TABLE; }
 "tables"		{ return TABLES; }
 "chain"			{ return CHAIN; }
+"chains"		{ return CHAINS; }
 "rule"			{ return RULE; }
+"rules"			{ return RULES; }
 "sets"			{ return SETS; }
 "set"			{ return SET; }
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "handle"		{ return HANDLE; }
+"new"			{ return NEW; }
+"destroy"		{ return DESTROY; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
@@ -256,6 +260,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
+"monitor"		{ return MONITOR; }
 
 "position"		{ return POSITION; }
 "comment"		{ return COMMENT; }

