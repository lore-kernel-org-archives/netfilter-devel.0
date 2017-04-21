From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Fri, 21 Apr 2017 12:30:24 +0200
Message-ID: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47029 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1037595AbdDUKae (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2017 06:30:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 5278951F376
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2017 10:30:31 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ll3_csk6ToMC for <netfilter-devel@vger.kernel.org>;
        Fri, 21 Apr 2017 12:30:25 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 04DD151F377
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2017 12:30:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new option to nft to print set elements per line instead
of all in a single line.
This is useful when printing a ruleset with very big sets.

The new option is -t/--elements.

Annonymous sets/maps/concats are not affected by this. The default
behaviour is not changed.

Example:

% nft list ruleset -t -nn
table ip t {
	set s {
		type inet_service
		elements = { 1,
				2,
				3,
				4,
				12345 }
	}

	set s2 {
		type ipv4_addr . inet_service
		elements = { 1.1.1.1 . 22,
				1.1.1.1 . 222,
				1.1.1.1 . 2222,
				2.1.1.1 . 22222 }
	}

	chain c {
		ip saddr { 1.1.1.1, 2.2.2.2 }
		ip saddr . tcp dport { 1.1.1.1 . 22 }
	}
}


Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 include/expression.h |    1 +
 include/nftables.h   |    1 +
 src/expression.c     |    2 +-
 src/main.c           |   12 +++++++++++-
 src/rule.c           |    2 ++
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 9ba87e8..2721434 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -243,6 +243,7 @@ struct expr {
 			struct list_head	expressions;
 			unsigned int		size;
 			uint32_t		set_flags;
+			const char		*delim;
 		};
 		struct {
 			/* EXPR_SET_REF */
diff --git a/include/nftables.h b/include/nftables.h
index 6f54155..93b3845 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ extern unsigned int numeric_output;
 extern unsigned int stateless_output;
 extern unsigned int ip2name_output;
 extern unsigned int handle_output;
+extern unsigned int elements_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
diff --git a/src/expression.c b/src/expression.c
index 45f3ed8..5164567 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -745,7 +745,7 @@ struct expr *list_expr_alloc(const struct location *loc)
 static void set_expr_print(const struct expr *expr)
 {
 	printf("{ ");
-	compound_expr_print(expr, ", ");
+	compound_expr_print(expr, expr->delim ? expr->delim : ", ");
 	printf(" }");
 }
 
diff --git a/src/main.c b/src/main.c
index 1cc8b39..13a2a78 100644
--- a/src/main.c
+++ b/src/main.c
@@ -33,6 +33,7 @@ unsigned int numeric_output;
 unsigned int stateless_output;
 unsigned int ip2name_output;
 unsigned int handle_output;
+unsigned int elements_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -51,10 +52,11 @@ enum opt_vals {
 	OPT_IP2NAME		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
+	OPT_ELEMENTS_OUTPUT	= 't',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vnsNa"
+#define OPTSTRING	"hvf:iI:vnsNat"
 
 static const struct option options[] = {
 	{
@@ -103,6 +105,10 @@ static const struct option options[] = {
 		.val		= OPT_HANDLE_OUTPUT,
 	},
 	{
+		.name		= "elements",
+		.val		= OPT_ELEMENTS_OUTPUT,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -126,6 +132,7 @@ static void show_help(const char *name)
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
+"  -t, --elements		Output map/set elements with line breaks instead of a single line.\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 #endif
@@ -333,6 +340,9 @@ int main(int argc, char * const *argv)
 		case OPT_HANDLE_OUTPUT:
 			handle_output++;
 			break;
+		case OPT_ELEMENTS_OUTPUT:
+			elements_output++;
+			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
 		}
diff --git a/src/rule.c b/src/rule.c
index 209cf2d..340cb10 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -353,6 +353,8 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("%s%selements = ", opts->tab, opts->tab);
+		if (elements_output > 0)
+			set->init->delim = ",\n\t\t\t\t";
 		expr_print(set->init);
 		printf("%s", opts->nl);
 	}

