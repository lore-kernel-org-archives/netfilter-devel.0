Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD24C2BA19
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 19:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A692720787
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 19:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgDKTcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 15:32:18 -0400
Received: from correo.us.es ([193.147.175.20]:49150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgDKTcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 15:32:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C3B2C04EA
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 21:32:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1602100A41
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 21:32:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7002DA736; Sat, 11 Apr 2020 21:32:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92CB2100A47
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 21:32:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 11 Apr 2020 21:32:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7D1994251481
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 21:32:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: broken error reporting with mappings
Date:   Sat, 11 Apr 2020 21:32:10 +0200
Message-Id: <20200411193210.45274-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Segfault on error reporting when intervals overlap.

ip saddr vmap {
    10.0.1.0-10.0.1.255 : accept,
    10.0.1.1-10.0.2.255 : drop
}

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1415
Fixes: 4d6ad0f310d6 ("segtree: check for overlapping elements at insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c      | 25 ++++++++++++++++++++-----
 tests/py/inet/ip.t |  2 ++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 8d79332d8578..a9d6ecc89d7c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -190,7 +190,8 @@ static bool segtree_debug(unsigned int debug_mask)
 static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		     struct elementary_interval *new, bool merge)
 {
-	struct elementary_interval *lei, *rei;
+	struct elementary_interval *lei, *rei, *ei;
+	struct expr *new_expr, *expr;
 	mpz_t p;
 
 	mpz_init2(p, tree->keylen);
@@ -205,8 +206,10 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
 
 	if (lei != NULL && rei != NULL && lei == rei) {
-		if (!merge)
+		if (!merge) {
+			ei = lei;
 			goto err;
+		}
 		/*
 		 * The new interval is entirely contained in the same interval,
 		 * split it into two parts:
@@ -228,8 +231,10 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		ei_destroy(lei);
 	} else {
 		if (lei != NULL) {
-			if (!merge)
+			if (!merge) {
+				ei = lei;
 				goto err;
+			}
 			/*
 			 * Left endpoint is within lei, adjust it so we have:
 			 *
@@ -248,8 +253,10 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 			}
 		}
 		if (rei != NULL) {
-			if (!merge)
+			if (!merge) {
+				ei = rei;
 				goto err;
+			}
 			/*
 			 * Right endpoint is within rei, adjust it so we have:
 			 *
@@ -276,7 +283,15 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 	return 0;
 err:
 	errno = EEXIST;
-	return expr_binary_error(msgs, lei->expr, new->expr,
+	if (new->expr->etype == EXPR_MAPPING) {
+		new_expr = new->expr->left;
+		expr = ei->expr->left;
+	} else {
+		new_expr = new->expr;
+		expr = ei->expr;
+	}
+
+	return expr_binary_error(msgs, new_expr, expr,
 				 "conflicting intervals specified");
 }
 
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index 4eb69d7362e3..86604a6363dd 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -7,3 +7,5 @@
 *netdev;test-netdev;ingress
 
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
+ip saddr vmap { 10.0.1.0-10.0.1.255 : accept, 10.0.1.1-10.0.2.255 : drop };fail
+ip saddr vmap { 1.1.1.1-1.1.1.255 : accept, 1.1.1.0-1.1.2.1 : drop};fail
-- 
2.11.0

