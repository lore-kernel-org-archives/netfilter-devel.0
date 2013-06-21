From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] meta: replace rtnl_tc_handle2str and rtnl_tc_str2handle
Date: Fri, 21 Jun 2013 16:42:18 +0200
Message-ID: <1371825739-3669-4-git-send-email-pablo@netfilter.org>
References: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41723 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161517Ab3FUOmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:31 -0400
In-Reply-To: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Provide replacements for rtnl_tc_handle2str and rtnl_tc_str2handle,
it removes the dependency with libnl-route.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |    3 ---
 src/meta.c   |   53 +++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/configure.ac b/configure.ac
index d8a850c..316d043 100644
--- a/configure.ac
+++ b/configure.ac
@@ -55,9 +55,6 @@ AC_CHECK_LIB([nl], [nl_socket_alloc], ,
 AC_CHECK_LIB([nl-nf], [nfnl_nft_rule_alloc], ,
 	     AC_MSG_ERROR([No suitable version of libnl-nf found]))
 
-AC_CHECK_LIB([nl-route], [rtnl_link_alloc], ,
-	     AC_MSG_ERROR([No suitable version of libnl-route found]))
-
 AC_CHECK_LIB([gmp], [__gmpz_init], ,
 	     AC_MSG_ERROR([No suitable version of libgmp found]))
 
diff --git a/src/meta.c b/src/meta.c
index c5719b9..49d8130 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -14,12 +14,12 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
+#include <string.h>
 #include <net/if.h>
 #include <net/if_arp.h>
 #include <pwd.h>
 #include <grp.h>
-#include <netlink/route/link.h>
-#include <netlink/route/tc.h>
+#include <linux/pkt_sched.h>
 
 #include <nftables.h>
 #include <expression.h>
@@ -65,10 +65,24 @@ static const struct datatype realm_type = {
 
 static void tchandle_type_print(const struct expr *expr)
 {
-	char buf[sizeof("ffff:ffff")];
-
-	printf("%s", rtnl_tc_handle2str(mpz_get_uint32(expr->value),
-					buf, sizeof(buf)));
+	uint32_t handle = mpz_get_uint32(expr->value);
+
+	switch(handle) {
+	case TC_H_ROOT:
+		printf("root\n");
+	case TC_H_UNSPEC:
+		printf("none\n");
+	default:
+		if (TC_H_MAJ(handle) == 0)
+			printf(":%04x\n", TC_H_MIN(handle));
+		else if (TC_H_MIN(handle) == 0)
+			printf("%04x:\n", TC_H_MAJ(handle) >> 16);
+		else {
+			printf("%04x:%04x\n",
+			       TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
+		}
+		break;
+	}
 }
 
 static struct error_record *tchandle_type_parse(const struct expr *sym,
@@ -76,14 +90,33 @@ static struct error_record *tchandle_type_parse(const struct expr *sym,
 {
 	uint32_t handle;
 
-	if (rtnl_tc_str2handle(sym->identifier, &handle) < 0)
-		return error(&sym->location, "Could not parse %s",
-			     sym->dtype->desc);
-
+	if (strcmp(sym->identifier, "root") == 0)
+		handle = TC_H_ROOT;
+	else if (strcmp(sym->identifier, "none") == 0)
+		handle = TC_H_UNSPEC;
+	else if (sym->identifier[0] == ':') {
+		if (sscanf(sym->identifier, ":%04x", &handle) < 0)
+			goto err;
+	} else if (sym->identifier[strlen(sym->identifier)-1] == ':') {
+		if (sscanf(sym->identifier, "%04x:", &handle) < 0)
+			goto err;
+
+		handle <<= 16;
+	} else {
+		uint32_t min, max;
+
+		if (sscanf(sym->identifier, "%04x:%04x", &min, &max) < 0)
+			goto err;
+
+		handle = max << 16 | min;
+	}
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(handle) * BITS_PER_BYTE, &handle);
 	return NULL;
+err:
+	return error(&sym->location, "Could not parse %s",
+		     sym->dtype->desc);
 }
 
 static const struct datatype tchandle_type = {
-- 
1.7.10.4

