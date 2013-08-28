From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 4/5] src: Ensure given base chain type is a valid one
Date: Wed, 28 Aug 2013 11:33:10 +0300
Message-ID: <1377678791-7616-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3H1IdV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:21 -0400
In-Reply-To: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So it verifies already from given command line that type is "filter",
"nat" or "route".

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/rule.h |  1 +
 src/parser.y   | 12 ++++++++++++
 src/rule.c     | 19 +++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 97bace5..161cee9 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -142,6 +142,7 @@ extern void chain_free(struct chain *chain);
 extern void chain_add_hash(struct chain *chain, struct table *table);
 extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
+extern bool chain_type_verify(const char *type);
 
 /**
  * struct rule - nftables rule
diff --git a/src/parser.y b/src/parser.y
index 9a91490..49740a5 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -772,6 +772,12 @@ hook_spec		:	TYPE	STRING	HOOK	STRING	PRIORITY	NUM
 				$<chain>0->priority	= $6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 
+				if (!chain_type_verify($<chain>0->type)) {
+					erec_queue(error(&@2, "unknown type %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+
 				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
 					erec_queue(error(&@4, "unknown hook %s", $4),
 						   state->msgs);
@@ -785,6 +791,12 @@ hook_spec		:	TYPE	STRING	HOOK	STRING	PRIORITY	NUM
 				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 
+				if (!chain_type_verify($<chain>0->type)) {
+					erec_queue(error(&@2, "unknown type %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+
 				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
 					erec_queue(error(&@4, "unknown hook %s", $4),
 						   state->msgs);
diff --git a/src/rule.c b/src/rule.c
index 28a52b0..6ad2388 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -228,6 +228,25 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
+static const char *chain_type_str_array[] = {
+	"filter",
+	"nat",
+	"route",
+	NULL,
+};
+
+bool chain_type_verify(const char *type)
+{
+	int i;
+
+	for (i = 0; chain_type_str_array[i]; i++) {
+		if (!strcmp(type, chain_type_str_array[i]))
+			return true;
+	}
+
+	return false;
+}
+
 static const char *hooknum2str_array[HOOK_NUMHOOKS] = {
 	[HOOK_PREROUTING]	= "prerouting",
 	[HOOK_INPUT]		= "input",
-- 
1.8.3.2

