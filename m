From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] parser: fix ether keyword clash
Date: Fri, 11 Apr 2014 15:51:11 +0200
Message-ID: <1397224271-4507-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33237 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaDKNv2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:51:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Due to the renaming of the "eth" keyword to "ether", parsing of arphrd
type "ether" fails.

Fix similar to TCP, UDP etc by allocating a constant arphrd expression for
the ether keyword without a following key.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/parser.y b/src/parser.y
index af34857..de5c0ed 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1639,6 +1639,13 @@ eth_hdr_expr		:	ETHER	eth_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_eth, $2);
 			}
+			|	ETHER
+			{
+				uint16_t data = ARPHRD_ETHER;
+				$$ = constant_expr_alloc(&@$, &arphrd_type,
+							 BYTEORDER_BIG_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 eth_hdr_field		:	SADDR		{ $$ = ETHHDR_SADDR; }
-- 
1.9.0

