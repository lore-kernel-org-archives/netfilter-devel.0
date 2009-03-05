From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: ctnetlink: move event reporting for new
	entries outside the lock
Date: Thu, 05 Mar 2009 17:07:59 +0100
Message-ID: <20090305160759.13755.64802.stgit@Decadence>
References: <20090305160714.13755.83435.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53244 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752366AbZCEQIF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:08:05 -0500
In-Reply-To: <20090305160714.13755.83435.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the event reporting outside the lock section. With
this patch, the creation and update of entries is homogeneous from
the event reporting perspective. Moreover, as the event reporting is
done outside the lock section, the netlink broadcast delivery can
benefit of the yield() call under congestion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   41 +++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d229370..fa5b23f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1234,12 +1234,10 @@ ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 				  report);
 }
 
-static int
+static struct nf_conn *
 ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple,
-			   u32 pid,
-			   int report,
 			   u8 u3)
 {
 	struct nf_conn *ct;
@@ -1248,7 +1246,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (!cda[CTA_TIMEOUT])
 		goto err;
@@ -1371,18 +1369,14 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		ct->master = master_ct;
 	}
 
-	nf_conntrack_get(&ct->ct_general);
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 	rcu_read_unlock();
-	ctnetlink_event_report(ct, pid, report);
-	nf_ct_put(ct);
-
-	return 0;
 
+	return ct;
 err:
 	nf_conntrack_free(ct);
-	return err;
+	return ERR_PTR(err);
 }
 
 static int
@@ -1415,14 +1409,25 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	if (h == NULL) {
 		err = -ENOENT;
-		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_conntrack(cda,
-							 &otuple,
-							 &rtuple,
-							 NETLINK_CB(skb).pid,
-							 nlmsg_report(nlh),
-							 u3);
-		spin_unlock_bh(&nf_conntrack_lock);
+		if (nlh->nlmsg_flags & NLM_F_CREATE) {
+			struct nf_conn *ct;
+
+			ct = ctnetlink_create_conntrack(cda, &otuple,
+							&rtuple, u3);
+			if (IS_ERR(ct)) {
+				err = PTR_ERR(ct);
+				goto out_unlock;
+			}
+			err = 0;
+			nf_conntrack_get(&ct->ct_general);
+			spin_unlock_bh(&nf_conntrack_lock);
+			ctnetlink_event_report(ct,
+					       NETLINK_CB(skb).pid,
+					       nlmsg_report(nlh));
+			nf_ct_put(ct);
+		} else
+			spin_unlock_bh(&nf_conntrack_lock);
+
 		return err;
 	}
 	/* implicit 'else' */

