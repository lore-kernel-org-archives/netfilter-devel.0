From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/39]: PPTP conntrack: consolidate header size checks
Date: Wed, 20 Sep 2006 10:24:34 +0200 (MEST)
Message-ID: <20060920082525.14636.22337.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: consolidate header size checks

Also make sure not to pass undersized messages to the NAT helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d38269d3e44ca6ae4529ed6d0822dae300a8fb87
tree 12aa473b01b221f5e3eab3150084273c66029069
parent 5bf78ee628377db21c4a025e6c4e4955c581af1d
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:59 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:59 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   65 ++++++++-----------------
 1 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 57eac6e..3b5464f 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -291,6 +291,22 @@ out_unexpect_orig:
 	goto out_put_both;
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
+
 static inline int
 pptp_inbound_pkt(struct sk_buff **pskb,
 		 struct tcphdr *tcph,
@@ -326,13 +342,11 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
 
+	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
+		return NF_ACCEPT;
+
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
-		if (reqlen < sizeof(_pptpReq.srep)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server confirms new control session */
 		if (info->sstate < PPTP_SESSION_REQUESTED) {
 			DEBUGP("%s without START_SESS_REQUEST\n",
@@ -346,11 +360,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_STOP_SESSION_REPLY:
-		if (reqlen < sizeof(_pptpReq.strep)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server confirms end of control session */
 		if (info->sstate > PPTP_SESSION_STOPREQ) {
 			DEBUGP("%s without STOP_SESS_REQUEST\n",
@@ -364,11 +373,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_OUT_CALL_REPLY:
-		if (reqlen < sizeof(_pptpReq.ocack)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server accepted call, we now expect GRE frames */
 		if (info->sstate != PPTP_SESSION_CONFIRMED) {
 			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
@@ -404,11 +408,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_IN_CALL_REQUEST:
-		if (reqlen < sizeof(_pptpReq.icack)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server tells us about incoming call request */
 		if (info->sstate != PPTP_SESSION_CONFIRMED) {
 			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
@@ -421,11 +420,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_IN_CALL_CONNECT:
-		if (reqlen < sizeof(_pptpReq.iccon)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server tells us about incoming call established */
 		if (info->sstate != PPTP_SESSION_CONFIRMED) {
 			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
@@ -455,11 +449,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_CALL_DISCONNECT_NOTIFY:
-		if (reqlen < sizeof(_pptpReq.disc)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* server confirms disconnect */
 		cid = pptpReq->disc.callID;
 		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
@@ -470,8 +459,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_WAN_ERROR_NOTIFY:
-		break;
-
 	case PPTP_ECHO_REQUEST:
 	case PPTP_ECHO_REPLY:
 		/* I don't have to explain these ;) */
@@ -522,6 +509,9 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
 
+	if (msg > 0 && msg <= PPTP_MSG_MAX && reqlen < pptp_msg_size[msg])
+		return NF_ACCEPT;
+
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
 		/* client requests for new control session */
@@ -537,11 +527,6 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		break;
 
 	case PPTP_OUT_CALL_REQUEST:
-		if (reqlen < sizeof(_pptpReq.ocreq)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* client initiating connection to server */
 		if (info->sstate != PPTP_SESSION_CONFIRMED) {
 			DEBUGP("%s but no session\n",
@@ -555,11 +540,6 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		info->pns_call_id = cid;
 		break;
 	case PPTP_IN_CALL_REPLY:
-		if (reqlen < sizeof(_pptpReq.icack)) {
-			DEBUGP("%s: short packet\n", pptp_msg_name[msg]);
-			break;
-		}
-
 		/* client answers incoming call */
 		if (info->cstate != PPTP_CALL_IN_REQ
 		    && info->cstate != PPTP_CALL_IN_REP) {
@@ -595,7 +575,6 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		info->cstate = PPTP_CALL_CLEAR_REQ;
 		break;
 	case PPTP_SET_LINK_INFO:
-		break;
 	case PPTP_ECHO_REQUEST:
 	case PPTP_ECHO_REPLY:
 		/* I don't have to explain these ;) */
