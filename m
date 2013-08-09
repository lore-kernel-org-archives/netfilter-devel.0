From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 01/16] xtables: Add support for injecting xtables target into nft rule
Date: Fri,  9 Aug 2013 16:31:15 +0300
Message-ID: <1376055090-26551-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967658Ab3HINbi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:38 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This bring the support for xtables target extentions to be translated to
pure nft expression list in the given rule.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 configure.ac              |  7 +++++++
 extensions/GNUmakefile.in |  1 +
 include/xtables.h         |  5 +++++
 iptables/nft.c            | 20 ++++++++++++--------
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1c713e8..68f661c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -119,6 +119,13 @@ PKG_CHECK_MODULES([libnftables], [libnftables >= 1.0],
 	[nftables=1], [nftables=0])
 AM_CONDITIONAL([HAVE_LIBNFTABLES], [test "$nftables" = 1])
 
+if test "$nftables" = 1; then
+	EXTENSION_NFT_LDFLAGS="${libmnl_LIBS} ${libnftables_LIBS}";
+else
+	EXTENSION_NFT_LDFLAGS="";
+fi;
+AC_SUBST(EXTENSION_NFT_LDFLAGS)
+
 AM_PROG_LEX
 AC_PROG_YACC
 
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 14e7c57..da2f38b 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -16,6 +16,7 @@ CCLD               = ${CC}
 CFLAGS             = @CFLAGS@
 CPPFLAGS           = @CPPFLAGS@
 LDFLAGS            = @LDFLAGS@
+@ENABLE_NFTABLES_TRUE@ LDFLAGS += @EXTENSION_NFT_LDFLAGS@
 regular_CFLAGS     = @regular_CFLAGS@
 regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
diff --git a/include/xtables.h b/include/xtables.h
index d4a4395..4d8874c 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -18,6 +18,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
+#include <libnftables/rule.h>
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
@@ -346,6 +348,9 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* NFT related */
+	int (*to_nft)(struct nft_rule *, struct xt_entry_target *);
+
 	size_t udata_size;
 
 	/* Ignore these men behind the curtain: */
diff --git a/iptables/nft.c b/iptables/nft.c
index 28e71d8..68861a8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -594,17 +594,21 @@ static int __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 	return 0;
 }
 
-static int add_target(struct nft_rule *r, struct xt_entry_target *t)
+static int add_target(struct nft_rule *r, struct xtables_target *target)
 {
-	struct nft_rule_expr *expr;
 	int ret;
 
-	expr = nft_rule_expr_alloc("target");
-	if (expr == NULL)
-		return -ENOMEM;
+	if (target->to_nft == NULL) {
+		struct nft_rule_expr *expr;
 
-	ret = __add_target(expr, t);
-	nft_rule_add_expr(r, expr);
+		expr = nft_rule_expr_alloc("target");
+		if (expr == NULL)
+			return -ENOMEM;
+
+		ret = __add_target(expr, target->t);
+		nft_rule_add_expr(r, expr);
+	} else
+		ret = target->to_nft(r, target->t);
 
 	return ret;
 }
@@ -713,7 +717,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
 		else
-			ret = add_target(r, cs->target->t);
+			ret = add_target(r, cs->target);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (ip_flags & IPT_F_GOTO)
-- 
1.8.3.2

