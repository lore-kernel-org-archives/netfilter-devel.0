From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 37/39]: PPTP conntrack: fix PPTP_IN_CALL message types
Date: Wed, 20 Sep 2006 10:24:39 +0200 (MEST)
Message-ID: <20060920082530.14636.33249.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: fix PPTP_IN_CALL message types

Fix incorrectly used message types and call IDs:

- PPTP_IN_CALL_REQUEST (PAC->PNS) contains a PptpInCallRequest (icreq)
  message and the PAC call ID

- PPTP_IN_CALL_REPLY (PNS->PAC) contains a PptpInCallReply (icack)
  message and the PNS call ID

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ba51b5a0b572b684c58b32391335d4a3e4a67c0b
tree 1109a5e88bb01dfa43d43042c85ef2d1be1a52e5
parent 0b844f188be93039e9b65b91c5e5ca50c8aca1c3
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:04 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:04 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   12 +++++++-----
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 5cb6b61..b0225b6 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -355,10 +355,10 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		if (info->sstate != PPTP_SESSION_CONFIRMED)
 			goto invalid;
 
-		pcid = pptpReq->icack.peersCallID;
-		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		cid = pptpReq->icreq.callID;
+		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_IN_REQ;
-		info->pac_call_id = pcid;
+		info->pac_call_id = cid;
 		break;
 
 	case PPTP_IN_CALL_CONNECT:
@@ -458,15 +458,17 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		    info->cstate != PPTP_CALL_IN_REP)
 			goto invalid;
 
+		cid = pptpReq->icack.callID;
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		DEBUGP("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+		       ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
 			/* part two of the three-way handshake */
 			info->cstate = PPTP_CALL_IN_REP;
-			info->pns_call_id = pcid;
+			info->pns_call_id = cid;
 		} else
 			info->cstate = PPTP_CALL_NONE;
 		break;
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 84f6bd0..2ff5788 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -172,7 +172,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		ct_pptp_info->pns_call_id = new_callid;
 		break;
 	case PPTP_IN_CALL_REPLY:
-		cid_off = offsetof(union pptp_ctrl_union, icreq.callID);
+		cid_off = offsetof(union pptp_ctrl_union, icack.callID);
 		break;
 	case PPTP_CALL_CLEAR_REQUEST:
 		cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
