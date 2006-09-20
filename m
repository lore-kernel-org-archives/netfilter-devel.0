From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/39]: PPTP conntrack: consolidate header parsing
Date: Wed, 20 Sep 2006 10:24:35 +0200 (MEST)
Message-ID: <20060920082527.14636.4594.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: consolidate header parsing

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d6e07cd63adbc8c291e8166b3e5d4779251ca8a3
tree 19a432f34d8660c061cdfa1b7ebcf000972a9cb0
parent d38269d3e44ca6ae4529ed6d0822dae300a8fb87
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:00 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:00 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |  119 ++++++++++---------------
 1 files changed, 47 insertions(+), 72 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 3b5464f..9a98a6c 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -291,60 +291,21 @@ out_unexpect_orig:
 	goto out_put_both;
 }
 
-static const unsigned int pptp_msg_size[] = {
-	[PPTP_START_SESSION_REQUEST]  = sizeof(struct PptpStartSessionRequest),
-	[PPTP_START_SESSION_REPLY]    = sizeof(struct PptpStartSessionReply),
-	[PPTP_STOP_SESSION_REQUEST]   = sizeof(struct PptpStopSessionRequest),
-	[PPTP_STOP_SESSION_REPLY]     = sizeof(struct PptpStopSessionReply),
-	[PPTP_OUT_CALL_REQUEST]       = sizeof(struct PptpOutCallRequest),
-	[PPTP_OUT_CALL_REPLY]	      = sizeof(struct PptpOutCallReply),
-	[PPTP_IN_CALL_REQUEST]	      = sizeof(struct PptpInCallRequest),
-	[PPTP_IN_CALL_REPLY]	      = sizeof(struct PptpInCallReply),
-	[PPTP_IN_CALL_CONNECT]	      = sizeof(struct PptpInCallConnected),
-	[PPTP_CALL_CLEAR_REQUEST]     = sizeof(struct PptpClearCallRequest),
-	[PPTP_CALL_DISCONNECT_NOTIFY] = sizeof(struct PptpCallDisconnectNotify),
-	[PPTP_WAN_ERROR_NOTIFY]	      = sizeof(struct PptpWanErrorNotify),
-	[PPTP_SET_LINK_INFO]	      = sizeof(struct PptpSetLinkInfo),
-};
-
 static inline int
 pptp_inbound_pkt(struct sk_buff **pskb,
-		 struct tcphdr *tcph,
-		 unsigned int nexthdr_off,
-		 unsigned int datalen,
+		 struct PptpControlHeader *ctlh,
+		 union pptp_ctrl_union *pptpReq,
+		 unsigned int reqlen,
 		 struct ip_conntrack *ct,
 		 enum ip_conntrack_info ctinfo)
 {
-	struct PptpControlHeader _ctlh, *ctlh;
-	unsigned int reqlen;
-	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 cid, pcid;
 
-	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
-	if (!ctlh) {
-		DEBUGP("error during skb_header_pointer\n");
-		return NF_ACCEPT;
-	}
-	nexthdr_off += sizeof(_ctlh);
-	datalen -= sizeof(_ctlh);
-
-	reqlen = datalen;
-	if (reqlen > sizeof(*pptpReq))
-		reqlen = sizeof(*pptpReq);
-	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
-	if (!pptpReq) {
-		DEBUGP("error during skb_header_pointer\n");
-		return NF_ACCEPT;
-	}
-
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
 
-	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
-		return NF_ACCEPT;
-
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
 		/* server confirms new control session */
@@ -480,38 +441,19 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 static inline int
 pptp_outbound_pkt(struct sk_buff **pskb,
-		  struct tcphdr *tcph,
-		  unsigned int nexthdr_off,
-		  unsigned int datalen,
+		  struct PptpControlHeader *ctlh,
+		  union pptp_ctrl_union *pptpReq,
+		  unsigned int reqlen,
 		  struct ip_conntrack *ct,
 		  enum ip_conntrack_info ctinfo)
 {
-	struct PptpControlHeader _ctlh, *ctlh;
-	unsigned int reqlen;
-	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 cid, pcid;
 
-	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
-	if (!ctlh)
-		return NF_ACCEPT;
-	nexthdr_off += sizeof(_ctlh);
-	datalen -= sizeof(_ctlh);
-
-	reqlen = datalen;
-	if (reqlen > sizeof(*pptpReq))
-		reqlen = sizeof(*pptpReq);
-	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
-	if (!pptpReq)
-		return NF_ACCEPT;
-
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
 
-	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
-		return NF_ACCEPT;
-
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
 		/* client requests for new control session */
@@ -593,6 +535,21 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	return NF_ACCEPT;
 }
 
+static const unsigned int pptp_msg_size[] = {
+	[PPTP_START_SESSION_REQUEST]  = sizeof(struct PptpStartSessionRequest),
+	[PPTP_START_SESSION_REPLY]    = sizeof(struct PptpStartSessionReply),
+	[PPTP_STOP_SESSION_REQUEST]   = sizeof(struct PptpStopSessionRequest),
+	[PPTP_STOP_SESSION_REPLY]     = sizeof(struct PptpStopSessionReply),
+	[PPTP_OUT_CALL_REQUEST]       = sizeof(struct PptpOutCallRequest),
+	[PPTP_OUT_CALL_REPLY]	      = sizeof(struct PptpOutCallReply),
+	[PPTP_IN_CALL_REQUEST]	      = sizeof(struct PptpInCallRequest),
+	[PPTP_IN_CALL_REPLY]	      = sizeof(struct PptpInCallReply),
+	[PPTP_IN_CALL_CONNECT]	      = sizeof(struct PptpInCallConnected),
+	[PPTP_CALL_CLEAR_REQUEST]     = sizeof(struct PptpClearCallRequest),
+	[PPTP_CALL_DISCONNECT_NOTIFY] = sizeof(struct PptpCallDisconnectNotify),
+	[PPTP_WAN_ERROR_NOTIFY]	      = sizeof(struct PptpWanErrorNotify),
+	[PPTP_SET_LINK_INFO]	      = sizeof(struct PptpSetLinkInfo),
+};
 
 /* track caller id inside control connection, call expect_related */
 static int
@@ -600,16 +557,17 @@ conntrack_pptp_help(struct sk_buff **psk
 		    struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 
 {
-	struct pptp_pkt_hdr _pptph, *pptph;
-	struct tcphdr _tcph, *tcph;
-	u_int32_t tcplen = (*pskb)->len - (*pskb)->nh.iph->ihl * 4;
-	u_int32_t datalen;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
-	unsigned int nexthdr_off;
-
+	struct tcphdr _tcph, *tcph;
+	struct pptp_pkt_hdr _pptph, *pptph;
+	struct PptpControlHeader _ctlh, *ctlh;
+	union pptp_ctrl_union _pptpReq, *pptpReq;
+	unsigned int tcplen = (*pskb)->len - (*pskb)->nh.iph->ihl * 4;
+	unsigned int datalen, reqlen, nexthdr_off;
 	int oldsstate, oldcstate;
 	int ret;
+	u_int16_t msg;
 
 	/* don't do any tracking before tcp handshake complete */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -648,6 +606,23 @@ conntrack_pptp_help(struct sk_buff **psk
 		return NF_ACCEPT;
 	}
 
+	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
+	if (!ctlh)
+		return NF_ACCEPT;
+	nexthdr_off += sizeof(_ctlh);
+	datalen -= sizeof(_ctlh);
+
+	reqlen = datalen;
+	msg = ntohs(ctlh->messageType);
+	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
+		return NF_ACCEPT;
+	if (reqlen > sizeof(*pptpReq))
+		reqlen = sizeof(*pptpReq);
+
+	pptpReq = skb_header_pointer(*pskb, nexthdr_off, reqlen, &_pptpReq);
+	if (!pptpReq)
+		return NF_ACCEPT;
+
 	oldsstate = info->sstate;
 	oldcstate = info->cstate;
 
@@ -657,11 +632,11 @@ conntrack_pptp_help(struct sk_buff **psk
 	 * established from PNS->PAC.  However, RFC makes no guarantee */
 	if (dir == IP_CT_DIR_ORIGINAL)
 		/* client -> server (PNS -> PAC) */
-		ret = pptp_outbound_pkt(pskb, tcph, nexthdr_off, datalen, ct,
+		ret = pptp_outbound_pkt(pskb, ctlh, pptpReq, reqlen, ct,
 					ctinfo);
 	else
 		/* server -> client (PAC -> PNS) */
-		ret = pptp_inbound_pkt(pskb, tcph, nexthdr_off, datalen, ct,
+		ret = pptp_inbound_pkt(pskb, ctlh, pptpReq, reqlen, ct,
 				       ctinfo);
 	DEBUGP("sstate: %d->%d, cstate: %d->%d\n",
 		oldsstate, info->sstate, oldcstate, info->cstate);
