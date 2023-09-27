Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22263E810D9
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 12:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjI0M2w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjI0M2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 08:28:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A512CCD
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695817679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COdZsTK6FwaJeuMz4QZSYxXph0G4j9lqGXjVqjWNy74=;
        b=SgMkn1675z+HD6K4q2UiHObq9U/qDWttSD5FPezC2UgUm3ROLmwNn4W5vQXX0VMU7S9Vog
        cuA4KahHaRY0J7Fu6Qh6vRWzN7yMpFXYFM1TXK75tjCTBM4mDsNNgibprJyduXqIYYWp8u
        hzZqeVauIAPk7bqaOhXiiwRyp2DfWHY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-_UYL0GlMOeWnZtOUxewS1Q-1; Wed, 27 Sep 2023 08:27:58 -0400
X-MC-Unique: _UYL0GlMOeWnZtOUxewS1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE2D6858F1B
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:27:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 481EB40C6EA8;
        Wed, 27 Sep 2023 12:27:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] netlink_linearize: avoid strict-overflow warning in netlink_gen_bitwise()
Date:   Wed, 27 Sep 2023 14:23:28 +0200
Message-ID: <20230927122744.3434851-4-thaller@redhat.com>
In-Reply-To: <20230927122744.3434851-1-thaller@redhat.com>
References: <20230927122744.3434851-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With gcc-13.2.1-1.fc38.x86_64:

  $ gcc -Iinclude -c -o tmp.o src/netlink_linearize.c -Werror -Wstrict-overflow=5 -O3
  src/netlink_linearize.c: In function ‘netlink_gen_bitwise’:
  src/netlink_linearize.c:1790:1: error: assuming signed overflow does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-Werror=strict-overflow]
   1790 | }
        | ^
  cc1: all warnings being treated as errors

It also makes more sense this way, where "n" is the hight of the
"binops" stack, and we check for a non-empty stack with "n > 0" and pop
the last element with "binops[--n]".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/netlink_linearize.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c91211582b3d..f2514b012a9d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -712,14 +712,13 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	while (left->etype == EXPR_BINOP && left->left != NULL &&
 	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR))
 		binops[n++] = left = left->left;
-	n--;
 
-	netlink_gen_expr(ctx, binops[n--], dreg);
+	netlink_gen_expr(ctx, binops[--n], dreg);
 
 	mpz_bitmask(mask, expr->len);
 	mpz_set_ui(xor, 0);
-	for (; n >= 0; n--) {
-		i = binops[n];
+	while (n > 0) {
+		i = binops[--n];
 		mpz_set(val, i->right->value);
 
 		switch (i->op) {
-- 
2.41.0

