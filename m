From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 35/39]: PPTP conntrack: clean up debugging cruft
Date: Wed, 20 Sep 2006 10:24:36 +0200 (MEST)
Message-ID: <20060920082528.14636.63573.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: clean up debugging cruft

Also make sure not to hand packets received in an invalid state to the
NAT helper since it will mangle the packet with invalid data.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d76093560bcc1bfe36ef0075661169247fd7a4c1
tree 661cebc886d62079b5ecb798bfcff6d7afc83100
parent d6e07cd63adbc8c291e8166b3e5d4779251ca8a3
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:01 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:01 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |  128 ++++++++++---------------
 1 files changed, 51 insertions(+), 77 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 9a98a6c..7b6d5aa 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -301,7 +301,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 {
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
-	__be16 cid, pcid;
+	__be16 cid = 0, pcid = 0;
 
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
@@ -309,11 +309,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
 		/* server confirms new control session */
-		if (info->sstate < PPTP_SESSION_REQUESTED) {
-			DEBUGP("%s without START_SESS_REQUEST\n",
-				pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate < PPTP_SESSION_REQUESTED)
+			goto invalid;
 		if (pptpReq->srep.resultCode == PPTP_START_OK)
 			info->sstate = PPTP_SESSION_CONFIRMED;
 		else
@@ -322,11 +319,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_STOP_SESSION_REPLY:
 		/* server confirms end of control session */
-		if (info->sstate > PPTP_SESSION_STOPREQ) {
-			DEBUGP("%s without STOP_SESS_REQUEST\n",
-				pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate > PPTP_SESSION_STOPREQ)
+			goto invalid;
 		if (pptpReq->strep.resultCode == PPTP_STOP_OK)
 			info->sstate = PPTP_SESSION_NONE;
 		else
@@ -335,15 +329,12 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_OUT_CALL_REPLY:
 		/* server accepted call, we now expect GRE frames */
-		if (info->sstate != PPTP_SESSION_CONFIRMED) {
-			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
 		if (info->cstate != PPTP_CALL_OUT_REQ &&
-		    info->cstate != PPTP_CALL_OUT_CONF) {
-			DEBUGP("%s without OUTCALL_REQ\n", pptp_msg_name[msg]);
-			break;
-		}
+		    info->cstate != PPTP_CALL_OUT_CONF)
+			goto invalid;
+
 		if (pptpReq->ocack.resultCode != PPTP_OUTCALL_CONNECT) {
 			info->cstate = PPTP_CALL_NONE;
 			break;
@@ -354,11 +345,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 		info->pac_call_id = cid;
 
-		if (info->pns_call_id != pcid) {
-			DEBUGP("%s for unknown callid %u\n",
-				pptp_msg_name[msg], ntohs(pcid));
-			break;
-		}
+		if (info->pns_call_id != pcid)
+			goto invalid;
 
 		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
 			ntohs(cid), ntohs(pcid));
@@ -370,10 +358,9 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_IN_CALL_REQUEST:
 		/* server tells us about incoming call request */
-		if (info->sstate != PPTP_SESSION_CONFIRMED) {
-			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+
 		pcid = pptpReq->icack.peersCallID;
 		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_REQ;
@@ -382,25 +369,17 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_IN_CALL_CONNECT:
 		/* server tells us about incoming call established */
-		if (info->sstate != PPTP_SESSION_CONFIRMED) {
-			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
-			break;
-		}
-		if (info->cstate != PPTP_CALL_IN_REP
-		    && info->cstate != PPTP_CALL_IN_CONF) {
-			DEBUGP("%s but never sent IN_CALL_REPLY\n",
-				pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
+		if (info->cstate != PPTP_CALL_IN_REP &&
+		    info->cstate != PPTP_CALL_IN_CONF)
+			goto invalid;
 
 		pcid = pptpReq->iccon.peersCallID;
 		cid = info->pac_call_id;
 
-		if (info->pns_call_id != pcid) {
-			DEBUGP("%s for unknown CallID %u\n",
-				pptp_msg_name[msg], ntohs(pcid));
-			break;
-		}
+		if (info->pns_call_id != pcid)
+			goto invalid;
 
 		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
@@ -425,18 +404,21 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		/* I don't have to explain these ;) */
 		break;
 	default:
-		DEBUGP("invalid %s (TY=%d)\n", (msg <= PPTP_MSG_MAX)
-			? pptp_msg_name[msg]:pptp_msg_name[0], msg);
-		break;
+		goto invalid;
 	}
 
-
 	if (ip_nat_pptp_hook_inbound)
 		return ip_nat_pptp_hook_inbound(pskb, ct, ctinfo, ctlh,
 						pptpReq);
-
 	return NF_ACCEPT;
 
+invalid:
+	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
+	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
+	return NF_ACCEPT;
 }
 
 static inline int
@@ -449,7 +431,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 {
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
-	__be16 cid, pcid;
+	__be16 cid = 0, pcid = 0;
 
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
@@ -457,10 +439,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
 		/* client requests for new control session */
-		if (info->sstate != PPTP_SESSION_NONE) {
-			DEBUGP("%s but we already have one",
-				pptp_msg_name[msg]);
-		}
+		if (info->sstate != PPTP_SESSION_NONE)
+			goto invalid;
 		info->sstate = PPTP_SESSION_REQUESTED;
 		break;
 	case PPTP_STOP_SESSION_REQUEST:
@@ -470,11 +450,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_OUT_CALL_REQUEST:
 		/* client initiating connection to server */
-		if (info->sstate != PPTP_SESSION_CONFIRMED) {
-			DEBUGP("%s but no session\n",
-				pptp_msg_name[msg]);
-			break;
-		}
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
 		cid = pptpReq->ocreq.callID;
@@ -483,22 +460,17 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		break;
 	case PPTP_IN_CALL_REPLY:
 		/* client answers incoming call */
-		if (info->cstate != PPTP_CALL_IN_REQ
-		    && info->cstate != PPTP_CALL_IN_REP) {
-			DEBUGP("%s without incall_req\n",
-				pptp_msg_name[msg]);
-			break;
-		}
+		if (info->cstate != PPTP_CALL_IN_REQ &&
+		    info->cstate != PPTP_CALL_IN_REP)
+			goto invalid;
+
 		if (pptpReq->icack.resultCode != PPTP_INCALL_ACCEPT) {
 			info->cstate = PPTP_CALL_NONE;
 			break;
 		}
 		pcid = pptpReq->icack.peersCallID;
-		if (info->pac_call_id != pcid) {
-			DEBUGP("%s for unknown call %u\n",
-				pptp_msg_name[msg], ntohs(pcid));
-			break;
-		}
+		if (info->pac_call_id != pcid)
+			goto invalid;
 		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		/* part two of the three-way handshake */
 		info->cstate = PPTP_CALL_IN_REP;
@@ -507,10 +479,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 
 	case PPTP_CALL_CLEAR_REQUEST:
 		/* client requests hangup of call */
-		if (info->sstate != PPTP_SESSION_CONFIRMED) {
-			DEBUGP("CLEAR_CALL but no session\n");
-			break;
-		}
+		if (info->sstate != PPTP_SESSION_CONFIRMED)
+			goto invalid;
 		/* FUTURE: iterate over all calls and check if
 		 * call ID is valid.  We don't do this without newnat,
 		 * because we only know about last call */
@@ -522,16 +492,20 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		/* I don't have to explain these ;) */
 		break;
 	default:
-		DEBUGP("invalid %s (TY=%d)\n", (msg <= PPTP_MSG_MAX)?
-			pptp_msg_name[msg]:pptp_msg_name[0], msg);
-		/* unknown: no need to create GRE masq table entry */
-		break;
+		goto invalid;
 	}
 
 	if (ip_nat_pptp_hook_outbound)
 		return ip_nat_pptp_hook_outbound(pskb, ct, ctinfo, ctlh,
 						 pptpReq);
+	return NF_ACCEPT;
 
+invalid:
+	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
+	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
 }
 
