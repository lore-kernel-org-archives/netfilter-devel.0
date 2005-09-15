From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 7/8]: pptp helper: clean up conntrack_pptp_help() a bit
Date: Fri, 16 Sep 2005 00:44:57 +0200
Message-ID: <4329F969.8060401@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="07.diff"
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

[NETFILTER]: pptp helper: clean up conntrack_pptp_help() a bit

- The tcp header is already fully validated by TCP connection tracking,
  no need to redo it
- Remove unused variable datalimit
- move nexthdr_off adjustment next to header parsing, use it where
  possible
- also adjust datalen as the packet is parsed instead of calculating
  how much was already parsed in later functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ac7e4424f98eef582b9923011d27c208252a0096
tree bc92def0c43e47effa8b32a904e598058fc1f302
parent 2834891111a5574444e4af9a6b1fd496a3359f2b
author Patrick McHardy <kaber@trash.net> Fri, 16 Sep 2005 00:18:40 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 16 Sep 2005 00:18:40 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   65 ++++++++-----------------
 1 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -311,8 +311,8 @@ out_unexpect_orig:
 static inline int 
 pptp_inbound_pkt(struct sk_buff **pskb,
 		 struct tcphdr *tcph,
-		 unsigned int ctlhoff,
-		 size_t datalen,
+		 unsigned int nexthdr_off,
+		 unsigned int datalen,
 		 struct ip_conntrack *ct,
 		 enum ip_conntrack_info ctinfo)
 {
@@ -323,18 +323,19 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	u_int16_t msg, *cid, *pcid;
 	u_int32_t seq;	
 
-	ctlh = skb_header_pointer(*pskb, ctlhoff, sizeof(_ctlh), &_ctlh);
-	if (unlikely(!ctlh)) {
+	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
+	if (!ctlh) {
 		DEBUGP("error during skb_header_pointer\n");
 		return NF_ACCEPT;
 	}
+	nexthdr_off += sizeof(_ctlh);
+	datalen -= sizeof(_ctlh);
 
-	reqlen = datalen - sizeof(struct pptp_pkt_hdr) - sizeof(_ctlh);
+	reqlen = datalen;
 	if (reqlen > sizeof(*pptpReq))
 		reqlen = sizeof(*pptpReq);
-	pptpReq = skb_header_pointer(*pskb, ctlhoff+sizeof(_ctlh),
-				     reqlen, &_pptpReq);
-	if (unlikely(!pptpReq)) {
+	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
+	if (!pptpReq) {
 		DEBUGP("error during skb_header_pointer\n");
 		return NF_ACCEPT;
 	}
@@ -521,8 +522,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 static inline int
 pptp_outbound_pkt(struct sk_buff **pskb,
 		  struct tcphdr *tcph,
-		  unsigned int ctlhoff,
-		  size_t datalen,
+		  unsigned int nexthdr_off,
+		  unsigned int datalen,
 		  struct ip_conntrack *ct,
 		  enum ip_conntrack_info ctinfo)
 {
@@ -532,15 +533,16 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg, *cid, *pcid;
 
-	ctlh = skb_header_pointer(*pskb, ctlhoff, sizeof(_ctlh), &_ctlh);
+	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh)
 		return NF_ACCEPT;
+	nexthdr_off += sizeof(_ctlh);
+	datalen -= sizeof(_ctlh);
 	
-	reqlen = datalen - sizeof(struct pptp_pkt_hdr) - sizeof(_ctlh);
+	reqlen = datalen;
 	if (reqlen > sizeof(*pptpReq))
 		reqlen = sizeof(*pptpReq);
-	pptpReq = skb_header_pointer(*pskb, ctlhoff+sizeof(_ctlh), reqlen, 
-				     &_pptpReq);
+	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
 	if (!pptpReq)
 		return NF_ACCEPT;
 
@@ -647,11 +649,9 @@ conntrack_pptp_help(struct sk_buff **psk
 
 {
 	struct pptp_pkt_hdr _pptph, *pptph;
-	
 	struct tcphdr _tcph, *tcph;
 	u_int32_t tcplen = (*pskb)->len - (*pskb)->nh.iph->ihl * 4;
 	u_int32_t datalen;
-	void *datalimit;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	unsigned int nexthdr_off;
@@ -667,29 +667,11 @@ conntrack_pptp_help(struct sk_buff **psk
 	}
 	
 	nexthdr_off = (*pskb)->nh.iph->ihl*4;
-	tcph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4, sizeof(_tcph),
-				  &_tcph);
-	if (!tcph)
-		return NF_ACCEPT;
-
-	/* not a complete TCP header? */
-	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4) {
-		DEBUGP("tcplen = %u\n", tcplen);
-		return NF_ACCEPT;
-	}
-
-
+	tcph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_tcph), &_tcph);
+	BUG_ON(!tcph);
+	nexthdr_off += tcph->doff * 4;
  	datalen = tcplen - tcph->doff * 4;
 
-	/* checksum invalid? */
-	if (tcp_v4_check(tcph, tcplen, (*pskb)->nh.iph->saddr,
-			 (*pskb)->nh.iph->daddr,
-			 csum_partial((char *) tcph, tcplen, 0))) {
-		DEBUGP(" bad csum\n");
-		/* W2K PPTP server sends TCP packets with wrong checksum :(( */
-		/* return NF_ACCEPT */
-	}
-
 	if (tcph->fin || tcph->rst) {
 		DEBUGP("RST/FIN received, timeouting GRE\n");
 		/* can't do this after real newnat */
@@ -699,15 +681,13 @@ conntrack_pptp_help(struct sk_buff **psk
 		pptp_timeout_related(ct);
 	}
 
-	nexthdr_off += tcph->doff*4;
-	pptph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4 + tcph->doff*4,
-				   sizeof(_pptph), &_pptph);
+	pptph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_pptph), &_pptph);
 	if (!pptph) {
 		DEBUGP("no full PPTP header, can't track\n");
 		return NF_ACCEPT;
 	}
-
-	datalimit = (void *) pptph + datalen;
+	nexthdr_off += sizeof(_pptph);
+	datalen -= sizeof(_pptph);
 
 	/* if it's not a control message we can't do anything with it */
 	if (ntohs(pptph->packetType) != PPTP_PACKET_CONTROL ||
@@ -721,7 +701,6 @@ conntrack_pptp_help(struct sk_buff **psk
 
 	spin_lock_bh(&ip_pptp_lock);
 
-	nexthdr_off += sizeof(_pptph);
 	/* FIXME: We just blindly assume that the control connection is always
 	 * established from PNS->PAC.  However, RFC makes no guarantee */
 	if (dir == IP_CT_DIR_ORIGINAL)
