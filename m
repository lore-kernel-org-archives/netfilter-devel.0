From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/8] rule: allow to print sets in plain format
Date: Mon, 14 Apr 2014 12:17:08 +0200
Message-ID: <20140414101708.5018.18529.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42745 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898AbaDNKRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:13 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow to print sets with or without format.

This is useful in situations where we want to print more or less the same
the user typed (IOW, in one single line, and with family/table info).

While at it, make family2str() function public, so it can be used in
other places.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/rule.h |    3 +++
 src/rule.c     |   60 +++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ecf801f..072cff8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -127,6 +127,8 @@ extern void chain_add_hash(struct chain *chain, struct table *table);
 extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
 
+extern const char *family2str(unsigned int family);
+
 /**
  * struct rule - nftables rule
  *
@@ -195,6 +197,7 @@ extern void set_free(struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern void set_print(const struct set *set);
+extern void set_print_plain(const struct set *s);
 
 /**
  * enum cmd_ops - command operations
diff --git a/src/rule.c b/src/rule.c
index 18ae6b1..accff0f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -93,21 +93,37 @@ struct set *set_lookup(const struct table *table, const char *name)
 	return NULL;
 }
 
-void set_print(const struct set *set)
+struct print_fmt_options {
+	const char	*tab;
+	const char	*nl;
+	const char	*table;
+	const char	*family;
+	const char	*stmt_separator;
+};
+
+static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 {
 	const char *delim = "";
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
-	printf("\t%s %s {\n", type, set->handle.set);
+	printf("%s%s", opts->tab, type);
+
+	if (opts->family != NULL)
+		printf(" %s", opts->family);
+
+	if (opts->table != NULL)
+		printf(" %s", opts->table);
 
-	printf("\t\ttype %s", set->keytype->name);
+	printf(" %s { %s", set->handle.set, opts->nl);
+
+	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
-	printf("\n");
+	printf("%s", opts->stmt_separator);
 
 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
-		printf("\t\tflags ");
+		printf("%s%sflags ", opts->tab, opts->tab);
 		if (set->flags & SET_F_CONSTANT) {
 			printf("%sconstant", delim);
 			delim = ",";
@@ -116,15 +132,39 @@ void set_print(const struct set *set)
 			printf("%sinterval", delim);
 			delim = ",";
 		}
-		printf("\n");
+		printf("%s", opts->nl);
 	}
 
 	if (set->init != NULL && set->init->size > 0) {
-		printf("\t\telements = ");
+		printf("%s%selements = ", opts->tab, opts->tab);
 		expr_print(set->init);
-		printf("\n");
+		printf("%s", opts->nl);
 	}
-	printf("\t}\n");
+	printf("%s}%s", opts->tab, opts->nl);
+}
+
+void set_print(const struct set *s)
+{
+	struct print_fmt_options opts = {
+		.tab		= "\t",
+		.nl		= "\n",
+		.stmt_separator	= "\n",
+	};
+
+	do_set_print(s, &opts);
+}
+
+void set_print_plain(const struct set *s)
+{
+	struct print_fmt_options opts = {
+		.tab		= "",
+		.nl		= "",
+		.table		= s->handle.table,
+		.family		= family2str(s->handle.family),
+		.stmt_separator	= ";",
+	};
+
+	do_set_print(s, &opts);
 }
 
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
@@ -281,7 +321,7 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
-static const char *family2str(unsigned int family)
+const char *family2str(unsigned int family)
 {
 	switch (family) {
 		case NFPROTO_IPV4:

