From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/6]: Convert sctp conntrack protocol to
	skb_header_pointer
Date: Sun, 26 Sep 2004 23:52:16 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A10.1050700@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030609010902000907060408"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030609010902000907060408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch converts the sctp conntrack protocol to skb_header_pointer.



--------------030609010902000907060408
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:17:39+02:00 kaber@coreworks.de 
#   [NETFILTER]: Convert sctp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2004/09/26 23:17:15+02:00 kaber@coreworks.de +67 -61
#   [NETFILTER]: Convert sctp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-26 23:23:02 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-26 23:23:02 +02:00
@@ -152,18 +152,18 @@
 			     unsigned int dataoff,
 			     struct ip_conntrack_tuple *tuple)
 {
-	sctp_sctphdr_t hdr;
+	sctp_sctphdr_t _hdr, *hp;
 
 	DEBUGP(__FUNCTION__);
 	DEBUGP("\n");
 
 	/* Actually only need first 8 bytes. */
-	if (skb_copy_bits(skb, dataoff, &hdr, 8) != 0)
+	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
+	if (hp == NULL)
 		return 0;
 
-	tuple->src.u.sctp.port = hdr.source;
-	tuple->dst.u.sctp.port = hdr.dest;
-
+	tuple->src.u.sctp.port = hp->source;
+	tuple->dst.u.sctp.port = hp->dest;
 	return 1;
 }
 
@@ -206,10 +206,11 @@
 	return seq_printf(s, "%s ", sctp_conntrack_names[state]);
 }
 
-#define for_each_sctp_chunk(skb, sch, offset, count)	\
-for (offset = skb->nh.iph->ihl * 4 + sizeof (sctp_sctphdr_t), count = 0;	\
-	offset < skb->len && !skb_copy_bits(skb, offset, &sch, sizeof(sch));	\
-	offset += (htons(sch.length) + 3) & ~3, count++)
+#define for_each_sctp_chunk(skb, sch, _sch, offset, count)		\
+for (offset = skb->nh.iph->ihl * 4 + sizeof(sctp_sctphdr_t), count = 0;	\
+	offset < skb->len &&						\
+	(sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch));	\
+	offset += (htons(sch->length) + 3) & ~3, count++)
 
 /* Some validity checks to make sure the chunks are fine */
 static int do_basic_checks(struct ip_conntrack *conntrack,
@@ -217,7 +218,7 @@
 			   char *map)
 {
 	u_int32_t offset, count;
-	sctp_chunkhdr_t sch;
+	sctp_chunkhdr_t _sch, *sch;
 	int flag;
 
 	DEBUGP(__FUNCTION__);
@@ -225,19 +226,19 @@
 
 	flag = 0;
 
-	for_each_sctp_chunk (skb, sch, offset, count) {
-		DEBUGP("Chunk Num: %d  Type: %d\n", count, sch.type);
+	for_each_sctp_chunk (skb, sch, _sch, offset, count) {
+		DEBUGP("Chunk Num: %d  Type: %d\n", count, sch->type);
 
-		if (sch.type == SCTP_CID_INIT 
-			|| sch.type == SCTP_CID_INIT_ACK
-			|| sch.type == SCTP_CID_SHUTDOWN_COMPLETE) {
+		if (sch->type == SCTP_CID_INIT 
+			|| sch->type == SCTP_CID_INIT_ACK
+			|| sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			flag = 1;
 		}
 
 		/* Cookie Ack/Echo chunks not the first OR 
 		   Init / Init Ack / Shutdown compl chunks not the only chunks */
-		if ((sch.type == SCTP_CID_COOKIE_ACK 
-			|| sch.type == SCTP_CID_COOKIE_ECHO
+		if ((sch->type == SCTP_CID_COOKIE_ACK 
+			|| sch->type == SCTP_CID_COOKIE_ECHO
 			|| flag)
 		     && count !=0 ) {
 			DEBUGP("Basic checks failed\n");
@@ -245,7 +246,7 @@
 		}
 
 		if (map) {
-			set_bit (sch.type, (void *)map);
+			set_bit(sch->type, (void *)map);
 		}
 	}
 
@@ -313,15 +314,17 @@
 		       enum ip_conntrack_info ctinfo)
 {
 	enum sctp_conntrack newconntrack, oldsctpstate;
-	sctp_sctphdr_t sctph;
-	sctp_chunkhdr_t sch;
+	struct iphdr *iph = skb->nh.iph;
+	sctp_sctphdr_t _sctph, *sh;
+	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
 	char map[256 / sizeof (char)] = {0};
 
 	DEBUGP(__FUNCTION__);
 	DEBUGP("\n");
 
-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &sctph, sizeof(sctph)) != 0)
+	sh = skb_header_pointer(skb, iph->ihl * 4, sizeof(_sctph), &_sctph);
+	if (sh == NULL)
 		return -1;
 
 	if (do_basic_checks(conntrack, skb, map) != 0)
@@ -333,71 +336,72 @@
 		&& !test_bit(SCTP_CID_COOKIE_ECHO, (void *)map)
 		&& !test_bit(SCTP_CID_ABORT, (void *)map)
 		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
-		&& (sctph.vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
+		&& (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 		DEBUGP("Verification tag check failed\n");
 		return -1;
 	}
 
 	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
-	for_each_sctp_chunk (skb, sch, offset, count) {
+	for_each_sctp_chunk (skb, sch, _sch, offset, count) {
 		WRITE_LOCK(&sctp_lock);
 
 		/* Special cases of Verification tag check (Sec 8.5.1) */
-		if (sch.type == SCTP_CID_INIT) {
+		if (sch->type == SCTP_CID_INIT) {
 			/* Sec 8.5.1 (A) */
-			if (sctph.vtag != 0) {
+			if (sh->vtag != 0) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
-		} else if (sch.type == SCTP_CID_ABORT) {
+		} else if (sch->type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
-			if (!(sctph.vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
-				&& !(sctph.vtag == conntrack->proto.sctp.vtag
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
+				&& !(sh->vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
-		} else if (sch.type == SCTP_CID_SHUTDOWN_COMPLETE) {
+		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
-			if (!(sctph.vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
-				&& !(sctph.vtag == conntrack->proto.sctp.vtag
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])
+				&& !(sh->vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)] 
-					&& (sch.flags & 1))) {
+					&& (sch->flags & 1))) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
-		} else if (sch.type == SCTP_CID_COOKIE_ECHO) {
+		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
-			if (!(sctph.vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
+			if (!(sh->vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
 				return -1;
 			}
 		}
 
 		oldsctpstate = conntrack->proto.sctp.state;
-		newconntrack = new_state(CTINFO2DIR(ctinfo), oldsctpstate, sch.type);
+		newconntrack = new_state(CTINFO2DIR(ctinfo), oldsctpstate, sch->type);
 
 		/* Invalid */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
 			DEBUGP("ip_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
-			       CTINFO2DIR(ctinfo), sch.type, oldsctpstate);
+			       CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
 			WRITE_UNLOCK(&sctp_lock);
 			return -1;
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
-		if (sch.type == SCTP_CID_INIT 
-			|| sch.type == SCTP_CID_INIT_ACK) {
-			sctp_inithdr_t inithdr;
-
-			if (skb_copy_bits(skb, offset + sizeof (sctp_chunkhdr_t),
-				&inithdr, sizeof(inithdr)) != 0) {
+		if (sch->type == SCTP_CID_INIT 
+			|| sch->type == SCTP_CID_INIT_ACK) {
+			sctp_inithdr_t _inithdr, *ih;
+
+			ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
+			                        sizeof(_inithdr), &_inithdr);
+			if (ih == NULL) {
 					WRITE_UNLOCK(&sctp_lock);
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
-					inithdr.init_tag, CTINFO2DIR(ctinfo));
-			conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = inithdr.init_tag;
+					ih->init_tag, CTINFO2DIR(ctinfo));
+			conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = ih->init_tag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
@@ -421,15 +425,17 @@
 		    const struct sk_buff *skb)
 {
 	enum sctp_conntrack newconntrack;
-	sctp_sctphdr_t sctph;
-	sctp_chunkhdr_t sch;
+	struct iphdr *iph = skb->nh.iph;
+	sctp_sctphdr_t _sctph, *sh;
+	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
 	char map[256 / sizeof (char)] = {0};
 
 	DEBUGP(__FUNCTION__);
 	DEBUGP("\n");
 
-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &sctph, sizeof(sctph)) != 0)
+	sh = skb_header_pointer(skb, iph->ihl * 4, sizeof(_sctph), &_sctph);
+	if (sh == NULL)
 		return 0;
 
 	if (do_basic_checks(conntrack, skb, map) != 0)
@@ -443,10 +449,10 @@
 	}
 
 	newconntrack = SCTP_CONNTRACK_MAX;
-	for_each_sctp_chunk (skb, sch, offset, count) {
+	for_each_sctp_chunk (skb, sch, _sch, offset, count) {
 		/* Don't need lock here: this conntrack not in circulation yet */
 		newconntrack = new_state (IP_CT_DIR_ORIGINAL, 
-						SCTP_CONNTRACK_NONE, sch.type);
+						SCTP_CONNTRACK_NONE, sch->type);
 
 		/* Invalid: delete conntrack */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
@@ -455,20 +461,20 @@
 		}
 
 		/* Copy the vtag into the state info */
-		if (sch.type == SCTP_CID_INIT) {
-			if (sctph.vtag == 0) {
-				sctp_inithdr_t inithdr;
-
-				if (skb_copy_bits(skb, offset + sizeof (sctp_chunkhdr_t), 
-					&inithdr, sizeof(inithdr)) != 0) {
-						return 0;
-				}
+		if (sch->type == SCTP_CID_INIT) {
+			if (sh->vtag == 0) {
+				sctp_inithdr_t _inithdr, *ih;
+
+				ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
+				                        sizeof(_inithdr), &_inithdr);
+				if (ih == NULL)
+					return 0;
 
 				DEBUGP("Setting vtag %x for new conn\n", 
-					inithdr.init_tag);
+					ih->init_tag);
 
 				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = 
-								inithdr.init_tag;
+								ih->init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
 				return 0;
@@ -478,8 +484,8 @@
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
 		else {
 			DEBUGP("Setting vtag %x for new conn OOTB\n", 
-				sctph.vtag);
-			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sctph.vtag;
+				sh->vtag);
+			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;

--------------030609010902000907060408--
