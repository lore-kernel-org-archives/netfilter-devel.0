Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D585DC10DCE
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00BA208D5
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgCXWc7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 18:32:59 -0400
Received: from correo.us.es ([193.147.175.20]:34638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgCXWcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B641FB371
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F39CDDA3C3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E9333DA736; Tue, 24 Mar 2020 23:31:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A2F2DA736;
        Tue, 24 Mar 2020 23:31:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D98DD42EF42B;
        Tue, 24 Mar 2020 23:31:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/7] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
Date:   Tue, 24 Mar 2020 23:32:17 +0100
Message-Id: <20200324223220.12119-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

...and return -ENOTEMPTY to the front-end in this case, instead of
proceeding. Currently, nft takes care of checking for these cases
and not sending them to the kernel, but if we drop the set_overlap()
call in nft we can end up in situations like:

 # nft add table t
 # nft add set t s '{ type inet_service ; flags interval ; }'
 # nft add element t s '{ 1 - 5 }'
 # nft add element t s '{ 6 - 10 }'
 # nft add element t s '{ 4 - 7 }'
 # nft list set t s
 table ip t {
 	set s {
 		type inet_service
 		flags interval
 		elements = { 1-3, 4-5, 6-7 }
 	}
 }

This change has the primary purpose of making the behaviour
consistent with nft_set_pipapo, but is also functional to avoid
inconsistent behaviour if userspace sends overlapping elements for
any reason.

v2: When we meet the same key data in the tree, as start element while
    inserting an end element, or as end element while inserting a start
    element, actually check that the existing element is active, before
    resetting the overlap flag (Pablo Neira Ayuso)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 70 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 85572b2a6051..8617fc16a1ed 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -213,8 +213,43 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
+	bool overlap = false;
 	int d;
 
+	/* Detect overlaps as we descend the tree. Set the flag in these cases:
+	 *
+	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
+	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 *
+	 * and clear it later on, as we eventually reach the points indicated by
+	 * '?' above, in the cases described below. We'll always meet these
+	 * later, locally, due to tree ordering, and overlaps for the intervals
+	 * that are the closest together are always evaluated last.
+	 *
+	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
+	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b3. !_____>|            (insert end after existing start)
+	 *
+	 * Case a4. resolves to b1.:
+	 * - if the inserted start element is the leftmost, because the '0'
+	 *   element in the tree serves as end element
+	 * - otherwise, if an existing end is found. Note that end elements are
+	 *   always inserted after corresponding start elements.
+	 *
+	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * in that order.
+	 *
+	 * The flag is also cleared in two special cases:
+	 *
+	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
+	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
+	 *
+	 * which always happen as last step and imply that no further
+	 * overlapping is possible.
+	 */
+
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
@@ -223,17 +258,42 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		d = memcmp(nft_set_ext_key(&rbe->ext),
 			   nft_set_ext_key(&new->ext),
 			   set->klen);
-		if (d < 0)
+		if (d < 0) {
 			p = &parent->rb_left;
-		else if (d > 0)
+
+			if (nft_rbtree_interval_start(new)) {
+				overlap = nft_rbtree_interval_start(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else {
+				overlap = nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			}
+		} else if (d > 0) {
 			p = &parent->rb_right;
-		else {
+
+			if (nft_rbtree_interval_end(new)) {
+				overlap = nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else if (nft_rbtree_interval_end(rbe) &&
+				   nft_set_elem_active(&rbe->ext, genmask)) {
+				overlap = true;
+			}
+		} else {
 			if (nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
+
+				if (nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
+
+				if (nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
 				*ext = &rbe->ext;
 				return -EEXIST;
@@ -242,6 +302,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			}
 		}
 	}
+
+	if (overlap)
+		return -ENOTEMPTY;
+
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;
-- 
2.11.0

