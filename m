From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 6/6] nft monitor [ trace ]
Date: Sun, 24 Apr 2016 22:30:40 +0100
Message-ID: <1461533440-10605-7-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52081 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcDXVjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:22 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=2E.. can now display nftables nftrace debug information.

$ nft filter input tcp dport 10000 nftrace set 1
$ nft filter input icmp type echo-request nftrace set 1
$ nft -nn monitor trace
trace id e1f5055f ip filter input packet: iif eth0 ether saddr 63:f6:4b=
:00:54:52 ether daddr c9:4b:a9:00:54:52 ip saddr 192.168.122.1 ip daddr=
 192.168.122.83 ip tos 0 ip ttl 64 ip id 32315 ip length 84 icmp type e=
cho-request icmp code 0 icmp id 10087 icmp sequence 1
trace id e1f5055f ip filter input rule icmp type echo-request nftrace s=
et 1 (verdict continue)
trace id e1f5055f ip filter input verdict continue
trace id e1f5055f ip filter input
trace id 74e47ad2 ip filter input packet: iif vlan0 ether saddr 63:f6:4=
b:00:54:52 ether daddr c9:4b:a9:00:54:52 vlan pcp 0 vlan cfi 1 vlan id =
1000 ip saddr 10.0.0.1 ip daddr 10.0.0.2 ip tos 0 ip ttl 64 ip id 49030=
 ip length 84 icmp type echo-request icmp code 0 icmp id 10095 icmp seq=
uence 1
trace id 74e47ad2 ip filter input rule icmp type echo-request nftrace s=
et 1 (verdict continue)
trace id 74e47ad2 ip filter input verdict continue
trace id 74e47ad2 ip filter input
trace id 3030de23 ip filter input packet: iif vlan0 ether saddr 63:f6:4=
b:00:54:52 ether daddr c9:4b:a9:00:54:52 vlan pcp 0 vlan cfi 1 vlan id =
1000 ip saddr 10.0.0.1 ip daddr 10.0.0.2 ip tos 16 ip ttl 64 ip id 5906=
2 ip length 60 tcp sport 55438 tcp dport 10000 tcp flags =3D=3D syn tcp=
 window 29200
trace id 3030de23 ip filter input rule tcp dport 10000 nftrace set 1 (v=
erdict continue)
trace id 3030de23 ip filter input verdict continue
trace id 3030de23 ip filter input

Based on a patch from Florian Westphal, which again was based on a patc=
h
from Markus K=C3=B6tter.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/payload.h |   1 +
 include/rule.h    |   1 +
 src/evaluate.c    |  18 ++++
 src/netlink.c     | 269 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++-
 src/payload.c     |   5 +
 src/rule.c        |  61 +++++++++++--
 6 files changed, 345 insertions(+), 10 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index b180ff5..37375c1 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -9,6 +9,7 @@ extern struct expr *payload_expr_alloc(const struct loc=
ation *loc,
 				       unsigned int type);
 extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
+extern unsigned int payload_hdr_field(const struct expr *expr);
=20
 struct eval_ctx;
 struct stmt;
diff --git a/include/rule.h b/include/rule.h
index 6dbde13..09b3ff7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -192,6 +192,7 @@ extern struct rule *rule_alloc(const struct locatio=
n *loc,
 			       const struct handle *h);
 extern void rule_free(struct rule *rule);
 extern void rule_print(const struct rule *rule);
+extern struct rule *rule_lookup(const struct chain *chain, uint64_t ha=
ndle);
=20
 /**
  * enum set_flags
diff --git a/src/evaluate.c b/src/evaluate.c
index a65e145..63c0091 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2479,6 +2479,7 @@ enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
 	CMD_MONITOR_EVENT_DEL,
+	CMD_MONITOR_EVENT_TRACE,
 	CMD_MONITOR_EVENT_MAX
 };
=20
@@ -2520,6 +2521,21 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_=
MAX][CMD_MONITOR_OBJ_MAX] =3D {
 		[CMD_MONITOR_OBJ_SETS]		=3D (1 << NFT_MSG_DELSET),
 		[CMD_MONITOR_OBJ_ELEMS]		=3D (1 << NFT_MSG_DELSETELEM),
 	},
+	[CMD_MONITOR_EVENT_TRACE] =3D {
+		[CMD_MONITOR_OBJ_ANY]		=3D (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_NEWRULE)  |
+						  (1 << NFT_MSG_DELTABLE) |
+						  (1 << NFT_MSG_DELCHAIN) |
+						  (1 << NFT_MSG_DELRULE)  |
+						  (1 << NFT_MSG_TRACE),
+		[CMD_MONITOR_OBJ_TABLES]	=3D (1 << NFT_MSG_NEWTABLE) |
+						  (1 << NFT_MSG_DELTABLE),
+		[CMD_MONITOR_OBJ_CHAINS]	=3D (1 << NFT_MSG_NEWCHAIN) |
+						  (1 << NFT_MSG_DELCHAIN),
+		[CMD_MONITOR_OBJ_RULES]		=3D (1 << NFT_MSG_NEWRULE) |
+						  (1 << NFT_MSG_DELRULE),
+	},
 };
=20
 static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
@@ -2537,6 +2553,8 @@ static int cmd_evaluate_monitor(struct eval_ctx *=
ctx, struct cmd *cmd)
 		event =3D CMD_MONITOR_EVENT_NEW;
 	else if (strcmp(cmd->monitor->event, "destroy") =3D=3D 0)
 		event =3D CMD_MONITOR_EVENT_DEL;
+	else if (strcmp(cmd->monitor->event, "trace") =3D=3D 0)
+		event =3D CMD_MONITOR_EVENT_TRACE;
 	else {
 		return monitor_error(ctx, cmd->monitor, "invalid event %s",
 				     cmd->monitor->event);
diff --git a/src/netlink.c b/src/netlink.c
index e3ba2ed..890e9b9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -18,6 +18,7 @@
 #include <stdlib.h>
=20
 #include <libnftnl/table.h>
+#include <libnftnl/trace.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
@@ -30,9 +31,11 @@
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
+#include <statement.h>
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <iface.h>
=20
 static struct mnl_socket *nf_sock;
 static struct mnl_socket *nf_mon_sock;
@@ -2109,6 +2112,266 @@ static void netlink_events_cache_update(struct =
netlink_mon_handler *monh,
 	}
 }
=20
+static void trace_print_hdr(const struct nftnl_trace *nlt)
+{
+	printf("trace id %08x ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
+	printf("%s ", family2str(nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY)=
));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_TABLE))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CHAIN))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
+}
+
+static void trace_print_expr(const struct nftnl_trace *nlt, unsigned i=
nt attr,
+			     struct expr *lhs)
+{
+	struct expr *rhs, *rel;
+	const void *data;
+	uint32_t len;
+
+	data =3D nftnl_trace_get_data(nlt, attr, &len);
+	rhs  =3D constant_expr_alloc(&netlink_location,
+				   lhs->dtype, lhs->byteorder,
+				   len * BITS_PER_BYTE, data);
+	rel  =3D relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
+
+	expr_print(rel);
+	printf(" ");
+	expr_free(rel);
+}
+
+static void trace_print_verdict(const struct nftnl_trace *nlt)
+{
+	const char *chain =3D NULL;
+	unsigned int verdict;
+	struct expr *expr;
+
+	verdict =3D nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET))
+		chain =3D xstrdup(nftnl_trace_get_str(nlt, NFTNL_TRACE_JUMP_TARGET))=
;
+	expr =3D verdict_expr_alloc(&netlink_location, verdict, chain);
+
+	printf("verdict ");
+	expr_print(expr);
+	expr_free(expr);
+}
+
+static void trace_print_rule(const struct nftnl_trace *nlt)
+{
+	const struct table *table;
+	uint64_t rule_handle;
+	struct chain *chain;
+	struct rule *rule;
+	struct handle h;
+
+	h.family =3D nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY);
+	h.table  =3D nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE);
+	h.chain  =3D nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN);
+
+	if (!h.table)
+		return;
+
+	table =3D table_lookup(&h);
+	if (!table)
+		return;
+
+	chain =3D chain_lookup(table, &h);
+	if (!chain)
+		return;
+
+	rule_handle =3D nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE);
+	rule =3D rule_lookup(chain, rule_handle);
+	if (!rule)
+		return;
+
+	trace_print_hdr(nlt);
+	printf("rule ");
+	rule_print(rule);
+	printf(" (");
+	trace_print_verdict(nlt);
+	printf(")\n");
+}
+
+static void trace_gen_stmts(struct list_head *stmts,
+			    struct proto_ctx *ctx, struct payload_dep_ctx *pctx,
+			    const struct nftnl_trace *nlt, unsigned int attr,
+			    enum proto_bases base)
+{
+	struct list_head unordered =3D LIST_HEAD_INIT(unordered);
+	struct list_head list;
+	struct expr *rel, *lhs, *rhs, *tmp, *nexpr;
+	struct stmt *stmt;
+	const struct proto_desc *desc;
+	const void *hdr;
+	uint32_t hlen;
+	unsigned int n;
+	bool stacked;
+
+	if (!nftnl_trace_is_set(nlt, attr))
+		return;
+	hdr =3D nftnl_trace_get_data(nlt, attr, &hlen);
+
+	lhs =3D payload_expr_alloc(&netlink_location, NULL, 0);
+	payload_init_raw(lhs, base, 0, hlen * BITS_PER_BYTE);
+	rhs =3D constant_expr_alloc(&netlink_location,
+				  &invalid_type, BYTEORDER_INVALID,
+				  hlen * BITS_PER_BYTE, hdr);
+
+restart:
+	init_list_head(&list);
+	payload_expr_expand(&list, lhs, ctx);
+	expr_free(lhs);
+
+	desc =3D NULL;
+	list_for_each_entry_safe(lhs, nexpr, &list, list) {
+		if (desc && desc !=3D ctx->protocol[base].desc) {
+			/* Chained protocols */
+			lhs->payload.offset =3D 0;
+			if (ctx->protocol[base].desc =3D=3D NULL)
+				break;
+			goto restart;
+		}
+
+		tmp =3D constant_expr_splice(rhs, lhs->len);
+		expr_set_type(tmp, lhs->dtype, lhs->byteorder);
+
+		/* Skip unknown and filtered expressions */
+		desc =3D lhs->payload.desc;
+		if (lhs->dtype =3D=3D &invalid_type ||
+		    desc->checksum_key =3D=3D payload_hdr_field(lhs) ||
+		    desc->format.filter & (1 << payload_hdr_field(lhs))) {
+			expr_free(lhs);
+			expr_free(tmp);
+			continue;
+		}
+
+		rel  =3D relational_expr_alloc(&lhs->location, OP_EQ, lhs, tmp);
+		stmt =3D expr_stmt_alloc(&rel->location, rel);
+		list_add_tail(&stmt->list, &unordered);
+
+		desc =3D ctx->protocol[base].desc;
+		lhs->ops->pctx_update(ctx, rel);
+	}
+
+	expr_free(rhs);
+
+	n =3D 0;
+next:
+	list_for_each_entry(stmt, &unordered, list) {
+		rel =3D stmt->expr;
+		lhs =3D rel->left;
+
+		/* Move statements to result list in defined order */
+		desc =3D lhs->payload.desc;
+		if (desc->format.order[n] &&
+		    desc->format.order[n] !=3D payload_hdr_field(lhs))
+			continue;
+
+		list_move_tail(&stmt->list, stmts);
+		n++;
+
+		stacked =3D payload_is_stacked(desc, rel);
+
+		if (lhs->flags & EXPR_F_PROTOCOL &&
+		    pctx->pbase =3D=3D PROTO_BASE_INVALID) {
+			payload_dependency_store(pctx, stmt, base - stacked);
+		} else {
+			payload_dependency_kill(pctx, lhs);
+			if (lhs->flags & EXPR_F_PROTOCOL)
+				payload_dependency_store(pctx, stmt, base - stacked);
+		}
+
+		goto next;
+	}
+}
+
+static void trace_print_packet(const struct nftnl_trace *nlt)
+{
+	struct list_head stmts =3D LIST_HEAD_INIT(stmts);
+	struct payload_dep_ctx pctx =3D {};
+	struct proto_ctx ctx;
+	uint16_t dev_type;
+	struct stmt *stmt, *next;
+
+	trace_print_hdr(nlt);
+
+	printf("packet: ");
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
+		trace_print_expr(nlt, NFTNL_TRACE_IIF,
+				 meta_expr_alloc(&netlink_location,
+						 NFT_META_IIF));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
+		trace_print_expr(nlt, NFTNL_TRACE_OIF,
+				 meta_expr_alloc(&netlink_location,
+						 NFT_META_OIF));
+
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
+	if (ctx.protocol[PROTO_BASE_LL_HDR].desc =3D=3D NULL &&
+	    nftnl_trace_is_set(nlt, NFTNL_TRACE_IIFTYPE)) {
+		dev_type =3D nftnl_trace_get_u16(nlt, NFTNL_TRACE_IIFTYPE);
+		proto_ctx_update(&ctx, PROTO_BASE_LL_HDR, &netlink_location,
+				 proto_dev_desc(dev_type));
+	}
+
+	trace_gen_stmts(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_LL_HEADER,
+			PROTO_BASE_LL_HDR);
+	trace_gen_stmts(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_NETWORK_HEADER,
+			PROTO_BASE_NETWORK_HDR);
+	trace_gen_stmts(&stmts, &ctx, &pctx, nlt, NFTNL_TRACE_TRANSPORT_HEADE=
R,
+			PROTO_BASE_TRANSPORT_HDR);
+
+	list_for_each_entry_safe(stmt, next, &stmts, list) {
+		stmt_print(stmt);
+		printf(" ");
+		stmt_free(stmt);
+	}
+	printf("\n");
+}
+
+static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int typ=
e,
+				   struct netlink_mon_handler *monh)
+{
+	struct nftnl_trace *nlt;
+
+	assert(type =3D=3D NFT_MSG_TRACE);
+
+	nlt =3D nftnl_trace_alloc();
+	if (!nlt)
+		memory_allocation_error();
+
+	if (nftnl_trace_nlmsg_parse(nlh, nlt) < 0)
+		netlink_abi_error();
+
+	switch (nftnl_trace_get_u32(nlt, NFTNL_TRACE_TYPE)) {
+	case NFT_TRACETYPE_RULE:
+		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
+		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
+			trace_print_packet(nlt);
+
+		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
+			trace_print_rule(nlt);
+		break;
+	case NFT_TRACETYPE_POLICY:
+	case NFT_TRACETYPE_RETURN:
+		trace_print_hdr(nlt);
+
+		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT)) {
+			trace_print_verdict(nlt);
+			printf(" ");
+		}
+
+		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_MARK))
+			trace_print_expr(nlt, NFTNL_TRACE_MARK,
+					 meta_expr_alloc(&netlink_location,
+							 NFT_META_MARK));
+		printf("\n");
+		break;
+	}
+
+	nftnl_trace_free(nlt);
+	return MNL_CB_OK;
+}
+
 static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret =3D MNL_CB_OK;
@@ -2141,6 +2404,9 @@ static int netlink_events_cb(const struct nlmsghd=
r *nlh, void *data)
 	case NFT_MSG_DELRULE:
 		ret =3D netlink_events_rule_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_TRACE:
+		ret =3D netlink_events_trace_cb(nlh, type, monh);
+		break;
 	}
 	fflush(stdout);
=20
@@ -2151,7 +2417,8 @@ int netlink_monitor(struct netlink_mon_handler *m=
onhandler)
 {
 	netlink_open_mon_sock();
=20
-	if (mnl_socket_bind(nf_mon_sock, (1 << (NFNLGRP_NFTABLES-1)),
+	if (mnl_socket_bind(nf_mon_sock, (1 << (NFNLGRP_NFTABLES-1)) |
+					 (1 << (NFNLGRP_NFTRACE-1)),
 			    MNL_SOCKET_AUTOPID) < 0)
 		return netlink_io_error(monhandler->ctx, monhandler->loc,
 					"Could not bind to netlink socket %s",
diff --git a/src/payload.c b/src/payload.c
index 0bbfb54..ac0e917 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -142,6 +142,11 @@ void payload_init_raw(struct expr *expr, enum prot=
o_bases base,
 	expr->len		=3D len;
 }
=20
+unsigned int payload_hdr_field(const struct expr *expr)
+{
+	return expr->payload.tmpl - expr->payload.desc->templates;
+}
+
 static void payload_stmt_print(const struct stmt *stmt)
 {
 	expr_print(stmt->payload.expr);
diff --git a/src/rule.c b/src/rule.c
index 2fe6745..cd7f84e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -396,6 +396,17 @@ void rule_print(const struct rule *rule)
 		printf(" # handle %" PRIu64, rule->handle.handle.id);
 }
=20
+struct rule *rule_lookup(const struct chain *chain, uint64_t handle)
+{
+	struct rule *rule;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		if (rule->handle.handle.id =3D=3D handle)
+			return rule;
+	}
+	return NULL;
+}
+
 struct scope *scope_init(struct scope *scope, const struct scope *pare=
nt)
 {
 	scope->parent =3D parent;
@@ -1198,27 +1209,59 @@ static int do_command_rename(struct netlink_ctx=
 *ctx, struct cmd *cmd)
 	return 0;
 }
=20
-static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd=
)
+static bool need_cache(const struct cmd *cmd)
 {
-	struct table *t;
-	struct set *s;
-	struct netlink_mon_handler monhandler;
-
-	/* cache only needed if monitoring:
+	/*
 	 *  - new rules in default format
 	 *  - new elements
 	 */
 	if (((cmd->monitor->flags & (1 << NFT_MSG_NEWRULE)) &&
 	    (cmd->monitor->format =3D=3D NFTNL_OUTPUT_DEFAULT)) ||
 	    (cmd->monitor->flags & (1 << NFT_MSG_NEWSETELEM)))
-		monhandler.cache_needed =3D true;
-	else
-		monhandler.cache_needed =3D false;
+		return true;
+
+	if (cmd->monitor->flags & (1 << NFT_MSG_TRACE))
+		return true;
=20
+	return false;
+}
+
+static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd=
)
+{
+	struct table *t;
+	struct set *s;
+	struct netlink_mon_handler monhandler;
+
+	monhandler.cache_needed =3D need_cache(cmd);
 	if (monhandler.cache_needed) {
+		struct rule *rule, *nrule;
+		struct chain *chain;
+		int ret;
+
 		list_for_each_entry(t, &table_list, list) {
 			list_for_each_entry(s, &t->sets, list)
 				s->init =3D set_expr_alloc(&cmd->location);
+
+			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
+				continue;
+
+			/* When tracing we'd like to translate the rule handle
+			 * we receive in the trace messages to the actual rule
+			 * struct to print that out.  Populate rule cache now.
+			 */
+			ret =3D netlink_list_table(ctx, &t->handle,
+						 &internal_location);
+
+			if (ret !=3D 0)
+				/* Shouldn't happen and doesn't break things
+				 * too badly
+				 */
+				continue;
+
+			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+				chain =3D chain_lookup(t, &rule->handle);
+				list_move_tail(&rule->list, &chain->rules);
+			}
 		}
 	}
=20
--=20
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
