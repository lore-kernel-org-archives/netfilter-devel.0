From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:02:11 +0100
Message-ID: <1448359331-12692-7-git-send-email-fw@strlen.de>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58373 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbbKXKCa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:02:30 -0500
In-Reply-To: <1448359331-12692-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft monitor [ trace ]

=2E.. can now display nftables nftrace debug information.

$ nft rule bridge raw prerouting add tcp dport 22 limit rate 1/second m=
eta nftrace set 1
$ nft monitor trace
trace id 834dd100 bridge packet src 5e:95:99:72:ea:c5 dst 52:54:40:a2:3=
f:a6 src 192.168.7.1 dst 192.168.7.11 len 88 ttl 64 id 2719 protocol 6 =
sport 3628 dport 22 iif eth0
trace id 834dd100 bridge raw prerouting rule verdict continue iif eth0
trace id 834dd100 rule tcp dport ssh limit rate 1/second nftrace set 1
trace id 834dd100 bridge raw prerouting policy verdict accept iif eth0
trace id 834dd100 ip filter input rule verdict jump iif br0
trace id 834dd100 rule ip saddr . tcp dport vmap { }
trace id 834dd100 ip filter test rule verdict accept iif br0
trace id 834dd100 rule accept

based on an initial patch from Markus K=C3=B6tter.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 30 +++++++++++++
 src/evaluate.c                      | 18 ++++++++
 src/netlink.c                       | 84 +++++++++++++++++++++++++++++=
++++++++
 src/rule.c                          | 47 +++++++++++++++++----
 4 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfil=
ter/nf_tables.h
index 5ebe3d8..85d739b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -101,6 +101,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_TRACE,
 	NFT_MSG_MAX,
 };
=20
@@ -961,4 +962,33 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
=20
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_LL_TYPE,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_PAYLOAD,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_VLAN_TAG,
+	NFTA_TRACE_DEVTYPE,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_PACKET,
+	NFT_TRACETYPE_POLICY,
+	NFT_TRACETYPE_RETURN,
+	NFT_TRACETYPE_RULE,
+	__NFT_TRACETYPE_MAX
+};
+#define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 48f071f..b1ab8e9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2279,6 +2279,7 @@ enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
 	CMD_MONITOR_EVENT_DEL,
+	CMD_MONITOR_EVENT_TRACE,
 	CMD_MONITOR_EVENT_MAX
 };
=20
@@ -2320,6 +2321,21 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_=
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
@@ -2332,6 +2348,8 @@ static int cmd_evaluate_monitor(struct eval_ctx *=
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
index 974afb1..8ab7bbe 100644
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
@@ -33,6 +34,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <iface.h>
=20
 static struct mnl_socket *nf_sock;
 static struct mnl_socket *nf_mon_sock;
@@ -2125,6 +2127,85 @@ static void netlink_events_cache_update(struct n=
etlink_mon_handler *monh,
 	}
 }
=20
+static void trace_print_rule(const struct nftnl_trace *nlt)
+{
+	const struct table *table;
+	uint64_t rule_handle;
+	struct chain *chain;
+	struct handle h;
+
+	h.table  =3D nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE);
+	h.chain  =3D nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN);
+	h.family =3D nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY);
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
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE)) {
+		struct rule *rule;
+
+		rule_handle =3D nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE);
+
+		list_for_each_entry(rule, &chain->rules, list) {
+			if (rule->handle.handle !=3D rule_handle)
+				continue;
+
+			printf("\ntrace id %08x rule ", nftnl_trace_get_u32(nlt, NFTNL_TRAC=
E_ID));
+			rule_print(rule);
+			return;
+		}
+	}
+}
+
+static void trace_print_if(const struct nftnl_trace *nlt, uint16_t att=
r, const char *str)
+{
+	char __name[IFNAMSIZ];
+	const char *ifname;
+
+        if (!nftnl_trace_is_set(nlt, attr))
+		return;
+
+	ifname =3D nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name)=
;
+	if (ifname)
+		printf(" %s %s", str, ifname);
+	else
+		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
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
+	printf("trace ");
+	nftnl_trace_fprintf(stdout, nlt, monh->format);
+
+	trace_print_if(nlt, NFTNL_TRACE_IIF, "iif");
+	trace_print_if(nlt, NFTNL_TRACE_OIF, "oif");
+
+	trace_print_rule(nlt);
+	printf("\n");
+	nftnl_trace_free(nlt);
+	return MNL_CB_OK;
+}
+
 static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret =3D MNL_CB_OK;
@@ -2157,6 +2238,9 @@ static int netlink_events_cb(const struct nlmsghd=
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
diff --git a/src/rule.c b/src/rule.c
index 5d3cd84..553990d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1192,27 +1192,56 @@ static int do_command_rename(struct netlink_ctx=
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
=20
+	if (cmd->monitor->flags & (1 << NFT_MSG_TRACE))
+		return true;
+
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
+			if (ret !=3D 0) /* shouldn't happen && doesn't break things too bad=
ly */
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
2.4.10

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
