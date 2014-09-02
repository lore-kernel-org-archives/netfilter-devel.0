From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] src: Add devgroup support in meta expresion.
Date: Tue,  2 Sep 2014 20:37:17 +0200
Message-ID: <1409683037-11611-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44601 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaIBSez (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:34:55 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so14902597wib.9
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2014 11:34:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds device group support in meta expresion.

The new attributes of meta are "iffgroup" and "oifgroup"
- iffgroup: Match device group of incoming device.
- oifgroup: Match device group of outcoming device.

Example of use:
nft add rule ip test input meta iifgroup 2 counter
nft add rule ip test output meta oifgroup 2 counter

The kernel and libnftnl support were added in these commits:
netfilter: nf_tables: add devgroup support in meta expresion
src: meta: Add devgroup support to meta expresion

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    4 ++++
 src/meta.c                          |    6 ++++++
 src/parser.y                        |    4 ++++
 src/scanner.l                       |    2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index dbdc4f5..e8b9d19 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -537,6 +537,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: packet type (skb->pkt_type), special handling for loopback
  * @NFT_META_CPU: cpu id through smp_processor_id()
+ * @NFT_META_IIFGROUP: packet input interface group
+ * @NFT_META_OIFGROUP: packet output interface group
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -560,6 +562,8 @@ enum nft_meta_keys {
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
 	NFT_META_CPU,
+	NFT_META_IIFGROUP,
+	NFT_META_OIFGROUP,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index bf41ac4..cea3ccb 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -396,6 +396,12 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_CPU]		= META_TEMPLATE("cpu",  &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_IIFGROUP]	= META_TEMPLATE("iifgroup", &integer_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup", &integer_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index d7bc287..baa0878 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -327,6 +327,8 @@ static int monitor_lookup_event(const char *event)
 %token OBRIPORT			"obriport"
 %token PKTTYPE			"pkttype"
 %token CPU			"cpu"
+%token IIFGROUP			"iifgroup"
+%token OIFGROUP			"oifgroup"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1842,6 +1844,8 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
 			|       PKTTYPE		{ $$ = NFT_META_PKTTYPE; }
 			|       CPU		{ $$ = NFT_META_CPU; }
+			|       IIFGROUP	{ $$ = NFT_META_IIFGROUP; }
+			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index b7a00b4..929dbf6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -417,6 +417,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "obriport"		{ return OBRIPORT; }
 "pkttype"		{ return PKTTYPE; }
 "cpu"			{ return CPU; }
+"iifgroup"		{ return IIFGROUP; }
+"oifgroup"		{ return OIFGROUP; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.7.10.4

