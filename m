From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/5] netfilter: nf_nat: fix locking in nf_nat_seq_adjust()
Date: Sun, 28 Jul 2013 22:54:09 +0200
Message-ID: <1375044851-12471-4-git-send-email-kaber@trash.net>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45250 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3G1VCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:02:43 -0400
In-Reply-To: <1375044851-12471-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_nat_seq_adjust() needs to grab nf_nat_setofs_lock to protect against
concurrent changes to the sequence adjustment data.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_nat_helper.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 85e20a9..a7262ed 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -373,6 +373,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	s16 seqoff, ackoff;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way, *other_way;
+	int res;
 
 	dir = CTINFO2DIR(ctinfo);
 
@@ -383,6 +384,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
+	spin_lock_bh(&nf_nat_seqofs_lock);
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
 		seqoff = this_way->offset_after;
 	else
@@ -407,7 +409,10 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	tcph->seq = newseq;
 	tcph->ack_seq = newack;
 
-	return nf_nat_sack_adjust(skb, protoff, tcph, ct, ctinfo);
+	res = nf_nat_sack_adjust(skb, protoff, tcph, ct, ctinfo);
+	spin_unlock_bh(&nf_nat_seqofs_lock);
+
+	return res;
 }
 
 /* Setup NAT on this expected conntrack so it follows master. */
-- 
1.8.1.4

