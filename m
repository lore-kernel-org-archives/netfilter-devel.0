From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/5] netfilter: nf_nat: use per-conntrack locking for sequence number adjustments
Date: Sun, 28 Jul 2013 22:54:11 +0200
Message-ID: <1375044851-12471-6-git-send-email-kaber@trash.net>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3G1VCo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:02:44 -0400
In-Reply-To: <1375044851-12471-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of the global lock and use per-conntrack locks for protecting the
sequencen number adjustment data. Additionally saves one lock/unlock
operation for every TCP packet.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_nat_helper.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index ff4a589..46b9baa 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -30,8 +30,6 @@
 	pr_debug("offset_before=%d, offset_after=%d, correction_pos=%u\n", \
 		 x->offset_before, x->offset_after, x->correction_pos);
 
-static DEFINE_SPINLOCK(nf_nat_seqofs_lock);
-
 /* Setup TCP sequence correction given this change at this sequence */
 static inline void
 adjust_tcp_sequence(u32 seq,
@@ -49,7 +47,7 @@ adjust_tcp_sequence(u32 seq,
 	pr_debug("adjust_tcp_sequence: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
 
-	spin_lock_bh(&nf_nat_seqofs_lock);
+	spin_lock_bh(&ct->lock);
 
 	/* SYN adjust. If it's uninitialized, or this is after last
 	 * correction, record it: we don't handle more than one
@@ -61,31 +59,26 @@ adjust_tcp_sequence(u32 seq,
 		this_way->offset_before = this_way->offset_after;
 		this_way->offset_after += sizediff;
 	}
-	spin_unlock_bh(&nf_nat_seqofs_lock);
+	spin_unlock_bh(&ct->lock);
 
 	pr_debug("adjust_tcp_sequence: Seq_offset after: ");
 	DUMP_OFFSET(this_way);
 }
 
-/* Get the offset value, for conntrack */
+/* Get the offset value, for conntrack. Caller must have the conntrack locked */
 s32 nf_nat_get_offset(const struct nf_conn *ct,
 		      enum ip_conntrack_dir dir,
 		      u32 seq)
 {
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way;
-	s32 offset;
 
 	if (!nat)
 		return 0;
 
 	this_way = &nat->seq[dir];
-	spin_lock_bh(&nf_nat_seqofs_lock);
-	offset = after(seq, this_way->correction_pos)
+	return after(seq, this_way->correction_pos)
 		 ? this_way->offset_after : this_way->offset_before;
-	spin_unlock_bh(&nf_nat_seqofs_lock);
-
-	return offset;
 }
 
 /* Frobs data inside this packet, which is linear. */
@@ -384,7 +377,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
-	spin_lock_bh(&nf_nat_seqofs_lock);
+	spin_lock_bh(&ct->lock);
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
 		seqoff = this_way->offset_after;
 	else
@@ -410,7 +403,7 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 	tcph->ack_seq = newack;
 
 	res = nf_nat_sack_adjust(skb, protoff, tcph, ct, ctinfo);
-	spin_unlock_bh(&nf_nat_seqofs_lock);
+	spin_unlock_bh(&ct->lock);
 
 	return res;
 }
-- 
1.8.1.4

