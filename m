Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F437C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 18:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665BC206D5
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 18:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgFGS0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 14:26:10 -0400
Received: from correo.us.es ([193.147.175.20]:45034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgFGS0J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 14:26:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5190B11D8E0
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:26:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 436CDDA8E8
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:26:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38E16DA8EC; Sun,  7 Jun 2020 20:26:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AEC2DA8E8
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:26:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 07 Jun 2020 20:26:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1560041E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:26:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: add misspelling suggestions for rule commands
Date:   Sun,  7 Jun 2020 20:26:01 +0200
Message-Id: <20200607182601.24792-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add rule foo ber counter
 Error: No such file or directory; did you mean chain ‘bar’ in table ip ‘foo’?
 add rule foo ber counter
              ^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index c8ea449222fe..e0cf3e7716cb 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -6,6 +6,7 @@
 #include <iface.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <cache.h>
 #include <string.h>
 
 static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
@@ -40,6 +41,40 @@ static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 1;
 }
 
+static int nft_cmd_enoent_rule(struct netlink_ctx *ctx, const struct cmd *cmd,
+			       struct location *loc)
+{
+	unsigned int flags = NFT_CACHE_TABLE |
+			     NFT_CACHE_CHAIN;
+	const struct table *table;
+	struct chain *chain;
+
+	if (cache_update(ctx->nft, flags, ctx->msgs) < 0)
+		return 0;
+
+	table = table_lookup_fuzzy(&cmd->handle, &ctx->nft->cache);
+	if (table && strcmp(cmd->handle.table.name, table->handle.table.name)) {
+		netlink_io_error(ctx, loc, "%s; did you mean table ‘%s’ in family %s?",
+				 strerror(ENOENT), table->handle.table.name,
+				 family2str(table->handle.family));
+		return 1;
+	} else if (!table) {
+		return 0;
+	}
+
+	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
+	if (chain && strcmp(cmd->handle.chain.name, chain->handle.chain.name)) {
+		netlink_io_error(ctx, loc, "%s; did you mean chain ‘%s’ in table %s ‘%s’?",
+				 strerror(ENOENT),
+				 chain->handle.chain.name,
+				 family2str(table->handle.family),
+				 table->handle.table.name);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 			      struct location *loc)
 {
@@ -109,6 +144,9 @@ static void nft_cmd_enoent(struct netlink_ctx *ctx, const struct cmd *cmd,
 	case CMD_OBJ_SET:
 		ret = nft_cmd_enoent_set(ctx, cmd, loc);
 		break;
+	case CMD_OBJ_RULE:
+		ret = nft_cmd_enoent_rule(ctx, cmd, loc);
+		break;
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
-- 
2.20.1

