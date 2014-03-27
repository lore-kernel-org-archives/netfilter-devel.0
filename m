From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH nftables 5/5] meta: Add support for input and output bridge interface name
Date: Thu, 27 Mar 2014 14:47:07 +0200
Message-ID: <1395924427-27947-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbaC0Mri (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:47:38 -0400
In-Reply-To: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to get an input or output bridge interface name through the
relevant meta keys: bri_iifname and bri_oifname.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  4 ++++
 src/meta.c                          | 38 +++++++++++++++++++++----------------
 src/parser.y                        |  4 ++++
 src/scanner.l                       |  2 ++
 4 files changed, 32 insertions(+), 16 deletions(-)

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
index ebc0c54..d95c124 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -298,40 +298,46 @@ static const struct datatype gid_type = {
 };
 
 static const struct meta_template meta_templates[] = {
-	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
+	[NFT_META_LEN]		= META_TEMPLATE("length",      &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_PROTOCOL]	= META_TEMPLATE("protocol",  &ethertype_type,
+	[NFT_META_PROTOCOL]	= META_TEMPLATE("protocol",    &ethertype_type,
 						2 * 8, BYTEORDER_BIG_ENDIAN),
-	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",   &nfproto_type,
+	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",     &nfproto_type,
 						1 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_L4PROTO]	= META_TEMPLATE("l4proto",   &inet_protocol_type,
+	[NFT_META_L4PROTO]	= META_TEMPLATE("l4proto",     &inet_protocol_type,
 						1 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",  &tchandle_type,
+	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",    &tchandle_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_MARK]		= META_TEMPLATE("mark",      &mark_type,
+	[NFT_META_MARK]		= META_TEMPLATE("mark",        &mark_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIF]		= META_TEMPLATE("iif",       &ifindex_type,
+	[NFT_META_IIF]		= META_TEMPLATE("iif",         &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &string_type,
+	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",     &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
+	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",     &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
+	[NFT_META_OIF]		= META_TEMPLATE("oif",	       &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &string_type,
+	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",     &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
+	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",     &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_SKUID]	= META_TEMPLATE("skuid",     &uid_type,
+	[NFT_META_SKUID]	= META_TEMPLATE("skuid",       &uid_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_SKGID]	= META_TEMPLATE("skgid",     &gid_type,
+	[NFT_META_SKGID]	= META_TEMPLATE("skgid",       &gid_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_NFTRACE]	= META_TEMPLATE("nftrace",   &integer_type,
+	[NFT_META_NFTRACE]	= META_TEMPLATE("nftrace",     &integer_type,
 						1    , BYTEORDER_HOST_ENDIAN),
-	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid", &realm_type,
+	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid",   &realm_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("bri_iifname", &string_type,
+						IFNAMSIZ * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("bri_oifname", &string_type,
+						IFNAMSIZ * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index db6f493..e8aef1d 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -304,6 +304,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SKGID			"skgid"
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
+%token BRI_IIFNAME		"bri_iifname"
+%token BRI_OIFNAME		"bri_oifname"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1563,6 +1565,8 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	SKGID		{ $$ = NFT_META_SKGID; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
+			|	BRI_IIFNAME	{ $$ = NFT_META_BRI_IIFNAME; }
+			|       BRI_OIFNAME	{ $$ = NFT_META_BRI_OIFNAME; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 47c5933..61c98b5 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -402,6 +402,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "skgid"			{ return SKGID; }
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
+"bri_iifname"		{ return BRI_IIFNAME; }
+"bri_oifname"		{ return BRI_OIFNAME; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.8.3.2

