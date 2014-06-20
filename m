From: lantw44@gmail.com
Subject: [PATCH 3/3] extra: fix wrong implementation in nfq_udp_get_payload_len
Date: Fri, 20 Jun 2014 18:27:01 +0800
Message-ID: <1403260021-8732-3-git-send-email-lantw44@gmail.com>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Cc: Ting-Wei Lan <lantw44@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45137 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966458AbaFTK1Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:27:16 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so2866590pdj.29
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 03:27:16 -0700 (PDT)
In-Reply-To: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ting-Wei Lan <lantw44@gmail.com>

---
 src/extra/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index 2a17a2f..64d3db4 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(nfq_udp_get_payload);
  */
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
-	return pktb->tail - pktb->transport_header;
+	return pktb->tail - pktb->transport_header - sizeof(struct udphdr);
 }
 EXPORT_SYMBOL(nfq_udp_get_payload_len);
 
-- 
1.9.3

