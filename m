From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v4 2/3] Implement --echo option
Date: Wed,  9 Aug 2017 13:16:42 +0200
Message-ID: <20170809111643.18906-3-phil@nwl.cc>
References: <20170809111643.18906-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50093 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbdHILRC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 07:17:02 -0400
In-Reply-To: <20170809111643.18906-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When used with add, insert or replace commands, nft tool will print
event notifications just like 'nft monitor' does for the same commands.

Apart from seeing what a given command will turn out in the rule set,
this allows to reliably retrieve a new rule's assigned handle (if used
together with --handle option).

Here are some examples of how it works:

| # nft --echo --handle add table ip t
| add table ip t
|
| # nft --echo --handle add chain ip t c \
| 	'{ type filter hook forward priority 0; }'
| add chain ip t c { type filter hook forward priority 0; policy accept; }
|
| # nft --echo --handle add rule ip t c tcp dport '{22, 80}' accept
| add rule ip t c tcp dport { ssh, http } accept # handle 2
|
| # nft --echo --handle add set ip t ipset '{ type ipv4_addr; \
| 	elements = { 192.168.0.1, 192.168.0.2 }; }'
| add set ip t ipset { type ipv4_addr; }
| add element ip t ipset { 192.168.0.1 }
| add element ip t ipset { 192.168.0.2 }

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop extern declaration of unused variable echo_output.
- Reworded --echo description in man page a bit.

Changes since v2:
- Get rid of NFT_MSG_META_ECHO hack, just use -1 instead.
- Fix for unknown tag <cmd> in nft.xml.

Changes since v3:
- Reuse nft monitor code completely.
- Added missing cache updates when adding a rule or named object.
- Pass flags on to __do_add_setelems() so that anonymous set elements
  are cached as well.
- Drop long description of echo option from nft.8 since it doesn't apply
  anymore.
---
 doc/nft.xml        | 10 ++++++++++
 include/netlink.h  |  2 ++
 include/nftables.h |  1 +
 src/evaluate.c     |  7 +++++++
 src/main.c         | 11 ++++++++++-
 src/mnl.c          | 25 +++++++++++++++++++++++--
 src/netlink.c      | 20 ++++++++++++++++++--
 src/rule.c         |  9 +++++++--
 8 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4d03a3dbc75bf..6c845013c088d 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -157,6 +157,16 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>-e, --echo</option></term>
+				<listitem>
+					<para>
+						When inserting items into the ruleset using <command>add</command>,
+						<command>insert</command> or <command>replace</command> commands,
+						print notifications just like <command>nft monitor</command>.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>-I, --includepath <replaceable>directory</replaceable></option></term>
 				<listitem>
 					<para>
diff --git a/include/netlink.h b/include/netlink.h
index ffbc51d352fa0..47ecef38f9e9d 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -222,4 +222,6 @@ extern int netlink_monitor(struct netlink_mon_handler *monhandler,
 			    struct mnl_socket *nf_sock);
 bool netlink_batch_supported(struct mnl_socket *nf_sock);
 
+int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/nftables.h b/include/nftables.h
index 640d3c7e715d8..ca609015274a9 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ struct output_ctx {
 	unsigned int stateless;
 	unsigned int ip2name;
 	unsigned int handle;
+	unsigned int echo;
 };
 
 struct nft_ctx {
diff --git a/src/evaluate.c b/src/evaluate.c
index d24526fef2954..477fb54d51f26 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2962,6 +2962,9 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
@@ -2975,6 +2978,10 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
+		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/main.c b/src/main.c
index 1535153ec815d..86862a1088e0c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -49,10 +49,11 @@ enum opt_vals {
 	OPT_IP2NAME		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
+	OPT_ECHO		= 'e',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvcf:iI:vnsNa"
+#define OPTSTRING	"hvcf:iI:vnsNae"
 
 static const struct option options[] = {
 	{
@@ -105,6 +106,10 @@ static const struct option options[] = {
 		.val		= OPT_HANDLE_OUTPUT,
 	},
 	{
+		.name		= "echo",
+		.val		= OPT_ECHO,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -128,6 +133,7 @@ static void show_help(const char *name)
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
+"  -e, --echo			Echo what has been added, inserted or replaced.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
@@ -375,6 +381,9 @@ int main(int argc, char * const *argv)
 		case OPT_HANDLE_OUTPUT:
 			nft.output.handle++;
 			break;
+		case OPT_ECHO:
+			nft.output.echo++;
+			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
 		}
diff --git a/src/mnl.c b/src/mnl.c
index 862311a740e0e..031b7f39da8f5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -67,11 +67,32 @@ out:
 	return ret;
 }
 
+struct nft_mnl_talk_cb_data {
+	int (*cb)(const struct nlmsghdr *nlh, void *data);
+	void *data;
+};
+
+static int nft_mnl_talk_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_mnl_talk_cb_data *cbdata = data;
+	int rc;
+
+	if (cbdata->cb)
+		rc = cbdata->cb(nlh, cbdata->data);
+	if (rc)
+		return rc;
+	return netlink_echo_callback(nlh, cbdata->data);
+}
+
 static int
 nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	uint32_t portid = mnl_socket_get_portid(nf_sock);
+	struct nft_mnl_talk_cb_data tcb_data = {
+		.cb = cb,
+		.data = cb_data,
+	};
 
 #ifdef DEBUG
 	if (debug_level & DEBUG_MNL)
@@ -81,7 +102,7 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
 		return -1;
 
-	return nft_mnl_recv(nf_sock, seq, portid, cb, cb_data);
+	return nft_mnl_recv(nf_sock, seq, portid, &nft_mnl_talk_cb, &tcb_data);
 }
 
 /*
@@ -276,7 +297,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
+		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
 		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
diff --git a/src/netlink.c b/src/netlink.c
index 26032f956aba6..b172d2cc76aca 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -464,11 +464,11 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
 	struct nftnl_rule *nlr;
-	int err;
+	int err, flags = ctx->octx->echo ? NLM_F_ECHO : 0;
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
-	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, 0, ctx->seqnum);
+	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, flags, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
@@ -3069,6 +3069,22 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	return ret;
 }
 
+int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
+{
+	struct netlink_mon_handler echo_monh = {
+		.format = NFTNL_OUTPUT_DEFAULT,
+		.ctx = data,
+		.loc = &netlink_location,
+		.monitor_flags = 0xffffffff,
+		.cache_needed = true,
+	};
+
+	if (!echo_monh.ctx->octx->echo)
+		return MNL_CB_OK;
+
+	return netlink_events_cb(nlh, &echo_monh);
+}
+
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		     struct mnl_socket *nf_sock)
 {
diff --git a/src/rule.c b/src/rule.c
index 6b9dbb623b313..fae8352a7c3f9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1009,7 +1009,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		return -1;
 	if (set->init != NULL) {
 		return __do_add_setelems(ctx, &set->handle, set, set->init,
-					 false);
+					 flags);
 	}
 	return 0;
 }
@@ -1018,6 +1018,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	uint32_t flags = excl ? NLM_F_EXCL : 0;
 
+	if (ctx->octx->echo)
+		flags |= NLM_F_ECHO;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		return netlink_add_table(ctx, &cmd->handle, &cmd->location,
@@ -1056,10 +1059,12 @@ static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	uint32_t flags = ctx->octx->echo ? NLM_F_ECHO : 0;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
 		return netlink_add_rule_batch(ctx, &cmd->handle,
-					      cmd->rule, 0);
+					      cmd->rule, flags);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.13.1

