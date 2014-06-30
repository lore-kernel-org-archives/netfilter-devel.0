From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnetfilter_queue] extra: tcp: insufficient sanitization in nfq_tcp_get_payload()
Date: Mon, 30 Jun 2014 12:33:53 +0200
Message-ID: <1404124433-5910-1-git-send-email-pablo@netfilter.org>
Cc: lantw44@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53312 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaF3KeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:34:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to 7335cbe ("extra: fix wrong implementation in
nfq_udp_get_payload").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/extra/tcp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 2eb5763..bf161aa 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -59,13 +59,17 @@ EXPORT_SYMBOL(nfq_tcp_get_hdr);
  */
 void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 {
-	unsigned int doff = tcph->doff * 4;
+	unsigned int len = tcph->doff * 4;
+
+	/* TCP packet is too short */
+	if (len < sizeof(struct tcphdr))
+		return NULL;
 
 	/* malformed TCP data offset. */
-	if (pktb->transport_header + doff >= pktb->tail)
+	if (pktb->transport_header + len > pktb->tail)
 		return NULL;
 
-	return pktb->transport_header + doff;
+	return pktb->transport_header + len;
 }
 EXPORT_SYMBOL(nfq_tcp_get_payload);
 
-- 
1.7.10.4

