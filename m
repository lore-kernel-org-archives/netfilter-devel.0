From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/39]: PPTP conntrack: remove more dead code
Date: Wed, 20 Sep 2006 10:24:29 +0200 (MEST)
Message-ID: <20060920082520.14636.85156.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: remove more dead code

The calculated sequence numbers are not used for anything.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 079c04abd728cd903f44bb1db0a0e835cf23e8b5
tree 8fb3b96f07ddfec21ea94223c9319a42191109bc
parent d263f9e4341b81008f743428b00674aeeb36f63c
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:53 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:53 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 57637ca..0510ee5 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -220,7 +220,6 @@ static void pptp_destroy_siblings(struct
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
 static inline int
 exp_gre(struct ip_conntrack *master,
-	u_int32_t seq,
 	__be16 callid,
 	__be16 peer_callid)
 {
@@ -336,7 +335,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 *cid, *pcid;
-	u_int32_t seq;
 
 	ctlh = skb_header_pointer(*pskb, nexthdr_off, sizeof(_ctlh), &_ctlh);
 	if (!ctlh) {
@@ -432,12 +430,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 		info->cstate = PPTP_CALL_OUT_CONF;
 
-		seq = ntohl(tcph->seq) + sizeof(struct pptp_pkt_hdr)
-				       + sizeof(struct PptpControlHeader)
-				       + ((void *)pcid - (void *)pptpReq);
-
-		if (exp_gre(ct, seq, *cid, *pcid) != 0)
-			printk("ip_conntrack_pptp: error during exp_gre\n");
+		exp_gre(ct, *cid, *pcid);
 		break;
 
 	case PPTP_IN_CALL_REQUEST:
@@ -488,13 +481,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
-		seq = ntohl(tcph->seq) + sizeof(struct pptp_pkt_hdr)
-				       + sizeof(struct PptpControlHeader)
-				       + ((void *)pcid - (void *)pptpReq);
-
-		if (exp_gre(ct, seq, *cid, *pcid) != 0)
-			printk("ip_conntrack_pptp: error during exp_gre\n");
-
+		exp_gre(ct, *cid, *pcid);
 		break;
 
 	case PPTP_CALL_DISCONNECT_NOTIFY:
