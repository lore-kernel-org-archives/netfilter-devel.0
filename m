From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] payload: fix ethernet type protocol matching
Date: Sun,  3 Nov 2013 20:46:54 +0100
Message-ID: <1383508014-22185-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59508 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3KCTrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 14:47:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes ethernet type protocol matching, which is needed
to match network layer information, eg.

 nft add rule bridge filter input ip protocol icmp counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index 0d22360..ea0d4e2 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1010,7 +1010,7 @@ const struct datatype ethertype_type = {
 	.type		= TYPE_ETHERTYPE,
 	.name		= "ethertype",
 	.desc		= "Ethernet protocol",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.basefmt	= "0x%.4Zx",
-- 
1.7.10.4

