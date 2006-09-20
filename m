From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/39]: PPTP conntrack: remove unnecessary cid/pcid
	header pointers
Date: Wed, 20 Sep 2006 10:24:31 +0200 (MEST)
Message-ID: <20060920082523.14636.9137.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: remove unnecessary cid/pcid header pointers

Just the values are needed, not the memory locations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3a6a0d83459e3dc898f2b81eda4be07e5b3dc858
tree 6b232a4b768e2c48efd2d97cb756e924dd643c92
parent d6d938738d5bea57063ead3a04405f0f729b99c3
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:56 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:56 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   56 +++++++++++++------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 1a8da90..5f7af6e 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -334,7 +334,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
-	__be16 *cid, *pcid;
+	__be16 cid, pcid;
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh) {
@@ -414,23 +414,23 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 			break;
 		}
 
-		cid = &pptpReq->ocack.callID;
-		pcid = &pptpReq->ocack.peersCallID;
+		cid = pptpReq->ocack.callID;
+		pcid = pptpReq->ocack.peersCallID;
 
-		info->pac_call_id = *cid;
+		info->pac_call_id = cid;
 
-		if (info->pns_call_id != *pcid) {
+		if (info->pns_call_id != pcid) {
 			DEBUGP("%s for unknown callid %u\n",
-				pptp_msg_name[msg], ntohs(*pcid));
+				pptp_msg_name[msg], ntohs(pcid));
 			break;
 		}
 
 		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
-			ntohs(*cid), ntohs(*pcid));
+			ntohs(cid), ntohs(pcid));
 
 		info->cstate = PPTP_CALL_OUT_CONF;
 
-		exp_gre(ct, *cid, *pcid);
+		exp_gre(ct, cid, pcid);
 		break;
 
 	case PPTP_IN_CALL_REQUEST:
@@ -444,10 +444,10 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
 			break;
 		}
-		pcid = &pptpReq->icack.peersCallID;
-		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(*pcid));
+		pcid = pptpReq->icack.peersCallID;
+		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_REQ;
-		info->pac_call_id = *pcid;
+		info->pac_call_id = pcid;
 		break;
 
 	case PPTP_IN_CALL_CONNECT:
@@ -468,20 +468,20 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 			break;
 		}
 
-		pcid = &pptpReq->iccon.peersCallID;
-		cid = &info->pac_call_id;
+		pcid = pptpReq->iccon.peersCallID;
+		cid = info->pac_call_id;
 
-		if (info->pns_call_id != *pcid) {
+		if (info->pns_call_id != pcid) {
 			DEBUGP("%s for unknown CallID %u\n",
-				pptp_msg_name[msg], ntohs(*pcid));
+				pptp_msg_name[msg], ntohs(pcid));
 			break;
 		}
 
-		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(*pcid));
+		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
-		exp_gre(ct, *cid, *pcid);
+		exp_gre(ct, cid, pcid);
 		break;
 
 	case PPTP_CALL_DISCONNECT_NOTIFY:
@@ -491,8 +491,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		}
 
 		/* server confirms disconnect */
-		cid = &pptpReq->disc.callID;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(*cid));
+		cid = pptpReq->disc.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
@@ -534,7 +534,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	union pptp_ctrl_union _pptpReq, *pptpReq;
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
-	__be16 *cid, *pcid;
+	__be16 cid, pcid;
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh)
@@ -580,9 +580,9 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		}
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
-		cid = &pptpReq->ocreq.callID;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(*cid));
-		info->pns_call_id = *cid;
+		cid = pptpReq->ocreq.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		info->pns_call_id = cid;
 		break;
 	case PPTP_IN_CALL_REPLY:
 		if (reqlen < sizeof(_pptpReq.icack)) {
@@ -601,16 +601,16 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 			info->cstate = PPTP_CALL_NONE;
 			break;
 		}
-		pcid = &pptpReq->icack.peersCallID;
-		if (info->pac_call_id != *pcid) {
+		pcid = pptpReq->icack.peersCallID;
+		if (info->pac_call_id != pcid) {
 			DEBUGP("%s for unknown call %u\n",
-				pptp_msg_name[msg], ntohs(*pcid));
+				pptp_msg_name[msg], ntohs(pcid));
 			break;
 		}
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(*pcid));
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		/* part two of the three-way handshake */
 		info->cstate = PPTP_CALL_IN_REP;
-		info->pns_call_id = pptpReq->icack.callID;
+		info->pns_call_id = pcid;
 		break;
 
 	case PPTP_CALL_CLEAR_REQUEST:
