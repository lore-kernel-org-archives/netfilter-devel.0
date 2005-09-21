From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ip_conntrack_pptp: fix endian sparse warnings
Date: Wed, 21 Sep 2005 21:05:39 +0400
Message-ID: <20050921170539.GA10537@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Al Viro <viro@zeniv.linux.org.uk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

net/ipv4/netfilter/ip_conntrack_helper_pptp.c:

   485		===>	cid = &info->pac_call_id;	<===
   486	
   487			if (info->pns_call_id != ntohs(*pcid)) {
   488				DEBUGP("%s for unknown CallID %u\n", 
   489					pptp_msg_name[msg], ntohs(*cid));
							    ^^^^^^^^^^^
However, comment at struct ip_ct_pptp_master::pac_call_id says "call id
of PAC, host byte order". Is this a bug?

 include/linux/netfilter_ipv4/ip_conntrack_pptp.h  |   20 ++++++++++----------
 include/linux/netfilter_ipv4/ip_conntrack_tuple.h |    6 +++---
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c     |   14 ++++++++------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff -uprN linux-vanilla/include/linux/netfilter_ipv4/ip_conntrack_pptp.h linux-pptp/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
--- linux-vanilla/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	2005-09-21 20:26:26.000000000 +0400
+++ linux-pptp/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	2005-09-21 20:46:31.000000000 +0400
@@ -60,8 +60,8 @@ struct ip_ct_pptp_expect {
 
 struct pptp_pkt_hdr {
 	__u16	packetLength;
-	__u16	packetType;
-	__u32	magicCookie;
+	__be16	packetType;
+	__be32	magicCookie;
 };
 
 /* PptpControlMessageType values */
@@ -93,7 +93,7 @@ struct pptp_pkt_hdr {
 #define PPTP_REMOVE_DEVICE_ERROR	6
 
 struct PptpControlHeader {
-	__u16	messageType;
+	__be16	messageType;
 	__u16	reserved;
 };
 
@@ -180,7 +180,7 @@ struct PptpEchoReply {
 #define PPTP_DONT_CARE_BEARER_TYPE	3
 
 struct PptpOutCallRequest {
-	__u16	callID;
+	__be16	callID;
 	__u16	callSerialNumber;
 	__u32	minBPS;
 	__u32	maxBPS;
@@ -205,8 +205,8 @@ struct PptpOutCallRequest {
 #define PPTP_OUTCALL_DONT_ACCEPT	7
 
 struct PptpOutCallReply {
-	__u16	callID;
-	__u16	peersCallID;
+	__be16	callID;
+	__be16	peersCallID;
 	__u8	resultCode;
 	__u8	generalErrorCode;
 	__u16	causeCode;
@@ -234,8 +234,8 @@ struct PptpInCallRequest {
 #define PPTP_INCALL_DONT_ACCEPT		3
 
 struct PptpInCallReply {
-	__u16	callID;
-	__u16	peersCallID;
+	__be16	callID;
+	__be16	peersCallID;
 	__u8	resultCode;
 	__u8	generalErrorCode;
 	__u16	packetWindow;
@@ -244,7 +244,7 @@ struct PptpInCallReply {
 };
 
 struct PptpInCallConnected {
-	__u16	peersCallID;
+	__be16	peersCallID;
 	__u16	reserved;
 	__u32	connectSpeed;
 	__u16	packetWindow;
@@ -258,7 +258,7 @@ struct PptpClearCallRequest {
 };
 
 struct PptpCallDisconnectNotify {
-	__u16	callID;
+	__be16	callID;
 	__u8	resultCode;
 	__u8	generalErrorCode;
 	__u16	causeCode;
diff -uprN linux-vanilla/include/linux/netfilter_ipv4/ip_conntrack_tuple.h linux-pptp/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
--- linux-vanilla/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-09-21 20:26:26.000000000 +0400
+++ linux-pptp/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-09-21 20:39:44.000000000 +0400
@@ -17,7 +17,7 @@ union ip_conntrack_manip_proto
 	u_int16_t all;
 
 	struct {
-		u_int16_t port;
+		__be16 port;
 	} tcp;
 	struct {
 		u_int16_t port;
@@ -29,7 +29,7 @@ union ip_conntrack_manip_proto
 		u_int16_t port;
 	} sctp;
 	struct {
-		u_int16_t key;	/* key is 32bit, pptp only uses 16 */
+		__be16 key;	/* key is 32bit, pptp only uses 16 */
 	} gre;
 };
 
@@ -65,7 +65,7 @@ struct ip_conntrack_tuple
 				u_int16_t port;
 			} sctp;
 			struct {
-				u_int16_t key;	/* key is 32bit, 
+				__be16 key;	/* key is 32bit, 
 						 * pptp only uses 16 */
 			} gre;
 		} u;
diff -uprN linux-vanilla/net/ipv4/netfilter/ip_conntrack_helper_pptp.c linux-pptp/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- linux-vanilla/net/ipv4/netfilter/ip_conntrack_helper_pptp.c	2005-09-21 20:26:26.000000000 +0400
+++ linux-pptp/net/ipv4/netfilter/ip_conntrack_helper_pptp.c	2005-09-21 20:47:35.000000000 +0400
@@ -223,8 +223,8 @@ static void pptp_destroy_siblings(struct
 static inline int
 exp_gre(struct ip_conntrack *master,
 	u_int32_t seq,
-	u_int16_t callid,
-	u_int16_t peer_callid)
+	__be16 callid,
+	__be16 peer_callid)
 {
 	struct ip_conntrack_tuple inv_tuple;
 	struct ip_conntrack_tuple exp_tuples[] = {
@@ -263,7 +263,7 @@ exp_gre(struct ip_conntrack *master,
 	exp_orig->mask.src.ip = 0xffffffff;
 	exp_orig->mask.src.u.all = 0;
 	exp_orig->mask.dst.u.all = 0;
-	exp_orig->mask.dst.u.gre.key = 0xffff;
+	exp_orig->mask.dst.u.gre.key = htons(0xffff);
 	exp_orig->mask.dst.ip = 0xffffffff;
 	exp_orig->mask.dst.protonum = 0xff;
 		
@@ -340,7 +340,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	unsigned int reqlen;
 	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
-	u_int16_t msg, *cid, *pcid;
+	u_int16_t msg;
+	__be16 *cid, *pcid;
 	u_int32_t seq;	
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
@@ -551,7 +552,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	unsigned int reqlen;
 	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
-	u_int16_t msg, *cid, *pcid;
+	u_int16_t msg;
+	__be16 *cid, *pcid;
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh)
@@ -755,7 +757,7 @@ static struct ip_conntrack_helper pptp =
 			  } 
 		 },
 	.mask = { .src = { .ip = 0, 
-			   .u = { .tcp = { .port = 0xffff } } 
+			   .u = { .tcp = { .port = __constant_htons(0xffff) } } 
 			 }, 
 		  .dst = { .ip = 0, 
 			   .u = { .all = 0 },
