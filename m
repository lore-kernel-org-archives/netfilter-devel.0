From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 5/5] meta: Add support for input and output bridge interface name
Date: Tue,  8 Apr 2014 14:25:24 +0300
Message-ID: <1396956324-17803-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42069 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbaDHLZr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:25:47 -0400
In-Reply-To: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to get an input or output bridge interface name through the
relevant meta keys.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h | 4 ++++
 src/meta.c                          | 6 ++++++
 src/parser.y                        | 4 ++++
 src/scanner.l                       | 2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ff9b0a7..a5f8ec0 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -533,6 +533,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
  * @NFT_META_NFPROTO: netfilter protocol
  * @NFT_META_L4PROTO: layer 4 protocol number
+ * @NFT_META_BRI_IIFNAME: packet input bridge interface name
+ * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -552,6 +554,8 @@ enum nft_meta_keys {
 	NFT_META_SECMARK,
 	NFT_META_NFPROTO,
 	NFT_META_L4PROTO,
+	NFT_META_BRI_IIFNAME,
+	NFT_META_BRI_OIFNAME,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index ebc0c54..c511f1c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -332,6 +332,12 @@ static const struct meta_template meta_templates[] = {
 						1    , BYTEORDER_HOST_ENDIAN),
 	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid", &realm_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("ibriport",  &string_type,
+						IFNAMSIZ * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
+						IFNAMSIZ * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index db6f493..6ae5e82 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -304,6 +304,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SKGID			"skgid"
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
+%token IBRIPORT			"ibriport"
+%token OBRIPORT			"obriport"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1563,6 +1565,8 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	SKGID		{ $$ = NFT_META_SKGID; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
+			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
+			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 47c5933..69d6b8f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -402,6 +402,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "skgid"			{ return SKGID; }
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
+"ibriport"		{ return IBRIPORT; }
+"obriport"		{ return OBRIPORT; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.8.3.2

