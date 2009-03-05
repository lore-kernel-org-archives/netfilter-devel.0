From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: ctnetlink: cleanup master conntrack assignation
Date: Thu, 05 Mar 2009 17:07:14 +0100
Message-ID: <20090305160714.13755.83435.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53170 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbZCEQHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:07:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the assignation of the master conntrack to
ctnetlink_create_conntrack(), which is where it really belongs.
This patch is a cleanup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   49 ++++++++++++++--------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 41226f0..a240a66 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1234,9 +1234,9 @@ static int
 ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple,
-			   struct nf_conn *master_ct,
 			   u32 pid,
-			   int report)
+			   int report,
+			   u8 u3)
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
@@ -1347,7 +1347,22 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 #endif
 
 	/* setup master conntrack: this is a confirmed expectation */
-	if (master_ct) {
+	if (cda[CTA_TUPLE_MASTER]) {
+		struct nf_conntrack_tuple master;
+		struct nf_conntrack_tuple_hash *master_h;
+		struct nf_conn *master_ct;
+
+		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_MASTER, u3);
+		if (err < 0)
+			goto err;
+
+		master_h = __nf_conntrack_find(&init_net, &master);
+		if (master_h == NULL) {
+			err = -ENOENT;
+			goto err;
+		}
+		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+		nf_conntrack_get(&master_ct->ct_general);
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
 	}
@@ -1395,39 +1410,15 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		h = __nf_conntrack_find(&init_net, &rtuple);
 
 	if (h == NULL) {
-		struct nf_conntrack_tuple master;
-		struct nf_conntrack_tuple_hash *master_h = NULL;
-		struct nf_conn *master_ct = NULL;
-
-		if (cda[CTA_TUPLE_MASTER]) {
-			err = ctnetlink_parse_tuple(cda,
-						    &master,
-						    CTA_TUPLE_MASTER,
-						    u3);
-			if (err < 0)
-				goto out_unlock;
-
-			master_h = __nf_conntrack_find(&init_net, &master);
-			if (master_h == NULL) {
-				err = -ENOENT;
-				goto out_unlock;
-			}
-			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
-			nf_conntrack_get(&master_ct->ct_general);
-		}
-
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda,
 							 &otuple,
 							 &rtuple,
-							 master_ct,
 							 NETLINK_CB(skb).pid,
-							 nlmsg_report(nlh));
+							 nlmsg_report(nlh),
+							 u3);
 		spin_unlock_bh(&nf_conntrack_lock);
-		if (err < 0 && master_ct)
-			nf_ct_put(master_ct);
-
 		return err;
 	}
 	/* implicit 'else' */

