From: Ana Rey <anarey@gmail.com>
Subject: [nftables PATCH] meta: Add support for datatype devgroup
Date: Thu, 23 Oct 2014 14:44:19 +0200
Message-ID: <1ee461886f3f61ce6dece0fad0c7a2322d1d5153.1414068114.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51804 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaJWMo2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:44:28 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so1862229wiv.6
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2014 05:44:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the new devgroup datatype to get the group name from
/etc/iproute2/group file.

Example of use:

nft add rule ip test input meta iifgroup 0 counter
nft add rule ip test input meta iifgroup default counter

Moreover, It adds tests in meta.t test file.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/datatype.h          |    2 ++
 src/meta.c                  |   39 +++++++++++++++++++++++++++++++++++++--
 tests/regression/any/meta.t |   21 +++++++++++++++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 15fea44..3f13dcd 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -39,6 +39,7 @@
  * @TYPE_ICMP_CODE:	icmp code (integer subtype)
  * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
+ * @TYPE_DEVGROUP:	devgroup code (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -76,6 +77,7 @@ enum datatypes {
 	TYPE_ICMP_CODE,
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
+	TYPE_DEVGROUP,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/src/meta.c b/src/meta.c
index cea3ccb..faa29eb 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -349,6 +349,40 @@ static const struct datatype pkttype_type = {
 	.parse		= pkttype_type_parse,
 };
 
+static struct symbol_table *devgroup_tbl;
+static void __init devgroup_table_init(void)
+{
+	devgroup_tbl = rt_symbol_table_init("/etc/iproute2/group");
+}
+
+static void __exit devgroup_table_exit(void)
+{
+	rt_symbol_table_free(devgroup_tbl);
+}
+
+static void devgroup_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(devgroup_tbl, expr);
+}
+
+static struct error_record *devgroup_type_parse(const struct expr *sym,
+						struct expr **res)
+{
+	return symbolic_constant_parse(sym, devgroup_tbl, res);
+}
+
+static const struct datatype devgroup_type = {
+	.type		= TYPE_DEVGROUP,
+	.name		= "devgroup",
+	.desc		= "devgroup name",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= 4 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= devgroup_type_print,
+	.parse		= devgroup_type_parse,
+	.flags		= DTYPE_F_PREFIX,
+};
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -396,10 +430,10 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_CPU]		= META_TEMPLATE("cpu",  &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFGROUP]	= META_TEMPLATE("iifgroup", &integer_type,
+	[NFT_META_IIFGROUP]	= META_TEMPLATE("iifgroup", &devgroup_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup", &integer_type,
+	[NFT_META_OIFGROUP]	= META_TEMPLATE("oifgroup", &devgroup_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 };
@@ -546,4 +580,5 @@ static void __init meta_init(void)
 	datatype_register(&tchandle_type);
 	datatype_register(&uid_type);
 	datatype_register(&gid_type);
+	datatype_register(&devgroup_type);
 }
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index 5bc3872..1e7a0fe 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -158,3 +158,24 @@ meta cpu 1-3;ok;cpu >= 1 cpu <= 3
 meta cpu != 1-2;ok;cpu < 1 cpu > 2
 meta cpu { 2,3};ok;cpu { 2, 3}
 -meta cpu != { 2,3};ok
+
+meta iifgroup 0;ok;iifgroup default
+meta iifgroup != 0;ok;iifgroup != default
+meta iifgroup default;ok;iifgroup default
+meta iifgroup != default;ok;iifgroup != default
+meta iifgroup {default};ok;;iifgroup {default}
+- meta iifgroup != {default};ok
+meta iifgroup {11,33};ok;oifgroup {11,33}
+meta iifgroup {11-33};ok
+- meta iifgroup != {11,33};ok
+- meta iifgroup != {11-33};ok
+meta oifgroup 0;ok;oifgroup default
+meta oifgroup != 0;ok;oifgroup != default
+meta oifgroup default;ok;oifgroup default
+meta oifgroup != default;ok;oifgroup != default
+meta oifgroup {default};ok;oifgroup {default}
+- meta oifgroup != {default};ok
+meta oifgroup {11,33};ok;oifgroup {11,33}
+meta oifgroup {11-33};ok
+- meta oifgroup != {11,33};ok
+- meta oifgroup != {11-33};ok
-- 
1.7.10.4

