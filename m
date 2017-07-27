From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC 3/4] Implement --echo option
Date: Thu, 27 Jul 2017 16:26:21 +0200
Message-ID: <20170727142622.12029-4-phil@nwl.cc>
References: <20170727142622.12029-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55795 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdG0O0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:26:35 -0400
In-Reply-To: <20170727142622.12029-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When used with add, insert or replace commands, nft tool will print a
string uniquely identifying the new item added to kernel's rule set.

The most beneficial effect of this feature is that it allows to
atomically retrieve an added rule's handle. Previously, one would do
something like this:

| # nft add rule ip t c tcp dport 22 accept
| # handle=$(nft -a list ruleset | \
|            sed -n 's/tcp dport 22 accept # handle \(.*\)/\1/p)

The obvious problem here is that another process might have added the
same rule in between the two commands, so the parsed handle is not
guaranteed to be the right one. Using --echo fixes that:

| # handle=$(nft --echo add rule ip t c tcp dport 22 accept)
| # handle=${handle#*handle }

(Where the second line is just to imitate the above examples behaviour.)

There is a more dramatic problem with any attempt at parsing 'nft list'
output: Some 'nft add' input will never be printed the same way again. A
simple example of this is using mixed port numbers and names:

| nft add rule ip t c tcp dport { ssh, 80 } accept

Depending on number of '-n' flags, the port list will either occur as
all names ("ssh, http") or all numbers ("22, 80").

The idea behind --echo is to print a statement which serves as a unique
identifier suitable for passing to 'nft delete' directly. See the
following examples for illustration:

| # nft --echo add table ip t
| table ip t
| # nft --echo add chain ip t c
| chain ip t c
| # nft --echo add rule ip t c accept
| rule handle 2

In an ideal world, every element and not just rules should have an
identifying handle. When these are added, --echo output can simply be
adjusted to print that handle instead of the name one has to use at the
moment.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml                         | 51 ++++++++++++++++++++++++++++++
 include/linux/netfilter/nf_tables.h |  1 +
 include/netlink.h                   |  2 ++
 include/nftables.h                  |  2 ++
 src/main.c                          | 11 ++++++-
 src/mnl.c                           | 25 +++++++++++++--
 src/netlink.c                       | 63 +++++++++++++++++++++++++++++++++++--
 src/rule.c                          |  7 ++++-
 8 files changed, 156 insertions(+), 6 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9c9192cf7a8bf..8b988cfd68f43 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -157,6 +157,17 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>-e, --echo</option></term>
+				<listitem>
+					<para>
+						When inserting items into the ruleset using <command>add</command> or
+						<command>replace</command> commands, print for each item a line uniquely
+						identifying it suitable to pass on to a following <command>delete</command>
+						command.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>-I, --includepath <replaceable>directory</replaceable></option></term>
 				<listitem>
 					<para>
@@ -4421,6 +4432,46 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 	</refsect1>
 
 	<refsect1>
+		<title>Echo Option</title>
+		<para>
+			The flag <option>-e/--echo</option> exists to overcome a practical problem for
+			scripts (or pedantic users) trying to reliably manage their own firewall rules:
+			Although every rule is assigned a unique handle allowing it to be identified later
+			in <cmd>delete</cmd> or <cmd>replace</cmd> commands, it wasn't possible to retrieve
+			that handle atomically. So one would have to call <cmd>nft -a list ruleset</cmd>,
+			parse the output (which may differ from the input sometimes) and still there would
+			be the chance that some other instance inserted a similar rule meanwhile.
+		</para>
+		<para>
+			Using <option>--echo</option> during insertion of a rule (or actually any item)
+			makes <cmd>nft</cmd> print a line suitable for passing on to later commands. Here
+			are some examples:
+		</para>
+		<example>
+			<programlisting>
+# nft --echo add table ip t
+table ip t
+# nft --echo add chain ip t c
+chain ip t c
+# nft --echo add set ip t portset '{ type inet_service; }'
+set ip t portset
+# nft --echo add element ip t portset '{ 80, 443 }'
+element ip t portset { http }
+element ip t portset { https }
+# nft --echo add rule ip t c tcp dport @portset drop
+rule ip t c handle 2
+			</programlisting>
+		</example>
+		<para>
+			One might notice that a unique handle exists only for rules - this is not an issue
+			since anything else is uniquely identified by it's name (like tables, chains and
+			sets) or in the case of set elements the element value suffices as there can't be
+			two identical items in a single set (if the element was already there, no line
+			would be printed for it so one doesn't by accident delete elements added by another
+			instance).
+		</para>
+	</refsect1>
+	<refsect1>
 		<title>Error reporting</title>
 		<para>
 			When an error is detected, nft shows the line(s) containing the error, the position
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 40096de04e963..70404f724808a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -114,6 +114,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_GETOBJ,
 	NFT_MSG_DELOBJ,
 	NFT_MSG_GETOBJ_RESET,
+	NFT_MSG_META_ECHO,
 	NFT_MSG_MAX,
 };
 
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
index 640d3c7e715d8..3885e749bc0b6 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ struct output_ctx {
 	unsigned int stateless;
 	unsigned int ip2name;
 	unsigned int handle;
+	unsigned int echo;
 };
 
 struct nft_ctx {
@@ -37,6 +38,7 @@ struct nft_ctx {
 };
 
 extern unsigned int max_errors;
+extern unsigned int echo_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
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
index a3a6bd3fff1e7..50f006e67c968 100644
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
index f13dfd3f9a021..f7b452415080a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -465,11 +465,11 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
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
@@ -2087,6 +2087,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 				printf("update table ");
 			else
 				printf("add table ");
+		} else if (type == NFT_MSG_META_ECHO) {
+			printf("table ");
 		} else {
 			printf("delete table ");
 		}
@@ -2136,6 +2138,12 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE),
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 			break;
+		case NFT_MSG_META_ECHO:
+			family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
+			printf("chain %s %s %s\n", family2str(family),
+			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE),
+			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
+			break;
 		}
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -2183,6 +2191,13 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
 			       nftnl_set_get_str(nls, NFTNL_SET_NAME));
 			break;
+		case NFT_MSG_META_ECHO:
+			family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
+			printf("set %s %s %s\n",
+			       family2str(family),
+			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
+			       nftnl_set_get_str(nls, NFTNL_SET_NAME));
+			break;
 		}
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -2323,6 +2338,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		case NFT_MSG_DELSETELEM:
 			printf("delete ");
 			break;
+		case NFT_MSG_META_ECHO:
+			break;
 		default:
 			set_free(dummyset);
 			goto out;
@@ -2376,6 +2393,14 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 			       nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE),
 			       nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
 			break;
+		case NFT_MSG_META_ECHO:
+			family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
+			printf("%s %s %s %s\n",
+			       obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE)),
+			       family2str(family),
+			       nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE),
+			       nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
+			break;
 		}
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -2431,6 +2456,10 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			printf("delete rule %s %s %s handle %u\n",
 			       family, table, chain, (unsigned int)handle);
 			break;
+		case NFT_MSG_META_ECHO:
+			printf("rule %s %s %s handle %u\n",
+			       family, table, chain, (unsigned int)handle);
+			break;
 		}
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -3070,6 +3099,36 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	return ret;
 }
 
+int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
+{
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t etype = NFT_MSG_META_ECHO;
+	struct netlink_mon_handler echo_monh = {
+		.format = NFTNL_OUTPUT_DEFAULT,
+		.ctx = data,
+		.loc = &netlink_location,
+	};
+
+	if (!echo_monh.ctx->octx->echo)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFT_MSG_NEWTABLE:
+		return netlink_events_table_cb(nlh, etype, &echo_monh);
+	case NFT_MSG_NEWCHAIN:
+		return netlink_events_chain_cb(nlh, etype, &echo_monh);
+	case NFT_MSG_NEWSET:
+		return netlink_events_set_cb(nlh, etype, &echo_monh);
+	case NFT_MSG_NEWSETELEM:
+		return netlink_events_setelem_cb(nlh, etype, &echo_monh);
+	case NFT_MSG_NEWRULE:
+		return netlink_events_rule_cb(nlh, etype, &echo_monh);
+	case NFT_MSG_NEWOBJ:
+		return netlink_events_obj_cb(nlh, etype, &echo_monh);
+	}
+	return MNL_CB_OK;
+}
+
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		     struct mnl_socket *nf_sock)
 {
diff --git a/src/rule.c b/src/rule.c
index f8e1b0a460292..9de38f176e02e 100644
--- a/src/rule.c
+++ b/src/rule.c
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

