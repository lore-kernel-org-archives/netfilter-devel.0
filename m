From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH] [NETFILTER] Fix CID offset bug in PPTP NAT helper
Date: Tue, 24 Jan 2006 14:49:37 +0100
Message-ID: <11381105772146-git-send-email-heitzenberger@astaro.com>
References: <1138110577340-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1138110577340-git-send-email-heitzenberger@astaro.com>
To: netfilter-devel@lists.netfilter.org
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

The recent (kernel 2.6.15.1) fix for PPTP NAT helper introduced a
bug - which only appears if DEBUGP is enabled though.

The calculation of the CID offset into a PPTP request struct is
not correct, so that at least not the correct CID is displayed
if DEBUGP is enabled.

This patch corrects CID offset calculation and introduces a #define
for that.

Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>

---

 net/ipv4/netfilter/ip_nat_helper_pptp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

b4a2c7646fb828e47b2f6ed8c7794155204a97a9
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 50960cb..8fe3e34 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -52,6 +52,9 @@
 
 #define IP_NAT_PPTP_VERSION "3.0"
 
+#define REQ_CID(req, off)		(*(u_int16_t *)((char *)(req) + (off)))
+
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
@@ -198,7 +201,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
 	 * down to here */
 	DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-		ntohs(*(u_int16_t *)pptpReq + cid_off), ntohs(new_callid));
+		ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
 
 	/* mangle packet */
 	if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
@@ -344,7 +347,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	/* mangle packet */
 	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
-		ntohs(*(u_int16_t *)pptpReq + pcid_off), ntohs(new_pcid));
+		ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
 	
 	rv = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 	                              pcid_off + sizeof(struct pptp_pkt_hdr) +
@@ -356,7 +359,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 
 	if (new_cid) {
 		DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-			ntohs(*(u_int16_t *)pptpReq + cid_off), ntohs(new_cid));
+			ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_cid));
 		rv = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 		                              cid_off + sizeof(struct pptp_pkt_hdr) +
 					      sizeof(struct PptpControlHeader),
-- 
1.0.GIT
