From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH libnftnl] expr: Add const qualifiers to *2str translation arrays
Date: Fri, 13 Jan 2017 11:50:09 +0100
Message-ID: <20170113105009.14502-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:50922 "EHLO mail.zhinst.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdAMKuy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2017 05:50:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add const qualifiers to the "to string" translation arrays used by
various *2str() functions.

This fixes GCC warnings such as the following when compiling with
-Wwrite-strings:

  expr/byteorder.c:176:25: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]

In order to catch these in the future, also add -Wwrite-strings to
default CFLAGS.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 configure.ac         | 2 +-
 src/expr/byteorder.c | 2 +-
 src/expr/cmp.c       | 2 +-
 src/expr/dynset.c    | 2 +-
 src/expr/payload.c   | 2 +-
 src/expr/range.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4777c5e26b3f..2b74e522b930 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,7 +40,7 @@ AS_IF([test "x$with_json_parsing" = "xyes"], [
 ])
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
-	-Wformat=2 -pipe"
+	-Wformat=2 -Wwrite-strings -pipe"
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftnl/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile tests/Makefile libnftnl.pc doxygen.cfg])
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 5f8e585d91ca..38053073982c 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -172,7 +172,7 @@ nftnl_expr_byteorder_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static char *expr_byteorder_str[] = {
+static const char *expr_byteorder_str[] = {
 	[NFT_BYTEORDER_HTON] = "hton",
 	[NFT_BYTEORDER_NTOH] = "ntoh",
 };
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index e7ed0db5bf9a..353e907c2513 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -139,7 +139,7 @@ nftnl_expr_cmp_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static char *expr_cmp_str[] = {
+static const char *expr_cmp_str[] = {
 	[NFT_CMP_EQ]	= "eq",
 	[NFT_CMP_NEQ]	= "neq",
 	[NFT_CMP_LT]	= "lt",
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 20a500449eeb..f7b99ea7e7f8 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -258,7 +258,7 @@ nftnl_expr_dynset_export(char *buf, size_t size,
 	return nftnl_buf_done(&b);
 }
 
-static char *op2str_array[] = {
+static const char *op2str_array[] = {
 	[NFT_DYNSET_OP_ADD]		= "add",
 	[NFT_DYNSET_OP_UPDATE] 		= "update",
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index d65585711bd1..91e1587ff239 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -203,7 +203,7 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static char *base2str_array[NFT_PAYLOAD_TRANSPORT_HEADER+1] = {
+static const char *base2str_array[NFT_PAYLOAD_TRANSPORT_HEADER+1] = {
 	[NFT_PAYLOAD_LL_HEADER]		= "link",
 	[NFT_PAYLOAD_NETWORK_HEADER] 	= "network",
 	[NFT_PAYLOAD_TRANSPORT_HEADER]	= "transport",
diff --git a/src/expr/range.c b/src/expr/range.c
index 1489d5849451..8c8ce1213420 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -159,7 +159,7 @@ nftnl_expr_range_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static char *expr_range_str[] = {
+static const char *expr_range_str[] = {
 	[NFT_RANGE_EQ]	= "eq",
 	[NFT_RANGE_NEQ]	= "neq",
 };
-- 
2.11.0


