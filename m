Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCFEC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 12:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiCCMP5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 07:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiCCMP5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 07:15:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46EA515DB30
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 04:15:11 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 09CBD625FB
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 13:13:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] optimize: more robust statement merge with vmap
Date:   Thu,  3 Mar 2022 13:15:05 +0100
Message-Id: <20220303121506.496055-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check expressions that are expected on the rhs rather than using a
catch-all default case.

Fixes: 1542082e259b ("optimize: merge same selector with different verdict into verdict map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 64c0a4dbe764..9c63f6a98e95 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -445,12 +445,17 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 			compound_expr_add(set, mapping);
 		}
 		break;
-	default:
+	case EXPR_VALUE:
+	case EXPR_PREFIX:
+	case EXPR_RANGE:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
 		break;
+	default:
+		assert(0);
+		break;
 	}
 }
 
-- 
2.30.2

