From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH nftables 1/3] meta: Add support for SKPID and SKSID meta keys
Date: Thu,  5 Jun 2014 22:19:14 +0800
Message-ID: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
Cc: Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54236 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFEOUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:20:13 -0400
Received: by mail-pd0-f181.google.com with SMTP id z10so1147570pdj.40
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jun 2014 07:20:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/datatype.h                  |  4 +++
 include/linux/netfilter/nf_tables.h |  4 +++
 src/meta.c                          | 55 +++++++++++++++++++++++++++++++++++++
 src/parser.y                        |  6 +++-
 src/scanner.l                       |  2 ++
 5 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2c66e9d..73b8cc5 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -35,6 +35,8 @@
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
+ * @TYPE_PID:		process ID (integer subtype)
+ * @TYPE_SID:		process session ID (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -68,6 +70,8 @@ enum datatypes {
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
+	TYPE_PID,
+	TYPE_SID,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a5f8ec0..dfdb251 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -535,6 +535,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_SKPID: origination socket owner PID
+ * @NFT_META_SKSID: origination socket owner SID
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -556,6 +558,8 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_SKPID,
+	NFT_META_SKSID,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 80f88ff..957157e 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -297,6 +297,57 @@ static const struct datatype gid_type = {
 	.parse		= gid_type_parse,
 };
 
+static void pid_type_print(const struct expr *expr)
+{
+	if (numeric_output < NUMERIC_ALL) {
+		uint32_t pid = mpz_get_uint32(expr->value);
+
+		printf("%d", pid);
+		return;
+	}
+	expr_basetype(expr)->print(expr);
+}
+
+static struct error_record *pid_type_parse(const struct expr *sym,
+					   struct expr **res)
+{
+	uint64_t pid;
+	char *endptr = NULL;
+
+	pid = strtoull(sym->identifier, &endptr, 10);
+	if (pid > UINT32_MAX)
+		return error(&sym->location, "Value too large");
+	else if (*endptr)
+		return error(&sym->location, "Process does not exist");
+
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   sizeof(pid) * BITS_PER_BYTE, &pid);
+	return NULL;
+}
+
+static const struct datatype pid_type = {
+	.type		= TYPE_PID,
+	.name		= "pid",
+	.desc		= "process ID",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= sizeof(pid_t) * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= pid_type_print,
+	.parse		= pid_type_parse,
+};
+
+static const struct datatype sid_type = {
+	.type		= TYPE_SID,
+	.name		= "sid",
+	.desc		= "process session ID",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= sizeof(pid_t) * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= pid_type_print,
+	.parse		= pid_type_parse,
+};
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -338,6 +389,10 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SKPID]	= META_TEMPLATE("skpid",     &pid_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SKSID]	= META_TEMPLATE("sksid",     &sid_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 9c20737..1355cab 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -307,6 +307,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token OIFTYPE			"oiftype"
 %token SKUID			"skuid"
 %token SKGID			"skgid"
+%token SKPID			"skpid"
+%token SKSID			"sksid"
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
 %token IBRIPORT			"ibriport"
@@ -1650,7 +1652,9 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
 			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
-			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
+			|	OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
+			|	SKPID		{ $$ = NFT_META_SKPID; }
+			|	SKSID		{ $$ = NFT_META_SKSID; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 801c030..24297d7 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -405,6 +405,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "oiftype"		{ return OIFTYPE; }
 "skuid"			{ return SKUID; }
 "skgid"			{ return SKGID; }
+"skpid"			{ return SKPID; }
+"sksid"			{ return SKSID; }
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
 "ibriport"		{ return IBRIPORT; }
-- 
1.9.3

