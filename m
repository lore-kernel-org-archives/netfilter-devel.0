Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FBAC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiABWPE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56140 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiABWPD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C5B8363F5A
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 3/7] src: remove '$' in symbol_expr_print
Date:   Sun,  2 Jan 2022 23:14:48 +0100
Message-Id: <20220102221452.86469-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is used in --debug=eval mode to annotate symbols that have not yet
been evaluated, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index f1cca8845376..34e0880be470 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -300,8 +300,7 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 
 static void symbol_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	nft_print(octx, "%s%s", expr->scope != NULL ? "$" : "",
-		  expr->identifier);
+	nft_print(octx, "%s", expr->identifier);
 }
 
 static void symbol_expr_clone(struct expr *new, const struct expr *expr)
-- 
2.30.2

