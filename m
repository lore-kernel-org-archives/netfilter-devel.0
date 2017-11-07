From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/23] netfilter: xt_connlimit: don't store address in the conn nodes
Date: Tue,  7 Nov 2017 01:52:02 +0100
Message-ID: <20171107005213.22618-13-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964879AbdKGAxM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:53:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3627A1F4B65
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24545DA80B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:11 +0100 (CET)
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Only stored, never read.  This is a leftover from commit 7d08487777c8
("netfilter: connlimit: use rbtree for per-host conntrack obj storage"),
which added the rbtree node struct that stores the address instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

