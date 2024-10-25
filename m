Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EB91C07DA
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 07:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729843098; cv=none; b=oVAuLNr7QIeC5lK0tD+1dd6inSKDyUrYwFXF2iRNEcQZJnh1G2p4rCervHQuc9y6lFu288xyn4On0kae8VqSR2c/227aeFAkeZ4wTWYNWxxqEYOPkPMH7B9j01lKnLrIM+iIVfJUHGbY7kA9h2GzSJQSYYg4P8ep5p33A+PKmbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729843098; c=relaxed/simple;
	bh=W8io9J6aqXhMZuro3IWJngUSZF4dvk27PYQIEY36oOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uVC/tKwEXoHBvfuFFV6NXRJ9K+lR00jAeKJ3/NKJfIo5raPsBw3Qo86PhIH6gKVozZj/jCZe9QjBV7IkIvDpceX+//sykPwLKA7S7V1Jwaxm0S3264H/ncKhyB3bC9hdhMDnyjl8syZCOUSpI76X7gpyme3S+JbUgeeFKj1Ikss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t4FD2-0002Df-EW; Fri, 25 Oct 2024 09:58:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: allow to map key to nfqueue number
Date: Fri, 25 Oct 2024 09:47:25 +0200
Message-ID: <20241025074729.12412-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to specify a numeric queue id as part of a map.
The parser side is easy, but the reverse direction (listing) is not.

'queue' is a statement, it doesn't have an expression.

Add a generic 'typeof_data_expr' as a placeholder, this is used only
for udata build/parse, it stores the "key" (the parser token, here
"queue") as udata in kernel and can then restore the original key.

Integer expression doesn't work for listing because it doesn't tell what
frontend token should be shown.

'string' doesn't work as a placeholder either because we must use a
16 bit length type, as thats what the kernel needs to reserve in the
map to hold the queue id.

Add a dumpfile to validate parser & output.
JSON support is missing because JSON doesn't allow any sort of typeof
use at this time.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1455
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h                          |  15 ++-
 include/json.h                                |   2 +
 src/expression.c                              | 112 ++++++++++++++++++
 src/json.c                                    |   6 +
 src/parser_bison.y                            |   4 +
 tests/shell/testcases/nft-f/dumps/nfqueue.nft |  11 ++
 tests/shell/testcases/nft-f/nfqueue           |   6 +
 7 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/nft-f/dumps/nfqueue.nft
 create mode 100755 tests/shell/testcases/nft-f/nfqueue

diff --git a/include/expression.h b/include/expression.h
index 8982110cce95..10733be7c02c 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -48,6 +48,7 @@
  * @EXPR_XFRM		XFRM (ipsec) expression
  * @EXPR_SET_ELEM_CATCHALL catchall element expression
  * @EXPR_FLAGCMP	flagcmp expression
+ * @EXPR_TYPEOF:	integer basetype encapsulation for udata
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -80,8 +81,9 @@ enum expr_types {
 	EXPR_XFRM,
 	EXPR_SET_ELEM_CATCHALL,
 	EXPR_FLAGCMP,
+	EXPR_TYPEOF,
 
-	EXPR_MAX = EXPR_FLAGCMP
+	EXPR_MAX = EXPR_TYPEOF,
 };
 
 enum ops {
@@ -217,6 +219,10 @@ enum expr_flags {
 	EXPR_F_REMOVE		= 0x80,
 };
 
+enum expr_typeof_key {
+	EXPR_TYPEOF_NFQUEUE_ID,
+};
+
 #include <payload.h>
 #include <exthdr.h>
 #include <fib.h>
@@ -397,6 +403,10 @@ struct expr {
 			struct expr		*mask;
 			struct expr		*value;
 		} flagcmp;
+		struct {
+			/* EXPR_TYPEOF */
+			enum expr_typeof_key key;
+		} datatype;
 	};
 };
 
@@ -447,6 +457,9 @@ extern struct expr *relational_expr_alloc(const struct location *loc, enum ops o
 extern void relational_expr_pctx_update(struct proto_ctx *ctx,
 					const struct expr *expr);
 
+extern struct expr *typeof_expr_alloc(const struct location *loc,
+				      enum expr_typeof_key key);
+
 extern struct expr *verdict_expr_alloc(const struct location *loc,
 				       int verdict, struct expr *chain);
 
diff --git a/include/json.h b/include/json.h
index 39be8928e8ee..5b145cd51a0a 100644
--- a/include/json.h
+++ b/include/json.h
@@ -51,6 +51,7 @@ json_t *hash_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *constant_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx);
+json_t *typeof_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx);
 
@@ -158,6 +159,7 @@ EXPR_PRINT_STUB(hash_expr)
 EXPR_PRINT_STUB(fib_expr)
 EXPR_PRINT_STUB(constant_expr)
 EXPR_PRINT_STUB(socket_expr)
+EXPR_PRINT_STUB(typeof_expr)
 EXPR_PRINT_STUB(osf_expr)
 EXPR_PRINT_STUB(xfrm_expr)
 
diff --git a/src/expression.c b/src/expression.c
index c0cb7f22eb73..d74addb35c66 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -332,6 +332,117 @@ struct expr *symbol_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+#define NFTNL_UDATA_TYPEOF_KEY 0
+#define NFTNL_UDATA_TYPEOF_MAX NFTNL_UDATA_TYPEOF_KEY
+
+static int typeof_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				   const struct expr *expr)
+{
+	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_TYPEOF_KEY, expr->datatype.key))
+		return -1;
+
+	return 0;
+}
+
+static int typeof_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+	uint32_t value;
+
+	switch (type) {
+	case NFTNL_UDATA_TYPEOF_KEY:
+		if (len != sizeof(uint32_t))
+			return -1;
+
+		value = nftnl_udata_get_u32(attr);
+		switch (value) {
+		case EXPR_TYPEOF_NFQUEUE_ID:
+			break;
+		default:
+			return -1;
+		}
+
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+static struct expr *typeof_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_TYPEOF_MAX + 1] = {};
+	enum expr_typeof_key key;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				typeof_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_TYPEOF_KEY])
+		return NULL;
+
+	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_TYPEOF_KEY]);
+
+	return typeof_expr_alloc(&internal_location, key);
+}
+
+static const char * const typeof_key_str[] = {
+	[EXPR_TYPEOF_NFQUEUE_ID] = "queue",
+};
+
+static void typeof_expr_print(const struct expr *expr,
+			      struct output_ctx *octx)
+{
+	uint32_t v = expr->datatype.key;
+	const char *s = "unknown";
+
+	if (v < array_size(typeof_key_str))
+		s = typeof_key_str[v];
+
+	nft_print(octx, "%s", s);
+}
+
+static bool typeof_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->datatype.key == e2->datatype.key;
+}
+
+const struct expr_ops typeof_expr_ops = {
+	.type		= EXPR_TYPEOF,
+	.name		= "typeof",
+	.print		= typeof_expr_print,
+	.json		= typeof_expr_json,
+	.cmp		= typeof_expr_cmp,
+	.build_udata	= typeof_expr_build_udata,
+	.parse_udata	= typeof_expr_parse_udata,
+};
+
+struct expr *typeof_expr_alloc(const struct location *loc,
+			       enum expr_typeof_key key)
+{
+	enum byteorder bo = BYTEORDER_INVALID;
+	struct expr *expr;
+	unsigned int len;
+
+	switch (key) {
+	case EXPR_TYPEOF_NFQUEUE_ID:
+		bo = BYTEORDER_HOST_ENDIAN;
+		len = 16;
+		break;
+	}
+
+	expr = expr_alloc(loc, EXPR_TYPEOF, &integer_type, bo, len);
+	expr->datatype.key = key;
+
+	return expr;
+}
+
 static void variable_expr_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
@@ -1507,6 +1618,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 {
 	switch (etype) {
 	case EXPR_INVALID: break;
+	case EXPR_TYPEOF: return &typeof_expr_ops;
 	case EXPR_VERDICT: return &verdict_expr_ops;
 	case EXPR_SYMBOL: return &symbol_expr_ops;
 	case EXPR_VARIABLE: return &variable_expr_ops;
diff --git a/src/json.c b/src/json.c
index b1531ff3f4c9..94fd968120a7 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1020,6 +1020,12 @@ json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx)
 			 socket_templates[expr->socket.key].token);
 }
 
+json_t *typeof_expr_json(const struct expr *expr, struct output_ctx *octx)
+{
+	/* Need to add support for 'typeof' keyword in json set/map declarations first */
+	return NULL;
+}
+
 json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *root;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e2936d10efe4..7fa114957e3e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2160,6 +2160,10 @@ typeof_data_expr	:	INTERVAL	typeof_expr
 			{
 				$$ = $1;
 			}
+			|	QUEUE
+			{
+				$$ = typeof_expr_alloc(&@$, EXPR_TYPEOF_NFQUEUE_ID);
+			}
 			;
 
 typeof_expr		:	primary_expr
diff --git a/tests/shell/testcases/nft-f/dumps/nfqueue.nft b/tests/shell/testcases/nft-f/dumps/nfqueue.nft
new file mode 100644
index 000000000000..7fe3ca669544
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/nfqueue.nft
@@ -0,0 +1,11 @@
+table inet t {
+	map get_queue_id {
+		typeof ip saddr . ip daddr . tcp dport : queue
+		elements = { 127.0.0.1 . 127.0.0.1 . 22 : 1,
+			     127.0.0.1 . 127.0.0.2 . 22 : 2 }
+	}
+
+	chain test {
+		queue flags bypass to ip saddr . ip daddr . tcp dport map @get_queue_id
+	}
+}
diff --git a/tests/shell/testcases/nft-f/nfqueue b/tests/shell/testcases/nft-f/nfqueue
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/nft-f/nfqueue
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
-- 
2.45.2

