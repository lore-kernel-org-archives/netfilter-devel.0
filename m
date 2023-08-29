Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F5AC83F18
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjH2S4q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjH2S4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B11BF
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAPVyztH6pHqTag7HxLb+l4tcxe/mVcAKuxelFWh69g=;
        b=L5dOh2mg9DrBd0M3jgDiC98O2vNEjSXflJoyQ65VgaRlzCy6x1EJIrfo9D+Ca0Zluv/zJQ
        /Ik0n9AJ9ob4JAzS6kOulgKJjQWaEa6usRRWRgvbCcMpE4oLViRbSYRHiik11w/pnJWXY/
        5OYsOibLZfWL49UF8ZM/djHtb2iApek=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-ucaQ3QfdNOiFG1MHRRuN_w-1; Tue, 29 Aug 2023 14:55:27 -0400
X-MC-Unique: ucaQ3QfdNOiFG1MHRRuN_w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C5203810D35
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0EC8401E54;
        Tue, 29 Aug 2023 18:55:26 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/5] src: silence "implicit-fallthrough" warnings
Date:   Tue, 29 Aug 2023 20:54:09 +0200
Message-ID: <20230829185509.374614-4-thaller@redhat.com>
In-Reply-To: <20230829185509.374614-1-thaller@redhat.com>
References: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gcc with "-Wextra" warns:

    CC       segtree.lo
  segtree.c: In function 'get_set_interval_find':
  segtree.c:129:28: error: this statement may fall through [-Werror=implicit-fallthrough=]
    129 |                         if (expr_basetype(i->key)->type != TYPE_STRING)
        |                            ^
  segtree.c:134:17: note: here
    134 |                 case EXPR_PREFIX:
        |                 ^~~~

    CC       optimize.lo
  optimize.c: In function 'rule_collect_stmts':
  optimize.c:396:28: error: this statement may fall through [-Werror=implicit-fallthrough=]
    396 |                         if (stmt->expr->left->etype == EXPR_CONCAT) {
        |                            ^
  optimize.c:400:17: note: here
    400 |                 case STMT_VERDICT:
        |                 ^~~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/optimize.c | 1 +
 src/segtree.c  | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 0b99b6726115..9c1704831693 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -397,6 +397,7 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 				clone->ops = &unsupported_stmt_ops;
 				break;
 			}
+			/* fall-through */
 		case STMT_VERDICT:
 			clone->expr = expr_get(stmt->expr);
 			break;
diff --git a/src/segtree.c b/src/segtree.c
index a265a0b30d64..bf207402c945 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -128,9 +128,8 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 		case EXPR_VALUE:
 			if (expr_basetype(i->key)->type != TYPE_STRING)
 				break;
-			/* string type, check if its a range (wildcard), so
-			 * fall through.
-			 */
+			/* string type, check if its a range (wildcard). */
+			/* fall-through */
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
 			range_expr_value_low(val, i);
-- 
2.41.0

