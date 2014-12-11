From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] meta: properly align types in meta_template table
Date: Thu, 11 Dec 2014 22:21:12 +0000
Message-ID: <1418336474-25567-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56500 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbaLKWV0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:21:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't use arbitrary amounts of spaces. The remaining table is
properly aligned, fix the new types.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/meta.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index f33837c..6ff5fc8 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -398,19 +398,19 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",  &pkttype_type,
+	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",   &pkttype_type,
 						BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_CPU]		= META_TEMPLATE("cpu",  &integer_type,
+	[NFT_META_CPU]		= META_TEMPLATE("cpu",	     &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFGROUP]	= META_TEMPLATE("iifgroup", &devgroup_type,
+	[NFT_META_IIFGROUP]	= META_TEMPLATE("iifgroup",  &devgroup_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup", &devgroup_type,
+	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup",  &devgroup_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",  &integer_type,
+	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",    &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 };
-- 
2.1.0

