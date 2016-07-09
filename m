From: Toby DiPasquale <toby@cbcg.net>
Subject: [PATCH] fix off-by-one in DecodeQ931
Date: Sat, 9 Jul 2016 19:26:38 +0000 (UTC)
Message-ID: <57814fde.87a2370a.19369.49af@mx.google.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35623 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbcGIT0Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 15:26:24 -0400
Received: by mail-qk0-f193.google.com with SMTP id q62so613649qkf.2
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Jul 2016 12:26:23 -0700 (PDT)
Date: Sun, 13 Jul 2016 14:59:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fix off-by-one in DecodeQ931

This patch corrects an off-by-one error in the DecodeQ931 function in
the nf_conntrack_h323 module. This error could result in reading off
the end of a Q.931 frame.

Signed-off-by: Toby DiPasquale <toby@cbcg.net>

---
 net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index bcd5ed6..89b2e46 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -846,9 +846,10 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 	sz -= len;
 
 	/* Message Type */
-	if (sz < 1)
+	if (sz < 2)
 		return H323_ERROR_BOUND;
 	q931->MessageType = *p++;
+	sz--;
 	PRINT("MessageType = %02X\n", q931->MessageType);
 	if (*p & 0x80) {
 		p++;
-- 
2.7.4

