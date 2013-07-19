From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  01/15] xtables: Add support for injecting xtables target into nft rule
Date: Fri, 19 Jul 2013 18:17:30 +0300
Message-ID: <1374247064-3361-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GSPRu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:17:50 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 configure.ac              |  7 +++++++
 extensions/GNUmakefile.in |  1 +
 include/xtables.h.in      |  5 +++++
 iptables/nft.c            | 20 ++++++++++++--------
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 48a0d54..e228078 100644
--- a/configure.ac
+++ b/configure.ac
@@ -104,6 +104,13 @@ PKG_CHECK_MODULES([libnftables], [libnftables >= 1.0],
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
index 4a8ff49..efb5502 100644
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
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 10b241f..767d53e 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -18,6 +18,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
+#include <libnftables/rule.h>
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
@@ -327,6 +329,9 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* NFT related */
+	int (*to_nft)(struct nft_rule *, struct xt_entry_target *);
+
 	size_t udata_size;
 
 	/* Ignore these men behind the curtain: */
diff --git a/iptables/nft.c b/iptables/nft.c
index 72ac4b0..e773ace 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -609,17 +609,21 @@ static int __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
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
@@ -745,7 +749,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
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

