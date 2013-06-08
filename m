From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/2] rule: display hook info
Date: Sun,  9 Jun 2013 01:08:46 +0200
Message-ID: <1370732927-23322-2-git-send-email-eric@regit.org>
References: <1370732927-23322-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56761 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3FHXI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:08:59 -0400
In-Reply-To: <1370732927-23322-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was not possible to restore a ruleset because of missing
hook information. This patch adds hooknum output to list
operation.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index e7627a7..663a7c8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -19,6 +19,8 @@
 #include <rule.h>
 #include <utils.h>
 
+#include <netinet/ip.h>
+#include <linux/netfilter.h>
 
 void handle_free(struct handle *h)
 {
@@ -224,11 +226,39 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
+static void hooknum_print(unsigned int hooknum)
+{
+	switch (hooknum) {
+		case NF_INET_PRE_ROUTING:
+			printf("NF_INET_PRE_ROUTING");
+			break;
+		case NF_INET_LOCAL_IN:
+			printf("NF_INET_LOCAL_IN");
+			break;
+		case NF_INET_FORWARD:
+			printf("NF_INET_FORWARD");
+			break;
+		case NF_INET_LOCAL_OUT:
+			printf("NF_INET_LOCAL_OUT");
+			break;
+		case NF_INET_POST_ROUTING:
+			printf("NF_INET_POST_ROUTING");
+			break;
+		default:
+			printf("UNKNOWN");
+	}
+}
+
 static void chain_print(const struct chain *chain)
 {
 	struct rule *rule;
 
 	printf("\tchain %s {\n", chain->handle.chain);
+	if (chain->hooknum) {
+		printf("\t\t hook ");
+		hooknum_print(chain->hooknum);
+		printf("\t\t%u;\n", chain->priority);
+	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
 		rule_print(rule);
-- 
1.7.10.4

