From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Fix NAT TCP sequence adjustment
Date: Sat, 2 Apr 2005 12:24:38 -0800
Message-ID: <20050402202438.GA2968@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In adjust_tcp_sequence, we track the sequence number of any adjustments
in the correction_pos variable.  The seq stored is based upon the left
side of the window of the NAT box -- not of the original sender.

Later, in ip_nat_seq_adjust, we compare the correction_pos variable to
the seq of the original sender to determine whether this is a new packet
or a retransmission (i.e. should we apply offset_before or offset_after).
So we are comparing the post-adjustment seq to a pre-adjustment seq.

This works ok under normal circumstances, like a single FTP transfer, since
the before/after comparison luckily works out.  But in situations like
an FTP 'mget', it can fail depending on how many files are transferred.

For example, assume the strlen of the PORT command from the client is 26, and
it gets adjusted to 27 by the NAT box (sizediff=1).  Under this scenario,
the mget will fail to transfer file #26 since at that point the before/after
comparison in ip_nat_seq_adjust flips the other way, and the adjustment
becomes offset_before instead of the appropriate offset_after.  Obviously
for larger sizediffs, the failure comes earlier.

The solution is to store the client's seq number in correction_pos instead
of the seq of the NAT box.  The below makes this change, as well as cleans up a
number of broken DEBUGP statements and a couple of u32->u16 casts.  

As noted, without this patch an mget fails at (sizediff * strlen(PORT...).
With this patch, I have successfully transferred 500 files under both
scenarios: sizediff > 0 and < 0.

This closes bugzilla #308.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ftp2

diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_ftp.c linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-03-02 02:38:38.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-01 21:11:12.389774176 -0500
@@ -252,7 +252,7 @@
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u16 seq, const struct ip_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -263,7 +263,7 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -330,9 +330,10 @@
 	/* Look up to see if we're just after a \n. */
 	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
 		/* Now if this ends in \n, update ftp info. */
-		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
-		       ct_ftp_info->seq_aft_nl[0][dir] 
-		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
+		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s%u vs %u\n",
+		       ct_ftp_info->seq_aft_nl[0][dir] ? "":"(UNSET)",
+		       ct_ftp_info->seq_aft_nl[0][dir],
+		       ntohl(th->seq));
 		ret = NF_ACCEPT;
 		goto out_update_nl;
 	}
@@ -373,7 +374,7 @@
 		goto out_update_nl;
 	}
 
-	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
+	DEBUGP("conntrack_ftp: match `%.26s' (%u bytes at %u)\n",
 	       fb_ptr + matchoff, matchlen, ntohl(th->seq) + matchoff);
 			 
 	/* Allocate expectation which will be inserted */
@@ -440,7 +441,7 @@
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info, dir);
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
diff -ru linux-orig/net/ipv4/netfilter/ip_nat_helper.c linux-new/net/ipv4/netfilter/ip_nat_helper.c
--- linux-orig/net/ipv4/netfilter/ip_nat_helper.c	2005-03-02 02:37:49.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ip_nat_helper.c	2005-04-02 12:45:42.787580776 -0500
@@ -57,17 +57,16 @@
 		    enum ip_conntrack_info ctinfo)
 {
 	int dir;
-	struct ip_nat_seq *this_way, *other_way;
+	struct ip_nat_seq *this_way;
+	u32 adjustedseq;
 
-	DEBUGP("ip_nat_resize_packet: old_size = %u, new_size = %u\n",
-		(*skb)->len, new_size);
+	DEBUGP("adjust_tcp_sequence: sizediff = %i\n", sizediff);
 
 	dir = CTINFO2DIR(ctinfo);
 
 	this_way = &ct->nat.info.seq[dir];
-	other_way = &ct->nat.info.seq[!dir];
 
-	DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
+	DEBUGP("adjust_tcp_sequence: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
 
 	LOCK_BH(&ip_nat_seqofs_lock);
@@ -76,15 +75,16 @@
 	 * correction, record it: we don't handle more than one
 	 * adjustment in the window, but do deal with common case of a
 	 * retransmit */
+	adjustedseq = seq - this_way->offset_after;
 	if (this_way->offset_before == this_way->offset_after
-	    || before(this_way->correction_pos, seq)) {
-		    this_way->correction_pos = seq;
+	    || before(this_way->correction_pos, adjustedseq)) {
+		    this_way->correction_pos = adjustedseq;
 		    this_way->offset_before = this_way->offset_after;
 		    this_way->offset_after += sizediff;
 	}
 	UNLOCK_BH(&ip_nat_seqofs_lock);
 
-	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
+	DEBUGP("adjust_tcp_sequence: Seq_offset after: ");
 	DUMP_OFFSET(this_way);
 }
 
@@ -116,7 +116,7 @@
 		       skb->len);
 		skb_put(skb, rep_len - match_len);
 	} else {
-		DEBUGP("ip_nat_mangle_packet: Shrinking packet from "
+		DEBUGP("ip_nat_mangle_packet: Shrinking packet by "
 			"%u from %u bytes\n", match_len - rep_len,
 		       skb->len);
 		__skb_trim(skb, skb->len + rep_len - match_len);
@@ -291,7 +291,7 @@
 				      - natseq->offset_before;
 		new_end_seq = htonl(new_end_seq);
 
-		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
+		DEBUGP("sack_adjust: start_seq: %u->%u, end_seq: %u->%u\n",
 			ntohl(sack->start_seq), new_start_seq,
 			ntohl(sack->end_seq), new_end_seq);
 

--G4iJoqBmSsgzjUCe--
