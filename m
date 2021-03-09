Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E6EC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08916525F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhCIPqC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhCIPpi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ABEC06175F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:37 -0800 (PST)
Received: from localhost ([::1]:56650 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYC-00016d-6I; Tue, 09 Mar 2021 16:45:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 05/10] expr: Check output type once and for all
Date:   Tue,  9 Mar 2021 16:45:11 +0100
Message-Id: <20210309154516.4987-6-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is but a single supported output type left, so check it in expr.c
and drop all the single option switch statements in individual
expressions.

Since the parameter is now unused (and to ensure code correctness), drop
'type' parameter from struct expr_ops' snprintf callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expr_ops.h      |  2 +-
 src/expr.c              |  4 ++--
 src/expr/bitwise.c      | 18 +++---------------
 src/expr/byteorder.c    | 20 +++-----------------
 src/expr/cmp.c          | 20 +++-----------------
 src/expr/connlimit.c    | 20 +++-----------------
 src/expr/counter.c      | 20 +++-----------------
 src/expr/ct.c           | 19 ++-----------------
 src/expr/dup.c          | 19 ++-----------------
 src/expr/dynset.c       | 19 ++-----------------
 src/expr/exthdr.c       | 20 +++-----------------
 src/expr/fib.c          | 19 ++-----------------
 src/expr/flow_offload.c | 18 ++----------------
 src/expr/fwd.c          | 19 ++-----------------
 src/expr/hash.c         | 19 ++-----------------
 src/expr/immediate.c    | 20 ++------------------
 src/expr/limit.c        | 20 +++-----------------
 src/expr/log.c          | 20 +++-----------------
 src/expr/lookup.c       | 19 ++-----------------
 src/expr/masq.c         | 18 ++----------------
 src/expr/match.c        | 13 ++-----------
 src/expr/meta.c         | 19 ++-----------------
 src/expr/nat.c          | 19 ++-----------------
 src/expr/numgen.c       | 19 ++-----------------
 src/expr/objref.c       | 20 +++-----------------
 src/expr/osf.c          | 20 +++-----------------
 src/expr/payload.c      | 32 ++++++++++++--------------------
 src/expr/queue.c        | 20 +++-----------------
 src/expr/quota.c        | 20 +++-----------------
 src/expr/range.c        | 18 ++----------------
 src/expr/redir.c        | 20 +++-----------------
 src/expr/reject.c       | 20 +++-----------------
 src/expr/rt.c           | 19 ++-----------------
 src/expr/socket.c       | 19 ++-----------------
 src/expr/synproxy.c     | 20 +++-----------------
 src/expr/target.c       | 13 ++-----------
 src/expr/tproxy.c       | 17 ++---------------
 src/expr/tunnel.c       | 19 ++-----------------
 src/expr/xfrm.c         | 19 ++-----------------
 39 files changed, 102 insertions(+), 617 deletions(-)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index 5237ac791588b..7a6aa23f9bd1d 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -18,7 +18,7 @@ struct expr_ops {
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
-	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
+	int	(*snprintf)(char *buf, size_t len, uint32_t flags, const struct nftnl_expr *e);
 };
 
 struct expr_ops *nftnl_expr_ops_lookup(const char *name);
diff --git a/src/expr.c b/src/expr.c
index 8e0bce2643b17..01c55cf2e880b 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -279,10 +279,10 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 	if (size)
 		buf[0] = '\0';
 
-	if (!expr->ops->snprintf)
+	if (!expr->ops->snprintf || type != NFTNL_OUTPUT_DEFAULT)
 		return 0;
 
-	ret = expr->ops->snprintf(buf + offset, remain, type, flags, expr);
+	ret = expr->ops->snprintf(buf + offset, remain, flags, expr);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ba379a84485e4..139f25f86b802 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -252,8 +252,9 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
 	return offset;
 }
 
-static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
-					       const struct nftnl_expr *e)
+static int
+nftnl_expr_bitwise_snprintf(char *buf, size_t size,
+			    uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 	int err = -1;
@@ -273,19 +274,6 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 	return err;
 }
 
-static int
-nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
-			    uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_bitwise_snprintf_default(buf, size, e);
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_bitwise = {
 	.name		= "bitwise",
 	.alloc_len	= sizeof(struct nftnl_expr_bitwise),
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index efdfa2b5eca4c..9718b8fe2506c 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -197,8 +197,9 @@ static inline int nftnl_str2ntoh(const char *op)
 	}
 }
 
-static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
-						 const struct nftnl_expr *e)
+static int
+nftnl_expr_byteorder_snprintf(char *buf, size_t size,
+			      uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -211,21 +212,6 @@ static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
-			      uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_byteorder_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_byteorder = {
 	.name		= "byteorder",
 	.alloc_len	= sizeof(struct nftnl_expr_byteorder),
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 86d7842d0813e..6b1c0fa3ac97f 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -176,8 +176,9 @@ static inline int nftnl_str2cmp(const char *op)
 	}
 }
 
-static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+static int
+nftnl_expr_cmp_snprintf(char *buf, size_t size,
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -193,21 +194,6 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_cmp_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_cmp = {
 	.name		= "cmp",
 	.alloc_len	= sizeof(struct nftnl_expr_cmp),
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 53af93bd8db94..3b37587e7e4ec 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -117,8 +117,9 @@ nftnl_expr_connlimit_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_connlimit_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_expr *e)
+static int nftnl_expr_connlimit_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_connlimit *connlimit = nftnl_expr_data(e);
 
@@ -126,21 +127,6 @@ static int nftnl_expr_connlimit_snprintf_default(char *buf, size_t len,
 			connlimit->count, connlimit->flags);
 }
 
-static int nftnl_expr_connlimit_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_connlimit_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_connlimit = {
 	.name		= "connlimit",
 	.alloc_len	= sizeof(struct nftnl_expr_connlimit),
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 89a602e0dcb6e..1676d70a46bda 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -115,8 +115,9 @@ nftnl_expr_counter_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_counter_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_expr *e)
+static int nftnl_expr_counter_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_counter *ctr = nftnl_expr_data(e);
 
@@ -124,21 +125,6 @@ static int nftnl_expr_counter_snprintf_default(char *buf, size_t len,
 			ctr->pkts, ctr->bytes);
 }
 
-static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_counter_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_counter = {
 	.name		= "counter",
 	.alloc_len	= sizeof(struct nftnl_expr_counter),
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 1a21c953c9be2..f4a7dc6932cb0 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -223,8 +223,8 @@ static inline int str2ctdir(const char *str, uint8_t *ctdir)
 }
 
 static int
-nftnl_expr_ct_snprintf_default(char *buf, size_t size,
-			       const struct nftnl_expr *e)
+nftnl_expr_ct_snprintf(char *buf, size_t size,
+		       uint32_t flags, const struct nftnl_expr *e)
 {
 	int ret, remain = size, offset = 0;
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
@@ -250,21 +250,6 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_ct_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_ct = {
 	.name		= "ct",
 	.alloc_len	= sizeof(struct nftnl_expr_ct),
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 7a3ee96361644..3eb560a21077f 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -111,9 +111,8 @@ static int nftnl_expr_dup_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
-					   const struct nftnl_expr *e,
-					   uint32_t flags)
+static int nftnl_expr_dup_snprintf(char *buf, size_t len,
+				   uint32_t flags, const struct nftnl_expr *e)
 {
 	int remain = len, offset = 0, ret;
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
@@ -131,20 +130,6 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
-				   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_dup_snprintf_default(buf, len, e, flags);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_dup = {
 	.name		= "dup",
 	.alloc_len	= sizeof(struct nftnl_expr_dup),
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index a9b11f27e819b..2ddf69a02b9de 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -308,8 +308,8 @@ static const char *op2str(enum nft_dynset_ops op)
 }
 
 static int
-nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
-				   const struct nftnl_expr *e)
+nftnl_expr_dynset_snprintf(char *buf, size_t size,
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nftnl_expr *expr;
@@ -346,21 +346,6 @@ nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_dynset_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 static void nftnl_expr_dynset_init(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index e5f714b07366f..1b813b1e47c4d 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -235,8 +235,9 @@ static inline int str2exthdr_type(const char *str)
 	return -1;
 }
 
-static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
-					      const struct nftnl_expr *e)
+static int
+nftnl_expr_exthdr_snprintf(char *buf, size_t len,
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
 
@@ -253,21 +254,6 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 
 }
 
-static int
-nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_exthdr_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_exthdr = {
 	.name		= "exthdr",
 	.alloc_len	= sizeof(struct nftnl_expr_exthdr),
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 9475af4047381..b0cbb3b752153 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -143,8 +143,8 @@ static const char *fib_type_str(enum nft_fib_result r)
 }
 
 static int
-nftnl_expr_fib_snprintf_default(char *buf, size_t size,
-				const struct nftnl_expr *e)
+nftnl_expr_fib_snprintf(char *buf, size_t size,
+			 uint32_t printflags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret, i;
@@ -190,21 +190,6 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_fib_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_fib_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_fib = {
 	.name		= "fib",
 	.alloc_len	= sizeof(struct nftnl_expr_fib),
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 6ccec9a133963..188269113ee8a 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -92,8 +92,8 @@ static int nftnl_expr_flow_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_flow_snprintf_default(char *buf, size_t size,
-					    const struct nftnl_expr *e)
+static int nftnl_expr_flow_snprintf(char *buf, size_t size,
+				    uint32_t flags, const struct nftnl_expr *e)
 {
 	int remain = size, offset = 0, ret;
 	struct nftnl_expr_flow *l = nftnl_expr_data(e);
@@ -104,20 +104,6 @@ static int nftnl_expr_flow_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_expr_flow_snprintf(char *buf, size_t size, uint32_t type,
-				    uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_flow_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 static void nftnl_expr_flow_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 2ec63c16dfe6e..0322be8f4aa4b 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -125,9 +125,8 @@ static int nftnl_expr_fwd_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
-					   const struct nftnl_expr *e,
-					   uint32_t flags)
+static int nftnl_expr_fwd_snprintf(char *buf, size_t len,
+				   uint32_t flags, const struct nftnl_expr *e)
 {
 	int remain = len, offset = 0, ret;
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
@@ -151,20 +150,6 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
-				   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_fwd_snprintf_default(buf, len, e, flags);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_fwd = {
 	.name		= "fwd",
 	.alloc_len	= sizeof(struct nftnl_expr_fwd),
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 2c801d28661f7..86b5ca6f0dfd0 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -184,8 +184,8 @@ nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_hash_snprintf_default(char *buf, size_t size,
-				 const struct nftnl_expr *e)
+nftnl_expr_hash_snprintf(char *buf, size_t size,
+			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -218,21 +218,6 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_hash_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_hash = {
 	.name		= "hash",
 	.alloc_len	= sizeof(struct nftnl_expr_hash),
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 7f34772bd0013..08ddd22a54c5f 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -184,9 +184,8 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
-				      const struct nftnl_expr *e,
-				      uint32_t flags)
+nftnl_expr_immediate_snprintf(char *buf, size_t len,
+			      uint32_t flags, const struct nftnl_expr *e)
 {
 	int remain = len, offset = 0, ret;
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
@@ -213,21 +212,6 @@ nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int
-nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
-			      uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_immediate_snprintf_default(buf, len, e, flags);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5872e276dbb80..3dfd54a8dd112 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -183,8 +183,9 @@ static const char *limit_to_type(enum nft_limit_type type)
 	}
 }
 
-static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
-					     const struct nftnl_expr *e)
+static int
+nftnl_expr_limit_snprintf(char *buf, size_t len,
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 
@@ -193,21 +194,6 @@ static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
 			limit_to_type(limit->type), limit->flags);
 }
 
-static int
-nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_limit_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_limit = {
 	.name		= "limit",
 	.alloc_len	= sizeof(struct nftnl_expr_limit),
diff --git a/src/expr/log.c b/src/expr/log.c
index bbe43d2dc6bcc..d56fad56d27cd 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -186,8 +186,9 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+static int
+nftnl_expr_log_snprintf(char *buf, size_t size,
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 	int ret, offset = 0, remain = size;
@@ -236,21 +237,6 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_log_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 static void nftnl_expr_log_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index a495ac0fdcfc8..ec7f6fb99e066 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -168,8 +168,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
-				   const struct nftnl_expr *e)
+nftnl_expr_lookup_snprintf(char *buf, size_t size,
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	int remain = size, offset = 0, ret;
 	struct nftnl_expr_lookup *l = nftnl_expr_data(e);
@@ -190,21 +190,6 @@ nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_lookup_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 static void nftnl_expr_lookup_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_lookup *lookup = nftnl_expr_data(e);
diff --git a/src/expr/masq.c b/src/expr/masq.c
index ea66fecdf2a72..1f6dbdb9cc33d 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -131,8 +131,8 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
-					    const struct nftnl_expr *e)
+static int nftnl_expr_masq_snprintf(char *buf, size_t len,
+				    uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 	int remain = len, offset = 0, ret = 0;
@@ -155,20 +155,6 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
-				    uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_masq_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_masq = {
 	.name		= "masq",
 	.alloc_len	= sizeof(struct nftnl_expr_masq),
diff --git a/src/expr/match.c b/src/expr/match.c
index 4fa74b2da893c..533fdf5c7ac3b 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -165,21 +165,12 @@ static int nftnl_expr_match_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
+nftnl_expr_match_snprintf(char *buf, size_t len,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "name %s rev %u ",
-				match->name, match->rev);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
+	return snprintf(buf, len, "name %s rev %u ", match->name, match->rev);
 }
 
 static void nftnl_expr_match_free(const struct nftnl_expr *e)
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6ed8ee5645c4b..34fbb9bb63c03 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -192,8 +192,8 @@ static inline int str2meta_key(const char *str)
 }
 
 static int
-nftnl_expr_meta_snprintf_default(char *buf, size_t len,
-				 const struct nftnl_expr *e)
+nftnl_expr_meta_snprintf(char *buf, size_t len,
+			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 
@@ -208,21 +208,6 @@ nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 	return 0;
 }
 
-static int
-nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_meta_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_meta = {
 	.name		= "meta",
 	.alloc_len	= sizeof(struct nftnl_expr_meta),
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 91a1ae6c99a43..25d4e9206da79 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -221,8 +221,8 @@ static inline int nftnl_str2nat(const char *nat)
 }
 
 static int
-nftnl_expr_nat_snprintf_default(char *buf, size_t size,
-				const struct nftnl_expr *e)
+nftnl_expr_nat_snprintf(char *buf, size_t size,
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret = 0;
@@ -266,21 +266,6 @@ nftnl_expr_nat_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_nat_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_nat = {
 	.name		= "nat",
 	.alloc_len	= sizeof(struct nftnl_expr_nat),
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 4e0d54158646c..602e4c0f77426 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -143,8 +143,8 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_ng_snprintf_default(char *buf, size_t size,
-			       const struct nftnl_expr *e)
+nftnl_expr_ng_snprintf(char *buf, size_t size,
+		       uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -172,21 +172,6 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_ng_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_ng = {
 	.name		= "numgen",
 	.alloc_len	= sizeof(struct nftnl_expr_ng),
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 2eb5c47f8e562..a4b6470bc25e2 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -174,8 +174,9 @@ static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_objref_snprintf_default(char *buf, size_t len,
-					      const struct nftnl_expr *e)
+static int nftnl_expr_objref_snprintf(char *buf, size_t len,
+				      uint32_t flags,
+				      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
 
@@ -195,21 +196,6 @@ static void nftnl_expr_objref_free(const struct nftnl_expr *e)
 	xfree(objref->set.name);
 }
 
-static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
-				      uint32_t flags,
-				      const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_objref_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_objref = {
 	.name		= "objref",
 	.alloc_len	= sizeof(struct nftnl_expr_objref),
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 98d0df96aa06e..56fc4e053a7b7 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -124,8 +124,9 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_osf_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+static int
+nftnl_expr_osf_snprintf(char *buf, size_t size,
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
 	int ret, offset = 0, len = size;
@@ -138,21 +139,6 @@ static int nftnl_expr_osf_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_osf_snprintf(char *buf, size_t len, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_osf_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_osf = {
 	.name		= "osf",
 	.alloc_len	= sizeof(struct nftnl_expr_osf),
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 2192dad5f15dd..9ccb78e6b5352 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -232,30 +232,22 @@ static inline int nftnl_str2base(const char *base)
 }
 
 static int
-nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
+nftnl_expr_payload_snprintf(char *buf, size_t len,
 			    uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		if (payload->sreg)
-			return snprintf(buf, len, "write reg %u => %ub @ %s header + %u csum_type %u csum_off %u csum_flags 0x%x ",
-					payload->sreg,
-					payload->len, base2str(payload->base),
-					payload->offset, payload->csum_type,
-					payload->csum_offset,
-					payload->csum_flags);
-		else
-			return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
-					payload->len, base2str(payload->base),
-					payload->offset, payload->dreg);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
+	if (payload->sreg)
+		return snprintf(buf, len, "write reg %u => %ub @ %s header + %u csum_type %u csum_off %u csum_flags 0x%x ",
+				payload->sreg,
+				payload->len, base2str(payload->base),
+				payload->offset, payload->csum_type,
+				payload->csum_offset,
+				payload->csum_flags);
+	else
+		return snprintf(buf, len, "load %ub @ %s header + %u => reg %u ",
+				payload->len, base2str(payload->base),
+				payload->offset, payload->dreg);
 }
 
 struct expr_ops expr_ops_payload = {
diff --git a/src/expr/queue.c b/src/expr/queue.c
index b892b57bc4897..0bab2837ad584 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -143,8 +143,9 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
-					     const struct nftnl_expr *e)
+static int
+nftnl_expr_queue_snprintf(char *buf, size_t len,
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
 	int ret, remain = len, offset = 0;
@@ -184,21 +185,6 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int
-nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_queue_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_queue = {
 	.name		= "queue",
 	.alloc_len	= sizeof(struct nftnl_expr_queue),
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 39a92e6ed6969..8c841d8006eb6 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -128,8 +128,9 @@ nftnl_expr_quota_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_quota_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_expr *e)
+static int nftnl_expr_quota_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_quota *quota = nftnl_expr_data(e);
 
@@ -138,21 +139,6 @@ static int nftnl_expr_quota_snprintf_default(char *buf, size_t len,
 			quota->bytes, quota->consumed, quota->flags);
 }
 
-static int nftnl_expr_quota_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_quota_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_quota = {
 	.name		= "quota",
 	.alloc_len	= sizeof(struct nftnl_expr_quota),
diff --git a/src/expr/range.c b/src/expr/range.c
index d1d50832a4503..a93b2ea74d6d4 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -184,8 +184,8 @@ static inline int nftnl_str2range(const char *op)
 	}
 }
 
-static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_expr *e)
+static int nftnl_expr_range_snprintf(char *buf, size_t size,
+				     uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret;
@@ -205,20 +205,6 @@ static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_expr_range_snprintf(char *buf, size_t size, uint32_t type,
-				     uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_range_snprintf_default(buf, size, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_range = {
 	.name		= "range",
 	.alloc_len	= sizeof(struct nftnl_expr_range),
diff --git a/src/expr/redir.c b/src/expr/redir.c
index c00c2a6ddf3cf..8de4c60556dac 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -131,8 +131,9 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
-					     const struct nftnl_expr *e)
+static int
+nftnl_expr_redir_snprintf(char *buf, size_t len,
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	int ret, remain = len, offset = 0;
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
@@ -158,21 +159,6 @@ static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int
-nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
-			  uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_redir_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_redir = {
 	.name		= "redir",
 	.alloc_len	= sizeof(struct nftnl_expr_redir),
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 141942e6941f3..716d25c77f7e5 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -116,8 +116,9 @@ nftnl_expr_reject_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
-					      const struct nftnl_expr *e)
+static int
+nftnl_expr_reject_snprintf(char *buf, size_t len,
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_reject *reject = nftnl_expr_data(e);
 
@@ -125,21 +126,6 @@ static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
 			reject->type, reject->icmp_code);
 }
 
-static int
-nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
-			   uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_reject_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_reject = {
 	.name		= "reject",
 	.alloc_len	= sizeof(struct nftnl_expr_reject),
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 0fce72d9a845b..1ad9b2ad4043f 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -142,8 +142,8 @@ static inline int str2rt_key(const char *str)
 }
 
 static int
-nftnl_expr_rt_snprintf_default(char *buf, size_t len,
-			       const struct nftnl_expr *e)
+nftnl_expr_rt_snprintf(char *buf, size_t len,
+		       uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_rt *rt = nftnl_expr_data(e);
 
@@ -154,21 +154,6 @@ nftnl_expr_rt_snprintf_default(char *buf, size_t len,
 	return 0;
 }
 
-static int
-nftnl_expr_rt_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_rt_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_rt = {
 	.name		= "rt",
 	.alloc_len	= sizeof(struct nftnl_expr_rt),
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 76fc90346141e..c7337cf75378d 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -127,8 +127,8 @@ static const char *socket_key2str(uint8_t key)
 }
 
 static int
-nftnl_expr_socket_snprintf_default(char *buf, size_t len,
-			       const struct nftnl_expr *e)
+nftnl_expr_socket_snprintf(char *buf, size_t len,
+		       uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_socket *socket = nftnl_expr_data(e);
 
@@ -139,21 +139,6 @@ nftnl_expr_socket_snprintf_default(char *buf, size_t len,
 	return 0;
 }
 
-static int
-nftnl_expr_socket_snprintf(char *buf, size_t len, uint32_t type,
-		       uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_socket_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_socket = {
 	.name		= "socket",
 	.alloc_len	= sizeof(struct nftnl_expr_socket),
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index 245f4fb5a41be..dc68b9d14db3a 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -127,8 +127,9 @@ nftnl_expr_synproxy_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_synproxy_snprintf_default(char *buf, size_t size,
-						const struct nftnl_expr *e)
+static int
+nftnl_expr_synproxy_snprintf(char *buf, size_t size,
+			     uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
 	int ret, offset = 0, len = size;
@@ -143,21 +144,6 @@ static int nftnl_expr_synproxy_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_synproxy_snprintf(char *buf, size_t len, uint32_t type,
-			     uint32_t flags, const struct nftnl_expr *e)
-{
-	switch(type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_synproxy_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_synproxy = {
 	.name		= "synproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_synproxy),
diff --git a/src/expr/target.c b/src/expr/target.c
index 91000386704aa..b7c595a7de989 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -165,21 +165,12 @@ static int nftnl_expr_target_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
+nftnl_expr_target_snprintf(char *buf, size_t len,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "name %s rev %u ",
-				target->name, target->rev);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
+	return snprintf(buf, len, "name %s rev %u ", target->name, target->rev);
 }
 
 static void nftnl_expr_target_free(const struct nftnl_expr *e)
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 3827b75ed2215..eeb1beee48ebe 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -135,8 +135,8 @@ nftnl_expr_tproxy_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 }
 
 static int
-nftnl_expr_tproxy_snprintf_default(char *buf, size_t size,
-				const struct nftnl_expr *e)
+nftnl_expr_tproxy_snprintf(char *buf, size_t size,
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_tproxy *tproxy = nftnl_expr_data(e);
 	int remain = size, offset = 0, ret = 0;
@@ -162,19 +162,6 @@ nftnl_expr_tproxy_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_tproxy_snprintf(char *buf, size_t size, uint32_t type,
-			uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_tproxy_snprintf_default(buf, size, e);
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_tproxy = {
 	.name		= "tproxy",
 	.alloc_len	= sizeof(struct nftnl_expr_tproxy),
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index 62e164805fee6..1460fd26b0fbc 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -125,8 +125,8 @@ static const char *tunnel_key2str(uint8_t key)
 }
 
 static int
-nftnl_expr_tunnel_snprintf_default(char *buf, size_t len,
-				 const struct nftnl_expr *e)
+nftnl_expr_tunnel_snprintf(char *buf, size_t len,
+			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_tunnel *tunnel = nftnl_expr_data(e);
 
@@ -137,21 +137,6 @@ nftnl_expr_tunnel_snprintf_default(char *buf, size_t len,
 	return 0;
 }
 
-static int
-nftnl_expr_tunnel_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_tunnel_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_tunnel = {
 	.name		= "tunnel",
 	.alloc_len	= sizeof(struct nftnl_expr_tunnel),
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 0502b53bb7edc..d7586ce689c0d 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -172,8 +172,8 @@ static const char *xfrmdir2str(uint8_t dir)
 }
 
 static int
-nftnl_expr_xfrm_snprintf_default(char *buf, size_t size,
-			       const struct nftnl_expr *e)
+nftnl_expr_xfrm_snprintf(char *buf, size_t size,
+			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_xfrm *x = nftnl_expr_data(e);
 	int ret, remain = size, offset = 0;
@@ -188,21 +188,6 @@ nftnl_expr_xfrm_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int
-nftnl_expr_xfrm_snprintf(char *buf, size_t len, uint32_t type,
-			 uint32_t flags, const struct nftnl_expr *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_expr_xfrm_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct expr_ops expr_ops_xfrm = {
 	.name		= "xfrm",
 	.alloc_len	= sizeof(struct nftnl_expr_xfrm),
-- 
2.30.1

