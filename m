From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft, v2] mnl: check for NLM_F_DUMP_INTR when dumping object lists
Date: Fri, 11 Jul 2014 13:49:55 +0200
Message-ID: <6ee34f2f-2dc0-40f0-9ed2-69304aa5c4b3@email.android.com>
References: <1405076914-5573-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53600 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaGKLuD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:50:03 -0400
In-Reply-To: <1405076914-5573-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11. Juli 2014 13:08:34 MESZ, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>This flag allows to detect that an update has ocurred while dumping
>any of the object lists. In case of interference, nft cancels the
>netlink socket to skip processing the remaining stale entries and
>it retries to obtain fresh list of objects.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> include/netlink.h |    2 ++
> src/main.c        |    8 ++++++-
> src/mnl.c         |   15 +++++++++++++
> src/netlink.c     |   30 +++++++++++++++++++++----
>src/rule.c        |   64
>+++++++++++++++++++++++++++++++----------------------
> 5 files changed, 88 insertions(+), 31 deletions(-)
>
>diff --git a/include/netlink.h b/include/netlink.h
>index 4ef7365..af5dcd9 100644
>--- a/include/netlink.h
>+++ b/include/netlink.h
>@@ -137,6 +137,8 @@ extern void netlink_dump_expr(struct nft_rule_expr
>*nle);
> extern void netlink_dump_set(struct nft_set *nls);
> 
> extern int netlink_batch_send(struct list_head *err_list);
>+
>+extern void netlink_restart(void);
> extern void netlink_abi_error(void) __noreturn;
> extern int netlink_io_error(struct netlink_ctx *ctx,
> 			    const struct location *loc, const char *fmt, ...);
>diff --git a/src/main.c b/src/main.c
>index a446bc6..30ea2c6 100644
>--- a/src/main.c
>+++ b/src/main.c
>@@ -223,8 +223,14 @@ int nft_run(void *scanner, struct parser_state
>*state, struct list_head *msgs)
> 	ret = nft_parse(scanner, state);
> 	if (ret != 0 || state->nerrs > 0)
> 		return -1;
>+retry:
>+	ret = nft_netlink(state, msgs);
>+	if (ret < 0 && errno == EINTR) {
>+		netlink_restart();
>+		goto retry;
>+	}
> 
>-	return nft_netlink(state, msgs);
>+	return ret;
> }
> 
> int main(int argc, char * const *argv)
>diff --git a/src/mnl.c b/src/mnl.c
>index a816106..d3c91b4 100644
>--- a/src/mnl.c
>+++ b/src/mnl.c
>@@ -363,6 +363,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void
>*data)
> 	struct nft_rule_list *nlr_list = data;
> 	struct nft_rule *r;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	r = nft_rule_alloc();
> 	if (r == NULL)
> 		memory_allocation_error();
>@@ -474,6 +477,9 @@ static int chain_cb(const struct nlmsghdr *nlh,
>void *data)
> 	struct nft_chain_list *nlc_list = data;
> 	struct nft_chain *c;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	c = nft_chain_alloc();
> 	if (c == NULL)
> 		memory_allocation_error();
>@@ -603,6 +609,9 @@ static int table_cb(const struct nlmsghdr *nlh,
>void *data)
> 	struct nft_table_list *nlt_list = data;
> 	struct nft_table *t;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	t = nft_table_alloc();
> 	if (t == NULL)
> 		memory_allocation_error();
>@@ -736,6 +745,9 @@ static int set_cb(const struct nlmsghdr *nlh, void
>*data)
> 	struct nft_set_list *nls_list = data;
> 	struct nft_set *s;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	s = nft_set_alloc();
> 	if (s == NULL)
> 		memory_allocation_error();
>@@ -839,6 +851,9 @@ int mnl_nft_setelem_delete(struct mnl_socket
>*nf_sock, struct nft_set *nls,
> 
> static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
> {
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	nft_set_elems_nlmsg_parse(nlh, data);
> 	return MNL_CB_OK;
> }
>diff --git a/src/netlink.c b/src/netlink.c
>index 987dd63..5bc4669 100644
>--- a/src/netlink.c
>+++ b/src/netlink.c
>@@ -70,6 +70,12 @@ static void __exit netlink_close_sock(void)
> 		mnl_socket_close(nf_mon_sock);
> }
> 
>+void netlink_restart(void)
>+{
>+	netlink_close_sock();
>+	netlink_open_sock();
>+}
>+
> static void netlink_open_mon_sock(void)
> {
> 	nf_mon_sock = nfsock_open();
>@@ -443,10 +449,14 @@ static int netlink_list_rules(struct netlink_ctx
>*ctx, const struct handle *h,
> 	struct nft_rule_list *rule_cache;
> 
> 	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
>-	if (rule_cache == NULL)
>+	if (rule_cache == NULL) {
>+		if (errno == EINTR)
>+			return -1;
>+
> 		return netlink_io_error(ctx, loc,
> 					"Could not receive rules from kernel: %s",
> 					strerror(errno));
>+	}
> 
> 	ctx->data = h;
> 	nft_rule_list_foreach(rule_cache, list_rule_cb, ctx);
>@@ -704,10 +714,14 @@ int netlink_list_chains(struct netlink_ctx *ctx,
>const struct handle *h,
> 	struct chain *chain;
> 
> 	chain_cache = mnl_nft_chain_dump(nf_sock, h->family);
>-	if (chain_cache == NULL)
>+	if (chain_cache == NULL) {
>+		if (errno == EINTR)
>+			return -1;
>+
> 		return netlink_io_error(ctx, loc,
> 					"Could not receive chains from kernel: %s",
> 					strerror(errno));
>+	}
> 
> 	ctx->data = h;
> 	nft_chain_list_foreach(chain_cache, list_chain_cb, ctx);
>@@ -907,10 +921,14 @@ int netlink_list_tables(struct netlink_ctx *ctx,
>const struct handle *h,
> 	struct nft_table_list *table_cache;
> 
> 	table_cache = mnl_nft_table_dump(nf_sock, h->family);
>-	if (table_cache == NULL)
>+	if (table_cache == NULL) {
>+		if (errno == EINTR)
>+			return -1;
>+
> 		return netlink_io_error(ctx, loc,
> 					"Could not receive tables from kernel: %s",
> 					strerror(errno));
>+	}
> 
> 	nft_table_list_foreach(table_cache, list_table_cb, ctx);
> 	nft_table_list_free(table_cache);
>@@ -1177,10 +1195,14 @@ int netlink_list_sets(struct netlink_ctx *ctx,
>const struct handle *h,
> 	int err;
> 
> 	set_cache = mnl_nft_set_dump(nf_sock, h->family, h->table);
>-	if (set_cache == NULL)
>+	if (set_cache == NULL) {
>+		if (errno == EINTR)
>+			return -1;
>+
> 		return netlink_io_error(ctx, loc,
> 					"Could not receive sets from kernel: %s",
> 					strerror(errno));
>+	}
> 
> 	err = nft_set_list_foreach(set_cache, list_set_cb, ctx);
> 	nft_set_list_free(set_cache);
>diff --git a/src/rule.c b/src/rule.c
>index a7bc6f4..1e54526 100644
>--- a/src/rule.c
>+++ b/src/rule.c
>@@ -14,6 +14,7 @@
> #include <stdint.h>
> #include <string.h>
> #include <inttypes.h>
>+#include <errno.h>
> 
> #include <statement.h>
> #include <rule.h>
>@@ -701,12 +702,28 @@ static int do_command_export(struct netlink_ctx
>*ctx, struct cmd *cmd)
> 	return 0;
> }
> 
>+static void do_command_list_cleanup(struct table *table)
>+{
>+	struct chain *chain, *nchain;
>+	struct set *set, *nset;
>+
>+	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
>+		list_del(&chain->list);
>+		chain_free(chain);
>+	}
>+
>+	list_for_each_entry_safe(set, nset, &table->sets, list) {
>+		list_del(&set->list);
>+		set_free(set);
>+	}
>+}
>+
> static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
> {
> 	struct table *table = NULL;
>-	struct chain *chain, *nchain;
>+	struct chain *chain;
> 	struct rule *rule, *nrule;
>-	struct set *set, *nset;
>+	struct set *set;
> 
> 	/* No need to allocate the table object when listing all tables */
> 	if (cmd->handle.table != NULL) {
>@@ -726,7 +743,7 @@ static int do_command_list(struct netlink_ctx *ctx,
>struct cmd *cmd)
> 
> 			if (netlink_list_tables(ctx, &cmd->handle,
> 						&cmd->location) < 0)
>-				return -1;
>+				goto err;
> 
> 			list_for_each_entry(table, &ctx->list, list) {
> 				printf("table %s\n", table->handle.table);
>@@ -735,39 +752,41 @@ static int do_command_list(struct netlink_ctx
>*ctx, struct cmd *cmd)
> 		}
> 		/* List content of this table */
> 		if (do_list_sets(ctx, &cmd->location, table) < 0)
>-			return -1;
>+			goto err;
> 		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		list_splice_tail_init(&ctx->list, &table->chains);
> 		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		break;
> 	case CMD_OBJ_CHAIN:
> 		if (do_list_sets(ctx, &cmd->location, table) < 0)
>-			return -1;
>+			goto err;
> 		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		list_splice_tail_init(&ctx->list, &table->chains);
> 		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		break;
> 	case CMD_OBJ_SETS:
> 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		list_for_each_entry(set, &ctx->list, list){
> 			if (netlink_get_setelems(ctx, &set->handle,
>-						 &cmd->location, set) < 0)
>-				return -1;
>+						 &cmd->location, set) < 0) {
>+				goto err;
>+			}
> 			set_print(set);
> 		}
> 		return 0;
> 	case CMD_OBJ_SET:
> 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
>-			return -1;
>+			goto err;
> 		list_for_each_entry(set, &ctx->list, list) {
> 			if (netlink_get_setelems(ctx, &cmd->handle,
>-						 &cmd->location, set) < 0)
>-				return -1;
>+						 &cmd->location, set) < 0) {
>+				goto err;
>+			}
> 			set_print(set);
> 		}
> 		return 0;
>@@ -787,18 +806,11 @@ static int do_command_list(struct netlink_ctx
>*ctx, struct cmd *cmd)
> 	}
> 
> 	table_print(table);
>-
>-	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
>-		list_del(&chain->list);
>-		chain_free(chain);
>-	}
>-
>-	list_for_each_entry_safe(set, nset, &table->sets, list) {
>-		list_del(&set->list);
>-		set_free(set);
>-	}
>-
>+	do_command_list_cleanup(table);
> 	return 0;
>+err:
>+	do_command_list_cleanup(table);
>+	return -1;
> }
> 
> static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)

Looks good to me, thanks.

-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
