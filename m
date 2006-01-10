From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: Fix return value confusion in PPTP NAT helper
Date: Tue, 10 Jan 2006 01:38:42 +0100
Message-ID: <20060110003842.9105.96756.sendpatchset@localhost.localdomain>
References: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix return value confusion in PPTP NAT helper

ip_nat_mangle_tcp_packet doesn't return NF_* values but 0/1 for
failure/success.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1aefffdcf7bb75a1b98b961b25c5a45f12a357a3
tree 49e70e9d824c331414e69ae2abfc481db867de50
parent dd180da32f914c0a56e3d75f84b898db7e2910c3
author Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 21:11:35 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 21:11:35 +0100

 net/ipv4/netfilter/ip_nat_helper_pptp.c |   36 +++++++++++--------------------
 1 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 50960cb..ac00489 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -299,8 +299,6 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	u_int16_t msg, new_cid = 0, new_pcid;
 	unsigned int pcid_off, cid_off = 0;
 
-	int ret = NF_ACCEPT, rv;
-
 	new_pcid = htons(nat_pptp_info->pns_call_id);
 
 	switch (msg = ntohs(ctlh->messageType)) {
@@ -345,32 +343,24 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	/* mangle packet */
 	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
 		ntohs(*(u_int16_t *)pptpReq + pcid_off), ntohs(new_pcid));
-	
-	rv = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
-	                              pcid_off + sizeof(struct pptp_pkt_hdr) +
-				      sizeof(struct PptpControlHeader),
-				      sizeof(new_pcid), (char *)&new_pcid, 
-				      sizeof(new_pcid));
-	if (rv != NF_ACCEPT) 
-		return rv;
+
+	if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+	                             pcid_off + sizeof(struct pptp_pkt_hdr) +
+				     sizeof(struct PptpControlHeader),
+				     sizeof(new_pcid), (char *)&new_pcid,
+				     sizeof(new_pcid)) == 0)
+		return NF_DROP;
 
 	if (new_cid) {
 		DEBUGP("altering call id from 0x%04x to 0x%04x\n",
 			ntohs(*(u_int16_t *)pptpReq + cid_off), ntohs(new_cid));
-		rv = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
-		                              cid_off + sizeof(struct pptp_pkt_hdr) +
-					      sizeof(struct PptpControlHeader),
-					      sizeof(new_cid), (char *)&new_cid, 
-					      sizeof(new_cid));
-		if (rv != NF_ACCEPT)
-			return rv;
+		if (ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+		                             cid_off + sizeof(struct pptp_pkt_hdr) +
+					     sizeof(struct PptpControlHeader),
+					     sizeof(new_cid), (char *)&new_cid,
+					     sizeof(new_cid)) == 0)
+			return NF_DROP;
 	}
-
-	/* check for earlier return value of 'switch' above */
-	if (ret != NF_ACCEPT)
-		return ret;
-
-	/* great, at least we don't need to resize packets */
 	return NF_ACCEPT;
 }
 
