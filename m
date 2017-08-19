From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 07/18] libnftables: put nft_run in library
Date: Sat, 19 Aug 2017 17:24:09 +0200
Message-ID: <20170819152420.22563-8-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33626 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751612AbdHSPYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:43 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h        |   4 --
 include/nftables_common.h |  18 ++++++++
 src/Makefile.am           |   1 +
 src/cli.c                 |   1 +
 src/libnftables.c         |   2 +
 src/main.c                |  85 -------------------------------------
 src/nftables_common.c     | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 126 insertions(+), 89 deletions(-)
 create mode 100644 include/nftables_common.h
 create mode 100644 src/nftables_common.c

diff --git a/include/nftables.h b/include/nftables.h
index 717af37..c2bb7d8 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -124,10 +124,6 @@ struct input_descriptor {
 struct parser_state;
 struct mnl_socket;
 
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    struct nft_cache *cache, void *scanner, struct parser_state *state,
-	    struct list_head *msgs);
-
 void ct_label_table_init(void);
 void mark_table_init(void);
 void gmp_init(void);
diff --git a/include/nftables_common.h b/include/nftables_common.h
new file mode 100644
index 0000000..c3f54a5
--- /dev/null
+++ b/include/nftables_common.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+
+#ifndef NFTABLES_NFTABLES_COMMON_H
+#define NFTABLES_NFTABLES_COMMON_H
+
+int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	    struct nft_cache *cache, void *scanner, struct parser_state *state,
+	    struct list_head *msgs);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index a340d39..cddd3a2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -58,6 +58,7 @@ libnftables_la_SOURCES =	rule.c				\
 		libnftables.c			\
 		scanner.l			\
 		tcpopt.c			\
+		nftables_common.c		\
 		parser_bison.y
 
 if BUILD_MINIGMP
diff --git a/src/cli.c b/src/cli.c
index a50fc58..7501b29 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -30,6 +30,7 @@
 #include <utils.h>
 #include <iface.h>
 #include <cli.h>
+#include <nftables_common.h>
 
 #include <libmnl/libmnl.h>
 
diff --git a/src/libnftables.c b/src/libnftables.c
index a487a87..446ec1e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -16,6 +16,8 @@
 #include <erec.h>
 #include <libmnl/libmnl.h>
 #include <mnl.h>
+#include <netlink.h>
+#include <nftables_common.h>
 
 #include <nftables/nftables.h>
 
diff --git a/src/main.c b/src/main.c
index 658988d..9b4e450 100644
--- a/src/main.c
+++ b/src/main.c
@@ -182,91 +182,6 @@ static const struct {
 };
 #endif
 
-static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
-		       struct parser_state *state, struct list_head *msgs,
-		       struct mnl_socket *nf_sock)
-{
-	uint32_t batch_seqnum, seqnum = 0;
-	struct nftnl_batch *batch;
-	struct netlink_ctx ctx;
-	struct cmd *cmd;
-	struct mnl_err *err, *tmp;
-	LIST_HEAD(err_list);
-	bool batch_supported = netlink_batch_supported(nf_sock, &seqnum);
-	int ret = 0;
-
-	batch = mnl_batch_init();
-
-	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
-	list_for_each_entry(cmd, &state->cmds, list) {
-		memset(&ctx, 0, sizeof(ctx));
-		ctx.msgs = msgs;
-		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
-		ctx.batch = batch;
-		ctx.batch_supported = batch_supported;
-		ctx.octx = &nft->output;
-		ctx.nf_sock = nf_sock;
-		ctx.cache = cache;
-		init_list_head(&ctx.list);
-		ret = do_command(&ctx, cmd);
-		if (ret < 0)
-			goto out;
-	}
-	if (!nft->check)
-		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
-
-	if (!mnl_batch_ready(batch))
-		goto out;
-
-	ret = netlink_batch_send(&ctx, &err_list);
-
-	list_for_each_entry_safe(err, tmp, &err_list, head) {
-		list_for_each_entry(cmd, &state->cmds, list) {
-			if (err->seqnum == cmd->seqnum ||
-			    err->seqnum == batch_seqnum) {
-				netlink_io_error(&ctx, &cmd->location,
-						 "Could not process rule: %s",
-						 strerror(err->err));
-				ret = -1;
-				errno = err->err;
-				if (err->seqnum == cmd->seqnum) {
-					mnl_err_list_free(err);
-					break;
-				}
-			}
-		}
-	}
-out:
-	mnl_batch_reset(batch);
-	return ret;
-}
-
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    struct nft_cache *cache, void *scanner, struct parser_state *state,
-	    struct list_head *msgs)
-{
-	struct cmd *cmd, *next;
-	int ret;
-
-	ret = nft_parse(scanner, state);
-	if (ret != 0 || state->nerrs > 0) {
-		ret = -1;
-		goto err1;
-	}
-
-	list_for_each_entry(cmd, &state->cmds, list)
-		nft_cmd_expand(cmd);
-
-	ret = nft_netlink(nft, cache, state, msgs, nf_sock);
-err1:
-	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
-		list_del(&cmd->list);
-		cmd_free(cmd);
-	}
-
-	return ret;
-}
-
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
diff --git a/src/nftables_common.c b/src/nftables_common.c
new file mode 100644
index 0000000..4ae9f3e
--- /dev/null
+++ b/src/nftables_common.c
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <string.h>
+#include <errno.h>
+
+#include <nftables.h>
+#include <nftables_common.h>
+#include <netlink.h>
+#include <parser.h>
+#include <mnl.h>
+
+static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
+		       struct parser_state *state, struct list_head *msgs,
+		       struct mnl_socket *nf_sock)
+{
+	uint32_t batch_seqnum, seqnum = 0;
+	struct nftnl_batch *batch;
+	struct netlink_ctx ctx;
+	struct cmd *cmd;
+	struct mnl_err *err, *tmp;
+	LIST_HEAD(err_list);
+	bool batch_supported = netlink_batch_supported(nf_sock, &seqnum);
+	int ret = 0;
+
+	batch = mnl_batch_init();
+
+	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
+	list_for_each_entry(cmd, &state->cmds, list) {
+		memset(&ctx, 0, sizeof(ctx));
+		ctx.msgs = msgs;
+		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
+		ctx.batch = batch;
+		ctx.batch_supported = batch_supported;
+		ctx.octx = &nft->output;
+		ctx.nf_sock = nf_sock;
+		ctx.cache = cache;
+		init_list_head(&ctx.list);
+		ret = do_command(&ctx, cmd);
+		if (ret < 0)
+			goto out;
+	}
+	if (!nft->check)
+		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
+
+	if (!mnl_batch_ready(batch))
+		goto out;
+
+	ret = netlink_batch_send(&ctx, &err_list);
+
+	list_for_each_entry_safe(err, tmp, &err_list, head) {
+		list_for_each_entry(cmd, &state->cmds, list) {
+			if (err->seqnum == cmd->seqnum ||
+			    err->seqnum == batch_seqnum) {
+				netlink_io_error(&ctx, &cmd->location,
+						 "Could not process rule: %s",
+						 strerror(err->err));
+				ret = -1;
+				errno = err->err;
+				if (err->seqnum == cmd->seqnum) {
+					mnl_err_list_free(err);
+					break;
+				}
+			}
+		}
+	}
+out:
+	mnl_batch_reset(batch);
+	return ret;
+}
+
+int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	    struct nft_cache *cache, void *scanner, struct parser_state *state,
+	    struct list_head *msgs)
+{
+	struct cmd *cmd, *next;
+	int ret;
+
+	ret = nft_parse(scanner, state);
+	if (ret != 0 || state->nerrs > 0) {
+		ret = -1;
+		goto err1;
+	}
+
+	list_for_each_entry(cmd, &state->cmds, list)
+		nft_cmd_expand(cmd);
+
+	ret = nft_netlink(nft, cache, state, msgs, nf_sock);
+err1:
+	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+
+	return ret;
+}
+
+
-- 
2.14.1

