Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7641C6FA8F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbjH3Siv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243677AbjH3L04 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 07:26:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3D0E185
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 04:26:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: remove check for NULL before calling expr_free()
Date:   Wed, 30 Aug 2023 13:26:47 +0200
Message-Id: <20230830112647.286054-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230830112647.286054-1-pablo@netfilter.org>
References: <20230830112647.286054-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

expr_free() already handles NULL pointer, remove redundant check.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 3 +--
 src/rule.c                | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1121f730ffa7..bde783bdf4ad 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -83,8 +83,7 @@ static void netlink_set_register(struct netlink_parse_ctx *ctx,
 		return;
 	}
 
-	if (ctx->registers[reg] != NULL)
-		expr_free(ctx->registers[reg]);
+	expr_free(ctx->registers[reg]);
 
 	ctx->registers[reg] = expr;
 }
diff --git a/src/rule.c b/src/rule.c
index 07b95a993275..35f6d8f28aee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -193,8 +193,8 @@ void set_free(struct set *set)
 
 	if (--set->refcnt > 0)
 		return;
-	if (set->init != NULL)
-		expr_free(set->init);
+
+	expr_free(set->init);
 	if (set->comment)
 		xfree(set->comment);
 	handle_free(&set->handle);
-- 
2.30.2

