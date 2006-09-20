From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/39]: PPTP conntrack: remove dead code
Date: Wed, 20 Sep 2006 10:24:27 +0200 (MEST)
Message-ID: <20060920082519.14636.30925.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: remove dead code

The call ID in reply packets is never changed, remove the code.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d263f9e4341b81008f743428b00674aeeb36f63c
tree 5576686063a9d88b2bcef4e80734bbb98b2da145
parent a1495e7210e4ed162b958b06ffe11623bd0a2b0a
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:52 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:52 +0200

 net/ipv4/netfilter/ip_nat_helper_pptp.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 6e8bd6b..0f5e753 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -296,16 +296,15 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		 union pptp_ctrl_union *pptpReq)
 {
 	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
-	u_int16_t msg, new_cid = 0;
+	u_int16_t msg;
 	__be16 new_pcid;
-	unsigned int pcid_off, cid_off = 0;
+	unsigned int pcid_off;
 
 	new_pcid = nat_pptp_info->pns_call_id;
 
 	switch (msg = ntohs(ctlh->messageType)) {
 	case PPTP_OUT_CALL_REPLY:
 		pcid_off = offsetof(union pptp_ctrl_union, ocack.peersCallID);
-		cid_off = offsetof(union pptp_ctrl_union, ocack.callID);
 		break;
 	case PPTP_IN_CALL_CONNECT:
 		pcid_off = offsetof(union pptp_ctrl_union, iccon.peersCallID);
@@ -351,17 +350,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 				     sizeof(new_pcid), (char *)&new_pcid,
 				     sizeof(new_pcid)) == 0)
 		return NF_DROP;
-
-	if (new_cid) {
-		DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-			ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_cid));
-		if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
-		                             cid_off + sizeof(struct pptp_pkt_hdr) +
-					     sizeof(struct PptpControlHeader),
-					     sizeof(new_cid), (char *)&new_cid,
-					     sizeof(new_cid)) == 0)
-			return NF_DROP;
-	}
 	return NF_ACCEPT;
 }
 
