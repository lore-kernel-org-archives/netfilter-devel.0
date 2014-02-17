From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 4/6] rule: generalize chain_print()
Date: Tue, 18 Feb 2014 00:18:27 +0100
Message-ID: <20140217231827.19943.82553.stgit@nfdev.cica.es>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39335 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753413AbaBQXSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:35 -0500
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lest generalize the chain_print() function, so we can print a plain chain
as the user typed in the basic CLI.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/rule.h |    1 +
 src/rule.c     |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index b263593..9791cea 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -126,6 +126,7 @@ extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
 
 extern const char *family2str(unsigned int family);
+extern void chain_print_plain(const struct chain *chain);
 
 /**
  * struct rule - nftables rule
diff --git a/src/rule.c b/src/rule.c
index 2c684d8..4301faa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -364,21 +364,42 @@ static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 	return "unknown";
 }
 
-static void chain_print(const struct chain *chain)
+static void do_chain_print(const struct chain *chain, const char *family,
+			   const char *table, const char *tab, const char *nl)
 {
 	struct rule *rule;
 
-	printf("\tchain %s {\n", chain->handle.chain);
+	printf("%schain", tab);
+
+	if (family != NULL)
+		printf(" %s", family);
+
+	if (table != NULL)
+		printf(" %s", table);
+
+	printf(" %s {%s", chain->handle.chain, nl);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s priority %u;\n", chain->type,
+		printf("%s%s type %s hook %s priority %u;\%s", tab, tab,
+		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority);
+		       chain->priority, nl);
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
-		printf("\t\t");
+		printf("%s%s", tab, tab);
 		rule_print(rule);
 	}
-	printf("\t}\n");
+	printf("%s}%s", tab, nl);
+}
+
+static void chain_print(const struct chain *chain)
+{
+	do_chain_print(chain, NULL, NULL, "\t", "\n");
+}
+
+void chain_print_plain(const struct chain *chain)
+{
+	do_chain_print(chain, family2str(chain->handle.family),
+		       chain->handle.table, "", "");
 }
 
 struct table *table_alloc(void)

