Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568C5CCA481
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiFTIch (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239818AbiFTIc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54F1B12A92
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 12/18] optimize: add hash expression support
Date:   Mon, 20 Jun 2022 10:32:09 +0200
Message-Id: <20220620083215.1021238-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend expr_cmp() to compare hash expressions used in relational.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 1fa46cb6a663..abd0b72f90d3 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -107,6 +107,18 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 		if (expr_a->numgen.offset != expr_b->numgen.offset)
 			return false;
 		break;
+	case EXPR_HASH:
+		if (expr_a->hash.mod != expr_b->hash.mod)
+			return false;
+		if (expr_a->hash.seed_set != expr_b->hash.seed_set)
+			return false;
+		if (expr_a->hash.seed != expr_b->hash.seed)
+			return false;
+		if (expr_a->hash.offset != expr_b->hash.offset)
+			return false;
+		if (expr_a->hash.type != expr_b->hash.type)
+			return false;
+		break;
 	case EXPR_BINOP:
 		return __expr_cmp(expr_a->left, expr_b->left);
 	default:
-- 
2.30.2

