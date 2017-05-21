From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_set_rbtree: handle re-addition element after deletion
Date: Mon, 22 May 2017 00:17:30 +0200
Message-ID: <1495405050-2332-1-git-send-email-pablo@netfilter.org>
Cc: w.bumiller@proxmox.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756978AbdEUWRn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 18:17:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D40713BB82
        for <netfilter-devel@vger.kernel.org>; Mon, 22 May 2017 00:17:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FA33FF2F1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 May 2017 00:17:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1E42DA870
        for <netfilter-devel@vger.kernel.org>; Mon, 22 May 2017 00:17:31 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The existing code selects no next branch to be inspected when
re-inserting an inactive element into the rb-tree, looping endlessly.
This patch restricts the check for active elements to the EEXIST case
only.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Reported-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index e97e2fb53f0a..fbdbaa00dd5f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -116,17 +116,17 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		else if (d > 0)
 			p = &parent->rb_right;
 		else {
-			if (nft_set_elem_active(&rbe->ext, genmask)) {
-				if (nft_rbtree_interval_end(rbe) &&
-				    !nft_rbtree_interval_end(new))
-					p = &parent->rb_left;
-				else if (!nft_rbtree_interval_end(rbe) &&
-					 nft_rbtree_interval_end(new))
-					p = &parent->rb_right;
-				else {
-					*ext = &rbe->ext;
-					return -EEXIST;
-				}
+			if (nft_rbtree_interval_end(rbe) &&
+			    !nft_rbtree_interval_end(new)) {
+				p = &parent->rb_left;
+			} else if (!nft_rbtree_interval_end(rbe) &&
+				   nft_rbtree_interval_end(new)) {
+				p = &parent->rb_right;
+			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
+				*ext = &rbe->ext;
+				return -EEXIST;
+			} else {
+				p = &parent->rb_left;
 			}
 		}
 	}
-- 
2.1.4

