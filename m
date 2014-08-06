From: Valentina Giusti <valentina.giusti@microon.de>
Subject: [PATCH 3/3] nftables: add support for cpu meta attribute
Date: Wed,  6 Aug 2014 23:59:52 +0200
Message-ID: <1407362392-24837-4-git-send-email-valentina.giusti@microon.de>
References: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
To: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:54653 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753900AbaHFWGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:06:13 -0400
In-Reply-To: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/meta.c                          | 2 ++
 src/parser.y                        | 2 ++
 src/scanner.l                       | 1 +
 4 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a5f8ec0..67e6ec0 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -535,6 +535,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_CPU: cpu handling the packet
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -556,6 +557,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 80f88ff..77ed035 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -338,6 +338,8 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_CPU]		= META_TEMPLATE("cpu",       &integer_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 26d2879..8815611 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -325,6 +325,7 @@ static int monitor_lookup_event(const char *event)
 %token RTCLASSID		"rtclassid"
 %token IBRIPORT			"ibriport"
 %token OBRIPORT			"obriport"
+%token CPU				"cpu"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1838,6 +1839,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
 			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
 			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
+			|	CPU		{ $$ = NFT_META_CPU; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 4eec92f..8e52454 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -415,6 +415,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rtclassid"		{ return RTCLASSID; }
 "ibriport"		{ return IBRIPORT; }
 "obriport"		{ return OBRIPORT; }
+"cpu"			{ return CPU; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
2.0.0.rc2

