Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04C6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 May 2022 16:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiECQOB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiECQNz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 12:13:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAB98167EA
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 09:10:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] optimize: do not clone unsupported statement
Date:   Tue,  3 May 2022 18:10:16 +0200
Message-Id: <20220503161017.54258-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220503161017.54258-1-pablo@netfilter.org>
References: <20220503161017.54258-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip unsupported statements when building the statement matrix,
otherwise clone remains uninitialized.

Fixes: fb298877ece2 ("src: add ruleset optimization infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index a6c26d21eb6b..13890a63e210 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -274,7 +274,7 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 				clone->log.prefix = expr_get(stmt->log.prefix);
 			break;
 		default:
-			break;
+			continue;
 		}
 
 		ctx->stmt[ctx->num_stmts++] = clone;
-- 
2.30.2

