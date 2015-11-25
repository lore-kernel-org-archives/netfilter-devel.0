From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft] proto: fix arpop symbol table endianess
Date: Wed, 25 Nov 2015 15:30:23 +0000
Message-ID: <1448465423-29293-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:58105 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752321AbbKYPad (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 10:30:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The symbols need to be in big endian.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/proto.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 28b93cb..51c643c 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -663,13 +663,13 @@ const struct proto_desc proto_inet_service = {
 
 static const struct symbol_table arpop_tbl = {
 	.symbols	= {
-		SYMBOL("request",	ARPOP_REQUEST),
-		SYMBOL("reply",		ARPOP_REPLY),
-		SYMBOL("rrequest",	ARPOP_RREQUEST),
-		SYMBOL("rreply",	ARPOP_RREPLY),
-		SYMBOL("inrequest",	ARPOP_InREQUEST),
-		SYMBOL("inreply",	ARPOP_InREPLY),
-		SYMBOL("nak",		ARPOP_NAK),
+		SYMBOL("request",	__constant_htons(ARPOP_REQUEST)),
+		SYMBOL("reply",		__constant_htons(ARPOP_REPLY)),
+		SYMBOL("rrequest",	__constant_htons(ARPOP_RREQUEST)),
+		SYMBOL("rreply",	__constant_htons(ARPOP_RREPLY)),
+		SYMBOL("inrequest",	__constant_htons(ARPOP_InREQUEST)),
+		SYMBOL("inreply",	__constant_htons(ARPOP_InREPLY)),
+		SYMBOL("nak",		__constant_htons(ARPOP_NAK)),
 		SYMBOL_LIST_END
 	},
 };
-- 
2.5.0

