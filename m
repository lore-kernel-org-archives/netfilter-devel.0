From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 4/4] netfilter: ctnetlink: acquire ct->lock before operating nf_ct_seqadj
Date: Mon, 17 Apr 2017 21:18:58 +0800
Message-ID: <1492435138-28283-5-git-send-email-zlpnobody@163.com>
References: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:56619 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753354AbdDQNTw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2017 09:19:52 -0400
In-Reply-To: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We should acquire the ct->lock before accessing or modifying the
nf_ct_seqadj, as another CPU may modify the nf_ct_seqadj at the same
time during its packet proccessing.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 86deed6..78f8c9a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -417,8 +417,7 @@ dump_ct_seq_adj(struct sk_buff *skb, const struct nf_ct_seqadj *seq, int type)
 	return -1;
 }
 
-static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb,
-				     const struct nf_conn *ct)
+static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
 {
 	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	struct nf_ct_seqadj *seq;
@@ -426,15 +425,20 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb,
 	if (!(ct->status & IPS_SEQ_ADJUST) || !seqadj)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	seq = &seqadj->seq[IP_CT_DIR_ORIGINAL];
 	if (dump_ct_seq_adj(skb, seq, CTA_SEQ_ADJ_ORIG) == -1)
-		return -1;
+		goto err;
 
 	seq = &seqadj->seq[IP_CT_DIR_REPLY];
 	if (dump_ct_seq_adj(skb, seq, CTA_SEQ_ADJ_REPLY) == -1)
-		return -1;
+		goto err;
 
+	spin_unlock_bh(&ct->lock);
 	return 0;
+err:
+	spin_unlock_bh(&ct->lock);
+	return -1;
 }
 
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
@@ -1637,11 +1641,12 @@ ctnetlink_change_seq_adj(struct nf_conn *ct,
 	if (!seqadj)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	if (cda[CTA_SEQ_ADJ_ORIG]) {
 		ret = change_seq_adj(&seqadj->seq[IP_CT_DIR_ORIGINAL],
 				     cda[CTA_SEQ_ADJ_ORIG]);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 	}
@@ -1650,12 +1655,16 @@ ctnetlink_change_seq_adj(struct nf_conn *ct,
 		ret = change_seq_adj(&seqadj->seq[IP_CT_DIR_REPLY],
 				     cda[CTA_SEQ_ADJ_REPLY]);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 	}
 
+	spin_unlock_bh(&ct->lock);
 	return 0;
+err:
+	spin_unlock_bh(&ct->lock);
+	return ret;
 }
 
 static int
-- 
2.5.5


