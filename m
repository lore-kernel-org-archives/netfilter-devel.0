From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH libnftnl] src: Use nftnl_buf to export XML/JSON rules
Date: Thu, 2 Mar 2017 15:34:13 -0300
Message-ID: <20170302183413.GA28448@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36116 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdCBSkt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 13:40:49 -0500
Received: by mail-qk0-f194.google.com with SMTP id m67so3718949qkf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Mar 2017 10:40:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This completes the use of nftnl_buf and its auxiliary functions to
export XML/JSON rules.

Highly based on work from Shivani Bhardwaj <shivanib134@gmail.com>.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/buffer.h |  11 ++++++
 src/buffer.c     |  46 ++++++++++++++++++++++++
 src/rule.c       | 104 ++++++++++++++++---------------------------------------
 3 files changed, 86 insertions(+), 75 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index c571657..f556895 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -4,6 +4,8 @@
 #include <stdint.h>
 #include <stdbool.h>
 
+struct nftnl_expr;
+
 struct nftnl_buf {
 	char		*buf;
 	size_t		size;
@@ -35,12 +37,18 @@ int nftnl_buf_u64(struct nftnl_buf *b, int type, uint64_t value, const char *tag
 int nftnl_buf_str(struct nftnl_buf *b, int type, const char *str, const char *tag);
 int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 		int reg_type, const char *tag);
+int nftnl_buf_expr_open(struct nftnl_buf *b, int type);
+int nftnl_buf_expr_close(struct nftnl_buf *b, int type);
+int nftnl_buf_expr(struct nftnl_buf *b, int type, uint32_t flags,
+		   struct nftnl_expr *expr);
 
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
@@ -64,10 +72,12 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
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
@@ -93,5 +103,6 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define FLUSH			"flush"
 #define MODULUS			"modulus"
 #define SEED			"seed"
+#define ID			"id"
 
 #endif
diff --git a/src/buffer.c b/src/buffer.c
index d97d517..f9d5a83 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -171,3 +171,49 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 	}
 	return 0;
 }
+
+int nftnl_buf_expr_open(struct nftnl_buf *b, int type)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_XML:
+		return 0;
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_buf_put(b, "\"expr\":[");
+	}
+	return 0;
+}
+
+int nftnl_buf_expr_close(struct nftnl_buf *b, int type)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_XML:
+		return 0;
+	case NFTNL_OUTPUT_JSON:
+		nftnl_buf_done(b);
+		return nftnl_buf_put(b, "]");
+	}
+	return 0;
+}
+
+int nftnl_buf_expr(struct nftnl_buf *b, int type, uint32_t flags,
+		   struct nftnl_expr *expr)
+{
+	int ret;
+
+	switch (type) {
+	case NFTNL_OUTPUT_XML:
+		return 0;
+	case NFTNL_OUTPUT_JSON:
+		nftnl_buf_put(b, "{");
+		nftnl_buf_str(b, type, expr->ops->name, TYPE);
+		ret = expr->ops->snprintf(b->buf + b->off, b->len, type, flags,
+					  expr);
+		if (ret > 0)
+			nftnl_buf_update(b, ret);
+		else
+			nftnl_buf_done(b);
+
+		return nftnl_buf_put(b, "},");
+	}
+	return 0;
+}
diff --git a/src/rule.c b/src/rule.c
index 31cd3ed..6c22141 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -20,6 +20,7 @@
 #include <errno.h>
 #include <inttypes.h>
 #include <ctype.h>
+#include <buffer.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -671,88 +672,41 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
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
+	NFTNL_BUF_INIT(b, buf, size);
 
-	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
-		ret = snprintf(buf+offset, len, "\"family\":\"%s\",",
-			       nftnl_family2str(r->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	nftnl_buf_open(&b, type, RULE);
 
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
-
-	if (r->flags & (1 << NFTNL_RULE_POSITION)) {
-		ret = snprintf(buf+offset, len, "\"position\":%"PRIu64",",
-			       r->position);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (r->flags & (1 << NFTNL_RULE_ID)) {
-		ret = snprintf(buf+offset, len, "\"id\":%u,", r->id);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf+offset, len, "\"expr\":[");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	list_for_each_entry(expr, &r->expr_list, head) {
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
+	if (r->flags & (1 << NFTNL_RULE_ID))
+		nftnl_buf_u32(&b, type, r->id, ID);
 
-		ret = snprintf(buf+offset, len, "},");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	nftnl_buf_expr_open(&b, type);
+	list_for_each_entry(expr, &r->expr_list, head)
+		nftnl_buf_expr(&b, type, flags, expr);
+	nftnl_buf_expr_close(&b, type);
 
-	}
-	/* Remove comma from last element */
-	offset--;
-	ret = snprintf(buf+offset, len, "]}}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	nftnl_buf_close(&b, type, RULE);
 
-	return offset;
+	return nftnl_buf_done(&b);
 }
 
 static int nftnl_rule_snprintf_default(char *buf, size_t size,
@@ -849,7 +803,7 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
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

