From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 1/5] expr: queue: Add nft_rule_expr_queue_snprinf_* functions
Date: Fri, 13 Jun 2014 11:31:49 +0200
Message-ID: <1402651913-15065-2-git-send-email-anarey@gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47077 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaFMJcG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:32:06 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so528853wiv.2
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 02:32:05 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring in nft_rule_expr_queue_snprinf functions. This process
adds three new functions:

* nft_rule_expr_queue_snprinf_default
* nft_rule_expr_queue_snprinf_xml
* nft_rule_expr_queue_snprinf_json

Also, It is delete an unnecesary whitespace as the CodingStyle recommends.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 82 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 31 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 9f269e7..5dad84a 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -194,46 +194,66 @@ nft_rule_expr_queue_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int
-nft_rule_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
-			      uint32_t flags, struct nft_rule_expr *e)
+static int nft_rule_expr_queue_snprintf_default(char *buf, size_t len,
+						struct nft_rule_expr *e)
 {
 	struct nft_expr_queue *queue = nft_expr_data(e);
 	int ret;
 	int one = 0;
 
+	ret = snprintf(buf, len, "num %u total %u", queue->queuenum,
+		       queue->queues_total);
+	if (queue->flags) {
+		ret += snprintf(buf + ret, len - ret, " options ");
+		if (queue->flags & NFT_QUEUE_FLAG_BYPASS) {
+			ret += snprintf(buf + ret, len - ret, "bypass");
+			one = 1;
+		}
+		if (queue->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
+			if (one)
+				ret += snprintf(buf + ret, len - ret, ",");
+			ret += snprintf(buf + ret, len - ret, "fanout");
+		}
+	}
+	return ret;
+}
+
+static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
+					    struct nft_rule_expr *e)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	return snprintf(buf, len, "<num>%u</num>"
+				  "<total>%u</total>"
+				  "<flags>%u</flags>",
+			queue->queuenum, queue->queues_total,
+			queue->flags);
+}
+
+static int nft_rule_expr_queue_snprintf_json(char *buf, size_t len,
+					     struct nft_rule_expr *e)
+{
+	struct nft_expr_queue *queue = nft_expr_data(e);
+
+	return snprintf(buf, len, "\"num\":%u,"
+				  "\"total\":%u,"
+				  "\"flags\":%u,",
+			queue->queuenum, queue->queues_total,
+			queue->flags);
+}
+
+static int
+nft_rule_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
+			      uint32_t flags, struct nft_rule_expr *e)
+{
+
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		ret = snprintf(buf, len, "num %u total %u",
-				queue->queuenum, queue->queues_total);
-		if (queue->flags) {
-			ret += snprintf(buf + ret , len - ret, " options ");
-			if (queue->flags & NFT_QUEUE_FLAG_BYPASS) {
-				ret += snprintf(buf + ret ,
-						len - ret, "bypass");
-				one = 1;
-			}
-			if (queue->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
-				if (one)
-					ret += snprintf(buf + ret ,
-							len - ret, ",");
-				ret += snprintf(buf + ret ,
-						len - ret, "fanout");
-			}
-		}
-		return ret;
+		return nft_rule_expr_queue_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<num>%u</num>"
-					  "<total>%u</total>"
-					  "<flags>%u</flags>",
-				queue->queuenum, queue->queues_total,
-				queue->flags);
+		return nft_rule_expr_queue_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"num\":%u,"
-					  "\"total\":%u,"
-					  "\"flags\":%u,",
-				queue->queuenum, queue->queues_total,
-				queue->flags);
+		return nft_rule_expr_queue_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
2.0.0

