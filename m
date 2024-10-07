Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC51E519
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296626; cv=none; b=kXtHGKq0lbfLCQq9HJV5zbH1l4Hn2T71TTebAwiPsg8wUPDeEpRx0LO39wvl4znHqQHw2AD4+GAoyVkPvEyRU98twYDQ5QbXvQUotolmAvp+SMYvGFowwUbSmeGRjKznGKhKhZAX19jeO0qboxcqraqCJeqf4iOZqeIkfFqhYs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296626; c=relaxed/simple;
	bh=/Shnaeplg8/JMo3STy8E2nM+ahJ8E7pusEBi1zqBl4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkuO2/oe1OWZb57woA7jSE8HdOGFKelWwN09+jOCEP5dhTZOg3oxWbqNg/PNAV7yCWBpVfYLw22iD5vUyQ9q0tEGXxqIpOfdsfChj+84iFOe7IVNm8nUfxb3lmEp8iEaNXNJRZYebJTjg0arFdQSyBigMXiCuTnWpTUBrSyqnU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxktx-0006fH-0N; Mon, 07 Oct 2024 12:23:41 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/5] expr: add and use incomplete tag
Date: Mon,  7 Oct 2024 11:49:34 +0200
Message-ID: <20241007094943.7544-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend netlink dump decoder functions to set
expr->incomplete marker if there are unrecognized attributes
set in the kernel dump.

This can be used by frontend tools to provide a warning to the user
that the rule dump might be incomplete.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expr.h          |  1 +
 src/expr/bitwise.c      |  8 +++++---
 src/expr/byteorder.c    |  9 ++++++---
 src/expr/cmp.c          |  9 ++++++---
 src/expr/connlimit.c    |  9 ++++++---
 src/expr/counter.c      |  9 ++++++---
 src/expr/ct.c           |  9 ++++++---
 src/expr/data_reg.c     | 13 +++++++------
 src/expr/dup.c          |  9 ++++++---
 src/expr/dynset.c       |  9 ++++++---
 src/expr/exthdr.c       |  8 +++++---
 src/expr/fib.c          |  9 ++++++---
 src/expr/flow_offload.c |  9 ++++++---
 src/expr/fwd.c          |  8 +++++---
 src/expr/hash.c         |  8 +++++---
 src/expr/immediate.c    |  8 +++++---
 src/expr/inner.c        |  8 +++++---
 src/expr/last.c         |  8 +++++---
 src/expr/limit.c        |  8 +++++---
 src/expr/log.c          |  8 +++++---
 src/expr/lookup.c       |  8 +++++---
 src/expr/masq.c         |  8 +++++---
 src/expr/match.c        |  8 +++++---
 src/expr/meta.c         |  6 ++++++
 src/expr/nat.c          |  8 +++++---
 src/expr/numgen.c       |  8 +++++---
 src/expr/objref.c       |  8 +++++---
 src/expr/osf.c          |  9 +++++----
 src/expr/payload.c      |  8 +++++---
 src/expr/queue.c        |  9 ++++++---
 src/expr/quota.c        |  8 +++++---
 src/expr/range.c        |  8 +++++---
 src/expr/redir.c        |  8 +++++---
 src/expr/reject.c       |  9 ++++++---
 src/expr/rt.c           |  9 ++++++---
 src/expr/socket.c       |  9 ++++++---
 src/expr/synproxy.c     | 16 ++++++++--------
 src/expr/target.c       |  9 ++++++---
 src/expr/tproxy.c       |  8 +++++---
 src/expr/tunnel.c       |  8 +++++---
 src/expr/xfrm.c         |  8 +++++---
 41 files changed, 221 insertions(+), 126 deletions(-)

diff --git a/include/expr.h b/include/expr.h
index be45e954df5b..b1b724f1272f 100644
--- a/include/expr.h
+++ b/include/expr.h
@@ -6,6 +6,7 @@ struct expr_ops;
 struct nftnl_expr {
 	struct list_head	head;
 	uint32_t		flags;
+	bool			incomplete;
 	struct expr_ops		*ops;
 	uint8_t			data[];
 };
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index e99131a090ed..46346712e462 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -97,9 +97,6 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_BITWISE_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_BITWISE_SREG:
 	case NFTA_BITWISE_DREG:
@@ -114,6 +111,9 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_BITWISE_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -169,6 +169,8 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_bitwise_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_BITWISE_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_BITWISE_SREG]) {
 		bitwise->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_SREG);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 383e80d57b44..43f16cd8aa66 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -86,9 +86,6 @@ static int nftnl_expr_byteorder_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_BYTEORDER_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_BYTEORDER_SREG:
 	case NFTA_BYTEORDER_DREG:
@@ -98,6 +95,9 @@ static int nftnl_expr_byteorder_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_BYTEORDER_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -141,6 +141,9 @@ nftnl_expr_byteorder_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_byteorder_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_BYTEORDER_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_BYTEORDER_SREG]) {
 		byteorder->sreg =
 			ntohl(mnl_attr_get_u32(tb[NFTA_BYTEORDER_SREG]));
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index d1f0f64a56b3..b04ddfd6f8e1 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -72,9 +72,6 @@ static int nftnl_expr_cmp_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_CMP_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_CMP_SREG:
 	case NFTA_CMP_OP:
@@ -85,6 +82,9 @@ static int nftnl_expr_cmp_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_CMP_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -119,6 +119,9 @@ nftnl_expr_cmp_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_cmp_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_CMP_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_CMP_SREG]) {
 		cmp->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_CMP_SREG]));
 		e->flags |= (1 << NFTA_CMP_SREG);
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index fcac8bf170ac..6974be6b2808 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -64,15 +64,15 @@ static int nftnl_expr_connlimit_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_CONNLIMIT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_CONNLIMIT_COUNT:
 	case NFTA_CONNLIMIT_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_CONNLIMIT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -101,6 +101,9 @@ nftnl_expr_connlimit_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_connlimit_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_CONNLIMIT_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_CONNLIMIT_COUNT]) {
 		connlimit->count =
 			ntohl(mnl_attr_get_u32(tb[NFTA_CONNLIMIT_COUNT]));
diff --git a/src/expr/counter.c b/src/expr/counter.c
index cef911908981..56c1fd09ca1d 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -66,15 +66,15 @@ static int nftnl_expr_counter_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_COUNTER_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_COUNTER_BYTES:
 	case NFTA_COUNTER_PACKETS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_COUNTER_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -101,6 +101,9 @@ nftnl_expr_counter_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_counter_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_COUNTER_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_COUNTER_BYTES]) {
 		ctr->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_BYTES]));
 		e->flags |= (1 << NFTNL_EXPR_CTR_BYTES);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index bea0522d8937..caeefced189d 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -82,9 +82,6 @@ static int nftnl_expr_ct_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_CT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_CT_KEY:
 	case NFTA_CT_DREG:
@@ -96,6 +93,9 @@ static int nftnl_expr_ct_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_CT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -126,6 +126,9 @@ nftnl_expr_ct_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_ct_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_CT_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_CT_KEY]) {
 		ct->key = ntohl(mnl_attr_get_u32(tb[NFTA_CT_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_CT_KEY);
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d2ccf2e8dc68..149d52aea9b4 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -83,9 +83,6 @@ static int nftnl_data_parse_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_DATA_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_DATA_VALUE:
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
@@ -95,7 +92,11 @@ static int nftnl_data_parse_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_DATA_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
+
 	tb[type] = attr;
 	return MNL_CB_OK;
 }
@@ -105,9 +106,6 @@ static int nftnl_verdict_parse_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_VERDICT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_VERDICT_CODE:
 	case NFTA_VERDICT_CHAIN_ID:
@@ -118,6 +116,9 @@ static int nftnl_verdict_parse_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_VERDICT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 	tb[type] = attr;
 	return MNL_CB_OK;
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 28d686b1351b..c90a5c22cca7 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -62,15 +62,15 @@ static int nftnl_expr_dup_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_DUP_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_DUP_SREG_ADDR:
 	case NFTA_DUP_SREG_DEV:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_DUP_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -97,6 +97,9 @@ static int nftnl_expr_dup_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_dup_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_DUP_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_DUP_SREG_ADDR]) {
 		dup->sreg_addr = ntohl(mnl_attr_get_u32(tb[NFTA_DUP_SREG_ADDR]));
 		e->flags |= (1 << NFTNL_EXPR_DUP_SREG_ADDR);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 9d2bfe5e206b..b3a8a8bbc30b 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -118,9 +118,6 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_DYNSET_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_DYNSET_SREG_KEY:
 	case NFTA_DYNSET_SREG_DATA:
@@ -143,6 +140,9 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_DYNSET_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -233,6 +233,9 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_dynset_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_DYNSET_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_DYNSET_SREG_KEY]) {
 		dynset->sreg_key = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SREG_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_SREG_KEY);
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 453902c23017..74709330f42c 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -107,9 +107,6 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_EXTHDR_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_EXTHDR_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
@@ -124,6 +121,9 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_EXTHDR_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -160,6 +160,8 @@ nftnl_expr_exthdr_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_exthdr_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_EXTHDR_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_EXTHDR_DREG]) {
 		exthdr->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_EXTHDR_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_EXTHDR_DREG);
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 20bc125aa3ad..d34162170001 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -72,9 +72,6 @@ static int nftnl_expr_fib_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_FIB_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_FIB_RESULT:
 	case NFTA_FIB_DREG:
@@ -82,6 +79,9 @@ static int nftnl_expr_fib_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_FIB_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -111,6 +111,9 @@ nftnl_expr_fib_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_fib_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_FIB_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_FIB_RESULT]) {
 		fib->result = ntohl(mnl_attr_get_u32(tb[NFTA_FIB_RESULT]));
 		e->flags |= (1 << NFTNL_EXPR_FIB_RESULT);
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 5f209a63fa96..9973e162847c 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -47,14 +47,14 @@ static int nftnl_expr_flow_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_FLOW_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_FLOW_TABLE_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_FLOW_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -79,6 +79,9 @@ static int nftnl_expr_flow_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_flow_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_FLOW_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_FLOW_TABLE_NAME]) {
 		flow->table_name =
 			strdup(mnl_attr_get_str(tb[NFTA_FLOW_TABLE_NAME]));
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 04cb089a7146..2e789673ad1f 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -69,9 +69,6 @@ static int nftnl_expr_fwd_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_FWD_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_FWD_SREG_DEV:
 	case NFTA_FWD_SREG_ADDR:
@@ -79,6 +76,9 @@ static int nftnl_expr_fwd_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_FWD_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -107,6 +107,8 @@ static int nftnl_expr_fwd_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_fwd_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_FWD_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_FWD_SREG_DEV]) {
 		fwd->sreg_dev = ntohl(mnl_attr_get_u32(tb[NFTA_FWD_SREG_DEV]));
 		e->flags |= (1 << NFTNL_EXPR_FWD_SREG_DEV);
diff --git a/src/expr/hash.c b/src/expr/hash.c
index eb44b2ea9bb6..d7ec7c438422 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -100,9 +100,6 @@ static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_HASH_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_HASH_SREG:
 	case NFTA_HASH_DREG:
@@ -114,6 +111,9 @@ static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_HASH_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -151,6 +151,8 @@ nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_hash_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_HASH_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_HASH_SREG]) {
 		hash->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_HASH_SREG);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index ab1276a1772c..6100ca5e07a9 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -86,9 +86,6 @@ static int nftnl_expr_immediate_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_IMMEDIATE_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_IMMEDIATE_DREG:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
@@ -98,6 +95,9 @@ static int nftnl_expr_immediate_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_IMMEDIATE_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -148,6 +148,8 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_immediate_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_IMMEDIATE_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_IMMEDIATE_DREG]) {
 		imm->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_IMMEDIATE_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_IMM_DREG);
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 4f66e944ec91..f66fff2666f2 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -110,9 +110,6 @@ static int nftnl_inner_parse_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_INNER_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_INNER_NUM:
 	case NFTA_INNER_TYPE:
@@ -125,6 +122,9 @@ static int nftnl_inner_parse_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_INNER_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -144,6 +144,8 @@ nftnl_expr_inner_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_INNER_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_INNER_HDRSIZE]) {
 		inner->hdrsize =
 			ntohl(mnl_attr_get_u32(tb[NFTA_INNER_HDRSIZE]));
diff --git a/src/expr/last.c b/src/expr/last.c
index 8e5b88ebb96b..27d6a704cf45 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -62,9 +62,6 @@ static int nftnl_expr_last_cb(const struct nlattr *attr, void *data)
 	int type = mnl_attr_get_type(attr);
 	const struct nlattr **tb = data;
 
-	if (mnl_attr_type_valid(attr, NFTA_LAST_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_LAST_MSECS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
@@ -74,6 +71,9 @@ static int nftnl_expr_last_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_LAST_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -100,6 +100,8 @@ nftnl_expr_last_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_last_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_LAST_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_LAST_MSECS]) {
 		last->msecs = be64toh(mnl_attr_get_u64(tb[NFTA_LAST_MSECS]));
 		e->flags |= (1 << NFTNL_EXPR_LAST_MSECS);
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5b821081eb20..d1e1a109bc2d 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -87,9 +87,6 @@ static int nftnl_expr_limit_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_LIMIT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_LIMIT_RATE:
 	case NFTA_LIMIT_UNIT:
@@ -102,6 +99,9 @@ static int nftnl_expr_limit_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_LIMIT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -134,6 +134,8 @@ nftnl_expr_limit_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_limit_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_LIMIT_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_LIMIT_RATE]) {
 		limit->rate = be64toh(mnl_attr_get_u64(tb[NFTA_LIMIT_RATE]));
 		e->flags |= (1 << NFTNL_EXPR_LIMIT_RATE);
diff --git a/src/expr/log.c b/src/expr/log.c
index 18ec2b64a5b9..7d0fde25e4fd 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -98,9 +98,6 @@ static int nftnl_expr_log_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_LOG_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_LOG_PREFIX:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
@@ -117,6 +114,9 @@ static int nftnl_expr_log_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_LOG_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -151,6 +151,8 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_log_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_LOG_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_LOG_PREFIX]) {
 		if (log->prefix)
 			xfree(log->prefix);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 21a7fcef4041..65e56dae8af2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -88,9 +88,6 @@ static int nftnl_expr_lookup_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_LOOKUP_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_LOOKUP_SREG:
 	case NFTA_LOOKUP_DREG:
@@ -103,6 +100,9 @@ static int nftnl_expr_lookup_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_LOOKUP_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -137,6 +137,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_lookup_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_LOOKUP_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_LOOKUP_SREG]) {
 		lookup->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_SREG);
diff --git a/src/expr/masq.c b/src/expr/masq.c
index e0565db66fe1..031f20544198 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -71,9 +71,6 @@ static int nftnl_expr_masq_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_MASQ_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_MASQ_REG_PROTO_MIN:
 	case NFTA_MASQ_REG_PROTO_MAX:
@@ -81,6 +78,9 @@ static int nftnl_expr_masq_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_MASQ_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -111,6 +111,8 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_masq_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_MASQ_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_MASQ_FLAGS]) {
 		masq->flags = be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_MASQ_FLAGS);
diff --git a/src/expr/match.c b/src/expr/match.c
index 8c1bc74a1ce1..f499fd801670 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -84,9 +84,6 @@ static int nftnl_expr_match_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_MATCH_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_MATCH_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
@@ -100,6 +97,9 @@ static int nftnl_expr_match_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_MATCH_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -127,6 +127,8 @@ static int nftnl_expr_match_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_match_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_MATCH_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_MATCH_NAME]) {
 		snprintf(match->name, XT_EXTENSION_MAXNAMELEN, "%s",
 			 mnl_attr_get_str(tb[NFTA_MATCH_NAME]));
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 136a450b6e97..858e6dc44e93 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -86,6 +86,9 @@ static int nftnl_expr_meta_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_META_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -114,6 +117,9 @@ nftnl_expr_meta_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_meta_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_META_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_META_KEY]) {
 		meta->key = ntohl(mnl_attr_get_u32(tb[NFTA_META_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_META_KEY);
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1235ba45b694..0caaba1c0633 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -104,9 +104,6 @@ static int nftnl_expr_nat_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_NAT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_NAT_TYPE:
 	case NFTA_NAT_FAMILY:
@@ -118,6 +115,9 @@ static int nftnl_expr_nat_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_NAT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -133,6 +133,8 @@ nftnl_expr_nat_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_nat_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_NAT_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_NAT_TYPE]) {
 		nat->type = ntohl(mnl_attr_get_u32(tb[NFTA_NAT_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_NAT_TYPE);
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index c015b8847aa4..bbe82e30e1b3 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -80,9 +80,6 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_NG_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_NG_DREG:
 	case NFTA_NG_MODULUS:
@@ -91,6 +88,9 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_NG_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -122,6 +122,8 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_ng_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_NG_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_NG_DREG]) {
 		ng->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_NG_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_NG_DREG);
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 00538057222b..8a820d549733 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -91,9 +91,6 @@ static int nftnl_expr_objref_cb(const struct nlattr *attr, void *data)
 	int type = mnl_attr_get_type(attr);
 	const struct nlattr **tb = data;
 
-	if (mnl_attr_type_valid(attr, NFTA_OBJREF_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_OBJREF_IMM_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
@@ -109,6 +106,9 @@ static int nftnl_expr_objref_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_OBJREF_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -143,6 +143,8 @@ static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_objref_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_OBJREF_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_OBJREF_IMM_TYPE]) {
 		objref->imm.type =
 			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_IMM_TYPE]));
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 293a81420a32..9b1197b4e0be 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -62,9 +62,6 @@ static int nftnl_expr_osf_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_OSF_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTNL_EXPR_OSF_DREG:
 	case NFTNL_EXPR_OSF_FLAGS:
@@ -76,7 +73,9 @@ static int nftnl_expr_osf_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
-
+	default:
+		tb[NFTA_OSF_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -106,6 +105,8 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_osf_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_OSF_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_OSF_DREG]) {
 		osf->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_OSF_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_OSF_DREG);
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 35cd10c31b98..f040e9e89a11 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -110,9 +110,6 @@ static int nftnl_expr_payload_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_PAYLOAD_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_PAYLOAD_SREG:
 	case NFTA_PAYLOAD_DREG:
@@ -125,6 +122,9 @@ static int nftnl_expr_payload_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_PAYLOAD_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -166,6 +166,8 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_payload_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_PAYLOAD_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_PAYLOAD_SREG]) {
 		payload->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_PAYLOAD_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_PAYLOAD_SREG);
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 09220c4a1138..d14d2964339f 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -77,9 +77,6 @@ static int nftnl_expr_queue_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_QUEUE_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_QUEUE_NUM:
 	case NFTA_QUEUE_TOTAL:
@@ -91,6 +88,9 @@ static int nftnl_expr_queue_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_QUEUE_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -121,6 +121,9 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_queue_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_QUEUE_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_QUEUE_NUM]) {
 		queue->queuenum = ntohs(mnl_attr_get_u16(tb[NFTA_QUEUE_NUM]));
 		e->flags |= (1 << NFTNL_EXPR_QUEUE_NUM);
diff --git a/src/expr/quota.c b/src/expr/quota.c
index ddf232f9f3ac..e71feeed09f0 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -69,9 +69,6 @@ static int nftnl_expr_quota_cb(const struct nlattr *attr, void *data)
 	int type = mnl_attr_get_type(attr);
 	const struct nlattr **tb = data;
 
-	if (mnl_attr_type_valid(attr, NFTA_QUOTA_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_QUOTA_BYTES:
 	case NFTA_QUOTA_CONSUMED:
@@ -82,6 +79,9 @@ static int nftnl_expr_quota_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_QUOTA_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -110,6 +110,8 @@ nftnl_expr_quota_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_quota_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_QUOTA_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_QUOTA_BYTES]) {
 		quota->bytes = be64toh(mnl_attr_get_u64(tb[NFTA_QUOTA_BYTES]));
 		e->flags |= (1 << NFTNL_EXPR_QUOTA_BYTES);
diff --git a/src/expr/range.c b/src/expr/range.c
index 96bb140119b6..ac419cd181fe 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -74,9 +74,6 @@ static int nftnl_expr_range_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_RANGE_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_RANGE_SREG:
 	case NFTA_RANGE_OP:
@@ -88,6 +85,9 @@ static int nftnl_expr_range_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_RANGE_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -131,6 +131,8 @@ nftnl_expr_range_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_range_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_RANGE_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_RANGE_SREG]) {
 		range->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_RANGE_SREG]));
 		e->flags |= (1 << NFTA_RANGE_SREG);
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 9971306130fb..b66326fad6ce 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -71,9 +71,6 @@ static int nftnl_expr_redir_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_REDIR_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_REDIR_REG_PROTO_MIN:
 	case NFTA_REDIR_REG_PROTO_MAX:
@@ -81,6 +78,9 @@ static int nftnl_expr_redir_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_REDIR_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -111,6 +111,8 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_redir_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_REDIR_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		redir->sreg_proto_min =
 			ntohl(mnl_attr_get_u32(tb[NFTA_REDIR_REG_PROTO_MIN]));
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 9090db3f697a..3a8487ebae63 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -64,9 +64,6 @@ static int nftnl_expr_reject_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_REJECT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_REJECT_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
@@ -76,6 +73,9 @@ static int nftnl_expr_reject_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_REJECT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -102,6 +102,9 @@ nftnl_expr_reject_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_reject_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_REJECT_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_REJECT_TYPE]) {
 		reject->type = ntohl(mnl_attr_get_u32(tb[NFTA_REJECT_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_REJECT_TYPE);
diff --git a/src/expr/rt.c b/src/expr/rt.c
index ff4fd03c8f1b..fee5594217b9 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -63,15 +63,15 @@ static int nftnl_expr_rt_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_RT_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_RT_KEY:
 	case NFTA_RT_DREG:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_RT_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -98,6 +98,9 @@ nftnl_expr_rt_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_rt_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_RT_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_RT_KEY]) {
 		rt->key = ntohl(mnl_attr_get_u32(tb[NFTA_RT_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_RT_KEY);
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 7a25cdf806d1..0e990cdf9b78 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -70,9 +70,6 @@ static int nftnl_expr_socket_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_SOCKET_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_SOCKET_KEY:
 	case NFTA_SOCKET_DREG:
@@ -80,6 +77,9 @@ static int nftnl_expr_socket_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_SOCKET_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -108,6 +108,9 @@ nftnl_expr_socket_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_socket_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_SOCKET_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_SOCKET_KEY]) {
 		socket->key = ntohl(mnl_attr_get_u32(tb[NFTA_SOCKET_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_SOCKET_KEY);
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index b5a1fef9f406..eb3c9b062999 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -60,24 +60,22 @@ static int nftnl_expr_synproxy_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_SYNPROXY_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
-	case NFTNL_EXPR_SYNPROXY_MSS:
+	case NFTA_SYNPROXY_MSS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
 			abi_breakage();
 		break;
-
-	case NFTNL_EXPR_SYNPROXY_WSCALE:
+	case NFTA_SYNPROXY_WSCALE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
-
-	case NFTNL_EXPR_SYNPROXY_FLAGS:
+	case NFTA_SYNPROXY_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_SYNPROXY_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -109,6 +107,8 @@ nftnl_expr_synproxy_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_synproxy_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_SYNPROXY_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_SYNPROXY_MSS]) {
 		synproxy->mss = ntohs(mnl_attr_get_u16(tb[NFTA_SYNPROXY_MSS]));
 		e->flags |= (1 << NFTNL_EXPR_SYNPROXY_MSS);
diff --git a/src/expr/target.c b/src/expr/target.c
index 8259a20a66cb..7b7795bcb6e3 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -84,9 +84,6 @@ static int nftnl_expr_target_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_TARGET_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_TARGET_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
@@ -100,6 +97,9 @@ static int nftnl_expr_target_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_TARGET_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -127,6 +127,9 @@ static int nftnl_expr_target_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_target_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_TARGET_UNSPEC])
+		e->incomplete = true;
+
 	if (tb[NFTA_TARGET_NAME]) {
 		snprintf(target->name, XT_EXTENSION_MAXNAMELEN, "%s",
 			 mnl_attr_get_str(tb[NFTA_TARGET_NAME]));
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 9391ce880cd3..72aac9edea0b 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -72,9 +72,6 @@ static int nftnl_expr_tproxy_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_TPROXY_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_TPROXY_FAMILY:
 	case NFTA_TPROXY_REG_ADDR:
@@ -82,6 +79,9 @@ static int nftnl_expr_tproxy_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_TPROXY_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -97,6 +97,8 @@ nftnl_expr_tproxy_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_tproxy_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_TPROXY_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_TPROXY_FAMILY]) {
 		tproxy->family = ntohl(mnl_attr_get_u32(tb[NFTA_TPROXY_FAMILY]));
 		e->flags |= (1 << NFTNL_EXPR_TPROXY_FAMILY);
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index 861e56dd64c2..54c3f5886edf 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -62,15 +62,15 @@ static int nftnl_expr_tunnel_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch(type) {
 	case NFTA_TUNNEL_KEY:
 	case NFTA_TUNNEL_DREG:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_TUNNEL_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -97,6 +97,8 @@ nftnl_expr_tunnel_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_tunnel_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_TUNNEL_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_TUNNEL_KEY]) {
 		tunnel->key = ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_TUNNEL_KEY);
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 2585579c3b54..54d102638ef5 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -78,9 +78,6 @@ static int nftnl_expr_xfrm_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_XFRM_MAX) < 0)
-		return MNL_CB_OK;
-
 	switch (type) {
 	case NFTA_XFRM_DREG:
 	case NFTA_XFRM_KEY:
@@ -92,6 +89,9 @@ static int nftnl_expr_xfrm_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
+	default:
+		tb[NFTA_XFRM_UNSPEC] = attr;
+		return MNL_CB_OK;
 	}
 
 	tb[type] = attr;
@@ -122,6 +122,8 @@ nftnl_expr_xfrm_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_xfrm_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_XFRM_UNSPEC])
+		e->incomplete = true;
 	if (tb[NFTA_XFRM_KEY]) {
 		x->key = ntohl(mnl_attr_get_u32(tb[NFTA_XFRM_KEY]));
 		e->flags |= (1 << NFTNL_EXPR_XFRM_KEY);
-- 
2.45.2

