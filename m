Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05704C34026
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 12:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13E42173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 12:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBRMqh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 07:46:37 -0500
Received: from correo.us.es ([193.147.175.20]:55404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgBRMqh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 07:46:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF60F120823
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 13:46:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E08ADDA390
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 13:46:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5BA0DA38D; Tue, 18 Feb 2020 13:46:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB691DA390
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 13:46:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 13:46:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B776C41E4800
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 13:46:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: combine extended netlink error reporting with mispelling support
Date:   Tue, 18 Feb 2020 13:46:29 +0100
Message-Id: <20200218124629.448157-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preliminary support to combine extended netlink error reporting, e.g.

 # nft delete table twst
 Error: No such file or directory; did you mean table ‘test’ in family ip?
 delete table twst
              ^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am |   1 +
 src/cmd.c           | 157 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/libnftables.c   |  23 +-------
 3 files changed, 160 insertions(+), 21 deletions(-)
 create mode 100644 src/cmd.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 04a4a619a530..42f24f35ce7a 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,6 +3,7 @@ SUBDIRS =		linux		\
 
 noinst_HEADERS = 	cli.h		\
 			cache.h		\
+			cmd.h		\
 			datatype.h	\
 			expression.h	\
 			fib.h		\
diff --git a/src/cmd.c b/src/cmd.c
new file mode 100644
index 000000000000..5a50632e28a0
--- /dev/null
+++ b/src/cmd.c
@@ -0,0 +1,157 @@
+#include <nftables/libnftables.h>
+#include <erec.h>
+#include <mnl.h>
+#include <cmd.h>
+#include <parser.h>
+#include <utils.h>
+#include <iface.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+
+static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
+				struct location *loc)
+{
+	struct table *table;
+
+	table = table_lookup_fuzzy(&cmd->handle, &ctx->nft->cache);
+	if (!table)
+		return 0;
+
+	netlink_io_error(ctx, loc, "%s; did you mean table ‘%s’ in family %s?",
+			 strerror(ENOENT), table->handle.table.name,
+			 family2str(table->handle.family));
+	return 1;
+}
+
+static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
+				struct location *loc)
+{
+	const struct table *table;
+	struct chain *chain;
+
+	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
+	if (!chain)
+		return 0;
+
+	netlink_io_error(ctx, loc, "%s; did you mean table ‘%s’ in family %s?",
+			 strerror(ENOENT), chain->handle.chain.name,
+			 family2str(table->handle.family),
+			 table->handle.table.name);
+	return 1;
+}
+
+static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
+			      struct location *loc)
+{
+	const struct table *table;
+	struct set *set;
+
+	set = set_lookup_fuzzy(cmd->handle.set.name, &ctx->nft->cache, &table);
+	if (!set)
+		return 0;
+
+	netlink_io_error(ctx, loc, "%s; did you mean %s ‘%s’ in table %s ‘%s’?",
+			 strerror(ENOENT),
+			 set_is_map(set->flags) ? "map" : "set",
+			 set->handle.set.name,
+			 family2str(set->handle.family),
+			 table->handle.table.name);
+	return 1;
+}
+
+static int nft_cmd_enoent_obj(struct netlink_ctx *ctx, const struct cmd *cmd,
+			      struct location *loc)
+{
+	const struct table *table;
+	struct obj *obj;
+
+	obj = obj_lookup_fuzzy(cmd->handle.obj.name, &ctx->nft->cache, &table);
+	if (!obj)
+		return 0;
+
+	netlink_io_error(ctx, loc, "%s; did you mean obj ‘%s’ in table %s ‘%s’?",
+			 strerror(ENOENT), obj->handle.obj.name,
+			 family2str(obj->handle.family),
+			 table->handle.table.name);
+	return 1;
+}
+
+static int nft_cmd_enoent_flowtable(struct netlink_ctx *ctx,
+				    const struct cmd *cmd, struct location *loc)
+{
+	const struct table *table;
+	struct flowtable *ft;
+
+	ft = flowtable_lookup_fuzzy(cmd->handle.flowtable.name,
+				    &ctx->nft->cache, &table);
+	if (!ft)
+		return 0;
+
+	netlink_io_error(ctx, loc, "%s; did you mean flowtable ‘%s’ in table %s ‘%s’?",
+			 strerror(ENOENT), ft->handle.flowtable.name,
+			 family2str(ft->handle.family),
+			 table->handle.table.name);
+	return 1;
+}
+
+static void nft_cmd_enoent(struct netlink_ctx *ctx, const struct cmd *cmd,
+			   struct location *loc, int err)
+{
+	int ret = 0;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		ret = nft_cmd_enoent_table(ctx, cmd, loc);
+		break;
+	case CMD_OBJ_CHAIN:
+		ret = nft_cmd_enoent_chain(ctx, cmd, loc);
+		break;
+	case CMD_OBJ_SET:
+		ret = nft_cmd_enoent_set(ctx, cmd, loc);
+		break;
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_SYNPROXY:
+		ret = nft_cmd_enoent_obj(ctx, cmd, loc);
+		break;
+	case CMD_OBJ_FLOWTABLE:
+		ret = nft_cmd_enoent_flowtable(ctx, cmd, loc);
+		break;
+	default:
+		break;
+	}
+
+	if (ret)
+		return;
+
+	netlink_io_error(ctx, loc, "Could not process rule: %s", strerror(err));
+}
+
+void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
+		   struct mnl_err *err)
+{
+	struct location *loc = NULL;
+	int i;
+
+	for (i = 0; i < cmd->num_attrs; i++) {
+		if (!cmd->attr[i].offset)
+			break;
+		if (cmd->attr[i].offset == err->offset)
+			loc = cmd->attr[i].location;
+	}
+	if (!loc)
+		loc = &cmd->location;
+
+	if (err->err == ENOENT) {
+		nft_cmd_enoent(ctx, cmd, loc, err->err);
+	} else {
+		netlink_io_error(ctx, loc, "Could not process rule: %s",
+				 strerror(err->err));
+	}
+}
diff --git a/src/libnftables.c b/src/libnftables.c
index eaa4736c397d..32da0a29ee21 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -12,30 +12,11 @@
 #include <parser.h>
 #include <utils.h>
 #include <iface.h>
-
+#include <cmd.h>
 #include <errno.h>
 #include <stdlib.h>
 #include <string.h>
 
-static void nft_error(struct netlink_ctx *ctx, struct cmd *cmd,
-		      struct mnl_err *err)
-{
-	struct location *loc = NULL;
-	int i;
-
-	for (i = 0; i < cmd->num_attrs; i++) {
-		if (!cmd->attr[i].offset)
-			break;
-		if (cmd->attr[i].offset == err->offset)
-			loc = cmd->attr[i].location;
-	}
-	if (!loc)
-		loc = &cmd->location;
-
-	netlink_io_error(ctx, loc, "Could not process rule: %s",
-			 strerror(err->err));
-}
-
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
@@ -87,7 +68,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		list_for_each_entry(cmd, cmds, list) {
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
-				nft_error(&ctx, cmd, err);
+				nft_cmd_error(&ctx, cmd, err);
 				errno = err->err;
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
-- 
2.11.0

