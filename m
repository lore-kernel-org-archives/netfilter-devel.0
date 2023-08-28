Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E329C83F1A
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjH1Or6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjH1Or2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6DD1A1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FL/4j7Y3ZiGpX3gXJ5+JBfCu0JDLnjgF05acidqM7sU=;
        b=iIt1tfoe2EhWa649uwMTWA2Qw0IGiINvefPfXTs2oFHS3psJxEEai0EOA79tgfhxBBk7Sw
        +CWpsigvHfQcF7yfvykY3cXePZW/vXBsqNHdS1fFM0G+DPRk9Q11iXRdR9mFip4nvxRW7y
        hwm6nJbtPNmoa5mpWw+A0WI7pD6CKF0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-9O-tUzqQPWGNuuiesFy3GA-1; Mon, 28 Aug 2023 10:46:24 -0400
X-MC-Unique: 9O-tUzqQPWGNuuiesFy3GA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E97C1856DED
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A44240D2839;
        Mon, 28 Aug 2023 14:46:23 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/8] src: use "%zx" format instead of "%Zx"
Date:   Mon, 28 Aug 2023 16:43:53 +0200
Message-ID: <20230828144441.3303222-4-thaller@redhat.com>
In-Reply-To: <20230828144441.3303222-1-thaller@redhat.com>
References: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"%zu" is C99. On the other hand, `man printf` comments about "Z":

  A nonstandard synonym for z that predates the appearance of z.  Do not use in code.

This fixes a compiler warning with clang:

    datatype.c:299:26: error: invalid conversion specifier 'Z' [-Werror,-Wformat-invalid-specifier]
            nft_gmp_print(octx, "0x%Zx [invalid type]", expr->value);
                                   ~^

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c  |  6 +++---
 src/intervals.c | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index dd6a5fbf5df8..a91b9cb793d5 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -296,7 +296,7 @@ void symbol_table_print(const struct symbol_table *tbl,
 
 static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	nft_gmp_print(octx, "0x%Zx [invalid type]", expr->value);
+	nft_gmp_print(octx, "0x%zx [invalid type]", expr->value);
 }
 
 const struct datatype invalid_type = {
@@ -436,7 +436,7 @@ const struct datatype bitmask_type = {
 	.type		= TYPE_BITMASK,
 	.name		= "bitmask",
 	.desc		= "bitmask",
-	.basefmt	= "0x%Zx",
+	.basefmt	= "0x%zx",
 	.basetype	= &integer_type,
 };
 
@@ -486,7 +486,7 @@ const struct datatype integer_type = {
 
 static void xinteger_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	nft_gmp_print(octx, "0x%Zx", expr->value);
+	nft_gmp_print(octx, "0x%zx", expr->value);
 }
 
 /* Alias of integer_type to print raw payload expressions in hexadecimal. */
diff --git a/src/intervals.c b/src/intervals.c
index 85de0199c373..a24f2ca69cb4 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -70,7 +70,7 @@ struct set_automerge_ctx {
 static void purge_elem(struct set_automerge_ctx *ctx, struct expr *i)
 {
 	if (ctx->debug_mask & NFT_DEBUG_SEGTREE) {
-		pr_gmp_debug("remove: [%Zx-%Zx]\n",
+		pr_gmp_debug("remove: [%zx-%zx]\n",
 			     i->key->left->value,
 			     i->key->right->value);
 	}
@@ -255,7 +255,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 			list_move_tail(&i->list, &existing_set->init->expressions);
 		} else if (existing_set) {
 			if (debug_mask & NFT_DEBUG_SEGTREE) {
-				pr_gmp_debug("add: [%Zx-%Zx]\n",
+				pr_gmp_debug("add: [%zx-%zx]\n",
 					     i->key->left->value, i->key->right->value);
 			}
 			clone = expr_clone(i);
@@ -509,13 +509,13 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	if (debug_mask & NFT_DEBUG_SEGTREE) {
 		list_for_each_entry(i, &init->expressions, list)
-			pr_gmp_debug("remove: [%Zx-%Zx]\n",
+			pr_gmp_debug("remove: [%zx-%zx]\n",
 				     i->key->left->value, i->key->right->value);
 		list_for_each_entry(i, &add->expressions, list)
-			pr_gmp_debug("add: [%Zx-%Zx]\n",
+			pr_gmp_debug("add: [%zx-%zx]\n",
 				     i->key->left->value, i->key->right->value);
 		list_for_each_entry(i, &existing_set->init->expressions, list)
-			pr_gmp_debug("existing: [%Zx-%Zx]\n",
+			pr_gmp_debug("existing: [%zx-%zx]\n",
 				     i->key->left->value, i->key->right->value);
 	}
 
-- 
2.41.0

