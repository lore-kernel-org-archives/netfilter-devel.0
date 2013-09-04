From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool v2 PATCH 2/4] src: Ensure given base chain type is a valid one
Date: Wed,  4 Sep 2013 12:50:20 +0300
Message-ID: <1378288222-13182-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469Ab3IDJul (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:50:41 -0400
In-Reply-To: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It verifies at command line parsing that given type is "filter", "nat",
or "route".

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/rule.h |  1 +
 src/parser.y   | 14 ++++++++++++--
 src/rule.c     | 19 +++++++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 14a3958..c6fca3c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -117,6 +117,7 @@ struct chain {
 	struct list_head	rules;
 };
 
+extern const char *chain_type_name_lookup(const char *name);
 extern const char *chain_hook_name_lookup(const char *name);
 extern struct chain *chain_alloc(const char *name);
 extern void chain_free(struct chain *chain);
diff --git a/src/parser.y b/src/parser.y
index 771b194..73a52d4 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -769,7 +769,12 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 			{
-				$<chain>0->type		= $2;
+				$<chain>0->type		= chain_type_name_lookup($2);
+				if ($<chain>0->type == NULL) {
+					erec_queue(error(&@2, "unknown type name %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
 				$<chain>0->hookstr	= chain_hook_name_lookup($4);
 				if ($<chain>0->hookstr == NULL) {
 					erec_queue(error(&@4, "unknown hook name %s", $4),
@@ -781,7 +786,12 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 			}
 			|	TYPE		STRING		HOOK		STRING		DASH	NUM
 			{
-				$<chain>0->type		= $2;
+				$<chain>0->type		= chain_type_name_lookup($2);
+				if ($<chain>0->type == NULL) {
+					erec_queue(error(&@2, "unknown type name %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
 				$<chain>0->hookstr	= chain_hook_name_lookup($4);
 				if ($<chain>0->hookstr == NULL) {
 					erec_queue(error(&@4, "unknown hook name %s", $4),
diff --git a/src/rule.c b/src/rule.c
index 1b1e5d4..37dcc8c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -190,6 +190,25 @@ struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 	return NULL;
 }
 
+static const char *chain_type_str_array[] = {
+	"filter",
+	"nat",
+	"route",
+	NULL,
+};
+
+const char *chain_type_name_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; chain_type_str_array[i]; i++) {
+		if (!strcmp(name, chain_type_str_array[i]))
+			return chain_type_str_array[i];
+	}
+
+	return NULL;
+}
+
 static const char *chain_hook_name_str_array[] = {
 	"prerouting",
 	"in",
-- 
1.8.3.2

