From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 4/6] xtables: Add support for translating xtables target into nft expressions
Date: Tue, 14 May 2013 13:52:05 +0300
Message-ID: <1368528727-10127-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3ENKwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:18 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 configure.ac              |  7 +++++++
 extensions/GNUmakefile.in |  2 +-
 include/xtables.h.in      |  5 +++++
 iptables/nft.c            | 21 ++++++++++++++-------
 4 files changed, 27 insertions(+), 8 deletions(-)

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
index 4a8ff49..28034d7 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -91,7 +91,7 @@ init%.o: init%.c
 #	Shared libraries
 #
 lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD} @EXTENSION_NFT_LDFLAGS@;
 
 lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 10b241f..74df61f 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -18,6 +18,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
+#include <libnftables/expr.h>
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
@@ -327,6 +329,9 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* NFT related */
+	struct nft_rule_expr_list *(*translate_to_nft)(struct xt_entry_target *);
+
 	size_t udata_size;
 
 	/* Ignore these men behind the curtain: */
diff --git a/iptables/nft.c b/iptables/nft.c
index afbba84..341d092 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -593,16 +593,23 @@ static void __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
 }
 
-static void add_target(struct nft_rule *r, struct xt_entry_target *t)
+static void add_target(struct nft_rule *r, struct xtables_target *target)
 {
 	struct nft_rule_expr *expr;
+	struct nft_rule_expr_list *expr_list;
 
-	expr = nft_rule_expr_alloc("target");
-	if (expr == NULL)
-		return;
+	if (target->translate_to_nft == NULL) {
+		expr = nft_rule_expr_alloc("target");
+		if (expr == NULL)
+			return;
 
-	__add_target(expr, t);
-	nft_rule_add_expr(r, expr);
+		__add_target(expr, target->t);
+		nft_rule_add_expr(r, expr);
+	} else {
+		expr_list = target->translate_to_nft(target->t);
+		if (expr_list != NULL)
+			nft_rule_add_expr_list(r, expr_list);
+	}
 }
 
 static void add_jumpto(struct nft_rule *r, const char *name, int verdict)
@@ -712,7 +719,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			add_verdict(r, NFT_RETURN);
 		else
-			add_target(r, cs->target->t);
+			add_target(r, cs->target);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (ip_flags & IPT_F_GOTO)
-- 
1.8.2.1

