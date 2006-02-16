From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/13]: Fix CID offset bug in PPTP NAT helper debug
	message
Date: Thu, 16 Feb 2006 22:32:08 +0100 (MET)
Message-ID: <20060216213208.6933.29247.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix CID offset bug in PPTP NAT helper debug message

The recent (kernel 2.6.15.1) fix for PPTP NAT helper introduced a
bug - which only appears if DEBUGP is enabled though.

The calculation of the CID offset into a PPTP request struct is
not correct, so that at least not the correct CID is displayed
if DEBUGP is enabled.

This patch corrects CID offset calculation and introduces a #define
for that.

Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d4f037506a5832b329930b927309e911fd42ee4d
tree c36fe915a018b64aa9db28c72a50ff53fa408e91
parent 43fa6235163124c797a94a4fc1703d38335309a7
author Holger Eitzenberger <heitzenberger@astaro.com> Thu, 16 Feb 2006 14:16:59 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:16:59 +0100

 net/ipv4/netfilter/ip_nat_helper_pptp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index ac00489..b9c016c 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -52,6 +52,8 @@
 
 #define IP_NAT_PPTP_VERSION "3.0"
 
+#define REQ_CID(req, off)		(*(u_int16_t *)((char *)(req) + (off)))
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
@@ -198,7 +200,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
 	 * down to here */
 	DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-		ntohs(*(u_int16_t *)pptpReq + cid_off), ntohs(new_callid));
+		ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
 
 	/* mangle packet */
 	if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
@@ -342,7 +344,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	/* mangle packet */
 	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
-		ntohs(*(u_int16_t *)pptpReq + pcid_off), ntohs(new_pcid));
+		ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
 
 	if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 	                             pcid_off + sizeof(struct pptp_pkt_hdr) +
@@ -353,7 +355,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	if (new_cid) {
 		DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-			ntohs(*(u_int16_t *)pptpReq + cid_off), ntohs(new_cid));
+			ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_cid));
 		if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 		                             cid_off + sizeof(struct pptp_pkt_hdr) +
 					     sizeof(struct PptpControlHeader),
