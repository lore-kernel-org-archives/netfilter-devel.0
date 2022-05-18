Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F5CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 18:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiERSEo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 14:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiERSEn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 14:04:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DAEF1ACF8A
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 11:04:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] src: remove NFT_NLATTR_LOC_MAX limit for netlink location error reporting
Date:   Wed, 18 May 2022 20:04:34 +0200
Message-Id: <20220518180435.298462-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518180435.298462-1-pablo@netfilter.org>
References: <20220518180435.298462-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set might have more than 16 elements, use a runtime array to store
netlink error location.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 13 ++++++++-----
 src/cmd.c      |  2 +-
 src/rule.c     | 10 ++++++++--
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e232b97afed7..44e51847b70a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -681,6 +681,11 @@ void monitor_free(struct monitor *m);
 
 #define NFT_NLATTR_LOC_MAX 32
 
+struct nlerr_loc {
+	uint16_t		offset;
+	const struct location	*location;
+};
+
 /**
  * struct cmd - command statement
  *
@@ -716,11 +721,9 @@ struct cmd {
 		struct markup	*markup;
 		struct obj	*object;
 	};
-	struct {
-		uint16_t		offset;
-		const struct location	*location;
-	} attr[NFT_NLATTR_LOC_MAX];
-	int			num_attrs;
+	struct nlerr_loc	*attr;
+	uint32_t		attr_size;
+	uint32_t		num_attrs;
 	const void		*arg;
 };
 
diff --git a/src/cmd.c b/src/cmd.c
index f6a8aa114768..63692422e765 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -237,7 +237,7 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		   struct mnl_err *err)
 {
 	const struct location *loc = NULL;
-	int i;
+	uint32_t i;
 
 	for (i = 0; i < cmd->num_attrs; i++) {
 		if (!cmd->attr[i].offset)
diff --git a/src/rule.c b/src/rule.c
index 799092eb15c5..78f47300d0fc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1279,13 +1279,18 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	cmd->handle   = *h;
 	cmd->location = *loc;
 	cmd->data     = data;
+	cmd->attr     = calloc(NFT_NLATTR_LOC_MAX, sizeof(struct nlerr_loc));
+	cmd->attr_size = NFT_NLATTR_LOC_MAX;
+
 	return cmd;
 }
 
 void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 {
-	if (cmd->num_attrs >= NFT_NLATTR_LOC_MAX)
-		return;
+	if (cmd->num_attrs >= cmd->attr_size) {
+		cmd->attr_size *= 2;
+		cmd->attr = reallocarray(cmd->attr, sizeof(struct nlerr_loc), cmd->attr_size);
+	}
 
 	cmd->attr[cmd->num_attrs].offset = offset;
 	cmd->attr[cmd->num_attrs].location = loc;
@@ -1462,6 +1467,7 @@ void cmd_free(struct cmd *cmd)
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
 	}
+	xfree(cmd->attr);
 	xfree(cmd->arg);
 	xfree(cmd);
 }
-- 
2.30.2

