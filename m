From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/6]: Convert sctp match to skb_header_pointer
Date: Sun, 26 Sep 2004 23:52:12 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A0C.4060309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090108000309020508070006"
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
--------------090108000309020508070006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch converts the sctp match to skb_header_pointer.



--------------090108000309020508070006
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:16:04+02:00 kaber@coreworks.de 
#   [NETFILTER]: Convert sctp match to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_sctp.c
#   2004/09/26 23:15:40+02:00 kaber@coreworks.de +18 -16
#   [NETFILTER]: Convert sctp match to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_sctp.c b/net/ipv4/netfilter/ipt_sctp.c
--- a/net/ipv4/netfilter/ipt_sctp.c	2004-09-26 23:22:45 +02:00
+++ b/net/ipv4/netfilter/ipt_sctp.c	2004-09-26 23:22:45 +02:00
@@ -42,7 +42,7 @@
 {
 	int offset;
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
-	sctp_chunkhdr_t sch;
+	sctp_chunkhdr_t _sch, *sch;
 
 #ifdef DEBUG_SCTP
 	int i = 0;
@@ -54,38 +54,39 @@
 
 	offset = skb->nh.iph->ihl * 4 + sizeof (sctp_sctphdr_t);
 	do {
-		if (skb_copy_bits(skb, offset, &sch, sizeof(sch)) < 0) {
+		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
+		if (sch == NULL) {
 			duprintf("Dropping invalid SCTP packet.\n");
 			*hotdrop = 1;
 			return 0;
         	}
 
 		duprintf("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d\tflags: %x\n", 
-				++i, offset, sch.type, htons(sch.length), sch.flags);
+				++i, offset, sch->type, htons(sch->length), sch->flags);
 
-		offset += (htons(sch.length) + 3) & ~3;
+		offset += (htons(sch->length) + 3) & ~3;
 
 		duprintf("skb->len: %d\toffset: %d\n", skb->len, offset);
 
-		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch.type)) {
+		if (SCTP_CHUNKMAP_IS_SET(chunkmap, sch->type)) {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ANY:
 				if (match_flags(flag_info, flag_count, 
-					sch.type, sch.flags)) {
+					sch->type, sch->flags)) {
 					return 1;
 				}
 				break;
 
 			case SCTP_CHUNK_MATCH_ALL:
 				if (match_flags(flag_info, flag_count, 
-					sch.type, sch.flags)) {
-					SCTP_CHUNKMAP_CLEAR(chunkmapcopy, sch.type);
+					sch->type, sch->flags)) {
+					SCTP_CHUNKMAP_CLEAR(chunkmapcopy, sch->type);
 				}
 				break;
 
 			case SCTP_CHUNK_MATCH_ONLY:
 				if (!match_flags(flag_info, flag_count, 
-					sch.type, sch.flags)) {
+					sch->type, sch->flags)) {
 					return 0;
 				}
 				break;
@@ -120,7 +121,7 @@
       int *hotdrop)
 {
 	const struct ipt_sctp_info *info;
-	sctp_sctphdr_t sh;
+	sctp_sctphdr_t _sh, *sh;
 
 	info = (const struct ipt_sctp_info *)matchinfo;
 
@@ -129,18 +130,19 @@
 		return 0;
 	}
 	
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &sh, sizeof(sh)) < 0) {
+	sh = skb_header_pointer(skb, skb->nh.iph->ihl*4, sizeof(_sh), &_sh);
+	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
 		*hotdrop = 1;
 		return 0;
        	}
-	duprintf("spt: %d\tdpt: %d\n", ntohs(sh.source), ntohs(sh.dest));
+	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
-	return  SCCHECK(((ntohs(sh.source) >= info->spts[0]) 
-			&& (ntohs(sh.source) <= info->spts[1])), 
+	return  SCCHECK(((ntohs(sh->source) >= info->spts[0]) 
+			&& (ntohs(sh->source) <= info->spts[1])), 
 		   	IPT_SCTP_SRC_PORTS, info->flags, info->invflags)
-		&& SCCHECK(((ntohs(sh.dest) >= info->dpts[0]) 
-			&& (ntohs(sh.dest) <= info->dpts[1])), 
+		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0]) 
+			&& (ntohs(sh->dest) <= info->dpts[1])), 
 			IPT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, info->chunkmap, info->chunk_match_type,
  					info->flag_info, info->flag_count, 

--------------090108000309020508070006--
