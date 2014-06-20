From: lantw44@gmail.com
Subject: [PATCH 2/3] extra: fix wrong implementation in nfq_udp_get_payload
Date: Fri, 20 Jun 2014 18:27:00 +0800
Message-ID: <1403260021-8732-2-git-send-email-lantw44@gmail.com>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Cc: Ting-Wei Lan <lantw44@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44316 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966458AbaFTK1O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:27:14 -0400
Received: by mail-pd0-f171.google.com with SMTP id fp1so2833384pdb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 03:27:13 -0700 (PDT)
In-Reply-To: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ting-Wei Lan <lantw44@gmail.com>

---
 src/extra/udp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index eee732e..2a17a2f 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -56,13 +56,17 @@ EXPORT_SYMBOL(nfq_udp_get_hdr);
  */
 void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 {
-	unsigned int doff = udph->len;
+	uint16_t len = ntohs (udph->len);
 
-	/* malformed UDP data offset. */
-	if (pktb->transport_header + doff > pktb->tail)
+	/* the UDP packet is too short. */
+	if (len < sizeof(struct udphdr))
 		return NULL;
 
-	return pktb->transport_header + doff;
+	/* malformed UDP packet. */
+	if (pktb->transport_header + len > pktb->tail)
+		return NULL;
+
+	return pktb->transport_header + sizeof(struct udphdr);
 }
 EXPORT_SYMBOL(nfq_udp_get_payload);
 
-- 
1.9.3

