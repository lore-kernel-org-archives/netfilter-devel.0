Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010DEC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 01:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiDMBv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 21:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiDMBvz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 21:51:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1DDD18E20
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 18:49:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft,v6 1/8] src: add EXPR_F_KERNEL to identify expression in the kernel
Date:   Wed, 13 Apr 2022 03:49:23 +0200
Message-Id: <20220413014930.410728-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413014930.410728-1-pablo@netfilter.org>
References: <20220413014930.410728-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to identify the set elements that reside in the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 2 ++
 src/netlink.c        | 1 +
 src/segtree.c        | 5 ++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

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
index 3ccf5ee129fc..6f7231755927 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -826,6 +826,7 @@ static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 	} else {
 		interval_expr_copy(elem, low);
 	}
+	elem->flags |= EXPR_F_KERNEL;
 
 	return elem;
 }
@@ -1192,7 +1193,7 @@ void interval_map_decompose(struct expr *set)
 		if (!mpz_cmp_ui(range, 0)) {
 			if (expr_basetype(low)->type == TYPE_STRING)
 				mpz_switch_byteorder(expr_value(low)->value, low->len / BITS_PER_BYTE);
-
+			low->flags |= EXPR_F_KERNEL;
 			compound_expr_add(set, expr_get(low));
 		} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 			struct expr *expr;
@@ -1239,6 +1240,8 @@ void interval_map_decompose(struct expr *set)
 		} else {
 			interval_expr_copy(i, low);
 		}
+		i->flags |= EXPR_F_KERNEL;
+
 		expr_free(low);
 	}
 
-- 
2.30.2

