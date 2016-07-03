From: Toby DiPasquale <toby@cbcg.net>
Subject: [PATCH] fix off-by-one in DecodeQ931
Date: Sun, 3 Jul 2016 19:01:01 +0000 (UTC)
Message-ID: <577960db.564e370a.24a9.375a@mx.google.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34130 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbcGCTAp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 15:00:45 -0400
Received: by mail-qk0-f195.google.com with SMTP id j2so30748525qkf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Jul 2016 12:00:45 -0700 (PDT)
Date: Sun, 13 Jul 2016 14:59:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

