Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED59EC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 14:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiDLOte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 10:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiDLOtd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 10:49:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A3435C87D
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 07:47:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4 1/7] src: add EXPR_F_KERNEL to identify expression in the kernel
Date:   Tue, 12 Apr 2022 16:47:05 +0200
Message-Id: <20220412144711.93354-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412144711.93354-1-pablo@netfilter.org>
References: <20220412144711.93354-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to identify the set elements that reside in the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  2 ++
 src/netlink.c        |  1 +
 src/segtree.c        | 10 ++++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 78f788b3c377..ce32e1f3d20c 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -192,6 +192,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype);
  * @EXPR_F_INTERVAL_END:	set member ends an open interval
  * @EXPR_F_BOOLEAN:		expression is boolean (set by relational expr on LHS)
  * @EXPR_F_INTERVAL:		expression describes a interval
+ * @EXPR_F_KERNEL:		expression resides in the kernel
  */
 enum expr_flags {
 	EXPR_F_CONSTANT		= 0x1,
@@ -200,6 +201,7 @@ enum expr_flags {
 	EXPR_F_INTERVAL_END	= 0x8,
 	EXPR_F_BOOLEAN		= 0x10,
 	EXPR_F_INTERVAL		= 0x20,
+	EXPR_F_KERNEL		= 0x40,
 };
 
 #include <payload.h>
diff --git a/src/netlink.c b/src/netlink.c
index 775c6f5170e2..24a9ad9852f3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1286,6 +1286,7 @@ key_end:
 	}
 
 	expr = set_elem_expr_alloc(&netlink_location, key);
+	expr->flags |= EXPR_F_KERNEL;
 
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT))
 		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
diff --git a/src/segtree.c b/src/segtree.c
index a61ea3d2854a..832bc7dd1402 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -1060,9 +1060,10 @@ void interval_map_decompose(struct expr *set)
 
 		mpz_and(p, expr_value(low)->value, range);
 
-		if (!mpz_cmp_ui(range, 0))
+		if (!mpz_cmp_ui(range, 0)) {
+			low->flags |= EXPR_F_KERNEL;
 			compound_expr_add(set, expr_get(low));
-		else if ((!range_is_prefix(range) ||
+		} else if ((!range_is_prefix(range) ||
 			  !(i->dtype->flags & DTYPE_F_PREFIX)) ||
 			 mpz_cmp_ui(p, 0)) {
 			struct expr *tmp;
@@ -1087,6 +1088,7 @@ void interval_map_decompose(struct expr *set)
 			} else {
 				interval_expr_copy(tmp, low);
 			}
+			tmp->flags |= EXPR_F_KERNEL;
 
 			compound_expr_add(set, tmp);
 		} else {
@@ -1109,6 +1111,7 @@ void interval_map_decompose(struct expr *set)
 			} else {
 				interval_expr_copy(prefix, low);
 			}
+			prefix->flags |= EXPR_F_KERNEL;
 
 			compound_expr_add(set, prefix);
 		}
@@ -1134,6 +1137,7 @@ void interval_map_decompose(struct expr *set)
 		i = range_expr_alloc(&low->location,
 				     expr_clone(expr_value(low)), i);
 		i = set_elem_expr_alloc(&low->location, i);
+
 		if (low->etype == EXPR_MAPPING) {
 			i = mapping_expr_alloc(&i->location, i,
 					       expr_clone(low->right));
@@ -1141,6 +1145,8 @@ void interval_map_decompose(struct expr *set)
 		} else {
 			interval_expr_copy(i, low);
 		}
+		i->flags |= EXPR_F_KERNEL;
+
 		expr_free(low);
 	}
 
-- 
2.30.2

