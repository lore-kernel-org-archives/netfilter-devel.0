From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 18/18] Netfilter:  More ECN Fixes: make writable before
	writing
Date: Wed, 05 Jan 2005 14:37:22 +1100
Message-ID: <1104896242.20582.86.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: More ECN Fixes: make writable before writing
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Patrick McHardy spotted this, on top of previous fix.  I neatened it.

===== net/ipv4/netfilter/ipt_ECN.c 1.11 vs edited =====
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ipt_ECN.c	2005-01-05 13:02:29.737091224 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_ECN.c	2005-01-05 13:49:02.093588512 +1100
@@ -52,44 +52,41 @@
 static inline int
 set_ect_tcp(struct sk_buff **pskb, const struct ipt_ECN_info *einfo, int inward)
 {
-	struct tcphdr _tcph, *th;
+	struct tcphdr _tcph, *tcph;
 	u_int16_t diffs[2];
 
 	/* Not enought header? */
-	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
-				sizeof(_tcph), &_tcph);
-	if (th == NULL)
+	tcph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (!tcph)
 		return 0;
 
-	diffs[0] = ((u_int16_t *)th)[6];
-	if (einfo->operation & IPT_ECN_OP_SET_ECE)
-		th->ece = einfo->proto.tcp.ece;
+	if (!(einfo->operation & IPT_ECN_OP_SET_ECE
+	      || tcph->ece == einfo->proto.tcp.ece)
+	    && (!(einfo->operation & IPT_ECN_OP_SET_CWR
+		  || tcph->cwr == einfo->proto.tcp.cwr)))
+		return 1;
 
-	if (einfo->operation & IPT_ECN_OP_SET_CWR)
-		th->cwr = einfo->proto.tcp.cwr;
-	diffs[1] = ((u_int16_t *)th)[6];
+	if (!skb_ip_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
+		return 0;
+	tcph = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
 
-	/* Only mangle if it's changed. */
-	if (diffs[0] != diffs[1]) {
-		diffs[0] = diffs[0] ^ 0xFFFF;
-		if (!skb_ip_make_writable(pskb,
-					  (*pskb)->nh.iph->ihl*4+sizeof(_tcph)))
+	diffs[0] = ((u_int16_t *)tcph)[6];
+	if (einfo->operation & IPT_ECN_OP_SET_ECE)
+		tcph->ece = einfo->proto.tcp.ece;
+	if (einfo->operation & IPT_ECN_OP_SET_CWR)
+		tcph->cwr = einfo->proto.tcp.cwr;
+	diffs[1] = ((u_int16_t *)tcph)[6];
+	diffs[0] = diffs[0] ^ 0xFFFF;
+
+	if ((*pskb)->ip_summed != CHECKSUM_HW)
+		tcph->check = csum_fold(csum_partial((char *)diffs,
+						     sizeof(diffs),
+						     tcph->check^0xFFFF));
+	else
+		if (skb_checksum_help(*pskb, inward))
 			return 0;
-
-		if (th != &_tcph)
-			memcpy(&_tcph, th, sizeof(_tcph));
-
-		if ((*pskb)->ip_summed != CHECKSUM_HW)
-			_tcph.check = csum_fold(csum_partial((char *)diffs,
-							     sizeof(diffs),
-							     _tcph.check^0xFFFF));
-		memcpy((*pskb)->data + (*pskb)->nh.iph->ihl*4,
-		       &_tcph, sizeof(_tcph));
-		if ((*pskb)->ip_summed == CHECKSUM_HW)
-			if (skb_checksum_help(*pskb, inward))
-				return 0;
-		(*pskb)->nfcache |= NFC_ALTERED;
-	}
+	(*pskb)->nfcache |= NFC_ALTERED;
 	return 1;
 }
 
