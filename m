From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5,nf-next] netfilter: nfnetlink: pass down netns pointer to commit() and abort() callbacks
Date: Tue, 15 Dec 2015 19:41:57 +0100
Message-ID: <1450204917-5418-2-git-send-email-pablo@netfilter.org>
References: <1450204917-5418-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbbLOSsu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 13:48:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E51B11324E5
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:48:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D3F95DA870
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:48:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0FC90DA814
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 19:48:47 +0100 (CET)
In-Reply-To: <1450204917-5418-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adapt callsites to avoid recurrent lookup of the netns pointer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h | 4 ++--
 net/netfilter/nf_tables_api.c       | 6 ++----
 net/netfilter/nfnetlink.c           | 6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index ceacbf5..ba0d978 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -26,8 +26,8 @@ struct nfnetlink_subsystem {
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
 	__u8 cb_count;			/* number of callbacks */
 	const struct nfnl_callback *cb;	/* callback for individual types */
-	int (*commit)(struct sk_buff *skb);
-	int (*abort)(struct sk_buff *skb);
+	int (*commit)(struct net *net, struct sk_buff *skb);
+	int (*abort)(struct net *net, struct sk_buff *skb);
 };
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e2369b4..6337946 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3865,9 +3865,8 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int nf_tables_commit(struct sk_buff *skb)
+static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
-	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 
@@ -4002,9 +4001,8 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int nf_tables_abort(struct sk_buff *skb)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 {
-	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c6dde34..15114fd 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -423,15 +423,15 @@ next:
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(oskb);
+		ss->abort(net, oskb);
 		nfnl_err_reset(&err_list);
 		nfnl_unlock(subsys_id);
 		kfree_skb(skb);
 		goto replay;
 	} else if (status == NFNL_BATCH_DONE) {
-		ss->commit(oskb);
+		ss->commit(net, oskb);
 	} else {
-		ss->abort(oskb);
+		ss->abort(net, oskb);
 	}
 
 	nfnl_err_deliver(&err_list, oskb);
-- 
2.1.4

