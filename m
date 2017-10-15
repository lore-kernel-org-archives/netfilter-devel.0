From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: xt_connlimit: don't store address in the conn nodes
Date: Sun, 15 Oct 2017 11:00:34 +0200
Message-ID: <20171015090034.6314-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59750 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750829AbdJOJAU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Oct 2017 05:00:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only stored, never read.  This is a leftover from commit 7d08487777c8
("netfilter: connlimit: use rbtree for per-host conntrack obj storage"),
which added the rbtree node struct that stores the address instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_connlimit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index ffa8eec980e9..ce2870428631 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -46,7 +46,6 @@
 struct xt_connlimit_conn {
 	struct hlist_node		node;
 	struct nf_conntrack_tuple	tuple;
-	union nf_inet_addr		addr;
 };
 
 struct xt_connlimit_rb {
@@ -125,7 +124,6 @@ static bool add_hlist(struct hlist_head *head,
 	if (conn == NULL)
 		return false;
 	conn->tuple = *tuple;
-	conn->addr = *addr;
 	hlist_add_head(&conn->node, head);
 	return true;
 }
@@ -270,7 +268,6 @@ count_tree(struct net *net, struct rb_root *root,
 	}
 
 	conn->tuple = *tuple;
-	conn->addr = *addr;
 	rbconn->addr = *addr;
 
 	INIT_HLIST_HEAD(&rbconn->hhead);
-- 
2.13.6

