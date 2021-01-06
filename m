Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8DCC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 14:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E050E2255F
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 14:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbhAFOCI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 09:02:08 -0500
Received: from correo.us.es ([193.147.175.20]:60784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAFOCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 09:02:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1EDBBDA723
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 15:00:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 109A2DA730
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 15:00:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06306DA4C8; Wed,  6 Jan 2021 15:00:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC274DA730;
        Wed,  6 Jan 2021 15:00:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Jan 2021 15:00:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 989BE426CC84;
        Wed,  6 Jan 2021 15:00:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     miked@softtalker.com
Subject: [PATCH nft] segtree: honor set element expiration
Date:   Wed,  6 Jan 2021 15:01:19 +0100
Message-Id: <20210106140119.10915-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend c1f0476fd590 ("segtree: copy expr data to closing element") to
use interval_expr_copy() from the linearization path.

Reported-by: Mike Dillinger <miked@softtalker.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 6988d07b24fb..9aa39e52d8a0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -568,6 +568,18 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 	mpz_clear(q);
 }
 
+static void interval_expr_copy(struct expr *dst, struct expr *src)
+{
+	if (src->comment)
+		dst->comment = xstrdup(src->comment);
+	if (src->timeout)
+		dst->timeout = src->timeout;
+	if (src->expiration)
+		dst->expiration = src->expiration;
+
+	list_splice_init(&src->stmt_list, &dst->stmt_list);
+}
+
 static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 				const struct elementary_interval *ei)
 {
@@ -580,17 +592,11 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 
 	if (ei->expr != NULL) {
 		if (ei->expr->etype == EXPR_MAPPING) {
-			if (ei->expr->left->comment)
-				expr->comment = xstrdup(ei->expr->left->comment);
-			if (ei->expr->left->timeout)
-				expr->timeout = ei->expr->left->timeout;
+			interval_expr_copy(expr, ei->expr->left);
 			expr = mapping_expr_alloc(&ei->expr->location, expr,
 						  expr_get(ei->expr->right));
 		} else {
-			if (ei->expr->comment)
-				expr->comment = xstrdup(ei->expr->comment);
-			if (ei->expr->timeout)
-				expr->timeout = ei->expr->timeout;
+			interval_expr_copy(expr, ei->expr);
 		}
 	}
 
@@ -927,18 +933,6 @@ next:
 	}
 }
 
-static void interval_expr_copy(struct expr *dst, struct expr *src)
-{
-	if (src->comment)
-		dst->comment = xstrdup(src->comment);
-	if (src->timeout)
-		dst->timeout = src->timeout;
-	if (src->expiration)
-		dst->expiration = src->expiration;
-
-	list_splice_init(&src->stmt_list, &dst->stmt_list);
-}
-
 void interval_map_decompose(struct expr *set)
 {
 	struct expr **elements, **ranges;
-- 
2.20.1

