From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nft] src: add rule batching support
Date: Sun, 22 Sep 2013 20:47:19 +0200
Message-ID: <1379875639-6404-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3IVSra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:47:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows nft to put all rule update messages into one
single batch that is sent to the kernel if `-f' option is used.
In order to provide fine grain error reporting, I decided to
to correlate the netlink message sequence number with the
correspoding command sequence number, which is the same. Thus,
nft can identify what rules trigger problems inside a batch
and report them accordingly.

Moreover, to avoid playing buffer size games at batch building
stage, ie. guess what is the final size of the batch for this
ruleset update will be, this patch collects batch pages that
are converted to iovec to ensure linearization when the batch
is sent to the kernel. This reduce the amount of unnecessary
memory usage that is allocated for the batch.

This patch uses the libmnl nlmsg batching infrastructure and it
requires the kernel patch entitled (netfilter: nfnetlink: add batch
support and use it from nf_tables).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h     |   25 ++++++
 include/netlink.h |   14 ++++
 include/rule.h    |    2 +
 src/main.c        |   68 +++++++++++----
 src/mnl.c         |  236 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c     |   46 ++++++++---
 src/rule.c        |   19 ++---
 7 files changed, 370 insertions(+), 40 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index bd24489..fe2fb40 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -1,6 +1,31 @@
 #ifndef _NFTABLES_MNL_H_
 #define _NFTABLES_MNL_H_
 
+#include <list.h>
+
+struct mnl_socket;
+
+uint32_t mnl_seqnum_alloc(void);
+
+struct mnl_err {
+	struct list_head	head;
+	int			err;
+	uint32_t		seqnum;
+};
+
+void mnl_err_list_free(struct mnl_err *err);
+
+void mnl_batch_init(void);
+bool mnl_batch_ready(void);
+void mnl_batch_reset(void);
+void mnl_batch_begin(void);
+void mnl_batch_end(void);
+int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list);
+int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
+			   uint32_t seqnum);
+int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
+			   uint32_t seqnum);
+
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *r,
 		     unsigned int flags);
 int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *r,
diff --git a/include/netlink.h b/include/netlink.h
index bdff7f4..85e8434 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -19,12 +19,14 @@
  * @list:	list of parsed rules/chains/tables
  * @set:	current set
  * @data:	pointer to pass data to callback
+ * @seqnum:	sequence number
  */
 struct netlink_ctx {
 	struct list_head	*msgs;
 	struct list_head	list;
 	struct set		*set;
 	const void		*data;
+	uint32_t		seqnum;
 };
 
 extern struct nft_table *alloc_nft_table(const struct handle *h);
@@ -69,6 +71,14 @@ extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
 extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
+extern int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
+				 struct list_head *rule_list);
+extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct rule *rule, uint32_t flags);
+extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc);
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
@@ -122,4 +132,8 @@ extern void netlink_dump_rule(struct nft_rule *nlr);
 extern void netlink_dump_expr(struct nft_rule_expr *nle);
 extern void netlink_dump_set(struct nft_set *nls);
 
+extern int netlink_batch_send(struct list_head *err_list);
+extern int netlink_io_error(struct netlink_ctx *ctx,
+			    const struct location *loc, const char *fmt, ...);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 10cfebd..6ad8af3 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -244,6 +244,7 @@ enum cmd_obj {
  * @op:		operation
  * @obj:	object type to perform operation on
  * @handle:	handle for operations working without full objects
+ * @seqnum:	sequence number to match netlink errors
  * @union:	object
  * @arg:	argument data
  */
@@ -253,6 +254,7 @@ struct cmd {
 	enum cmd_ops		op;
 	enum cmd_obj		obj;
 	struct handle		handle;
+	uint32_t		seqnum;
 	union {
 		void		*data;
 		struct expr	*expr;
diff --git a/src/main.c b/src/main.c
index 1a40b9e..3ddcb71 100644
--- a/src/main.c
+++ b/src/main.c
@@ -24,6 +24,7 @@
 #include <rule.h>
 #include <netlink.h>
 #include <erec.h>
+#include <mnl.h>
 
 unsigned int numeric_output;
 unsigned int handle_output;
@@ -149,10 +150,57 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
+static int nft_netlink(struct parser_state *state, struct list_head *msgs)
+{
+	struct netlink_ctx ctx;
+	struct cmd *cmd, *next;
+	struct mnl_err *err, *tmp;
+	LIST_HEAD(err_list);
+	int ret = 0;
+
+	mnl_batch_begin();
+	list_for_each_entry(cmd, &state->cmds, list) {
+		memset(&ctx, 0, sizeof(ctx));
+		ctx.msgs = msgs;
+		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
+		init_list_head(&ctx.list);
+		ret = do_command(&ctx, cmd);
+		if (ret < 0)
+			return ret;
+	}
+	mnl_batch_end();
+
+	if (mnl_batch_ready())
+		ret = netlink_batch_send(&err_list);
+	else {
+		mnl_batch_reset();
+		goto out;
+	}
+
+	list_for_each_entry_safe(err, tmp, &err_list, head) {
+		list_for_each_entry(cmd, &state->cmds, list) {
+			if (err->seqnum == cmd->seqnum) {
+				netlink_io_error(&ctx, &cmd->location,
+					"Could not process rule in batch: %s",
+					strerror(err->err));
+				mnl_err_list_free(err);
+				break;
+			}
+		}
+	}
+out:
+	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+
+	return ret;
+}
+
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 {
 	struct eval_ctx ctx;
-	int ret;
+	int ret = 0;
 
 	ret = nft_parse(scanner, state);
 	if (ret != 0)
@@ -163,23 +211,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 	if (evaluate(&ctx, &state->cmds) < 0)
 		return -1;
 
-	{
-		struct netlink_ctx ctx;
-		struct cmd *cmd, *next;
-
-		list_for_each_entry_safe(cmd, next, &state->cmds, list) {
-			memset(&ctx, 0, sizeof(ctx));
-			ctx.msgs = msgs;
-			init_list_head(&ctx.list);
-			ret = do_command(&ctx, cmd);
-			list_del(&cmd->list);
-			cmd_free(cmd);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	return 0;
+	return nft_netlink(state, msgs);
 }
 
 int main(int argc, char * const *argv)
diff --git a/src/mnl.c b/src/mnl.c
index 928d692..0acd658 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -21,9 +21,15 @@
 #include <mnl.h>
 #include <errno.h>
 #include <utils.h>
+#include <nftables.h>
 
 static int seq;
 
+uint32_t mnl_seqnum_alloc(void)
+{
+	return seq++;
+}
+
 static int
 mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
@@ -51,6 +57,236 @@ out:
 }
 
 /*
+ * Batching
+ */
+struct mnl_nlmsg_batch *batch;
+
+static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
+{
+	static char *buf;
+
+	buf = xmalloc(getpagesize() * 2);
+	return mnl_nlmsg_batch_start(buf, getpagesize());
+}
+
+void mnl_batch_init(void)
+{
+	batch = mnl_batch_alloc();
+}
+
+static LIST_HEAD(batch_page_list);
+static int batch_num_pages;
+
+struct batch_page {
+	struct list_head	head;
+	struct mnl_nlmsg_batch *batch;
+};
+
+static void mnl_batch_page_add(void)
+{
+	struct batch_page *batch_page;
+
+	batch_page = xmalloc(sizeof(struct batch_page));
+	batch_page->batch = batch;
+	list_add_tail(&batch_page->head, &batch_page_list);
+	batch = mnl_batch_alloc();
+	batch_num_pages++;
+}
+
+static void mnl_batch_put(int type)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = mnl_seqnum_alloc();
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+}
+
+void mnl_batch_begin(void)
+{
+	mnl_batch_put(NFNL_MSG_BATCH_BEGIN);
+}
+
+void mnl_batch_end(void)
+{
+	mnl_batch_put(NFNL_MSG_BATCH_END);
+}
+
+bool mnl_batch_ready(void)
+{
+	/* Check if the batch only contains the initial and trailing batch
+	 * messages. In that case, the batch is empty.
+	 */
+	return mnl_nlmsg_batch_size(batch) != (NLMSG_HDRLEN+sizeof(struct nfgenmsg)) * 2;
+}
+
+void mnl_batch_reset(void)
+{
+	mnl_nlmsg_batch_reset(batch);
+}
+
+static void mnl_err_list_node_add(struct list_head *err_list, int error,
+				  int seqnum)
+{
+	struct mnl_err *err = xmalloc(sizeof(struct mnl_err));
+
+	err->seqnum = seqnum;
+	err->err = error;
+	list_add_tail(&err->head, err_list);
+}
+
+void mnl_err_list_free(struct mnl_err *err)
+{
+	list_del(&err->head);
+	xfree(err);
+}
+
+static int nlbuffsiz;
+
+static void mnl_set_sndbuffer(const struct mnl_socket *nl)
+{
+	int newbuffsiz;
+
+	if (batch_num_pages * getpagesize() <= nlbuffsiz)
+		return;
+
+	newbuffsiz = batch_num_pages * getpagesize();
+
+	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
+		       &newbuffsiz, sizeof(socklen_t)) < 0)
+		return;
+
+	nlbuffsiz = newbuffsiz;
+}
+
+static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
+{
+	static const struct sockaddr_nl snl = {
+		.nl_family = AF_NETLINK
+	};
+	struct iovec iov[batch_num_pages+1];
+	struct msghdr msg = {
+		.msg_name	= (struct sockaddr *) &snl,
+		.msg_namelen	= sizeof(snl),
+		.msg_iov	= iov,
+		.msg_iovlen	= batch_num_pages+1,
+	};
+	struct batch_page *batch_page;
+	int i = 0;
+
+	mnl_set_sndbuffer(nl);
+	mnl_batch_page_add();
+
+	list_for_each_entry(batch_page, &batch_page_list, head) {
+		iov[i].iov_base = mnl_nlmsg_batch_head(batch_page->batch);
+		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
+		i++;
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK) {
+			mnl_nlmsg_fprintf(stdout,
+					  mnl_nlmsg_batch_head(batch_page->batch),
+					  mnl_nlmsg_batch_size(batch_page->batch),
+					  sizeof(struct nfgenmsg));
+		}
+#endif
+	}
+
+	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+}
+
+int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
+{
+	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
+	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	fd_set readfds;
+	struct timeval tv = {
+		.tv_sec		= 0,
+		.tv_usec	= 0
+	};
+
+	ret = mnl_nft_socket_sendmsg(nl);
+	if (ret == -1)
+		goto err;
+
+	FD_ZERO(&readfds);
+	FD_SET(fd, &readfds);
+
+	/* receive and digest all the acknowledgments from the kernel. */
+	ret = select(fd+1, &readfds, NULL, NULL, &tv);
+	if (ret == -1)
+		goto err;
+
+	while (ret > 0 && FD_ISSET(fd, &readfds)) {
+		struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
+
+		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
+		if (ret == -1)
+			goto err;
+
+		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
+		/* Continue on error, make sure we get all acknoledgments */
+		if (ret == -1)
+			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
+
+		ret = select(fd+1, &readfds, NULL, NULL, &tv);
+		if (ret == -1)
+			goto err;
+
+		FD_ZERO(&readfds);
+		FD_SET(fd, &readfds);
+	}
+err:
+	mnl_nlmsg_batch_reset(batch);
+	return ret;
+}
+
+int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
+			   uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			flags|NLM_F_ACK|NLM_F_CREATE, seqnum);
+
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
+int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
+			   uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			NLM_F_ACK, seqnum);
+
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
+/*
  * Rule
  */
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
diff --git a/src/netlink.c b/src/netlink.c
index 9a766cb..c48e667 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -37,6 +37,7 @@ static void __init netlink_open_sock(void)
 		memory_allocation_error();
 
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
+	mnl_batch_init();
 }
 
 static void __exit netlink_close_sock(void)
@@ -44,8 +45,8 @@ static void __exit netlink_close_sock(void)
 	mnl_socket_close(nf_sock);
 }
 
-static int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
-			    const char *fmt, ...)
+int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
+		     const char *fmt, ...)
 {
 	struct error_record *erec;
 	va_list ap;
@@ -305,8 +306,9 @@ struct expr *netlink_alloc_data(const struct location *loc,
 	}
 }
 
-int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
-		     const struct rule *rule, uint32_t flags)
+int netlink_add_rule_batch(struct netlink_ctx *ctx,
+			   const struct handle *h,
+		           const struct rule *rule, uint32_t flags)
 {
 	struct nft_rule *nlr;
 	int err;
@@ -314,29 +316,44 @@ int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 	nlr = alloc_nft_rule(&rule->handle);
 	err = netlink_linearize_rule(ctx, nlr, rule);
 	if (err == 0) {
-		err = mnl_nft_rule_add(nf_sock, nlr, flags | NLM_F_EXCL);
+		err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL,
+					     ctx->seqnum);
 		if (err < 0)
 			netlink_io_error(ctx, &rule->location,
-					 "Could not add rule: %s",
+					 "Could not add rule to batch: %s",
 					 strerror(errno));
 	}
 	nft_rule_free(nlr);
 	return err;
 }
 
-int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc)
+int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle *h,
+			  struct list_head *rule_list)
+{
+	struct rule *rule;
+
+	list_for_each_entry(rule, rule_list, list) {
+		if (netlink_add_rule_batch(ctx, &rule->handle, rule,
+					   NLM_F_APPEND) < 0)
+			return -1;
+	}
+	return 0;
+}
+
+int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct location *loc)
 {
 	struct nft_rule *nlr;
 	int err;
 
 	nlr = alloc_nft_rule(h);
-	err = mnl_nft_rule_delete(nf_sock, nlr, 0);
+	err = mnl_nft_rule_batch_del(nlr, 0, ctx->seqnum);
 	nft_rule_free(nlr);
 
 	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete rule: %s",
+		netlink_io_error(ctx, loc, "Could not delete rule to batch: %s",
 				 strerror(errno));
+
 	return err;
 }
 
@@ -408,7 +425,7 @@ static int flush_rule_cb(struct nft_rule *nlr, void *arg)
 	int err;
 
 	netlink_dump_rule(nlr);
-	err = mnl_nft_rule_delete(nf_sock, nlr, 0);
+	err = mnl_nft_rule_batch_del(nlr, 0, ctx->seqnum);
 	if (err < 0) {
 		netlink_io_error(ctx, NULL, "Could not delete rule: %s",
 				 strerror(errno));
@@ -429,10 +446,12 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive rules from kernel: %s",
 					strerror(errno));
 
+	mnl_batch_begin();
 	nlr = alloc_nft_rule(h);
 	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
 	nft_rule_free(nlr);
 	nft_rule_list_free(rule_cache);
+	mnl_batch_end();
 	return 0;
 }
 
@@ -1035,3 +1054,8 @@ out:
 				 strerror(errno));
 	return err;
 }
+
+int netlink_batch_send(struct list_head *err_list)
+{
+	return mnl_batch_talk(nf_sock, err_list);
+}
diff --git a/src/rule.c b/src/rule.c
index 52f5e16..39a66d7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -454,16 +454,11 @@ void cmd_free(struct cmd *cmd)
 static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc, struct chain *chain)
 {
-	struct rule *rule;
-
 	if (netlink_add_chain(ctx, h, loc, chain) < 0)
 		return -1;
 	if (chain != NULL) {
-		list_for_each_entry(rule, &chain->rules, list) {
-			if (netlink_add_rule(ctx, &rule->handle, rule,
-					     NLM_F_APPEND) < 0)
-				return -1;
-		}
+		if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
+			return -1;
 	}
 	return 0;
 }
@@ -523,8 +518,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_add_chain(ctx, &cmd->handle, &cmd->location,
 				    cmd->chain);
 	case CMD_OBJ_RULE:
-		return netlink_add_rule(ctx, &cmd->handle, cmd->rule,
-					NLM_F_APPEND);
+		return netlink_add_rule_batch(ctx, &cmd->handle,
+					      cmd->rule, NLM_F_APPEND);
 	case CMD_OBJ_SET:
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
@@ -539,7 +534,8 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-		return netlink_add_rule(ctx, &cmd->handle, cmd->rule, 0);
+		return netlink_add_rule_batch(ctx, &cmd->handle,
+					      cmd->rule, 0);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -554,7 +550,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return netlink_delete_chain(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_RULE:
-		return netlink_delete_rule(ctx, &cmd->handle, &cmd->location);
+		return netlink_del_rule_batch(ctx, &cmd->handle,
+					      &cmd->location);
 	case CMD_OBJ_SET:
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
-- 
1.7.10.4

