From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft] proto: fix VLAN header definition
Date: Fri, 27 Nov 2015 09:13:34 +0000
Message-ID: <1448615614-16510-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44584 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbbK0JNk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:13:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The VID is located after Priority and CFI.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/proto.h | 4 ++--
 src/proto.c     | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 974116f..d90bccd 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -159,9 +159,9 @@ enum eth_hdr_fields {
 
 enum vlan_hdr_fields {
 	VLANHDR_INVALID,
-	VLANHDR_VID,
-	VLANHDR_CFI,
 	VLANHDR_PCP,
+	VLANHDR_CFI,
+	VLANHDR_VID,
 	VLANHDR_TYPE,
 };
 
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..f2cf297 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -730,9 +730,9 @@ const struct proto_desc proto_vlan = {
 
 	},
 	.templates	= {
-		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 0, 12),
-		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 12, 1),
-		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 13, 3),
+		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 0, 3),
+		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 3, 1),
+		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 4, 12),
 		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
 	},
 };
-- 
2.5.0

