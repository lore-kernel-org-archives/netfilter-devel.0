From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] expr: queue: Use snprintf and SNPRINTF_BUFFER_SIZE in snprintf_default functions.
Date: Mon, 16 Jun 2014 11:06:37 +0200
Message-ID: <1402909598-24943-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59693 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJGr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:06:47 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so3634083wiv.8
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:06:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use snprintf and SNPRINTF_BUFFER_SIZE in
snprintf_default functions. Also, It adapts to the next syntax in queue
(Added in
http://git.netfilter.org/nftables/commit/?id=27619ffbe503ed4d9e59a02e81db9a7ac49d37af)

Here, some examples:

ip test input 31
  [ queue num 3-5 bypass fanout]

ip test input 32 31
  [ queue num 0]

ip test input 33 32
  [ queue num 4]

ip test input 34 33
  [ queue num 2-6 bypass]

table ip test {
	chain input {
		 type filter hook input priority 0;
		 queue num 3-5 bypass fanout
		 queue num 0
		 queue num 4
		 queue num 2-6 bypass
	}
}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/queue.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/src/expr/queue.c b/src/expr/queue.c
index 78540b6..282dc8b 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -187,24 +187,31 @@ static int nft_rule_expr_queue_snprintf_default(char *buf, size_t len,
 						struct nft_rule_expr *e)
 {
 	struct nft_expr_queue *queue = nft_expr_data(e);
-	int ret;
-	int one = 0;
-
-	ret = snprintf(buf, len, "num %u total %u", queue->queuenum,
-		       queue->queues_total);
-	if (queue->flags) {
-		ret += snprintf(buf + ret, len - ret, " options ");
-		if (queue->flags & NFT_QUEUE_FLAG_BYPASS) {
-			ret += snprintf(buf + ret, len - ret, "bypass");
-			one = 1;
+	int ret, size = len, offset = 0;
+	uint16_t total_queues;
+
+	total_queues = queue->queuenum + queue->queues_total -1;
+
+	ret = snprintf(buf + offset, len, "num %u", queue->queuenum);
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (queue->queues_total && total_queues != queue->queuenum) {
+		ret = snprintf(buf + offset, len, "-%u", total_queues);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_QUEUE_FLAGS)) {
+		if (queue->flags & (NFT_QUEUE_FLAG_BYPASS)) {
+			ret = snprintf(buf + offset, len, " bypass");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
-		if (queue->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
-			if (one)
-				ret += snprintf(buf + ret, len - ret, ",");
-			ret += snprintf(buf + ret, len - ret, "fanout");
+		if (queue->flags & (NFT_QUEUE_FLAG_CPU_FANOUT)) {
+			ret = snprintf(buf + offset, len, " fanout");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 	}
-	return ret;
+	return offset;
 }
 
 static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
@@ -213,7 +220,6 @@ static int nft_rule_expr_queue_snprintf_xml(char *buf, size_t len,
 	int ret, size = len, offset = 0;
 	struct nft_expr_queue *queue = nft_expr_data(e);
 
-
 	if (e->flags & (1 << NFT_EXPR_QUEUE_NUM)) {
 		ret = snprintf(buf + offset, len, "<num>%u</num>",
 			       queue->queuenum);
-- 
2.0.0

