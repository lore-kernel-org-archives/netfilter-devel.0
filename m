From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 2/6] rule: allow to print sets in plain format
Date: Tue, 18 Feb 2014 00:18:17 +0100
Message-ID: <20140217231816.19943.70578.stgit@nfdev.cica.es>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39320 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754282AbaBQXSY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:24 -0500
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow to print sets with or without format.

This is useful in situations where we want to print exactly the same the user
typed (IOW, in one single line, and with family/table info).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/rule.h |    1 +
 src/rule.c     |   44 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 4891dc1..b263593 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -195,6 +195,7 @@ extern void set_free(struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern void set_print(const struct set *set);
+extern void set_print_plain(const struct set *s);
 
 /**
  * enum cmd_ops - command operations
diff --git a/src/rule.c b/src/rule.c
index 9ff2dd3..2c684d8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -90,21 +90,30 @@ struct set *set_lookup(const struct table *table, const char *name)
 	return NULL;
 }
 
-void set_print(const struct set *set)
+static void do_set_print(const struct set *set, const char *tab,
+			 const char *nl, const char *family, const char *table)
 {
 	const char *delim = "";
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
-	printf("\t%s %s {\n", type, set->handle.set);
+	printf("%s%s", tab, type);
 
-	printf("\t\ttype %s", set->keytype->name);
+	if (family != NULL)
+		printf(" %s", family);
+
+	if (table != NULL)
+		printf(" %s", table);
+
+	printf(" %s {%s", set->handle.set, nl);
+
+	printf("%s%stype %s", tab, tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
-	printf("\n");
+	printf("%s", nl);
 
 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
-		printf("\t\tflags ");
+		printf("%s%sflags ", tab, tab);
 		if (set->flags & SET_F_CONSTANT) {
 			printf("%sconstant", delim);
 			delim = ",";
@@ -113,15 +122,32 @@ void set_print(const struct set *set)
 			printf("%sinterval", delim);
 			delim = ",";
 		}
-		printf("\n");
+		printf("%s", nl);
 	}
 
 	if (set->init != NULL && set->init->size > 0) {
-		printf("\t\telements = ");
+		printf("%s%selements = ", tab, tab);
 		expr_print(set->init);
-		printf("\n");
+		printf("%s", nl);
 	}
-	printf("\t}\n");
+	printf("%s}%s", tab, nl);
+}
+
+void set_print(const struct set *s)
+{
+	const char *tab = "\t";
+	const char *nl = "\n";
+
+	do_set_print(s, tab, nl, NULL, NULL);
+}
+
+void set_print_plain(const struct set *s)
+{
+	const char *tab = "";
+	const char *nl = "";
+
+	do_set_print(s, tab, nl, family2str(s->handle.family),
+		     s->handle.table);
 }
 
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)

