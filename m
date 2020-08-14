Return-Path: <SRS0=6aKc=BY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68141C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Aug 2020 19:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466042078D
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Aug 2020 19:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHNTWA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Aug 2020 15:22:00 -0400
Received: from correo.us.es ([193.147.175.20]:54486 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHNTV7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Aug 2020 15:21:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87B5CB6FD0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79D53DA704
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2020 21:21:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6F61BDA730; Fri, 14 Aug 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1CECDA704;
        Fri, 14 Aug 2020 21:21:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Aug 2020 21:21:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9104542EF4E0;
        Fri, 14 Aug 2020 21:21:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sbrivio@redhat.com
Subject: [PATCH nf] netfilter: nft_set_rbtree: revisit partial overlap detection
Date:   Fri, 14 Aug 2020 21:21:26 +0200
Message-Id: <20200814192126.29528-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assuming d = memcmp(node, new) when comparing existing nodes and a new
node, when descending the tree to find the spot to insert the node, the
overlaps that can be detected are:

1) If d < 0 and the new node represents an opening interval and there
   is an existing opening interval node in the tree, then there is a
   possible overlap.

2) If d > 0 and the new node represents an end of interval and there is an
   existing end of interval node, then there is a possible overlap.

When descending the tree, the overlap flag can be reset if the
conditions above do not evaluate true anymore.

Note that it is not possible to detect some form of overlaps from the
kernel: Assuming the interval [x, y] exists, then this code cannot
detect when the interval [ a, b ] when [ a, b ] fully wraps [ x, y ], ie.

             [ a, b ]
	<---------------->
             [ x, y ]
           <---------->

Moreover, skip checks for anonymous sets where it is not possible to
catch overlaps since anonymous sets might not have an explicit end of
interval.  e.g.  192.168.0.0/24 and 192.168.1.0/24 results in three tree
nodes, one open interval for 192.168.0.0, another open interval for
192.168.1.0 and the end of interval 192.168.2.0. In this case, there is
no end of interval for 192.168.1.0 since userspace optimizes the
structure to skip this redundant node.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is coming after https://bugzilla.netfilter.org/show_bug.cgi?id=1449
I have removed the documentation in the code, although I could have updated it.
This patch description what kind of overlaps can be detected.

 net/netfilter/nft_set_rbtree.c | 86 ++++++++++++----------------------
 1 file changed, 29 insertions(+), 57 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b6aad3fc46c3..a70decea3e8c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -225,39 +225,6 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	bool overlap = false;
 	int d;
 
-	/* Detect overlaps as we descend the tree. Set the flag in these cases:
-	 *
-	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
-	 *
-	 * and clear it later on, as we eventually reach the points indicated by
-	 * '?' above, in the cases described below. We'll always meet these
-	 * later, locally, due to tree ordering, and overlaps for the intervals
-	 * that are the closest together are always evaluated last.
-	 *
-	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
-	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
-	 *
-	 * Case a3. resolves to b3.:
-	 * - if the inserted start element is the leftmost, because the '0'
-	 *   element in the tree serves as end element
-	 * - otherwise, if an existing end is found. Note that end elements are
-	 *   always inserted after corresponding start elements.
-	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
-	 * in that order.
-	 *
-	 * The flag is also cleared in two special cases:
-	 *
-	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
-	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
-	 *
-	 * which always happen as last step and imply that no further
-	 * overlapping is possible.
-	 */
-
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
@@ -269,44 +236,49 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (d < 0) {
 			p = &parent->rb_left;
 
-			if (nft_rbtree_interval_start(new)) {
-				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else {
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-			}
+			if (nft_set_is_anonymous(set) ||
+			    !nft_set_elem_active(&rbe->ext, genmask) ||
+			    nft_set_elem_expired(&rbe->ext))
+				continue;
+
+			if (nft_rbtree_interval_start(new) &&
+			    nft_rbtree_interval_start(rbe))
+				overlap = true;
+			else
+				overlap = false;
 		} else if (d > 0) {
 			p = &parent->rb_right;
 
-			if (nft_rbtree_interval_end(new)) {
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-			} else if (nft_rbtree_interval_end(rbe) &&
-				   nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
+			if (nft_set_is_anonymous(set) ||
+			    !nft_set_elem_active(&rbe->ext, genmask) ||
+			    nft_set_elem_expired(&rbe->ext))
+				continue;
+
+			if (nft_rbtree_interval_end(new) &&
+			    nft_rbtree_interval_end(rbe))
 				overlap = true;
-			}
+			else
+				overlap = false;
 		} else {
 			if (nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
 
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				if (!nft_set_elem_active(&rbe->ext, genmask) ||
+				    nft_set_elem_expired(&rbe->ext))
+					continue;
+
+				if (!nft_set_is_anonymous(set))
 					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				if (!nft_set_elem_active(&rbe->ext, genmask) ||
+				    nft_set_elem_expired(&rbe->ext))
+					continue;
+
+				if (!nft_set_is_anonymous(set))
 					overlap = false;
 			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
-- 
2.20.1

