Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FEBC43331
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 866C96523F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhCIPqC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhCIPpn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A756C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:43 -0800 (PST)
Received: from localhost ([::1]:56656 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYH-00016k-Kx; Tue, 09 Mar 2021 16:45:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 08/10] Drop pointless local variable in snprintf callbacks
Date:   Tue,  9 Mar 2021 16:45:14 +0100
Message-Id: <20210309154516.4987-9-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A common idiom among snprintf callbacks was to copy the unsigned
parameter 'size' (or 'len') into a signed variable for further use.
Though since snprintf() itself casts it to unsigned and
SNPRINTF_BUFFER_SIZE() does not allow it to become negative, this is not
needed. Drop the local variable and rename the parameter accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c             |  8 ++++----
 src/expr.c              |  6 +++---
 src/expr/bitwise.c      |  8 ++++----
 src/expr/byteorder.c    |  4 ++--
 src/expr/cmp.c          |  4 ++--
 src/expr/ct.c           |  4 ++--
 src/expr/data_reg.c     |  4 ++--
 src/expr/dup.c          |  4 ++--
 src/expr/dynset.c       |  4 ++--
 src/expr/fib.c          |  4 ++--
 src/expr/flow_offload.c |  4 ++--
 src/expr/fwd.c          |  4 ++--
 src/expr/hash.c         |  4 ++--
 src/expr/immediate.c    |  4 ++--
 src/expr/log.c          |  4 ++--
 src/expr/lookup.c       |  4 ++--
 src/expr/masq.c         |  4 ++--
 src/expr/nat.c          |  4 ++--
 src/expr/numgen.c       |  4 ++--
 src/expr/osf.c          |  4 ++--
 src/expr/queue.c        |  4 ++--
 src/expr/range.c        |  4 ++--
 src/expr/redir.c        |  4 ++--
 src/expr/synproxy.c     |  4 ++--
 src/expr/tproxy.c       |  4 ++--
 src/expr/xfrm.c         |  4 ++--
 src/flowtable.c         |  8 ++++----
 src/gen.c               |  6 +++---
 src/obj/ct_expect.c     |  5 ++---
 src/obj/ct_timeout.c    |  5 ++---
 src/obj/synproxy.c      |  4 ++--
 src/object.c            | 10 +++++-----
 src/rule.c              |  8 ++++----
 src/ruleset.c           | 25 +++++++++++++------------
 src/set.c               |  9 ++++-----
 src/set_elem.c          |  9 ++++-----
 src/table.c             |  4 ++--
 37 files changed, 102 insertions(+), 105 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index aac9da6319556..7906bf44ff72d 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -826,10 +826,10 @@ static inline int nftnl_str2hooknum(int family, const char *hook)
 	return -1;
 }
 
-static int nftnl_chain_snprintf_default(char *buf, size_t size,
+static int nftnl_chain_snprintf_default(char *buf, size_t remain,
 					const struct nftnl_chain *c)
 {
-	int ret, remain = size, offset = 0, i;
+	int ret, offset = 0, i;
 
 	ret = snprintf(buf, remain, "%s %s %s use %u",
 		       nftnl_family2str(c->family), c->table, c->name, c->use);
@@ -884,11 +884,11 @@ static int nftnl_chain_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
+static int nftnl_chain_cmd_snprintf(char *buf, size_t remain,
 				    const struct nftnl_chain *c, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr.c b/src/expr.c
index 01c55cf2e880b..277bbdeeb5d02 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -270,13 +270,13 @@ err1:
 }
 
 EXPORT_SYMBOL(nftnl_expr_snprintf);
-int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
+int nftnl_expr_snprintf(char *buf, size_t remain, const struct nftnl_expr *expr,
 			uint32_t type, uint32_t flags)
 {
 	int ret;
-	unsigned int offset = 0, remain = size;
+	unsigned int offset = 0;
 
-	if (size)
+	if (remain)
 		buf[0] = '\0';
 
 	if (!expr->ops->snprintf || type != NFTNL_OUTPUT_DEFAULT)
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 1d46a97757dfd..d0c7827eacec9 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -210,10 +210,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
+nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
 				 const struct nftnl_expr_bitwise *bitwise)
 {
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u = ( reg %u & ",
 		       bitwise->dreg, bitwise->sreg);
@@ -234,9 +234,9 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 }
 
 static int
-nftnl_expr_bitwise_snprintf_shift(char *buf, size_t size, const char *op,
+nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
 				  const struct nftnl_expr_bitwise *bitwise)
-{	int remain = size, offset = 0, ret;
+{	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
 		       bitwise->dreg, bitwise->sreg, op);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 9718b8fe2506c..d299745fc57b4 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -198,11 +198,11 @@ static inline int nftnl_str2ntoh(const char *op)
 }
 
 static int
-nftnl_expr_byteorder_snprintf(char *buf, size_t size,
+nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u = %s(reg %u, %u, %u) ",
 		       byteorder->dreg, bo2str(byteorder->op),
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 04b9f25806725..6030693f15d86 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -177,11 +177,11 @@ static inline int nftnl_str2cmp(const char *op)
 }
 
 static int
-nftnl_expr_cmp_snprintf(char *buf, size_t size,
+nftnl_expr_cmp_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "%s reg %u ",
 		       cmp2str(cmp->op), cmp->sreg);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f4a7dc6932cb0..d5dfc81cfe0d1 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -223,11 +223,11 @@ static inline int str2ctdir(const char *str, uint8_t *ctdir)
 }
 
 static int
-nftnl_expr_ct_snprintf(char *buf, size_t size,
+nftnl_expr_ct_snprintf(char *buf, size_t remain,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
-	int ret, remain = size, offset = 0;
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG)) {
 		ret = snprintf(buf, remain, "set %s with reg %u ",
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index bafdc6f3dadd3..2633a775c90cc 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -25,12 +25,12 @@
 #include "internal.h"
 
 static int
-nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
+nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
 				      uint32_t flags)
 {
 	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
-	int remain = size, offset = 0, ret, i;
+	int offset = 0, ret, i;
 
 
 
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 3eb560a21077f..f041b551a7e78 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -111,11 +111,11 @@ static int nftnl_expr_dup_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_dup_snprintf(char *buf, size_t len,
+static int nftnl_expr_dup_snprintf(char *buf, size_t remain,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
-	int remain = len, offset = 0, ret;
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
+	int offset = 0, ret;
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR)) {
 		ret = snprintf(buf + offset, remain, "sreg_addr %u ", dup->sreg_addr);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 2ddf69a02b9de..85d64bb58d5af 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -308,12 +308,12 @@ static const char *op2str(enum nft_dynset_ops op)
 }
 
 static int
-nftnl_expr_dynset_snprintf(char *buf, size_t size,
+nftnl_expr_dynset_snprintf(char *buf, size_t remain,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nftnl_expr *expr;
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "%s reg_key %u set %s ",
 		       op2str(dynset->op), dynset->sreg_key, dynset->set_name);
diff --git a/src/expr/fib.c b/src/expr/fib.c
index b0cbb3b752153..aaff52acabdbd 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -143,13 +143,13 @@ static const char *fib_type_str(enum nft_fib_result r)
 }
 
 static int
-nftnl_expr_fib_snprintf(char *buf, size_t size,
+nftnl_expr_fib_snprintf(char *buf, size_t remain,
 			 uint32_t printflags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret, i;
 	uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
 	uint32_t present_flag = fib->flags & NFTA_FIB_F_PRESENT;
+	int offset = 0, ret, i;
 	static const struct {
 		int bit;
 		const char *name;
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 188269113ee8a..a826202eb69b9 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -92,11 +92,11 @@ static int nftnl_expr_flow_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_flow_snprintf(char *buf, size_t size,
+static int nftnl_expr_flow_snprintf(char *buf, size_t remain,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
-	int remain = size, offset = 0, ret;
 	struct nftnl_expr_flow *l = nftnl_expr_data(e);
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "flowtable %s ", l->table_name);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 0322be8f4aa4b..82e5a418bfae5 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -125,11 +125,11 @@ static int nftnl_expr_fwd_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return ret;
 }
 
-static int nftnl_expr_fwd_snprintf(char *buf, size_t len,
+static int nftnl_expr_fwd_snprintf(char *buf, size_t remain,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
-	int remain = len, offset = 0, ret;
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+	int offset = 0, ret;
 
 	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV)) {
 		ret = snprintf(buf + offset, remain, "sreg_dev %u ",
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 86b5ca6f0dfd0..10b4a72d30b0d 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -184,11 +184,11 @@ nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_hash_snprintf(char *buf, size_t size,
+nftnl_expr_hash_snprintf(char *buf, size_t remain,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	switch (hash->type) {
 	case NFT_HASH_SYM:
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 241aad3b5507c..94b043c0fc8ab 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -184,11 +184,11 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_immediate_snprintf(char *buf, size_t len,
+nftnl_expr_immediate_snprintf(char *buf, size_t remain,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
-	int remain = len, offset = 0, ret;
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u ", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/src/expr/log.c b/src/expr/log.c
index d56fad56d27cd..86db5484d2173 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -187,11 +187,11 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_log_snprintf(char *buf, size_t size,
+nftnl_expr_log_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
-	int ret, offset = 0, remain = size;
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_LOG_PREFIX)) {
 		ret = snprintf(buf, remain, "prefix %s ", log->prefix);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ec7f6fb99e066..83adce97c98b0 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -168,11 +168,11 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_lookup_snprintf(char *buf, size_t size,
+nftnl_expr_lookup_snprintf(char *buf, size_t remain,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
-	int remain = size, offset = 0, ret;
 	struct nftnl_expr_lookup *l = nftnl_expr_data(e);
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "reg %u set %s ", l->sreg, l->set_name);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 1f6dbdb9cc33d..684708c758390 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -131,11 +131,11 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_expr_masq_snprintf(char *buf, size_t len,
+static int nftnl_expr_masq_snprintf(char *buf, size_t remain,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
-	int remain = len, offset = 0, ret = 0;
+	int offset = 0, ret = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN)) {
 		ret = snprintf(buf + offset, remain, "proto_min reg %u ",
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 25d4e9206da79..0a9cdd7f65f8f 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -221,11 +221,11 @@ static inline int nftnl_str2nat(const char *nat)
 }
 
 static int
-nftnl_expr_nat_snprintf(char *buf, size_t size,
+nftnl_expr_nat_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret = 0;
+	int offset = 0, ret = 0;
 
 	ret = snprintf(buf, remain, "%s ", nat2str(nat->type));
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 602e4c0f77426..159dfeca3618b 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -143,11 +143,11 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_ng_snprintf(char *buf, size_t size,
+nftnl_expr_ng_snprintf(char *buf, size_t remain,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 56fc4e053a7b7..215a681a97aae 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -125,11 +125,11 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_osf_snprintf(char *buf, size_t size,
+nftnl_expr_osf_snprintf(char *buf, size_t len,
 			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
-	int ret, offset = 0, len = size;
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_OSF_DREG)) {
 		ret = snprintf(buf, len, "dreg %u ", osf->dreg);
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 0bab2837ad584..8f70977f7de85 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -144,12 +144,12 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_queue_snprintf(char *buf, size_t len,
+nftnl_expr_queue_snprintf(char *buf, size_t remain,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
-	int ret, remain = len, offset = 0;
 	uint16_t total_queues;
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_NUM)) {
 		total_queues = queue->queuenum + queue->queues_total - 1;
diff --git a/src/expr/range.c b/src/expr/range.c
index eed48829a246d..f76843a8afd0c 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -184,11 +184,11 @@ static inline int nftnl_str2range(const char *op)
 	}
 }
 
-static int nftnl_expr_range_snprintf(char *buf, size_t size,
+static int nftnl_expr_range_snprintf(char *buf, size_t remain,
 				     uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret;
+	int offset = 0, ret;
 
 	ret = snprintf(buf, remain, "%s reg %u ",
 		       range2str(range->op), range->sreg);
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 8de4c60556dac..4f56cb4302b30 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -132,10 +132,10 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_redir_snprintf(char *buf, size_t len,
+nftnl_expr_redir_snprintf(char *buf, size_t remain,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
-	int ret, remain = len, offset = 0;
+	int ret, offset = 0;
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MIN)) {
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index dc68b9d14db3a..630f3f4c60927 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -128,11 +128,11 @@ nftnl_expr_synproxy_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_synproxy_snprintf(char *buf, size_t size,
+nftnl_expr_synproxy_snprintf(char *buf, size_t len,
 			     uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
-	int ret, offset = 0, len = size;
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_SYNPROXY_MSS) &&
 	    e->flags & (1 << NFTNL_EXPR_SYNPROXY_WSCALE)) {
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index eeb1beee48ebe..d3ee8f89b6db3 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -135,11 +135,11 @@ nftnl_expr_tproxy_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 }
 
 static int
-nftnl_expr_tproxy_snprintf(char *buf, size_t size,
+nftnl_expr_tproxy_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_tproxy *tproxy = nftnl_expr_data(e);
-	int remain = size, offset = 0, ret = 0;
+	int offset = 0, ret = 0;
 
 	if (tproxy->family != NFTA_TPROXY_UNSPEC) {
 		ret = snprintf(buf + offset, remain, "%s ",
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index d7586ce689c0d..c81d14d638dcd 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -172,11 +172,11 @@ static const char *xfrmdir2str(uint8_t dir)
 }
 
 static int
-nftnl_expr_xfrm_snprintf(char *buf, size_t size,
+nftnl_expr_xfrm_snprintf(char *buf, size_t remain,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_xfrm *x = nftnl_expr_data(e);
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_XFRM_DREG)) {
 		ret = snprintf(buf, remain, "load %s %u %s => reg %u ",
diff --git a/src/flowtable.c b/src/flowtable.c
index 658115dd24766..d651066273460 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -591,10 +591,10 @@ int nftnl_flowtable_parse_file(struct nftnl_flowtable *c,
 	return -1;
 }
 
-static int nftnl_flowtable_snprintf_default(char *buf, size_t size,
+static int nftnl_flowtable_snprintf_default(char *buf, size_t remain,
 					    const struct nftnl_flowtable *c)
 {
-	int ret, remain = size, offset = 0, i;
+	int ret, offset = 0, i;
 
 	ret = snprintf(buf, remain, "flow table %s %s use %u size %u flags %x",
 		       c->table, c->name, c->use, c->size, c->ft_flags);
@@ -623,12 +623,12 @@ static int nftnl_flowtable_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_flowtable_cmd_snprintf(char *buf, size_t size,
+static int nftnl_flowtable_cmd_snprintf(char *buf, size_t remain,
 					const struct nftnl_flowtable *c,
 					uint32_t cmd, uint32_t type,
 					uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/gen.c b/src/gen.c
index f2ac2ba03b9a4..362132eb2766f 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -156,15 +156,15 @@ int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 	return 0;
 }
 
-static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
+static int nftnl_gen_cmd_snprintf(char *buf, size_t remain,
 				  const struct nftnl_gen *gen, uint32_t cmd,
 				  uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = snprintf(buf, size, "ruleset generation ID %u", gen->id);
+		ret = snprintf(buf, remain, "ruleset generation ID %u", gen->id);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	default:
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index c29f99c419dcb..8136ad9c21602 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -151,13 +151,12 @@ nftnl_obj_ct_expect_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_ct_expect_snprintf(char *buf, size_t len,
+static int nftnl_obj_ct_expect_snprintf(char *buf, size_t remain,
 					uint32_t flags,
 					const struct nftnl_obj *e)
 {
-	int ret = 0;
-	int offset = 0, remain = len;
 	struct nftnl_obj_ct_expect *exp = nftnl_obj_data(e);
+	int ret = 0, offset = 0;
 
 	if (e->flags & (1 << NFTNL_OBJ_CT_EXPECT_L3PROTO)) {
 		ret = snprintf(buf + offset, remain,
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index a2e5b4fe6de99..1d4f8fb75ea3a 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -257,12 +257,11 @@ nftnl_obj_ct_timeout_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_ct_timeout_snprintf(char *buf, size_t len,
+static int nftnl_obj_ct_timeout_snprintf(char *buf, size_t remain,
 				       uint32_t flags,
 				       const struct nftnl_obj *e)
 {
-	int ret = 0;
-	int offset = 0, remain = len;
+	int ret = 0, offset = 0;
 
 	struct nftnl_obj_ct_timeout *timeout = nftnl_obj_data(e);
 
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index e3a991bc6e023..d689fee3757c2 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -117,12 +117,12 @@ static int nftnl_obj_synproxy_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_synproxy_snprintf(char *buf, size_t size,
+static int nftnl_obj_synproxy_snprintf(char *buf, size_t len,
 				    uint32_t flags,
 				    const struct nftnl_obj *e)
 {
 	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
-        int ret, offset = 0, len = size;
+        int ret, offset = 0;
 
         if (e->flags & (1 << NFTNL_OBJ_SYNPROXY_MSS) &&
             e->flags & (1 << NFTNL_OBJ_SYNPROXY_WSCALE)) {
diff --git a/src/object.c b/src/object.c
index 2d15629eb0f95..4eb4d35d874c9 100644
--- a/src/object.c
+++ b/src/object.c
@@ -384,14 +384,14 @@ int nftnl_obj_parse_file(struct nftnl_obj *obj, enum nftnl_parse_type type,
 	return nftnl_obj_do_parse(obj, type, fp, err, NFTNL_PARSE_FILE);
 }
 
-static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
+static int nftnl_obj_snprintf_dflt(char *buf, size_t remain,
 				   const struct nftnl_obj *obj,
 				   uint32_t type, uint32_t flags)
 {
 	const char *name = obj->ops ? obj->ops->name : "(unknown)";
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
-	ret = snprintf(buf, size, "table %s name %s use %u [ %s ",
+	ret = snprintf(buf, remain, "table %s name %s use %u [ %s ",
 		       obj->table, obj->name, obj->use, name);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -405,11 +405,11 @@ static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
+static int nftnl_obj_cmd_snprintf(char *buf, size_t remain,
 				    const struct nftnl_obj *obj, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/rule.c b/src/rule.c
index e82cf73e9bbe5..439e451330233 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -545,12 +545,12 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 	return nftnl_rule_do_parse(r, type, fp, err, NFTNL_PARSE_FILE);
 }
 
-static int nftnl_rule_snprintf_default(char *buf, size_t size,
+static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 				       const struct nftnl_rule *r,
 				       uint32_t type, uint32_t flags)
 {
 	struct nftnl_expr *expr;
-	int ret, remain = size, offset = 0, i;
+	int ret, offset = 0, i;
 	const char *sep = "";
 
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
@@ -635,12 +635,12 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
+static int nftnl_rule_cmd_snprintf(char *buf, size_t remain,
 				   const struct nftnl_rule *r, uint32_t cmd,
 				   uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
+	int ret, offset = 0;
 
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
diff --git a/src/ruleset.c b/src/ruleset.c
index 2468bd46cd5d0..f904aa4ca94a7 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -343,13 +343,13 @@ static const char *nftnl_ruleset_o_closetag(uint32_t type)
 }
 
 static int
-nftnl_ruleset_snprintf_table(char *buf, size_t size,
+nftnl_ruleset_snprintf_table(char *buf, size_t remain,
 			   const struct nftnl_ruleset *rs, uint32_t type,
 			   uint32_t flags)
 {
 	struct nftnl_table *t;
 	struct nftnl_table_list_iter *ti;
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	ti = nftnl_table_list_iter_create(rs->table_list);
 	if (ti == NULL)
@@ -372,13 +372,13 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
 }
 
 static int
-nftnl_ruleset_snprintf_chain(char *buf, size_t size,
+nftnl_ruleset_snprintf_chain(char *buf, size_t remain,
 			   const struct nftnl_ruleset *rs, uint32_t type,
 			   uint32_t flags)
 {
 	struct nftnl_chain *c;
 	struct nftnl_chain_list_iter *ci;
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	ci = nftnl_chain_list_iter_create(rs->chain_list);
 	if (ci == NULL)
@@ -401,13 +401,13 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t size,
 }
 
 static int
-nftnl_ruleset_snprintf_set(char *buf, size_t size,
+nftnl_ruleset_snprintf_set(char *buf, size_t remain,
 			 const struct nftnl_ruleset *rs, uint32_t type,
 			 uint32_t flags)
 {
 	struct nftnl_set *s;
 	struct nftnl_set_list_iter *si;
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	si = nftnl_set_list_iter_create(rs->set_list);
 	if (si == NULL)
@@ -430,13 +430,13 @@ nftnl_ruleset_snprintf_set(char *buf, size_t size,
 }
 
 static int
-nftnl_ruleset_snprintf_rule(char *buf, size_t size,
+nftnl_ruleset_snprintf_rule(char *buf, size_t remain,
 			  const struct nftnl_ruleset *rs, uint32_t type,
 			  uint32_t flags)
 {
 	struct nftnl_rule *r;
 	struct nftnl_rule_list_iter *ri;
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	ri = nftnl_rule_list_iter_create(rs->rule_list);
 	if (ri == NULL)
@@ -459,12 +459,13 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t size,
 }
 
 static int
-nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs,
-			uint32_t cmd, uint32_t type, uint32_t flags)
+nftnl_ruleset_do_snprintf(char *buf, size_t remain,
+			  const struct nftnl_ruleset *rs,
+			  uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
-	void *prev = NULL;
 	uint32_t inner_flags = flags;
+	int ret, offset = 0;
+	void *prev = NULL;
 
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
diff --git a/src/set.c b/src/set.c
index a21df1fa50f41..021543e8b7752 100644
--- a/src/set.c
+++ b/src/set.c
@@ -784,13 +784,12 @@ int nftnl_set_parse_file(struct nftnl_set *s, enum nftnl_parse_type type,
 	return nftnl_set_do_parse(s, type, fp, err, NFTNL_PARSE_FILE);
 }
 
-static int nftnl_set_snprintf_default(char *buf, size_t size,
+static int nftnl_set_snprintf_default(char *buf, size_t remain,
 				      const struct nftnl_set *s,
 				      uint32_t type, uint32_t flags)
 {
-	int ret;
-	int remain = size, offset = 0;
 	struct nftnl_set_elem *elem;
+	int ret, offset = 0;
 
 	ret = snprintf(buf, remain, "%s %s %x",
 			s->name, s->table, s->set_flags);
@@ -837,12 +836,12 @@ static int nftnl_set_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_set_cmd_snprintf(char *buf, size_t size,
+static int nftnl_set_cmd_snprintf(char *buf, size_t remain,
 				  const struct nftnl_set *s, uint32_t cmd,
 				  uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
+	int ret, offset = 0;
 
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
diff --git a/src/set_elem.c b/src/set_elem.c
index 061469a74789c..a1764e232d335 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -698,13 +698,12 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 	return -1;
 }
 
-int nftnl_set_elem_snprintf_default(char *buf, size_t size,
+int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 				    const struct nftnl_set_elem *e,
 				    enum nft_data_types dtype)
 {
 	int dregtype = (dtype == NFT_DATA_VERDICT) ? DATA_VERDICT : DATA_VALUE;
-
-	int ret, remain = size, offset = 0, i;
+	int ret, offset = 0, i;
 
 	ret = snprintf(buf, remain, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -751,12 +750,12 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
+static int nftnl_set_elem_cmd_snprintf(char *buf, size_t remain,
 				       const struct nftnl_set_elem *e,
 				       uint32_t cmd, uint32_t type,
 				       uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/table.c b/src/table.c
index 32f1bf705f9ff..5835788dce2e2 100644
--- a/src/table.c
+++ b/src/table.c
@@ -367,11 +367,11 @@ static int nftnl_table_snprintf_default(char *buf, size_t size,
 			t->table_flags, t->use, (unsigned long long)t->handle);
 }
 
-static int nftnl_table_cmd_snprintf(char *buf, size_t size,
+static int nftnl_table_cmd_snprintf(char *buf, size_t remain,
 				    const struct nftnl_table *t, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, remain = size, offset = 0;
+	int ret, offset = 0;
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-- 
2.30.1

