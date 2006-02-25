From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: support non-linear skbs
Date: Sat, 25 Feb 2006 10:06:18 +0100
Message-ID: <44001E0A.5060006@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050100090903040202050202"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
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

This is a multi-part message in MIME format.
--------------050100090903040202050202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Add support for non-linear SKBs. I know switching to
ip_nat_mangle_{tcp,udp}_packet is less efficient because it checksums
the packet on each call, but that can be fixed seperately by switching
it to incremental checksumming.


--------------050100090903040202050202
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

[NETFILTER]: H.323 helper: support non-linear skbs

Change the H.323 helper to support non-linear skbs similar to the other
helpers. This has two additional positive side-effects:

- skb_writable was broken as it always tried to reload the data pointer with
  an assumed TPKT payload, even for H.225 RAS packets.

- we can use the regular NAT packet mangling functions and get rid of the
  manual checksumming

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9141da3e4912a8df591add5ea10dc55b5df83c21
tree dcbb6e1c302fd54d3ae0073c1014422a26424dec
parent 7206cd2e0c2c0a0c650c83ab4a10e1f54728d42d
author Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:05:41 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:05:41 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |  230 ++++++++++++-------------
 net/ipv4/netfilter/ip_nat_helper_h323.c       |  178 ++++++-------------
 2 files changed, 169 insertions(+), 239 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 8d49e74..212e258 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
-#include <net/checksum.h>
 #include <net/tcp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
@@ -32,14 +31,12 @@
 #endif
 
 /* Hooks for NAT */
-void (*recalc_tcp_checksum_hook) (struct sk_buff ** pskb);
-void (*recalc_udp_checksum_hook) (struct sk_buff ** pskb);
 int (*set_h245_addr_hook) (struct sk_buff ** pskb,
-			   unsigned char **data,
+			   unsigned char **data, unsigned int dataoff,
 			   H245_TransportAddress * addr,
 			   u_int32_t ip, u_int16_t port);
 int (*set_h225_addr_hook) (struct sk_buff ** pskb,
-			   unsigned char **data,
+			   unsigned char **data, unsigned int dataoff,
 			   TransportAddress * addr,
 			   u_int32_t ip, u_int16_t port);
 int (*set_sig_addr_hook) (struct sk_buff ** pskb,
@@ -55,7 +52,7 @@ int (*set_ras_addr_hook) (struct sk_buff
 int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,
 			  struct ip_conntrack * ct,
 			  enum ip_conntrack_info ctinfo,
-			  unsigned char **data,
+			  unsigned char **data, unsigned int dataoff,
 			  H245_TransportAddress * addr,
 			  u_int16_t port, u_int16_t rtp_port,
 			  struct ip_conntrack_expect * rtp_exp,
@@ -63,25 +60,24 @@ int (*nat_rtp_rtcp_hook) (struct sk_buff
 int (*nat_h245_hook) (struct sk_buff ** pskb,
 		      struct ip_conntrack * ct,
 		      enum ip_conntrack_info ctinfo,
-		      unsigned char **data,
+		      unsigned char **data, unsigned int dataoff,
 		      TransportAddress * addr,
 		      u_int16_t port, struct ip_conntrack_expect * exp);
 int (*nat_q931_hook) (struct sk_buff ** pskb,
 		      struct ip_conntrack * ct,
 		      enum ip_conntrack_info ctinfo,
-		      unsigned char **data,
+		      unsigned char **data, unsigned int dataoff,
 		      TransportAddress * addr,
 		      int idx, u_int16_t port,
 		      struct ip_conntrack_expect * exp);
 
 
-static DEFINE_SPINLOCK(ip_h245_lock);
-static DEFINE_SPINLOCK(ip_q931_lock);
-static DEFINE_SPINLOCK(ip_ras_lock);
-
+static DEFINE_SPINLOCK(ip_h323_lock);
+static char *h323_buffer;
 
 /****************************************************************************/
-unsigned char *get_tpkt_data(struct sk_buff **pskb, int *datalen)
+static unsigned char *get_tpkt_data(struct sk_buff **pskb,
+                                    int *datalen, int *dataoff)
 {
 	struct tcphdr _tcph, *th;
 	unsigned int tpktoff;
@@ -89,10 +85,6 @@ unsigned char *get_tpkt_data(struct sk_b
 	int tpktlen;
 	int len;
 
-	/* Must be linear */
-	if (skb_is_nonlinear(*pskb))
-		return NULL;
-
 	/* Look for TCP */
 	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl * 4,
 				sizeof(_tcph), &_tcph);
@@ -104,14 +96,15 @@ unsigned char *get_tpkt_data(struct sk_b
 	if (tpktoff >= (*pskb)->len)	/* No TCP data */
 		return NULL;
 	tpktlen = (*pskb)->len - tpktoff;
-	tpkt = (unsigned char *) ((*pskb)->nh.iph) + tpktoff;
+	tpkt = skb_header_pointer(*pskb, tpktoff, tpktlen, h323_buffer);
+	BUG_ON(tpkt == NULL);
 
 	/* Validate TPKT identifier */
 	if (tpktlen < 1 || tpkt[0] != 0x03 || tpktlen < 2 || tpkt[1] != 0) {
 		/* Some applications like Netmeeting send TPKT header and 
 		 * data separately, let's just try to decode it as bare data */
-		if (datalen)
-			*datalen = tpktlen;
+		*datalen = tpktlen;
+		*dataoff = 0;
 		return tpkt;
 	}
 
@@ -126,8 +119,8 @@ unsigned char *get_tpkt_data(struct sk_b
 	}
 
 	/* This is the encapsulated data */
-	if (datalen)
-		*datalen = len - 4;
+	*datalen = len - 4;
+	*dataoff = 4;
 	return tpkt + 4;
 }
 
@@ -151,7 +144,8 @@ int get_h245_addr(unsigned char *data, H
 /****************************************************************************/
 static int expect_rtp_rtcp(struct sk_buff **pskb, struct ip_conntrack *ct,
 			   enum ip_conntrack_info ctinfo,
-			   unsigned char **data, H245_TransportAddress * addr)
+			   unsigned char **data, unsigned int dataoff,
+			   H245_TransportAddress * addr)
 {
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
@@ -204,8 +198,9 @@ static int expect_rtp_rtcp(struct sk_buf
 	if (ct->tuplehash[dir].tuple.src.ip !=
 	    ct->tuplehash[!dir].tuple.dst.ip && nat_rtp_rtcp_hook) {
 		/* NAT needed */
-		ret = nat_rtp_rtcp_hook(pskb, ct, ctinfo, data, addr, port,
-					rtp_port, rtp_exp, rtcp_exp);
+		ret = nat_rtp_rtcp_hook(pskb, ct, ctinfo, data, dataoff,
+					addr, port, rtp_port,
+					rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
 		rtp_exp->expectfn = NULL;
 		rtcp_exp->expectfn = NULL;
@@ -244,7 +239,7 @@ static int expect_rtp_rtcp(struct sk_buf
 static int process_h245_channel(struct sk_buff **pskb,
 				struct ip_conntrack *ct,
 				enum ip_conntrack_info ctinfo,
-				unsigned char **data,
+				unsigned char **data, unsigned int dataoff,
 				H2250LogicalChannelParameters * channel)
 {
 	int ret = 0;
@@ -252,7 +247,7 @@ static int process_h245_channel(struct s
 
 	if (channel->options & eH2250LogicalChannelParameters_mediaChannel) {
 		/* RTP */
-		ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data,
+		ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 				       &channel->mediaChannel);
 		if (ret2 < 0)
 			return -1;
@@ -262,7 +257,7 @@ static int process_h245_channel(struct s
 	if (channel->options &
 	    eH2250LogicalChannelParameters_mediaControlChannel) {
 		/* RTCP */
-		ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data,
+		ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 				       &channel->mediaControlChannel);
 		if (ret2 < 0)
 			return -1;
@@ -275,7 +270,8 @@ static int process_h245_channel(struct s
 /****************************************************************************/
 static int process_olc(struct sk_buff **pskb, struct ip_conntrack *ct,
 		       enum ip_conntrack_info ctinfo,
-		       unsigned char **data, OpenLogicalChannel * olc)
+		       unsigned char **data, unsigned int dataoff,
+		       OpenLogicalChannel * olc)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -285,7 +281,7 @@ static int process_olc(struct sk_buff **
 	if (olc->forwardLogicalChannelParameters.multiplexParameters.choice ==
 	    eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters)
 	{
-		ret2 = process_h245_channel(pskb, ct, ctinfo, data,
+		ret2 = process_h245_channel(pskb, ct, ctinfo, data, dataoff,
 					    &olc->
 					    forwardLogicalChannelParameters.
 					    multiplexParameters.
@@ -307,7 +303,7 @@ static int process_olc(struct sk_buff **
 		    eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters)
 		{
 			ret2 =
-			    process_h245_channel(pskb, ct, ctinfo, data,
+			    process_h245_channel(pskb, ct, ctinfo, data, dataoff,
 						 &olc->
 						 reverseLogicalChannelParameters.
 						 multiplexParameters.
@@ -324,7 +320,8 @@ static int process_olc(struct sk_buff **
 /****************************************************************************/
 static int process_olca(struct sk_buff **pskb, struct ip_conntrack *ct,
 			enum ip_conntrack_info ctinfo,
-			unsigned char **data, OpenLogicalChannelAck * olca)
+			unsigned char **data, unsigned int dataoff,
+			OpenLogicalChannelAck * olca)
 {
 	H2250LogicalChannelAckParameters *ack;
 	int ret = 0;
@@ -340,7 +337,7 @@ static int process_olca(struct sk_buff *
 		choice ==
 		eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters))
 	{
-		ret2 = process_h245_channel(pskb, ct, ctinfo, data,
+		ret2 = process_h245_channel(pskb, ct, ctinfo, data, dataoff,
 					    &olca->
 					    reverseLogicalChannelParameters.
 					    multiplexParameters.
@@ -360,7 +357,7 @@ static int process_olca(struct sk_buff *
 		if (ack->options &
 		    eH2250LogicalChannelAckParameters_mediaChannel) {
 			/* RTP */
-			ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data,
+			ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 					       &ack->mediaChannel);
 			if (ret2 < 0)
 				return -1;
@@ -370,7 +367,7 @@ static int process_olca(struct sk_buff *
 		if (ack->options &
 		    eH2250LogicalChannelAckParameters_mediaControlChannel) {
 			/* RTCP */
-			ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data,
+			ret2 = expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 					       &ack->mediaControlChannel);
 			if (ret2 < 0)
 				return -1;
@@ -384,21 +381,21 @@ static int process_olca(struct sk_buff *
 /****************************************************************************/
 static int process_h245(struct sk_buff **pskb, struct ip_conntrack *ct,
 			enum ip_conntrack_info ctinfo,
-			unsigned char **data,
+			unsigned char **data, unsigned int dataoff,
 			MultimediaSystemControlMessage * mscm)
 {
 	switch (mscm->choice) {
 	case eMultimediaSystemControlMessage_request:
 		if (mscm->request.choice ==
 		    eRequestMessage_openLogicalChannel) {
-			return process_olc(pskb, ct, ctinfo, data,
+			return process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &mscm->request.openLogicalChannel);
 		}
 		break;
 	case eMultimediaSystemControlMessage_response:
 		if (mscm->response.choice ==
 		    eResponseMessage_openLogicalChannelAck) {
-			return process_olca(pskb, ct, ctinfo, data,
+			return process_olca(pskb, ct, ctinfo, data, dataoff,
 					    &mscm->response.
 					    openLogicalChannelAck);
 		}
@@ -415,7 +412,7 @@ static int h245_help(struct sk_buff **ps
 		     enum ip_conntrack_info ctinfo)
 {
 	unsigned char *data;
-	int datalen;
+	int datalen, dataoff;
 	int ret;
 	static MultimediaSystemControlMessage mscm;
 
@@ -425,38 +422,37 @@ static int h245_help(struct sk_buff **ps
 		return NF_ACCEPT;
 	}
 
-	data = get_tpkt_data(pskb, &datalen);
+	spin_lock_bh(&ip_h323_lock);
+	data = get_tpkt_data(pskb, &datalen, &dataoff);
 	if (data == NULL) {
 		DEBUGP("ip_ct_h245: skblen = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 	DEBUGP("ip_ct_h245: TPKT %u.%u.%u.%u->%u.%u.%u.%u, len=%d\n",
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
-	spin_lock_bh(&ip_h245_lock);
 	ret = DecodeMultimediaSystemControlMessage(data, datalen, &mscm);
 	if (ret < 0) {
 		DEBUGP("ip_ct_h245: decoding error: %s\n",
 		       ret ==
 		       H323_ERROR_BOUND ? "out of bound" : "out of range");
-		spin_unlock_bh(&ip_h245_lock);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 
-	ret = process_h245(pskb, ct, ctinfo, &data, &mscm);
-	spin_unlock_bh(&ip_h245_lock);
+	ret = process_h245(pskb, ct, ctinfo, &data, dataoff, &mscm);
+	spin_unlock_bh(&ip_h323_lock);
 
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_h245: packet dropped\n");
 		return NF_DROP;
-	} else if (ret > 0 && recalc_tcp_checksum_hook) {
-		DEBUGP("ip_ct_h245: packet mangled\n");
-		recalc_tcp_checksum_hook(pskb);
 	}
 
 	return NF_ACCEPT;
+out_unlock:
+	spin_unlock_bh(&ip_h323_lock);
+	return NF_ACCEPT;
 }
 
 /****************************************************************************/
@@ -498,7 +494,8 @@ static int get_h225_addr(unsigned char *
 /****************************************************************************/
 static int expect_h245(struct sk_buff **pskb, struct ip_conntrack *ct,
 		       enum ip_conntrack_info ctinfo,
-		       unsigned char **data, TransportAddress * addr)
+		       unsigned char **data, unsigned int dataoff,
+		       TransportAddress * addr)
 {
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
@@ -529,7 +526,8 @@ static int expect_h245(struct sk_buff **
 	if (ct->tuplehash[dir].tuple.src.ip !=
 	    ct->tuplehash[!dir].tuple.dst.ip && nat_h245_hook) {
 		/* NAT needed */
-		ret = nat_h245_hook(pskb, ct, ctinfo, data, addr, port, exp);
+		ret = nat_h245_hook(pskb, ct, ctinfo, data, dataoff,
+				    addr, port, exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = ip_conntrack_h245_expect;
 
@@ -552,7 +550,8 @@ static int expect_h245(struct sk_buff **
 /****************************************************************************/
 static int process_setup(struct sk_buff **pskb, struct ip_conntrack *ct,
 			 enum ip_conntrack_info ctinfo,
-			 unsigned char **data, Setup_UUIE * setup)
+			 unsigned char **data, unsigned int dataoff,
+			 Setup_UUIE * setup)
 {
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
@@ -564,7 +563,7 @@ static int process_setup(struct sk_buff 
 	DEBUGP("ip_ct_q931: Setup\n");
 
 	if (setup->options & eSetup_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &setup->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -580,7 +579,7 @@ static int process_setup(struct sk_buff 
 		     "%u.%u.%u.%u:%hu\n", NIPQUAD(ip), port,
 		     NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
 		     ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));
-		ret2 = set_h225_addr_hook(pskb, data,
+		ret2 = set_h225_addr_hook(pskb, data, dataoff,
 					  &setup->destCallSignalAddress,
 					  ct->tuplehash[!dir].tuple.src.ip,
 					  ntohs(ct->tuplehash[!dir].tuple.src.
@@ -599,7 +598,7 @@ static int process_setup(struct sk_buff 
 		     "%u.%u.%u.%u:%hu\n", NIPQUAD(ip), port,
 		     NIPQUAD(ct->tuplehash[!dir].tuple.dst.ip),
 		     ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));
-		ret2 = set_h225_addr_hook(pskb, data,
+		ret2 = set_h225_addr_hook(pskb, data, dataoff,
 					  &setup->sourceCallSignalAddress,
 					  ct->tuplehash[!dir].tuple.dst.ip,
 					  ntohs(ct->tuplehash[!dir].tuple.dst.
@@ -611,7 +610,7 @@ static int process_setup(struct sk_buff 
 
 	if (setup->options & eSetup_UUIE_fastStart) {
 		for (i = 0; i < setup->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &setup->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -626,7 +625,7 @@ static int process_setup(struct sk_buff 
 static int process_callproceeding(struct sk_buff **pskb,
 				  struct ip_conntrack *ct,
 				  enum ip_conntrack_info ctinfo,
-				  unsigned char **data,
+				  unsigned char **data, unsigned int dataoff,
 				  CallProceeding_UUIE * callproc)
 {
 	int ret = 0;
@@ -636,7 +635,7 @@ static int process_callproceeding(struct
 	DEBUGP("ip_ct_q931: CallProceeding\n");
 
 	if (callproc->options & eCallProceeding_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &callproc->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -645,7 +644,7 @@ static int process_callproceeding(struct
 
 	if (callproc->options & eCallProceeding_UUIE_fastStart) {
 		for (i = 0; i < callproc->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &callproc->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -659,7 +658,8 @@ static int process_callproceeding(struct
 /****************************************************************************/
 static int process_connect(struct sk_buff **pskb, struct ip_conntrack *ct,
 			   enum ip_conntrack_info ctinfo,
-			   unsigned char **data, Connect_UUIE * connect)
+			   unsigned char **data, unsigned int dataoff,
+			   Connect_UUIE * connect)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -668,7 +668,7 @@ static int process_connect(struct sk_buf
 	DEBUGP("ip_ct_q931: Connect\n");
 
 	if (connect->options & eConnect_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &connect->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -677,7 +677,7 @@ static int process_connect(struct sk_buf
 
 	if (connect->options & eConnect_UUIE_fastStart) {
 		for (i = 0; i < connect->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &connect->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -691,7 +691,8 @@ static int process_connect(struct sk_buf
 /****************************************************************************/
 static int process_alerting(struct sk_buff **pskb, struct ip_conntrack *ct,
 			    enum ip_conntrack_info ctinfo,
-			    unsigned char **data, Alerting_UUIE * alert)
+			    unsigned char **data, unsigned int dataoff,
+			    Alerting_UUIE * alert)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -700,7 +701,7 @@ static int process_alerting(struct sk_bu
 	DEBUGP("ip_ct_q931: Alerting\n");
 
 	if (alert->options & eAlerting_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &alert->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -709,7 +710,7 @@ static int process_alerting(struct sk_bu
 
 	if (alert->options & eAlerting_UUIE_fastStart) {
 		for (i = 0; i < alert->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &alert->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -724,7 +725,8 @@ static int process_alerting(struct sk_bu
 static int process_information(struct sk_buff **pskb,
 			       struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
-			       unsigned char **data, Information_UUIE * info)
+			       unsigned char **data, unsigned int dataoff,
+			       Information_UUIE * info)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -734,7 +736,7 @@ static int process_information(struct sk
 
 	if (info->options & eInformation_UUIE_fastStart) {
 		for (i = 0; i < info->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &info->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -749,7 +751,8 @@ static int process_information(struct sk
 /****************************************************************************/
 static int process_facility(struct sk_buff **pskb, struct ip_conntrack *ct,
 			    enum ip_conntrack_info ctinfo,
-			    unsigned char **data, Facility_UUIE * facility)
+			    unsigned char **data, unsigned int dataoff,
+			    Facility_UUIE * facility)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -758,7 +761,7 @@ static int process_facility(struct sk_bu
 	DEBUGP("ip_ct_q931: Facility\n");
 
 	if (facility->options & eFacility_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &facility->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -767,7 +770,7 @@ static int process_facility(struct sk_bu
 
 	if (facility->options & eFacility_UUIE_fastStart) {
 		for (i = 0; i < facility->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &facility->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -781,7 +784,8 @@ static int process_facility(struct sk_bu
 /****************************************************************************/
 static int process_progress(struct sk_buff **pskb, struct ip_conntrack *ct,
 			    enum ip_conntrack_info ctinfo,
-			    unsigned char **data, Progress_UUIE * progress)
+			    unsigned char **data, unsigned int dataoff,
+			    Progress_UUIE * progress)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -790,7 +794,7 @@ static int process_progress(struct sk_bu
 	DEBUGP("ip_ct_q931: Progress\n");
 
 	if (progress->options & eProgress_UUIE_h245Address) {
-		ret2 = expect_h245(pskb, ct, ctinfo, data,
+		ret2 = expect_h245(pskb, ct, ctinfo, data, dataoff,
 				   &progress->h245Address);
 		if (ret2 < 0)
 			return -1;
@@ -799,7 +803,7 @@ static int process_progress(struct sk_bu
 
 	if (progress->options & eProgress_UUIE_fastStart) {
 		for (i = 0; i < progress->fastStart.count; i++) {
-			ret2 = process_olc(pskb, ct, ctinfo, data,
+			ret2 = process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &progress->fastStart.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -813,7 +817,8 @@ static int process_progress(struct sk_bu
 /****************************************************************************/
 static int process_q931(struct sk_buff **pskb, struct ip_conntrack *ct,
 			enum ip_conntrack_info ctinfo,
-			unsigned char **data, Q931 * q931)
+			unsigned char **data, unsigned int dataoff,
+			Q931 * q931)
 {
 	H323_UU_PDU *pdu = &q931->UUIE.h323_uu_pdu;
 	int i;
@@ -822,33 +827,33 @@ static int process_q931(struct sk_buff *
 
 	switch (pdu->h323_message_body.choice) {
 	case eH323_UU_PDU_h323_message_body_setup:
-		ret = process_setup(pskb, ct, ctinfo, data,
+		ret = process_setup(pskb, ct, ctinfo, data, dataoff,
 				    &pdu->h323_message_body.setup);
 		break;
 	case eH323_UU_PDU_h323_message_body_callProceeding:
-		ret = process_callproceeding(pskb, ct, ctinfo, data,
+		ret = process_callproceeding(pskb, ct, ctinfo, data, dataoff,
 					     &pdu->h323_message_body.
 					     callProceeding);
 		break;
 	case eH323_UU_PDU_h323_message_body_connect:
-		ret = process_connect(pskb, ct, ctinfo, data,
+		ret = process_connect(pskb, ct, ctinfo, data, dataoff,
 				      &pdu->h323_message_body.connect);
 		break;
 	case eH323_UU_PDU_h323_message_body_alerting:
-		ret = process_alerting(pskb, ct, ctinfo, data,
+		ret = process_alerting(pskb, ct, ctinfo, data, dataoff,
 				       &pdu->h323_message_body.alerting);
 		break;
 	case eH323_UU_PDU_h323_message_body_information:
-		ret = process_information(pskb, ct, ctinfo, data,
+		ret = process_information(pskb, ct, ctinfo, data, dataoff,
 					  &pdu->h323_message_body.
 					  information);
 		break;
 	case eH323_UU_PDU_h323_message_body_facility:
-		ret = process_facility(pskb, ct, ctinfo, data,
+		ret = process_facility(pskb, ct, ctinfo, data, dataoff,
 				       &pdu->h323_message_body.facility);
 		break;
 	case eH323_UU_PDU_h323_message_body_progress:
-		ret = process_progress(pskb, ct, ctinfo, data,
+		ret = process_progress(pskb, ct, ctinfo, data, dataoff,
 				       &pdu->h323_message_body.progress);
 		break;
 	default:
@@ -857,7 +862,7 @@ static int process_q931(struct sk_buff *
 
 	if (ret >= 0 && pdu->options & eH323_UU_PDU_h245Control) {
 		for (i = 0; i < pdu->h245Control.count; i++) {
-			ret2 = process_h245(pskb, ct, ctinfo, data,
+			ret2 = process_h245(pskb, ct, ctinfo, data, dataoff,
 					    &pdu->h245Control.item[i]);
 			if (ret2 < 0)
 				return -1;
@@ -873,7 +878,7 @@ static int q931_help(struct sk_buff **ps
 		     enum ip_conntrack_info ctinfo)
 {
 	unsigned char *data;
-	int datalen;
+	int datalen, dataoff;
 	int ret;
 	static Q931 q931;
 
@@ -883,39 +888,38 @@ static int q931_help(struct sk_buff **ps
 		return NF_ACCEPT;
 	}
 
-	data = get_tpkt_data(pskb, &datalen);
+	spin_lock_bh(&ip_h323_lock);
+	data = get_tpkt_data(pskb, &datalen, &dataoff);
 	if (data == NULL) {
 		DEBUGP("ip_ct_q931: skblen = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 	DEBUGP("ip_ct_q931: TPKT %u.%u.%u.%u->%u.%u.%u.%u, len=%d\n",
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
-	spin_lock_bh(&ip_q931_lock);
 	ret = DecodeQ931(data, datalen, &q931);
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_q931: decoding error: %s\n",
 			       ret == H323_ERROR_BOUND ?
 			       "out of bound" : "out of range");
-		spin_unlock_bh(&ip_q931_lock);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 
-	ret = process_q931(pskb, ct, ctinfo, &data, &q931);
-	spin_unlock_bh(&ip_q931_lock);
+	ret = process_q931(pskb, ct, ctinfo, &data, dataoff, &q931);
+	spin_unlock_bh(&ip_h323_lock);
 
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_q931: packet dropped\n");
 		return NF_DROP;
-	} else if (ret > 0 && recalc_tcp_checksum_hook) {
-		DEBUGP("ip_ct_q931: packet mangled\n");
-		(*recalc_tcp_checksum_hook) (pskb);
 	}
 
 	return NF_ACCEPT;
+out_unlock:
+	spin_unlock_bh(&ip_h323_lock);
+	return NF_ACCEPT;
 }
 
 /****************************************************************************/
@@ -941,15 +945,11 @@ void ip_conntrack_q931_expect(struct ip_
 }
 
 /****************************************************************************/
-unsigned char *get_udp_data(struct sk_buff **pskb, int *datalen)
+static unsigned char *get_udp_data(struct sk_buff **pskb, int *datalen)
 {
 	struct udphdr _uh, *uh;
 	unsigned int dataoff;
 
-	/* Must be linear */
-	if (skb_is_nonlinear(*pskb))
-		return NULL;
-
 	uh = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl * 4, sizeof(_uh),
 				&_uh);
 	if (uh == NULL)
@@ -957,9 +957,8 @@ unsigned char *get_udp_data(struct sk_bu
 	dataoff = (*pskb)->nh.iph->ihl * 4 + sizeof(_uh);
 	if (dataoff >= (*pskb)->len)
 		return NULL;
-	if (*datalen)
-		*datalen = (*pskb)->len - dataoff;
-	return (unsigned char *) ((*pskb)->nh.iph) + dataoff;
+	*datalen = (*pskb)->len - dataoff;
+	return skb_header_pointer(*pskb, dataoff, *datalen, h323_buffer);
 }
 
 /****************************************************************************/
@@ -1032,7 +1031,7 @@ static int expect_q931(struct sk_buff **
 	exp->flags = IP_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	if (nat_q931_hook) {	/* Need NAT */
-		ret = nat_q931_hook(pskb, ct, ctinfo, data, addr, i, port,
+		ret = nat_q931_hook(pskb, ct, ctinfo, data, 0, addr, i, port,
 				    exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = ip_conntrack_q931_expect;
@@ -1246,7 +1245,7 @@ static int process_arq(struct sk_buff **
 	    ip == ct->tuplehash[dir].tuple.src.ip &&
 	    port == info->sig_port[dir] && set_h225_addr_hook) {
 		/* Answering ARQ */
-		return set_h225_addr_hook(pskb, data,
+		return set_h225_addr_hook(pskb, data, 0,
 					  &arq->destCallSignalAddress,
 					  ct->tuplehash[!dir].tuple.dst.ip,
 					  info->sig_port[!dir]);
@@ -1256,7 +1255,7 @@ static int process_arq(struct sk_buff **
 	    get_h225_addr(*data, &arq->srcCallSignalAddress, &ip, &port) &&
 	    ip == ct->tuplehash[dir].tuple.src.ip && set_h225_addr_hook) {
 		/* Calling ARQ */
-		return set_h225_addr_hook(pskb, data,
+		return set_h225_addr_hook(pskb, data, 0,
 					  &arq->srcCallSignalAddress,
 					  ct->tuplehash[!dir].tuple.dst.ip,
 					  port);
@@ -1465,39 +1464,38 @@ static int ras_help(struct sk_buff **psk
 	int ret;
 	static RasMessage ras;
 
+	spin_lock_bh(&ip_h323_lock);
 	data = get_udp_data(pskb, &datalen);
 	if (data == NULL) {
 		DEBUGP("ip_ct_ras: skblen = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 	DEBUGP("ip_ct_ras: %u.%u.%u.%u->%u.%u.%u.%u, len=%d\n",
 	       NIPQUAD((*pskb)->nh.iph->saddr),
 	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);
 
-	spin_lock_bh(&ip_ras_lock);
 	ret = DecodeRasMessage(data, datalen, &ras);
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_ras: decoding error: %s\n",
 			       ret == H323_ERROR_BOUND ?
 			       "out of bound" : "out of range");
-		spin_unlock_bh(&ip_ras_lock);
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 
 	ret = process_ras(pskb, ct, ctinfo, &data, &ras);
-	spin_unlock_bh(&ip_ras_lock);
+	spin_unlock_bh(&ip_h323_lock);
 
 	if (ret < 0) {
 		if (net_ratelimit())
 			printk("ip_ct_ras: packet dropped\n");
 		return NF_DROP;
-	} else if (ret > 0 && recalc_udp_checksum_hook) {
-		DEBUGP("ip_ct_ras: packet mangled\n");
-		(*recalc_udp_checksum_hook) (pskb);
 	}
 
 	return NF_ACCEPT;
+out_unlock:
+	spin_unlock_bh(&ip_h323_lock);
+	return NF_ACCEPT;
 }
 
 /****************************************************************************/
@@ -1527,6 +1525,7 @@ static void __exit fini(void)
 {
 	ip_conntrack_helper_unregister(&ip_conntrack_helper_ras);
 	ip_conntrack_helper_unregister(&ip_conntrack_helper_q931);
+	kfree(h323_buffer);
 	DEBUGP("ip_ct_h323: fini\n");
 }
 
@@ -1535,6 +1534,9 @@ static int __init init(void)
 {
 	int ret;
 
+	h323_buffer = kmalloc(65536, GFP_KERNEL);
+	if (!h323_buffer)
+		return -ENOMEM;
 	if ((ret = ip_conntrack_helper_register(&ip_conntrack_helper_q931)) ||
 	    (ret = ip_conntrack_helper_register(&ip_conntrack_helper_ras))) {
 		fini();
@@ -1549,14 +1551,10 @@ static int __init init(void)
 module_init(init);
 module_exit(fini);
 
-EXPORT_SYMBOL(get_tpkt_data);
-EXPORT_SYMBOL(get_udp_data);
 EXPORT_SYMBOL(get_h245_addr);
 EXPORT_SYMBOL(get_h225_addr);
 EXPORT_SYMBOL(ip_conntrack_h245_expect);
 EXPORT_SYMBOL(ip_conntrack_q931_expect);
-EXPORT_SYMBOL(recalc_tcp_checksum_hook);
-EXPORT_SYMBOL(recalc_udp_checksum_hook);
 EXPORT_SYMBOL(set_h245_addr_hook);
 EXPORT_SYMBOL(set_h225_addr_hook);
 EXPORT_SYMBOL(set_sig_addr_hook);
diff --git a/net/ipv4/netfilter/ip_nat_helper_h323.c b/net/ipv4/netfilter/ip_nat_helper_h323.c
index 3c2fd3a..bce1b7d 100644
--- a/net/ipv4/netfilter/ip_nat_helper_h323.c
+++ b/net/ipv4/netfilter/ip_nat_helper_h323.c
@@ -16,7 +16,6 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/moduleparam.h>
-#include <net/checksum.h>
 #include <net/tcp.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
@@ -33,8 +32,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-extern unsigned char *get_tpkt_data(struct sk_buff **pskb, int *datalen);
-extern unsigned char *get_udp_data(struct sk_buff **pskb, int *datalen);
 extern int get_h245_addr(unsigned char *data,
 			 H245_TransportAddress * addr,
 			 u_int32_t * ip, u_int16_t * port);
@@ -45,14 +42,12 @@ extern void ip_conntrack_h245_expect(str
 				     struct ip_conntrack_expect *this);
 extern void ip_conntrack_q931_expect(struct ip_conntrack *new,
 				     struct ip_conntrack_expect *this);
-extern void (*recalc_tcp_checksum_hook) (struct sk_buff ** pskb);
-extern void (*recalc_udp_checksum_hook) (struct sk_buff ** pskb);
 extern int (*set_h245_addr_hook) (struct sk_buff ** pskb,
-				  unsigned char **data,
+				  unsigned char **data, unsigned int dataoff,
 				  H245_TransportAddress * addr,
 				  u_int32_t ip, u_int16_t port);
 extern int (*set_h225_addr_hook) (struct sk_buff ** pskb,
-				  unsigned char **data,
+				  unsigned char **data, unsigned int dataoff,
 				  TransportAddress * addr,
 				  u_int32_t ip, u_int16_t port);
 extern int (*set_sig_addr_hook) (struct sk_buff ** pskb,
@@ -68,7 +63,7 @@ extern int (*set_ras_addr_hook) (struct 
 extern int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,
 				 struct ip_conntrack * ct,
 				 enum ip_conntrack_info ctinfo,
-				 unsigned char **data,
+				 unsigned char **data, unsigned int dataoff,
 				 H245_TransportAddress * addr,
 				 u_int16_t port, u_int16_t rtp_port,
 				 struct ip_conntrack_expect * rtp_exp,
@@ -76,131 +71,73 @@ extern int (*nat_rtp_rtcp_hook) (struct 
 extern int (*nat_h245_hook) (struct sk_buff ** pskb,
 			     struct ip_conntrack * ct,
 			     enum ip_conntrack_info ctinfo,
-			     unsigned char **data,
+			     unsigned char **data, unsigned int dataoff,
 			     TransportAddress * addr,
 			     u_int16_t port,
 			     struct ip_conntrack_expect * exp);
 extern int (*nat_q931_hook) (struct sk_buff ** pskb,
 			     struct ip_conntrack * ct,
 			     enum ip_conntrack_info ctinfo,
-			     unsigned char **data,
+			     unsigned char **data, unsigned int dataoff,
 			     TransportAddress * addr,
 			     int idx, u_int16_t port,
 			     struct ip_conntrack_expect * exp);
 
 
-/****************************************************************************
- * Recalculate TCP header checksum. Only called when NAT is enabled and
- * the packet has been changed at least once. Note: This function assumes
- * the packet length hasn't been changed 
- ****************************************************************************/
-static void recalc_tcp_checksum(struct sk_buff **pskb)
-{
-	struct iphdr *iph;
-	struct tcphdr *tcph;
-	int datalen;
-
-	iph = (*pskb)->nh.iph;
-	tcph = (void *) iph + iph->ihl * 4;
-	datalen = (*pskb)->len - iph->ihl * 4;
-	tcph->check = 0;
-	tcph->check = tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
-				   csum_partial((char *) tcph, datalen, 0));
-}
-
-/****************************************************************************
- * Recalculate UDP header checksum. Only called when NAT is enabled and
- * the packet has been changed at least once. Note: This function assumes
- * the packet length hasn't been changed 
- ****************************************************************************/
-static void recalc_udp_checksum(struct sk_buff **pskb)
-{
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct udphdr *udph = (void *) iph + iph->ihl * 4;
-	size_t udplen = (*pskb)->len - iph->ihl * 4;
-
-	(*pskb)->csum = csum_partial((char *) udph + sizeof(struct udphdr),
-				     udplen - sizeof(struct udphdr), 0);
-	udph->check = 0;
-	udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr, udplen,
-					IPPROTO_UDP,
-					csum_partial((char *) udph,
-						     sizeof(struct udphdr),
-						     (*pskb)->csum));
-}
-
 /****************************************************************************/
-static int skb_writable(struct sk_buff **pskb, unsigned char **data)
-{
-	struct sk_buff *nskb;
-
-	/* Not exclusive use of packet?  Must copy. */
-	if (skb_shared(*pskb) || skb_cloned(*pskb)) {
-		nskb = skb_copy(*pskb, GFP_ATOMIC);
-		if (!nskb) {
-			if (net_ratelimit())
-				printk("ip_nat_h323: skb_copy() failed\n");
-			return 0;
-		}
-		BUG_ON(skb_is_nonlinear(nskb));
-		DEBUGP("ip_nat_h323: skb copied for modification\n");
-
-		/* Rest of kernel will get very unhappy if we pass it a 
-		 * suddenly-orphaned skbuff */
-		if ((*pskb)->sk)
-			skb_set_owner_w(nskb, (*pskb)->sk);
-		kfree_skb(*pskb);
-		*pskb = nskb;
-		*data = get_tpkt_data(pskb, NULL);
+static int set_addr(struct sk_buff **pskb,
+		    unsigned char **data, unsigned int dataoff,
+		    unsigned int addroff, u_int32_t ip, u_int16_t port)
+{
+	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack *ct = ip_conntrack_get(*pskb, &ctinfo);
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) buf;
+	ptrdiff_t diff;
+
+	buf.ip = ip;
+	buf.port = port;
+
+	diff = *data - (*pskb)->data;
+
+	addroff += dataoff;
+	if ((*pskb)->nh.iph->protocol == IPPROTO_TCP) {
+		if (!ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+					      addroff, sizeof(buf),
+					      (char *)&buf, sizeof(buf)))
+			return -1;
+	} else {
+		if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+					      addroff, sizeof(buf),
+					      (char *)&buf, sizeof(buf)))
+			return -1;
 	}
 
+	/* Adjust data pointer if it pointed to the linear area */
+	if (diff > 0 && diff <= (*pskb)->len)
+		*data = (*pskb)->data + diff + dataoff;
 	return 1;
 }
 
 /****************************************************************************/
-static int set_h225_addr(struct sk_buff **pskb, unsigned char **data,
+static int set_h225_addr(struct sk_buff **pskb,
+			 unsigned char **data, unsigned int dataoff,
 			 TransportAddress * addr,
 			 u_int32_t ip, u_int16_t port)
 {
-	unsigned char *p;
-
-	if (!skb_writable(pskb, data))
-		return -1;
-
-	p = *data + addr->ipAddress.ip;
-
-	ip = ntohl(ip);
-	p[0] = (ip >> 24) & 0xff;
-	p[1] = (ip >> 16) & 0xff;
-	p[2] = (ip >> 8) & 0xff;
-	p[3] = ip & 0xff;
-	p[4] = (port >> 8) & 0xff;
-	p[5] = port & 0xff;
-
-	return 1;
+	return set_addr(pskb, data, dataoff, addr->ipAddress.ip, ip, port);
 }
 
 /****************************************************************************/
-static int set_h245_addr(struct sk_buff **pskb, unsigned char **data,
+static int set_h245_addr(struct sk_buff **pskb,
+		         unsigned char **data, unsigned int dataoff,
 			 H245_TransportAddress * addr,
 			 u_int32_t ip, u_int16_t port)
 {
-	unsigned char *p;
-
-	if (!skb_writable(pskb, data))
-		return -1;
-
-	p = *data + addr->unicastAddress.iPAddress.network;
-
-	ip = ntohl(ip);
-	p[0] = (ip >> 24) & 0xff;
-	p[1] = (ip >> 16) & 0xff;
-	p[2] = (ip >> 8) & 0xff;
-	p[3] = ip & 0xff;
-	p[4] = (port >> 8) & 0xff;
-	p[5] = port & 0xff;
-
-	return 1;
+	return set_addr(pskb, data, dataoff,
+			addr->unicastAddress.iPAddress.network, ip, port);
 }
 
 /****************************************************************************/
@@ -234,7 +171,7 @@ static int set_sig_addr(struct sk_buff *
 				     NIPQUAD(ip), port,
 				     NIPQUAD(ct->tuplehash[!dir].tuple.dst.
 					     ip), info->sig_port[!dir]);
-				return set_h225_addr(pskb, data, &addr[i],
+				return set_h225_addr(pskb, data, 0, &addr[i],
 						     ct->tuplehash[!dir].
 						     tuple.dst.ip,
 						     info->sig_port[!dir]);
@@ -247,7 +184,7 @@ static int set_sig_addr(struct sk_buff *
 				     NIPQUAD(ip), port,
 				     NIPQUAD(ct->tuplehash[!dir].tuple.src.
 					     ip), info->sig_port[!dir]);
-				return set_h225_addr(pskb, data, &addr[i],
+				return set_h225_addr(pskb, data, 0, &addr[i],
 						     ct->tuplehash[!dir].
 						     tuple.src.ip,
 						     info->sig_port[!dir]);
@@ -279,7 +216,7 @@ static int set_ras_addr(struct sk_buff *
 			       NIPQUAD(ct->tuplehash[!dir].tuple.dst.ip),
 			       ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.
 				     port));
-			return set_h225_addr(pskb, data, &addr[i],
+			return set_h225_addr(pskb, data, 0, &addr[i],
 					     ct->tuplehash[!dir].tuple.dst.ip,
 					     ntohs(ct->tuplehash[!dir].tuple.
 						   dst.u.udp.port));
@@ -292,7 +229,7 @@ static int set_ras_addr(struct sk_buff *
 /****************************************************************************/
 static int nat_rtp_rtcp(struct sk_buff **pskb, struct ip_conntrack *ct,
 			enum ip_conntrack_info ctinfo,
-			unsigned char **data,
+			unsigned char **data, unsigned int dataoff,
 			H245_TransportAddress * addr,
 			u_int16_t port, u_int16_t rtp_port,
 			struct ip_conntrack_expect *rtp_exp,
@@ -356,7 +293,8 @@ static int nat_rtp_rtcp(struct sk_buff *
 	}
 
 	/* Modify signal */
-	if (set_h245_addr(pskb, data, addr, ct->tuplehash[!dir].tuple.dst.ip,
+	if (set_h245_addr(pskb, data, dataoff, addr,
+			  ct->tuplehash[!dir].tuple.dst.ip,
 			  (port & 1) ? nated_port + 1 : nated_port) > 0) {
 		/* Save ports */
 		info->rtp_port[i][dir] = rtp_port;
@@ -397,7 +335,7 @@ static void ip_nat_h245_expect(struct ip
 /****************************************************************************/
 static int nat_h245(struct sk_buff **pskb, struct ip_conntrack *ct,
 		    enum ip_conntrack_info ctinfo,
-		    unsigned char **data,
+		    unsigned char **data, unsigned int dataoff,
 		    TransportAddress * addr, u_int16_t port,
 		    struct ip_conntrack_expect *exp)
 {
@@ -428,8 +366,8 @@ static int nat_h245(struct sk_buff **psk
 	}
 
 	/* Modify signal */
-	if (set_h225_addr(pskb, data, addr, ct->tuplehash[!dir].tuple.dst.ip,
-			  nated_port) > 0) {
+	if (set_h225_addr(pskb, data, dataoff, addr,
+			  ct->tuplehash[!dir].tuple.dst.ip, nated_port) > 0) {
 		/* Save ports */
 		info->sig_port[dir] = port;
 		info->sig_port[!dir] = nated_port;
@@ -480,7 +418,7 @@ static void ip_nat_q931_expect(struct ip
 /****************************************************************************/
 static int nat_q931(struct sk_buff **pskb, struct ip_conntrack *ct,
 		    enum ip_conntrack_info ctinfo,
-		    unsigned char **data,
+		    unsigned char **data, unsigned int dataoff,
 		    TransportAddress * addr,
 		    int idx, u_int16_t port, struct ip_conntrack_expect *exp)
 {
@@ -512,7 +450,7 @@ static int nat_q931(struct sk_buff **psk
 	}
 
 	/* Modify signal */
-	if (set_h225_addr(pskb, data, &addr[idx],
+	if (set_h225_addr(pskb, data, dataoff, &addr[idx],
 			  ct->tuplehash[!dir].tuple.dst.ip, nated_port) > 0) {
 		/* Save ports */
 		info->sig_port[dir] = port;
@@ -522,7 +460,7 @@ static int nat_q931(struct sk_buff **psk
 		if (idx > 0 &&
 		    get_h225_addr(*data, &addr[0], &ip, &port) &&
 		    (ntohl(ip) & 0xff000000) == 0x7f000000) {
-			set_h225_addr_hook(pskb, data, &addr[0],
+			set_h225_addr_hook(pskb, data, dataoff, &addr[0],
 					   ct->tuplehash[!dir].tuple.dst.ip,
 					   info->sig_port[!dir]);
 		}
@@ -542,8 +480,6 @@ static int nat_q931(struct sk_buff **psk
 /****************************************************************************/
 static int __init init(void)
 {
-	BUG_ON(recalc_tcp_checksum_hook != NULL);
-	BUG_ON(recalc_udp_checksum_hook != NULL);
 	BUG_ON(set_h245_addr_hook != NULL);
 	BUG_ON(set_h225_addr_hook != NULL);
 	BUG_ON(set_sig_addr_hook != NULL);
@@ -552,8 +488,6 @@ static int __init init(void)
 	BUG_ON(nat_h245_hook != NULL);
 	BUG_ON(nat_q931_hook != NULL);
 
-	recalc_tcp_checksum_hook = recalc_tcp_checksum;
-	recalc_udp_checksum_hook = recalc_udp_checksum;
 	set_h245_addr_hook = set_h245_addr;
 	set_h225_addr_hook = set_h225_addr;
 	set_sig_addr_hook = set_sig_addr;
@@ -568,8 +502,6 @@ static int __init init(void)
 /****************************************************************************/
 static void __exit fini(void)
 {
-	recalc_tcp_checksum_hook = NULL;
-	recalc_udp_checksum_hook = NULL;
 	set_h245_addr_hook = NULL;
 	set_h225_addr_hook = NULL;
 	set_sig_addr_hook = NULL;

--------------050100090903040202050202--
