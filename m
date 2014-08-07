From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] [nft] src: Add support for cpu in meta expresion
Date: Thu,  7 Aug 2014 09:00:57 +0200
Message-ID: <1407394858-26841-3-git-send-email-anarey@gmail.com>
References: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Cc: eric.dumazet@gmail.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59598 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGG7B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:59:01 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so3690431wgg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2014 23:59:00 -0700 (PDT)
In-Reply-To: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to match cpu handling with a packet.

This is an example of the syntax for this new attribute:

nft add rule ip test input meta cpu 1 counter
nft add rule ip test input meta cpu 1-3 counter
nft add rule ip test input meta cpu { 1, 3} counter

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    2 ++
 src/meta.c                          |    3 +++
 src/parser.y                        |    2 ++
 src/scanner.l                       |    1 +
 4 files changed, 8 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fbc7904..9e67c14 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -536,6 +536,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: packet type
+ * @NFT_META_CPU: packet cpu
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -558,6 +559,7 @@ enum nft_meta_keys {
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 2c61455..75a16ee 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -393,6 +393,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",  &pkttype_type,
 						BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_CPU]		= META_TEMPLATE("cpu",  &integer_type,
+						BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 6da6e98..bf32c4e 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -325,6 +325,7 @@ static int monitor_lookup_event(const char *event)
 %token IBRIPORT			"ibriport"
 %token OBRIPORT			"obriport"
 %token PKTTYPE			"pkttype"
+%token CPU			"cpu"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1786,6 +1787,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
 			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
 			|       PKTTYPE		{ $$ = NFT_META_PKTTYPE; }
+			|       CPU		{ $$ = NFT_META_CPU; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 1d2be76..ad0b58d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -407,6 +407,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ibriport"		{ return IBRIPORT; }
 "obriport"		{ return OBRIPORT; }
 "pkttype"		{ return PKTTYPE; }
+"cpu"			{ return CPU; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.7.10.4

