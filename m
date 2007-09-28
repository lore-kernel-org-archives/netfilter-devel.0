From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/19]: nf_conntrack_netlink: add support to related connections
Date: Fri, 28 Sep 2007 18:30:54 +0200 (MEST)
Message-ID: <20070928163054.8394.52508.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015AbXI1Qaz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:55 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_netlink: add support to related connections

This patch adds support to relate a connection to an existing master
connection. This patch is used by conntrackd to correctly replicate
related connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b7ee1904c7e1e916c8a5f3cae94ef302ed59daf2
tree 757969dd0db39b7af43e88000cce06b72fb9daf4
parent e4c32368714870c516b5ec7abbb22c1fe8a80feb
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 28 Sep 2007 18:09:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:17 +0200

 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_netlink.c          |   43 +++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index d7c3503..4affa3f 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -36,6 +36,7 @@ enum ctattr_type {
 	CTA_USE,
 	CTA_ID,
 	CTA_NAT_DST,
+	CTA_TUPLE_MASTER,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2abd648..442bfaa 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -975,7 +975,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 static int
 ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
-			   struct nf_conntrack_tuple *rtuple)
+			   struct nf_conntrack_tuple *rtuple,
+			   struct nf_conn *master_ct)
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
@@ -1022,6 +1023,10 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		rcu_assign_pointer(help->helper, helper);
 	}
 
+	/* setup master conntrack: this is a confirmed expectation */
+	if (master_ct)
+		ct->master = master_ct;
+
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 
@@ -1064,10 +1069,37 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		h = __nf_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
+		struct nf_conntrack_tuple master;
+		struct nf_conntrack_tuple_hash *master_h = NULL;
+		struct nf_conn *master_ct = NULL;
+
+		if (cda[CTA_TUPLE_MASTER]) {
+			err = ctnetlink_parse_tuple(cda,
+						    &master,
+						    CTA_TUPLE_MASTER,
+						    u3);
+			if (err < 0)
+				return err;
+
+			master_h = __nf_conntrack_find(&master, NULL);
+			if (master_h == NULL) {
+        			err = -ENOENT;
+				goto out_unlock;
+			}
+			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+			atomic_inc(&master_ct->ct_general.use);
+		}
+
 		write_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+			err = ctnetlink_create_conntrack(cda,
+							 &otuple,
+							 &rtuple,
+							 master_ct);
+		if (err < 0 && master_ct)
+			nf_ct_put(master_ct);
+
 		return err;
 	}
 	/* implicit 'else' */
@@ -1081,6 +1113,11 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = -EINVAL;
 			goto out_unlock;
 		}
+		/* can't link an existing conntrack to a master */
+		if (cda[CTA_TUPLE_MASTER]) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
 		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
 						 cda);
 	}
