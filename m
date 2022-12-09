Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7889EC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 12:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLIMQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Dec 2022 07:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLIMQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2022 07:16:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96E8949B51
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2022 04:16:49 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] netlink: add function to generate set element key data
Date:   Fri,  9 Dec 2022 13:16:44 +0100
Message-Id: <20221209121645.903831-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221209121645.903831-1-pablo@netfilter.org>
References: <20221209121645.903831-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add netlink_gen_key(), it is just like __netlink_gen_data() with no
EXPR_VERDICT case, which should not ever happen for set element keys.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index db92f3506503..15eb890e422a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -96,7 +96,8 @@ struct nftnl_expr *alloc_nft_expr(const char *name)
 
 	return nle;
 }
-
+static void netlink_gen_key(const struct expr *expr,
+			    struct nft_data_linearize *data);
 static void __netlink_gen_data(const struct expr *expr,
 			       struct nft_data_linearize *data, bool expand);
 
@@ -136,19 +137,19 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		if (set->set_flags & NFT_SET_INTERVAL &&
 		    key->etype == EXPR_CONCAT && key->field_count > 1) {
 			key->flags |= EXPR_F_INTERVAL;
-			__netlink_gen_data(key, &nld, false);
+			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL;
 
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 
 			key->flags |= EXPR_F_INTERVAL_END;
-			__netlink_gen_data(key, &nld, false);
+			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL_END;
 
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
 					   &nld.value, nld.len);
 		} else {
-			__netlink_gen_data(key, &nld, false);
+			netlink_gen_key(key, &nld);
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 		}
 		break;
@@ -430,6 +431,23 @@ static void netlink_gen_prefix(const struct expr *expr,
 	nld->len = len;
 }
 
+static void netlink_gen_key(const struct expr *expr,
+			    struct nft_data_linearize *data)
+{
+	switch (expr->etype) {
+	case EXPR_VALUE:
+		return netlink_gen_constant_data(expr, data);
+	case EXPR_CONCAT:
+		return netlink_gen_concat_data(expr, data, false);
+	case EXPR_RANGE:
+		return netlink_gen_range(expr, data);
+	case EXPR_PREFIX:
+		return netlink_gen_prefix(expr, data);
+	default:
+		BUG("invalid data expression type %s\n", expr_name(expr));
+	}
+}
+
 static void __netlink_gen_data(const struct expr *expr,
 			       struct nft_data_linearize *data, bool expand)
 {
-- 
2.30.2

