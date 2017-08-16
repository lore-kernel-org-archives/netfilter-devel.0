From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 14/16] erec: add function to free list
Date: Wed, 16 Aug 2017 22:43:08 +0200
Message-ID: <20170816204310.3371-15-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40686 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752262AbdHPVZa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:30 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/erec.h |  1 +
 src/erec.c     | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa..befc274 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -60,6 +60,7 @@ static inline void erec_queue(struct error_record *erec,
 
 extern void erec_print(FILE *f, const struct error_record *erec);
 extern void erec_print_list(FILE *f, struct list_head *list);
+void erec_free_list(struct list_head *list);
 
 struct eval_ctx;
 
diff --git a/src/erec.c b/src/erec.c
index 439add9..f454d34 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -213,6 +213,16 @@ void erec_print_list(FILE *f, struct list_head *list)
 	}
 }
 
+void erec_free_list(struct list_head *list)
+{
+	struct error_record *erec, *next;
+
+	list_for_each_entry_safe(erec, next, list, list) {
+		list_del(&erec->list);
+		erec_destroy(erec);
+	}
+}
+
 int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 					  const struct location *l1,
 					  const struct location *l2,
-- 
2.14.1

