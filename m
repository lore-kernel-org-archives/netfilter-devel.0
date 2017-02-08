From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] src: consolidate XML/JSON exportation for rule
Date: Wed, 8 Feb 2017 21:12:53 +0530
Message-ID: <20170208154252.GA32430@Novo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34871 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753007AbdBHPo1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 10:44:27 -0500
Received: by mail-pf0-f196.google.com with SMTP id f144so11923642pfa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Feb 2017 07:43:20 -0800 (PST)
Received: from Novo ([2405:204:110b:d1a7:51bb:739:9943:6e91])
        by smtp.gmail.com with ESMTPSA id f191sm21511881pgc.12.2017.02.08.07.43.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Feb 2017 07:43:19 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This completes the XML/JSON exportation using the new buffer class for
rule.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 include/buffer.h |  5 +++
 src/buffer.c     | 11 +++++++
 src/rule.c       | 96 ++++++++++++++++----------------------------------------
 3 files changed, 43 insertions(+), 69 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index c571657..a3a50d7 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -35,12 +35,15 @@ int nftnl_buf_u64(struct nftnl_buf *b, int type, uint64_t value, const char *tag
 int nftnl_buf_str(struct nftnl_buf *b, int type, const char *str, const char *tag);
 int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 		int reg_type, const char *tag);
+int nftnl_buf_expr(struct nftnl_buf *b, int type);
 
 #define BASE			"base"
 #define BYTES			"bytes"
 #define BURST			"burst"
 #define CHAIN			"chain"
 #define CODE			"code"
+#define COMPAT_FLAGS		"compat_flags"
+#define COMPAT_PROTO		"compat_proto"
 #define CONSUMED		"consumed"
 #define DATA			"data"
 #define DEVICE			"device"
@@ -64,10 +67,12 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define PACKETS			"packets"
 #define PKTS			"pkts"
 #define POLICY			"policy"
+#define POSITION		"position"
 #define PREFIX			"prefix"
 #define PRIO			"prio"
 #define QTHRESH			"qthreshold"
 #define RATE			"rate"
+#define RULE			"rule"
 #define SET			"set"
 #define SET_NAME		"set_name"
 #define SIZE			"size"
diff --git a/src/buffer.c b/src/buffer.c
index d97d517..8dffef2 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -171,3 +171,14 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 	}
 	return 0;
 }
+
+int nftnl_buf_expr(struct nftnl_buf *b, int type)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_XML:
+		return 0;
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_buf_put(b, "\"expr\":[{");
+	}
+	return 0;
+}
diff --git a/src/rule.c b/src/rule.c
index 02d013b..5359972 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -20,6 +20,7 @@
 #include <errno.h>
 #include <inttypes.h>
 #include <ctype.h>
+#include <buffer.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -645,83 +646,40 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 }
 EXPORT_SYMBOL(nftnl_rule_parse_file);
 
-static int nftnl_rule_snprintf_json(char *buf, size_t size,
-				    const struct nftnl_rule *r,
-				    uint32_t type, uint32_t flags)
+static int nftnl_rule_export(char *buf, size_t size,
+			     const struct nftnl_rule *r,
+			     uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
 	struct nftnl_expr *expr;
 
-	ret = snprintf(buf, len, "{\"rule\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
-		ret = snprintf(buf+offset, len, "\"family\":\"%s\",",
-			       nftnl_family2str(r->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_TABLE)) {
-		ret = snprintf(buf+offset, len, "\"table\":\"%s\",",
-			       r->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_CHAIN)) {
-		ret = snprintf(buf+offset, len, "\"chain\":\"%s\",",
-			       r->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-	if (r->flags & (1 << NFTNL_RULE_HANDLE)) {
-		ret = snprintf(buf+offset, len, "\"handle\":%llu,",
-			       (unsigned long long)r->handle);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_COMPAT_PROTO) ||
-	    r->flags & (1 << NFTNL_RULE_COMPAT_FLAGS)) {
-		ret = snprintf(buf+offset, len, "\"compat_flags\":%u,"
-					        "\"compat_proto\":%u,",
-			       r->compat.flags, r->compat.proto);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	NFTNL_BUF_INIT(b, buf, size);
 
-	if (r->flags & (1 << NFTNL_RULE_POSITION)) {
-		ret = snprintf(buf+offset, len, "\"position\":%"PRIu64",",
-			       r->position);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	nftnl_buf_open(&b, type, RULE);
+	if (r->flags & (1 << NFTNL_RULE_FAMILY))
+		nftnl_buf_str(&b, type, nftnl_family2str(r->family), FAMILY);
+	if (r->flags & (1 << NFTNL_RULE_TABLE))
+		nftnl_buf_str(&b, type, r->table, TABLE);
+	if (r->flags & (1 << NFTNL_RULE_CHAIN))
+		nftnl_buf_str(&b, type, r->chain, CHAIN);
+	if (r->flags & (1 << NFTNL_RULE_HANDLE))
+		nftnl_buf_u64(&b, type, r->handle, HANDLE);
+	if (r->flags & (1 << NFTNL_RULE_COMPAT_PROTO))
+		nftnl_buf_u32(&b, type, r->compat.proto, COMPAT_PROTO);
+	if (r->flags & (1 << NFTNL_RULE_COMPAT_FLAGS))
+		nftnl_buf_u32(&b, type, r->compat.flags, COMPAT_FLAGS);
+	if (r->flags & (1 << NFTNL_RULE_POSITION))
+		nftnl_buf_u64(&b, type, r->position, POSITION);
 
-	ret = snprintf(buf+offset, len, "\"expr\":[");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	nftnl_buf_expr(&b, type);
 
 	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf+offset, len,
-			       "{\"type\":\"%s\",", expr->ops->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		/*
-		 * Remove comma from the first element if there is type
-		 * key-value pair only. Example: "expr":[{"type":"log"}]
-		 */
-		if (ret == 0) {
-			offset--;
-			len--;
-		}
-
-		ret = snprintf(buf+offset, len, "},");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
+		nftnl_buf_str(&b, type, expr->ops->name, TYPE);
+		vsnprintf(b.buf, b.len, flags, expr);
 	}
-	/* Remove comma from last element */
-	offset--;
-	ret = snprintf(buf+offset, len, "]}}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	return offset;
+	nftnl_buf_close(&b, type, RULE);
+
+	return nftnl_buf_done(&b);
 }
 
 static int nftnl_rule_snprintf_default(char *buf, size_t size,
@@ -813,7 +771,7 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 						inner_flags);
 		break;
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_rule_snprintf_json(buf+offset, len, r, type,
+		ret = nftnl_rule_export(buf+offset, len, r, type,
 					     inner_flags);
 		break;
 	case NFTNL_OUTPUT_XML:
-- 
2.7.4

