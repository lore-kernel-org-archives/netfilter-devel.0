From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 36/39]: PPTP conntrack: check call ID before changing
	state
Date: Wed, 20 Sep 2006 10:24:38 +0200 (MEST)
Message-ID: <20060920082529.14636.87022.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: check call ID before changing state

For rejected calls the state is set to PPTP_CALL_NONE even for non-matching
call ids.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0b844f188be93039e9b65b91c5e5ca50c8aca1c3
tree bdc9707f013a30c11f1484d1ce54e67980ee78d2
parent d76093560bcc1bfe36ef0075661169247fd7a4c1
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:03 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:03 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   32 ++++++++++---------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 7b6d5aa..5cb6b61 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -335,25 +335,19 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		    info->cstate != PPTP_CALL_OUT_CONF)
 			goto invalid;
 
-		if (pptpReq->ocack.resultCode != PPTP_OUTCALL_CONNECT) {
-			info->cstate = PPTP_CALL_NONE;
-			break;
-		}
-
 		cid = pptpReq->ocack.callID;
 		pcid = pptpReq->ocack.peersCallID;
-
-		info->pac_call_id = cid;
-
 		if (info->pns_call_id != pcid)
 			goto invalid;
-
 		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
 			ntohs(cid), ntohs(pcid));
 
-		info->cstate = PPTP_CALL_OUT_CONF;
-
-		exp_gre(ct, cid, pcid);
+		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
+			info->cstate = PPTP_CALL_OUT_CONF;
+			info->pac_call_id = cid;
+			exp_gre(ct, cid, pcid);
+		} else
+			info->cstate = PPTP_CALL_NONE;
 		break;
 
 	case PPTP_IN_CALL_REQUEST:
@@ -464,17 +458,17 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		    info->cstate != PPTP_CALL_IN_REP)
 			goto invalid;
 
-		if (pptpReq->icack.resultCode != PPTP_INCALL_ACCEPT) {
-			info->cstate = PPTP_CALL_NONE;
-			break;
-		}
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
 		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(pcid));
-		/* part two of the three-way handshake */
-		info->cstate = PPTP_CALL_IN_REP;
-		info->pns_call_id = pcid;
+
+		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
+			/* part two of the three-way handshake */
+			info->cstate = PPTP_CALL_IN_REP;
+			info->pns_call_id = pcid;
+		} else
+			info->cstate = PPTP_CALL_NONE;
 		break;
 
 	case PPTP_CALL_CLEAR_REQUEST:
