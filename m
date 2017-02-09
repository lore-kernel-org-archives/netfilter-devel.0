From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/5] netfilter: nfnetlink: add nfnetlink_rcv_skb_batch()
Date: Thu,  9 Feb 2017 17:13:47 +0100
Message-ID: <1486656830-3245-3-git-send-email-pablo@netfilter.org>
References: <1486656830-3245-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752628AbdBIQOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 11:14:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CB7711A126
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37A67DA818
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54D1BBAAA2
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:14:02 +0100 (CET)
In-Reply-To: <1486656830-3245-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new nfnetlink_rcv_skb_batch() to wrap initial nfnetlink batch
handling.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 51 ++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 586212ebba9e..ca645a3b1375 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -436,12 +436,35 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	kfree_skb(skb);
 }
 
-static void nfnetlink_rcv(struct sk_buff *skb)
+static void nfnetlink_rcv_skb_batch(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
-	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	struct nfgenmsg *nfgenmsg;
 	u16 res_id;
 	int msglen;
 
+	msglen = NLMSG_ALIGN(nlh->nlmsg_len);
+	if (msglen > skb->len)
+		msglen = skb->len;
+
+	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
+	    skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
+		return;
+
+	nfgenmsg = nlmsg_data(nlh);
+	skb_pull(skb, msglen);
+	/* Work around old nft using host byte order */
+	if (nfgenmsg->res_id == NFNL_SUBSYS_NFTABLES)
+		res_id = NFNL_SUBSYS_NFTABLES;
+	else
+		res_id = ntohs(nfgenmsg->res_id);
+
+	nfnetlink_rcv_batch(skb, nlh, res_id);
+}
+
+static void nfnetlink_rcv(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+
 	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
 	    skb->len < nlh->nlmsg_len)
 		return;
@@ -451,28 +474,10 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 		return;
 	}
 
-	if (nlh->nlmsg_type == NFNL_MSG_BATCH_BEGIN) {
-		struct nfgenmsg *nfgenmsg;
-
-		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
-		if (msglen > skb->len)
-			msglen = skb->len;
-
-		if (nlh->nlmsg_len < NLMSG_HDRLEN ||
-		    skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
-			return;
-
-		nfgenmsg = nlmsg_data(nlh);
-		skb_pull(skb, msglen);
-		/* Work around old nft using host byte order */
-		if (nfgenmsg->res_id == NFNL_SUBSYS_NFTABLES)
-			res_id = NFNL_SUBSYS_NFTABLES;
-		else
-			res_id = ntohs(nfgenmsg->res_id);
-		nfnetlink_rcv_batch(skb, nlh, res_id);
-	} else {
+	if (nlh->nlmsg_type == NFNL_MSG_BATCH_BEGIN)
+		nfnetlink_rcv_skb_batch(skb, nlh);
+	else
 		netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
-	}
 }
 
 #ifdef CONFIG_MODULES
-- 
2.1.4

