Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02122C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 10:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B83613CA
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 10:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFQK5A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 06:57:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48060 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQK47 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 06:56:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CD8C06424D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 12:53:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: memleak in error path of the set to segtree conversion
Date:   Thu, 17 Jun 2021 12:54:48 +0200
Message-Id: <20210617105448.17190-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release the array of intervals and the segtree in case of error,
otherwise these structures and objects are never released:

SUMMARY: AddressSanitizer: 2864 byte(s) leaked in 37 allocation(s).

Moreover, improve existing a test coverage of this error path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c      | 16 ++++++++++++++--
 tests/py/inet/ip.t |  2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 5eaf684578bf..f721954f76eb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -288,6 +288,7 @@ out:
 
 	return 0;
 err:
+	mpz_clear(p);
 	errno = EEXIST;
 	if (new->expr->etype == EXPR_MAPPING) {
 		new_expr = new->expr->left;
@@ -437,7 +438,7 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 {
 	struct elementary_interval **intervals;
 	struct expr *i, *next;
-	unsigned int n;
+	unsigned int n, m;
 	int err = 0;
 
 	/* We are updating an existing set with new elements, check if the new
@@ -467,8 +468,19 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	 */
 	for (n = 0; n < init->size; n++) {
 		err = ei_insert(msgs, tree, intervals[n], merge);
-		if (err < 0)
+		if (err < 0) {
+			struct elementary_interval *ei;
+			struct rb_node *node, *next;
+
+			for (m = n; m < init->size; m++)
+				ei_destroy(intervals[m]);
+
+			rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
+				ei_remove(tree, ei);
+				ei_destroy(ei);
+			}
 			break;
+		}
 	}
 
 	xfree(intervals);
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index 86604a6363dd..ac5b825e4a34 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -8,4 +8,4 @@
 
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
 ip saddr vmap { 10.0.1.0-10.0.1.255 : accept, 10.0.1.1-10.0.2.255 : drop };fail
-ip saddr vmap { 1.1.1.1-1.1.1.255 : accept, 1.1.1.0-1.1.2.1 : drop};fail
+ip saddr vmap { 3.3.3.3-3.3.3.4 : accept, 1.1.1.1-1.1.1.255 : accept, 1.1.1.0-1.1.2.1 : drop};fail
-- 
2.20.1

