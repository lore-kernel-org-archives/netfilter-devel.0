From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 00:18:38 +0100
Message-ID: <20140217231837.19943.77406.stgit@nfdev.cica.es>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39344 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754348AbaBQXSq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:46 -0500
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a basic events reporting option to nft.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/mnl.h     |    3 +
 include/netlink.h |    8 ++
 include/rule.h    |    3 +
 src/evaluate.c    |    1 
 src/mnl.c         |   45 ++++++++---
 src/netlink.c     |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser.y      |   60 ++++++++++++++
 src/rule.c        |   14 +++
 src/scanner.l     |    2 
 9 files changed, 343 insertions(+), 16 deletions(-)

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
index 1e6655c..70de811 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -149,4 +149,12 @@ extern int netlink_io_error(struct netlink_ctx *ctx,
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
+struct netlink_ev_handler {
+	uint32_t		selector;
+	uint32_t		format;
+	struct netlink_ctx	*ctx;
+	const struct location	*loc;
+};
+
+extern int netlink_events(struct netlink_ev_handler *evhandler);
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 9791cea..49173df 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -210,6 +210,7 @@ extern void set_print_plain(const struct set *s);
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
+ * @CMD_EVENT:		event listener
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -221,6 +222,7 @@ enum cmd_ops {
 	CMD_FLUSH,
 	CMD_RENAME,
 	CMD_EXPORT,
+	CMD_EVENT,
 };
 
 /**
@@ -276,6 +278,7 @@ struct cmd {
 	};
 	const void		*arg;
 	uint32_t		format;
+	uint32_t		event_selector;
 };
 
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
diff --git a/src/evaluate.c b/src/evaluate.c
index f10d0d9..80d16f4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1410,6 +1410,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
+	case CMD_EVENT:
 		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
diff --git a/src/mnl.c b/src/mnl.c
index e825fb0..7e34b31 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -34,24 +34,16 @@ uint32_t mnl_seqnum_alloc(void)
 }
 
 static int
-mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
-	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
+mnl_talk_recv(struct mnl_socket *nf_sock, int seqnum, uint32_t portid,
+	      int (*cb)(const struct nlmsghdr *nlh, void *data),
+	      void *cb_data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	uint32_t portid = mnl_socket_get_portid(nf_sock);
 	int ret;
-
-#ifdef DEBUG
-	if (debug_level & DEBUG_MNL)
-		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
-#endif
-
-	if (mnl_socket_sendto(nf_sock, data, len) < 0)
-		return -1;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
 
 	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, cb, cb_data);
+		ret = mnl_cb_run(buf, ret, seqnum, portid, cb, cb_data);
 		if (ret <= 0)
 			goto out;
 
@@ -64,6 +56,23 @@ out:
 	return ret;
 }
 
+static int
+mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
+{
+	uint32_t portid = mnl_socket_get_portid(nf_sock);
+
+#ifdef DEBUG
+	if (debug_level & DEBUG_MNL)
+		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
+#endif
+
+	if (mnl_socket_sendto(nf_sock, data, len) < 0)
+		return -1;
+
+	return mnl_talk_recv(nf_sock, seq, portid, cb, cb_data);
+}
+
 /*
  * Batching
  */
@@ -805,3 +814,13 @@ out:
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
+	return mnl_talk_recv(nf_sock, 0, 0, cb, cb_data);
+}
diff --git a/src/netlink.c b/src/netlink.c
index cd5e64a..efa52bf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -20,6 +20,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
 
@@ -1010,3 +1011,225 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 
 	return rs;
 }
+
+static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
+				   struct netlink_ev_handler *evh)
+{
+	struct nft_table *nlt;
+	uint32_t family;
+	char buf[4096];
+
+	nlt = nft_table_alloc();
+	if (nlt == NULL)
+		memory_allocation_error();
+
+	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
+		netlink_io_error(evh->ctx, evh->loc,
+				"Could not parse table: %s",
+				strerror(errno));
+		goto err;
+	}
+
+	if (evh->format == NFT_OUTPUT_DEFAULT) {
+		if (type == NFT_MSG_NEWTABLE)
+			printf("add table ");
+		else
+			printf("delete table ");
+
+		family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
+
+		printf("%s %s\n", family2str(family),
+		       nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
+	} else {
+		nft_table_snprintf(buf, sizeof(buf), nlt, evh->format, 0);
+		printf("%s\t# %s table\n", buf,
+		       type == NFT_MSG_NEWTABLE ? "add" : "del");
+	}
+
+err:
+	nft_table_free(nlt);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
+				   struct netlink_ev_handler *evh)
+{
+	struct nft_chain *nlc;
+	struct chain *c;
+	uint32_t family;
+	char buf[4096];
+
+	nlc = nft_chain_alloc();
+	if (nlc == NULL)
+		memory_allocation_error();
+
+	if (nft_chain_nlmsg_parse(nlh, nlc) < 0) {
+		netlink_io_error(evh->ctx, evh->loc,
+				 "Could not parse chain: %s",
+				 strerror(errno));
+		goto out;
+	}
+
+	if (evh->format == NFT_OUTPUT_DEFAULT) {
+		if (type == NFT_MSG_NEWCHAIN) {
+			printf("add ");
+			c = netlink_delinearize_chain(evh->ctx, nlc);
+			chain_print_plain(c);
+			printf("\n");
+			chain_free(c);
+			goto out;
+		}
+
+		printf("delete chain ");
+
+		family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
+		printf("%s %s %s\n", family2str(family),
+		       nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE),
+		       nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+	} else {
+		nft_chain_snprintf(buf, sizeof(buf), nlc, evh->format, 0);
+		printf("%s\t# %s chain\n", buf,
+		       type == NFT_MSG_NEWCHAIN ? "add" : "del");
+	}
+
+out:
+	nft_chain_free(nlc);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
+				 struct netlink_ev_handler *evh)
+{
+	struct nft_set *nls;
+	struct set *set;
+	uint32_t family, flags;
+	char buf[4096];
+
+	nls = nft_set_alloc();
+	if (nls == NULL)
+		memory_allocation_error();
+
+	if (nft_set_nlmsg_parse(nlh, nls) < 0) {
+		netlink_io_error(evh->ctx, evh->loc,
+				 "Could not parse set: %s",
+				 strerror(errno));
+		goto out;
+	}
+
+	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	if (flags & SET_F_ANONYMOUS && type == NFT_MSG_DELSET)
+		goto out;
+
+	if (evh->format == NFT_OUTPUT_DEFAULT) {
+		set = netlink_delinearize_set(evh->ctx, nls);
+		family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+
+		if (type == NFT_MSG_NEWSET) {
+			printf("add ");
+			set_print_plain(set);
+		} else {
+			printf("delete set %s %s %s",
+			       family2str(family),
+			       nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE),
+			       nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+		}
+
+		printf("\n");
+
+	} else {
+		nft_set_snprintf(buf, sizeof(buf), nls, evh->format, 0);
+		printf("%s\t# %s set\n", buf,
+		       type == NFT_MSG_NEWSET ? "add" : "del");
+	}
+
+out:
+	nft_set_free(nls);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
+				  struct netlink_ev_handler *evh)
+{
+	struct nft_rule *nlr;
+	uint32_t family, handle;
+	char buf[4096];
+
+	nlr = nft_rule_alloc();
+	if (nlr == NULL)
+		memory_allocation_error();
+
+	if (nft_rule_nlmsg_parse(nlh, nlr) < 0) {
+		netlink_io_error(evh->ctx, evh->loc,
+				 "Could not parse rule: %s",
+				 strerror(errno));
+		goto out;
+	}
+
+	if (evh->format == NFT_OUTPUT_DEFAULT) {
+		family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+		handle = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_HANDLE);
+
+		if (type == NFT_MSG_NEWRULE)
+			printf("add rule ");
+		else
+			printf("delete rule ");
+
+		printf("%s %s %s handle %u\n", family2str(family),
+		       nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE),
+		       nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN),
+		       handle);
+	} else {
+		nft_rule_snprintf(buf, sizeof(buf), nlr, evh->format, 0);
+		printf("%s\t# %s rule\n", buf,
+		       type == NFT_MSG_NEWRULE ? "add" : "del");
+	}
+
+out:
+	nft_rule_free(nlr);
+	return MNL_CB_OK;
+}
+
+static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
+{
+	int ret = MNL_CB_OK;
+	int type = nlh->nlmsg_type & 0xFF;
+	struct netlink_ev_handler *evh = (struct netlink_ev_handler *)data;
+
+	if (!(evh->selector & (1 << type)))
+		return ret;
+
+	switch (type) {
+	case NFT_MSG_NEWTABLE:
+	case NFT_MSG_DELTABLE:
+		ret = netlink_events_table_cb(nlh, type, evh);
+		break;
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_DELCHAIN:
+		ret = netlink_events_chain_cb(nlh, type, evh);
+		break;
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_DELSET:
+		ret = netlink_events_set_cb(nlh, type, evh);
+		break;
+	case NFT_MSG_NEWRULE:
+	case NFT_MSG_DELRULE:
+		ret = netlink_events_rule_cb(nlh, type, evh);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+int netlink_events(struct netlink_ev_handler *evhandler)
+{
+	if (mnl_socket_bind(nf_sock, (1 << (NFNLGRP_NFTABLES-1)),
+			    MNL_SOCKET_AUTOPID) < 0)
+		return netlink_io_error(evhandler->ctx, evhandler->loc,
+					"Could not bind to socket: %s",
+					strerror(errno));
+
+	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, 0);
+	return mnl_nft_event_listener(nf_sock, netlink_events_cb, evhandler);
+}
diff --git a/src/parser.y b/src/parser.y
index 07613e2..79a42ac 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -169,6 +169,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token ELEMENT			"element"
 %token MAP			"map"
 %token HANDLE			"handle"
+%token ALL			"all"
 
 %token INET			"inet"
 
@@ -181,6 +182,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
+%token EVENT			"event"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -360,8 +362,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd event_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd event_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
@@ -376,6 +378,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <rule>			rule
 %destructor { rule_free($$); }	rule
 
+%type <val>			event_selector
+
 %type <val>			set_flag_list	set_flag
 
 %type <set>			set_block_alloc set_block
@@ -484,7 +488,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format
+%type <val>			export_format	event_format
 
 %%
 
@@ -584,6 +588,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
+			|	EVENT		event_cmd	{ $$ = $2; }
 			|	DESCRIBE	primary_expr
 			{
 				expr_describe($2);
@@ -751,6 +756,55 @@ export_cmd		:	export_format
 			}
 			;
 
+event_cmd		:	event_selector	event_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				$$ = cmd_alloc(CMD_EVENT, CMD_OBJ_RULESET, &h, &@$, NULL);
+				$$->event_selector = $1;
+				$$->format = $2;
+			}
+			;
+
+event_selector		:	ALL
+			{
+				$$ |= (1 << NFT_MSG_NEWRULE);
+				$$ |= (1 << NFT_MSG_DELRULE);
+				$$ |= (1 << NFT_MSG_NEWSET);
+				$$ |= (1 << NFT_MSG_DELSET);
+				$$ |= (1 << NFT_MSG_NEWCHAIN);
+				$$ |= (1 << NFT_MSG_DELCHAIN);
+				$$ |= (1 << NFT_MSG_NEWTABLE);
+				$$ |= (1 << NFT_MSG_DELTABLE);
+			}
+			|	TABLE
+			{
+				$$ |= (1 << NFT_MSG_NEWTABLE);
+				$$ |= (1 << NFT_MSG_DELTABLE);
+			}
+			|	CHAIN
+			{
+				$$ |= (1 << NFT_MSG_NEWCHAIN);
+				$$ |= (1 << NFT_MSG_DELCHAIN);
+			}
+			|	SET
+			{
+				$$ |= (1 << NFT_MSG_NEWSET);
+				$$ |= (1 << NFT_MSG_DELSET);
+			}
+			|	RULE
+			{
+				$$ |= (1 << NFT_MSG_NEWRULE);
+				$$ |= (1 << NFT_MSG_DELRULE);
+			}
+			;
+
+event_format		:	/* empty */
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
index 4301faa..30a8529 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -790,6 +790,18 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_event(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct netlink_ev_handler evhandler;
+
+	evhandler.selector = cmd->event_selector;
+	evhandler.format = cmd->format;
+	evhandler.ctx = ctx;
+	evhandler.loc = &cmd->location;
+
+	return netlink_events(&evhandler);
+}
+
 int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
@@ -809,6 +821,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_rename(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
+	case CMD_EVENT:
+		return do_command_event(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index e4cb398..70b781a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -238,6 +238,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "handle"		{ return HANDLE; }
+"all"			{ return ALL; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
@@ -256,6 +257,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
+"event"			{ return EVENT; }
 
 "position"		{ return POSITION; }
 

