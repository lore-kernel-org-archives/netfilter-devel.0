Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259AD2B9BA
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868355; cv=none; b=aJbWj+AlESsOvKFy43z1rzXGh47BrWvO94sgeuGmdDuWEVD/emcwCAH4jxuLqv8/xcoFrNRNKHnzCDRlItTxe1gWZom+kbeZ9uMSvGPIQPdKxjjXyVB6vs+ElCj7ehyRKAJFJ9LZykKWae0Vt+QUGh0yC6FXmGArfMSyk0R3pXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868355; c=relaxed/simple;
	bh=V+VotOhYViK1G2g4csei05P/zjkgdNdDGm4IEf46dRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DytTotCyA3xjXQf3BO/j+LY9lwim5mKjrdjV94hWR8Tx/J/kGzSKy7Oyq3J4uCKaHxC8DA5v3bmB6L6GG+QsKQSO2Vq14dnAlevLWmaNnCzwUPBY83uUAcxk6aMTeVixNmUKp2YivnUSaVrkqblPT6KNInCiHJFuYWqLNhHC+qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XTgKKgOE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XTgKKgOE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T3tya4airNFoq1iNXPb3jXhrsvmHIwvszsp7tc8TzLg=; b=XTgKKgOEUNWfWLvqWsiAp96d7a
	onffmXL0zRrPlMmFUrLCDo0JAy23Lmlq4+W9kJMjbsspu4+3KkqwHVV/kLiLEWxSVZoSoW3rWQ0mm
	jkkWC26LCACDBhaqMkBpH0wach748OLLFFY17WFET77d97B3W9zOhtCejVnCyQv0MLLSW9PIDmcPn
	lzA0ON1iNoLMoNi0qggfiWojrp3+vQJObMl18l8GGc1Hq4pg/6bDE7/Ehp6+GNl1V8HBf+MoBJPQ2
	qR607e2w7+k1gJ8V98T7Lzf/3ikk3c3Rb0NSuTdRFzseaA7AzeDxf/wsDpuM5taTzQeb3LbwxBv4j
	Q86q3GtA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0o-000000007fm-1ppL;
	Tue, 19 Mar 2024 18:12:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 17/17] expr: Respect data_len when setting attributes
Date: Tue, 19 Mar 2024 18:12:24 +0100
Message-ID: <20240319171224.18064-18-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With attr_policy in place, data_len has an upper boundary but it may be
lower than the attribute's storage area in which case memcpy() would
read garbage.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/bitwise.c   |  8 ++++----
 src/expr/byteorder.c | 10 +++++-----
 src/expr/cmp.c       |  4 ++--
 src/expr/connlimit.c |  4 ++--
 src/expr/counter.c   |  4 ++--
 src/expr/ct.c        |  8 ++++----
 src/expr/dup.c       |  4 ++--
 src/expr/dynset.c    | 12 ++++++------
 src/expr/exthdr.c    | 14 +++++++-------
 src/expr/fib.c       |  6 +++---
 src/expr/fwd.c       |  6 +++---
 src/expr/hash.c      | 14 +++++++-------
 src/expr/immediate.c |  6 +++---
 src/expr/inner.c     |  6 +++---
 src/expr/last.c      |  4 ++--
 src/expr/limit.c     | 10 +++++-----
 src/expr/log.c       | 10 +++++-----
 src/expr/lookup.c    |  8 ++++----
 src/expr/masq.c      |  6 +++---
 src/expr/match.c     |  2 +-
 src/expr/meta.c      |  6 +++---
 src/expr/nat.c       | 14 +++++++-------
 src/expr/numgen.c    |  8 ++++----
 src/expr/objref.c    |  6 +++---
 src/expr/osf.c       |  6 +++---
 src/expr/payload.c   | 16 ++++++++--------
 src/expr/queue.c     |  8 ++++----
 src/expr/quota.c     |  6 +++---
 src/expr/range.c     |  4 ++--
 src/expr/redir.c     |  6 +++---
 src/expr/reject.c    |  4 ++--
 src/expr/rt.c        |  4 ++--
 src/expr/socket.c    |  6 +++---
 src/expr/synproxy.c  |  6 +++---
 src/expr/target.c    |  2 +-
 src/expr/tproxy.c    |  6 +++---
 src/expr/tunnel.c    |  4 ++--
 src/expr/xfrm.c      |  8 ++++----
 38 files changed, 133 insertions(+), 133 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index dab1690707ec6..e99131a090ed7 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -39,16 +39,16 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_BITWISE_SREG:
-		memcpy(&bitwise->sreg, data, sizeof(bitwise->sreg));
+		memcpy(&bitwise->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_DREG:
-		memcpy(&bitwise->dreg, data, sizeof(bitwise->dreg));
+		memcpy(&bitwise->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_OP:
-		memcpy(&bitwise->op, data, sizeof(bitwise->op));
+		memcpy(&bitwise->op, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_LEN:
-		memcpy(&bitwise->len, data, sizeof(bitwise->len));
+		memcpy(&bitwise->len, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_MASK:
 		return nftnl_data_cpy(&bitwise->mask, data, data_len);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index d4e85a8dacfc0..383e80d57b442 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -37,19 +37,19 @@ nftnl_expr_byteorder_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_BYTEORDER_SREG:
-		memcpy(&byteorder->sreg, data, sizeof(byteorder->sreg));
+		memcpy(&byteorder->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_BYTEORDER_DREG:
-		memcpy(&byteorder->dreg, data, sizeof(byteorder->dreg));
+		memcpy(&byteorder->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_BYTEORDER_OP:
-		memcpy(&byteorder->op, data, sizeof(byteorder->op));
+		memcpy(&byteorder->op, data, data_len);
 		break;
 	case NFTNL_EXPR_BYTEORDER_LEN:
-		memcpy(&byteorder->len, data, sizeof(byteorder->len));
+		memcpy(&byteorder->len, data, data_len);
 		break;
 	case NFTNL_EXPR_BYTEORDER_SIZE:
-		memcpy(&byteorder->size, data, sizeof(byteorder->size));
+		memcpy(&byteorder->size, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 2937d7e63a18e..d1f0f64a56b3b 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -36,10 +36,10 @@ nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_CMP_SREG:
-		memcpy(&cmp->sreg, data, sizeof(cmp->sreg));
+		memcpy(&cmp->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_CMP_OP:
-		memcpy(&cmp->op, data, sizeof(cmp->op));
+		memcpy(&cmp->op, data, data_len);
 		break;
 	case NFTNL_EXPR_CMP_DATA:
 		return nftnl_data_cpy(&cmp->data, data, data_len);
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 1c78c7113f0e9..fcac8bf170ac4 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -33,10 +33,10 @@ nftnl_expr_connlimit_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_CONNLIMIT_COUNT:
-		memcpy(&connlimit->count, data, sizeof(connlimit->count));
+		memcpy(&connlimit->count, data, data_len);
 		break;
 	case NFTNL_EXPR_CONNLIMIT_FLAGS:
-		memcpy(&connlimit->flags, data, sizeof(connlimit->flags));
+		memcpy(&connlimit->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 2c6f2a7a820ac..cef911908981c 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -35,10 +35,10 @@ nftnl_expr_counter_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_CTR_BYTES:
-		memcpy(&ctr->bytes, data, sizeof(ctr->bytes));
+		memcpy(&ctr->bytes, data, data_len);
 		break;
 	case NFTNL_EXPR_CTR_PACKETS:
-		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
+		memcpy(&ctr->pkts, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f7dd40d54799a..bea0522d89372 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -39,16 +39,16 @@ nftnl_expr_ct_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_CT_KEY:
-		memcpy(&ct->key, data, sizeof(ct->key));
+		memcpy(&ct->key, data, data_len);
 		break;
 	case NFTNL_EXPR_CT_DIR:
-		memcpy(&ct->dir, data, sizeof(ct->dir));
+		memcpy(&ct->dir, data, data_len);
 		break;
 	case NFTNL_EXPR_CT_DREG:
-		memcpy(&ct->dreg, data, sizeof(ct->dreg));
+		memcpy(&ct->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_CT_SREG:
-		memcpy(&ct->sreg, data, sizeof(ct->sreg));
+		memcpy(&ct->sreg, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 6a5e4cae93b1c..28d686b1351b8 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -32,10 +32,10 @@ static int nftnl_expr_dup_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_DUP_SREG_ADDR:
-		memcpy(&dup->sreg_addr, data, sizeof(dup->sreg_addr));
+		memcpy(&dup->sreg_addr, data, data_len);
 		break;
 	case NFTNL_EXPR_DUP_SREG_DEV:
-		memcpy(&dup->sreg_dev, data, sizeof(dup->sreg_dev));
+		memcpy(&dup->sreg_dev, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index c1f79b5741cd4..8a159f8ff520c 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -41,16 +41,16 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_DYNSET_SREG_KEY:
-		memcpy(&dynset->sreg_key, data, sizeof(dynset->sreg_key));
+		memcpy(&dynset->sreg_key, data, data_len);
 		break;
 	case NFTNL_EXPR_DYNSET_SREG_DATA:
-		memcpy(&dynset->sreg_data, data, sizeof(dynset->sreg_data));
+		memcpy(&dynset->sreg_data, data, data_len);
 		break;
 	case NFTNL_EXPR_DYNSET_OP:
-		memcpy(&dynset->op, data, sizeof(dynset->op));
+		memcpy(&dynset->op, data, data_len);
 		break;
 	case NFTNL_EXPR_DYNSET_TIMEOUT:
-		memcpy(&dynset->timeout, data, sizeof(dynset->timeout));
+		memcpy(&dynset->timeout, data, data_len);
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
 		dynset->set_name = strdup((const char *)data);
@@ -58,7 +58,7 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
-		memcpy(&dynset->set_id, data, sizeof(dynset->set_id));
+		memcpy(&dynset->set_id, data, data_len);
 		break;
 	case NFTNL_EXPR_DYNSET_EXPR:
 		list_for_each_entry_safe(expr, next, &dynset->expr_list, head)
@@ -68,7 +68,7 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 		list_add(&expr->head, &dynset->expr_list);
 		break;
 	case NFTNL_EXPR_DYNSET_FLAGS:
-		memcpy(&dynset->dynset_flags, data, sizeof(dynset->dynset_flags));
+		memcpy(&dynset->dynset_flags, data, data_len);
 		break;
 	default:
 		return -1;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 93b75216031b6..453902c230173 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -46,25 +46,25 @@ nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_EXTHDR_DREG:
-		memcpy(&exthdr->dreg, data, sizeof(exthdr->dreg));
+		memcpy(&exthdr->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_TYPE:
-		memcpy(&exthdr->type, data, sizeof(exthdr->type));
+		memcpy(&exthdr->type, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_OFFSET:
-		memcpy(&exthdr->offset, data, sizeof(exthdr->offset));
+		memcpy(&exthdr->offset, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_LEN:
-		memcpy(&exthdr->len, data, sizeof(exthdr->len));
+		memcpy(&exthdr->len, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_OP:
-		memcpy(&exthdr->op, data, sizeof(exthdr->op));
+		memcpy(&exthdr->op, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_FLAGS:
-		memcpy(&exthdr->flags, data, sizeof(exthdr->flags));
+		memcpy(&exthdr->flags, data, data_len);
 		break;
 	case NFTNL_EXPR_EXTHDR_SREG:
-		memcpy(&exthdr->sreg, data, sizeof(exthdr->sreg));
+		memcpy(&exthdr->sreg, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 5f7bef43be89a..20bc125aa3adf 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -35,13 +35,13 @@ nftnl_expr_fib_set(struct nftnl_expr *e, uint16_t result,
 
 	switch (result) {
 	case NFTNL_EXPR_FIB_RESULT:
-		memcpy(&fib->result, data, sizeof(fib->result));
+		memcpy(&fib->result, data, data_len);
 		break;
 	case NFTNL_EXPR_FIB_DREG:
-		memcpy(&fib->dreg, data, sizeof(fib->dreg));
+		memcpy(&fib->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_FIB_FLAGS:
-		memcpy(&fib->flags, data, sizeof(fib->flags));
+		memcpy(&fib->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 566d6f495f1e3..04cb089a7146e 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -33,13 +33,13 @@ static int nftnl_expr_fwd_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_FWD_SREG_DEV:
-		memcpy(&fwd->sreg_dev, data, sizeof(fwd->sreg_dev));
+		memcpy(&fwd->sreg_dev, data, data_len);
 		break;
 	case NFTNL_EXPR_FWD_SREG_ADDR:
-		memcpy(&fwd->sreg_addr, data, sizeof(fwd->sreg_addr));
+		memcpy(&fwd->sreg_addr, data, data_len);
 		break;
 	case NFTNL_EXPR_FWD_NFPROTO:
-		memcpy(&fwd->nfproto, data, sizeof(fwd->nfproto));
+		memcpy(&fwd->nfproto, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 4cd9006c9b29b..eb44b2ea9bb69 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -37,25 +37,25 @@ nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	switch (type) {
 	case NFTNL_EXPR_HASH_SREG:
-		memcpy(&hash->sreg, data, sizeof(hash->sreg));
+		memcpy(&hash->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_DREG:
-		memcpy(&hash->dreg, data, sizeof(hash->dreg));
+		memcpy(&hash->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_LEN:
-		memcpy(&hash->len, data, sizeof(hash->len));
+		memcpy(&hash->len, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_MODULUS:
-		memcpy(&hash->modulus, data, sizeof(hash->modulus));
+		memcpy(&hash->modulus, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_SEED:
-		memcpy(&hash->seed, data, sizeof(hash->seed));
+		memcpy(&hash->seed, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_OFFSET:
-		memcpy(&hash->offset, data, sizeof(hash->offset));
+		memcpy(&hash->offset, data, data_len);
 		break;
 	case NFTNL_EXPR_HASH_TYPE:
-		memcpy(&hash->type, data, sizeof(hash->type));
+		memcpy(&hash->type, data, data_len);
 		break;
 	default:
 		return -1;
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index b77cceadf771c..ab1276a1772cc 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -33,12 +33,12 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_IMM_DREG:
-		memcpy(&imm->dreg, data, sizeof(imm->dreg));
+		memcpy(&imm->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_IMM_DATA:
 		return nftnl_data_cpy(&imm->data, data, data_len);
 	case NFTNL_EXPR_IMM_VERDICT:
-		memcpy(&imm->data.verdict, data, sizeof(imm->data.verdict));
+		memcpy(&imm->data.verdict, data, data_len);
 		break;
 	case NFTNL_EXPR_IMM_CHAIN:
 		if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
@@ -49,7 +49,7 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_IMM_CHAIN_ID:
-		memcpy(&imm->data.chain_id, data, sizeof(uint32_t));
+		memcpy(&imm->data.chain_id, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 45ef4fb6208d8..4f66e944ec91a 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -45,13 +45,13 @@ nftnl_expr_inner_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_INNER_TYPE:
-		memcpy(&inner->type, data, sizeof(inner->type));
+		memcpy(&inner->type, data, data_len);
 		break;
 	case NFTNL_EXPR_INNER_FLAGS:
-		memcpy(&inner->flags, data, sizeof(inner->flags));
+		memcpy(&inner->flags, data, data_len);
 		break;
 	case NFTNL_EXPR_INNER_HDRSIZE:
-		memcpy(&inner->hdrsize, data, sizeof(inner->hdrsize));
+		memcpy(&inner->hdrsize, data, data_len);
 		break;
 	case NFTNL_EXPR_INNER_EXPR:
 		if (inner->expr)
diff --git a/src/expr/last.c b/src/expr/last.c
index 074f463811459..8e5b88ebb96be 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -32,10 +32,10 @@ static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_LAST_MSECS:
-		memcpy(&last->msecs, data, sizeof(last->msecs));
+		memcpy(&last->msecs, data, data_len);
 		break;
 	case NFTNL_EXPR_LAST_SET:
-		memcpy(&last->set, data, sizeof(last->set));
+		memcpy(&last->set, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 935d449d046df..9d025920586b2 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -38,19 +38,19 @@ nftnl_expr_limit_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_LIMIT_RATE:
-		memcpy(&limit->rate, data, sizeof(limit->rate));
+		memcpy(&limit->rate, data, data_len);
 		break;
 	case NFTNL_EXPR_LIMIT_UNIT:
-		memcpy(&limit->unit, data, sizeof(limit->unit));
+		memcpy(&limit->unit, data, data_len);
 		break;
 	case NFTNL_EXPR_LIMIT_BURST:
-		memcpy(&limit->burst, data, sizeof(limit->burst));
+		memcpy(&limit->burst, data, data_len);
 		break;
 	case NFTNL_EXPR_LIMIT_TYPE:
-		memcpy(&limit->type, data, sizeof(limit->type));
+		memcpy(&limit->type, data, data_len);
 		break;
 	case NFTNL_EXPR_LIMIT_FLAGS:
-		memcpy(&limit->flags, data, sizeof(limit->flags));
+		memcpy(&limit->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/log.c b/src/expr/log.c
index d6d6910ca9201..18ec2b64a5b93 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -46,19 +46,19 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_LOG_GROUP:
-		memcpy(&log->group, data, sizeof(log->group));
+		memcpy(&log->group, data, data_len);
 		break;
 	case NFTNL_EXPR_LOG_SNAPLEN:
-		memcpy(&log->snaplen, data, sizeof(log->snaplen));
+		memcpy(&log->snaplen, data, data_len);
 		break;
 	case NFTNL_EXPR_LOG_QTHRESHOLD:
-		memcpy(&log->qthreshold, data, sizeof(log->qthreshold));
+		memcpy(&log->qthreshold, data, data_len);
 		break;
 	case NFTNL_EXPR_LOG_LEVEL:
-		memcpy(&log->level, data, sizeof(log->level));
+		memcpy(&log->level, data, data_len);
 		break;
 	case NFTNL_EXPR_LOG_FLAGS:
-		memcpy(&log->flags, data, sizeof(log->flags));
+		memcpy(&log->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index be045286eb13e..21a7fcef40413 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -37,10 +37,10 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_LOOKUP_SREG:
-		memcpy(&lookup->sreg, data, sizeof(lookup->sreg));
+		memcpy(&lookup->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_LOOKUP_DREG:
-		memcpy(&lookup->dreg, data, sizeof(lookup->dreg));
+		memcpy(&lookup->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
 		lookup->set_name = strdup((const char *)data);
@@ -48,10 +48,10 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
-		memcpy(&lookup->set_id, data, sizeof(lookup->set_id));
+		memcpy(&lookup->set_id, data, data_len);
 		break;
 	case NFTNL_EXPR_LOOKUP_FLAGS:
-		memcpy(&lookup->flags, data, sizeof(lookup->flags));
+		memcpy(&lookup->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 4be5a9c18ed11..e0565db66fe16 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -34,13 +34,13 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_MASQ_FLAGS:
-		memcpy(&masq->flags, data, sizeof(masq->flags));
+		memcpy(&masq->flags, data, data_len);
 		break;
 	case NFTNL_EXPR_MASQ_REG_PROTO_MIN:
-		memcpy(&masq->sreg_proto_min, data, sizeof(masq->sreg_proto_min));
+		memcpy(&masq->sreg_proto_min, data, data_len);
 		break;
 	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
-		memcpy(&masq->sreg_proto_max, data, sizeof(masq->sreg_proto_max));
+		memcpy(&masq->sreg_proto_max, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/match.c b/src/expr/match.c
index 68288dc4349e9..8c1bc74a1ce19 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -46,7 +46,7 @@ nftnl_expr_match_set(struct nftnl_expr *e, uint16_t type,
 			 (const char *)data);
 		break;
 	case NFTNL_EXPR_MT_REV:
-		memcpy(&mt->rev, data, sizeof(mt->rev));
+		memcpy(&mt->rev, data, data_len);
 		break;
 	case NFTNL_EXPR_MT_INFO:
 		if (e->flags & (1 << NFTNL_EXPR_MT_INFO))
diff --git a/src/expr/meta.c b/src/expr/meta.c
index cd49c341a3d6f..136a450b6e976 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -39,13 +39,13 @@ nftnl_expr_meta_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_META_KEY:
-		memcpy(&meta->key, data, sizeof(meta->key));
+		memcpy(&meta->key, data, data_len);
 		break;
 	case NFTNL_EXPR_META_DREG:
-		memcpy(&meta->dreg, data, sizeof(meta->dreg));
+		memcpy(&meta->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_META_SREG:
-		memcpy(&meta->sreg, data, sizeof(meta->sreg));
+		memcpy(&meta->sreg, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/nat.c b/src/expr/nat.c
index f3f8644ffdd52..1235ba45b694d 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -42,25 +42,25 @@ nftnl_expr_nat_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_NAT_TYPE:
-		memcpy(&nat->type, data, sizeof(nat->type));
+		memcpy(&nat->type, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_FAMILY:
-		memcpy(&nat->family, data, sizeof(nat->family));
+		memcpy(&nat->family, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_REG_ADDR_MIN:
-		memcpy(&nat->sreg_addr_min, data, sizeof(nat->sreg_addr_min));
+		memcpy(&nat->sreg_addr_min, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_REG_ADDR_MAX:
-		memcpy(&nat->sreg_addr_max, data, sizeof(nat->sreg_addr_max));
+		memcpy(&nat->sreg_addr_max, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_REG_PROTO_MIN:
-		memcpy(&nat->sreg_proto_min, data, sizeof(nat->sreg_proto_min));
+		memcpy(&nat->sreg_proto_min, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_REG_PROTO_MAX:
-		memcpy(&nat->sreg_proto_max, data, sizeof(nat->sreg_proto_max));
+		memcpy(&nat->sreg_proto_max, data, data_len);
 		break;
 	case NFTNL_EXPR_NAT_FLAGS:
-		memcpy(&nat->flags, data, sizeof(nat->flags));
+		memcpy(&nat->flags, data, data_len);
 		break;
 	}
 
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index c5e8772d22957..c015b8847aa48 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -35,16 +35,16 @@ nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_NG_DREG:
-		memcpy(&ng->dreg, data, sizeof(ng->dreg));
+		memcpy(&ng->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_NG_MODULUS:
-		memcpy(&ng->modulus, data, sizeof(ng->modulus));
+		memcpy(&ng->modulus, data, data_len);
 		break;
 	case NFTNL_EXPR_NG_TYPE:
-		memcpy(&ng->type, data, sizeof(ng->type));
+		memcpy(&ng->type, data, data_len);
 		break;
 	case NFTNL_EXPR_NG_OFFSET:
-		memcpy(&ng->offset, data, sizeof(ng->offset));
+		memcpy(&ng->offset, data, data_len);
 		break;
 	default:
 		return -1;
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 59e1dddcb5f6d..00538057222b5 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -39,7 +39,7 @@ static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_OBJREF_IMM_TYPE:
-		memcpy(&objref->imm.type, data, sizeof(objref->imm.type));
+		memcpy(&objref->imm.type, data, data_len);
 		break;
 	case NFTNL_EXPR_OBJREF_IMM_NAME:
 		objref->imm.name = strdup(data);
@@ -47,7 +47,7 @@ static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_OBJREF_SET_SREG:
-		memcpy(&objref->set.sreg, data, sizeof(objref->set.sreg));
+		memcpy(&objref->set.sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_OBJREF_SET_NAME:
 		objref->set.name = strdup(data);
@@ -55,7 +55,7 @@ static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
 			return -1;
 		break;
 	case NFTNL_EXPR_OBJREF_SET_ID:
-		memcpy(&objref->set.id, data, sizeof(objref->set.id));
+		memcpy(&objref->set.id, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 1e4ceb02e3a04..060394b30329a 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -25,13 +25,13 @@ static int nftnl_expr_osf_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_OSF_DREG:
-		memcpy(&osf->dreg, data, sizeof(osf->dreg));
+		memcpy(&osf->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_OSF_TTL:
-		memcpy(&osf->ttl, data, sizeof(osf->ttl));
+		memcpy(&osf->ttl, data, data_len);
 		break;
 	case NFTNL_EXPR_OSF_FLAGS:
-		memcpy(&osf->flags, data, sizeof(osf->flags));
+		memcpy(&osf->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 76d38f7ede112..35cd10c31b98a 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -43,28 +43,28 @@ nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_PAYLOAD_SREG:
-		memcpy(&payload->sreg, data, sizeof(payload->sreg));
+		memcpy(&payload->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_DREG:
-		memcpy(&payload->dreg, data, sizeof(payload->dreg));
+		memcpy(&payload->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_BASE:
-		memcpy(&payload->base, data, sizeof(payload->base));
+		memcpy(&payload->base, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_OFFSET:
-		memcpy(&payload->offset, data, sizeof(payload->offset));
+		memcpy(&payload->offset, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_LEN:
-		memcpy(&payload->len, data, sizeof(payload->len));
+		memcpy(&payload->len, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_CSUM_TYPE:
-		memcpy(&payload->csum_type, data, sizeof(payload->csum_type));
+		memcpy(&payload->csum_type, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_CSUM_OFFSET:
-		memcpy(&payload->csum_offset, data, sizeof(payload->csum_offset));
+		memcpy(&payload->csum_offset, data, data_len);
 		break;
 	case NFTNL_EXPR_PAYLOAD_FLAGS:
-		memcpy(&payload->csum_flags, data, sizeof(payload->csum_flags));
+		memcpy(&payload->csum_flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 54792ef009474..09220c4a1138c 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -34,16 +34,16 @@ static int nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_QUEUE_NUM:
-		memcpy(&queue->queuenum, data, sizeof(queue->queuenum));
+		memcpy(&queue->queuenum, data, data_len);
 		break;
 	case NFTNL_EXPR_QUEUE_TOTAL:
-		memcpy(&queue->queues_total, data, sizeof(queue->queues_total));
+		memcpy(&queue->queues_total, data, data_len);
 		break;
 	case NFTNL_EXPR_QUEUE_FLAGS:
-		memcpy(&queue->flags, data, sizeof(queue->flags));
+		memcpy(&queue->flags, data, data_len);
 		break;
 	case NFTNL_EXPR_QUEUE_SREG_QNUM:
-		memcpy(&queue->sreg_qnum, data, sizeof(queue->sreg_qnum));
+		memcpy(&queue->sreg_qnum, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 60631febcd220..ddf232f9f3acd 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -33,13 +33,13 @@ static int nftnl_expr_quota_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_QUOTA_BYTES:
-		memcpy(&quota->bytes, data, sizeof(quota->bytes));
+		memcpy(&quota->bytes, data, data_len);
 		break;
 	case NFTNL_EXPR_QUOTA_CONSUMED:
-		memcpy(&quota->consumed, data, sizeof(quota->consumed));
+		memcpy(&quota->consumed, data, data_len);
 		break;
 	case NFTNL_EXPR_QUOTA_FLAGS:
-		memcpy(&quota->flags, data, sizeof(quota->flags));
+		memcpy(&quota->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/range.c b/src/expr/range.c
index 6310b79d0a02b..96bb140119b66 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -34,10 +34,10 @@ static int nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_RANGE_SREG:
-		memcpy(&range->sreg, data, sizeof(range->sreg));
+		memcpy(&range->sreg, data, data_len);
 		break;
 	case NFTNL_EXPR_RANGE_OP:
-		memcpy(&range->op, data, sizeof(range->op));
+		memcpy(&range->op, data, data_len);
 		break;
 	case NFTNL_EXPR_RANGE_FROM_DATA:
 		return nftnl_data_cpy(&range->data_from, data, data_len);
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 69095bde094c1..9971306130fb0 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -34,13 +34,13 @@ nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_REDIR_REG_PROTO_MIN:
-		memcpy(&redir->sreg_proto_min, data, sizeof(redir->sreg_proto_min));
+		memcpy(&redir->sreg_proto_min, data, data_len);
 		break;
 	case NFTNL_EXPR_REDIR_REG_PROTO_MAX:
-		memcpy(&redir->sreg_proto_max, data, sizeof(redir->sreg_proto_max));
+		memcpy(&redir->sreg_proto_max, data, data_len);
 		break;
 	case NFTNL_EXPR_REDIR_FLAGS:
-		memcpy(&redir->flags, data, sizeof(redir->flags));
+		memcpy(&redir->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/reject.c b/src/expr/reject.c
index f97011a704663..9090db3f697a7 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -33,10 +33,10 @@ static int nftnl_expr_reject_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_REJECT_TYPE:
-		memcpy(&reject->type, data, sizeof(reject->type));
+		memcpy(&reject->type, data, data_len);
 		break;
 	case NFTNL_EXPR_REJECT_CODE:
-		memcpy(&reject->icmp_code, data, sizeof(reject->icmp_code));
+		memcpy(&reject->icmp_code, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 0ab255609632f..ff4fd03c8f1b1 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -32,10 +32,10 @@ nftnl_expr_rt_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_RT_KEY:
-		memcpy(&rt->key, data, sizeof(rt->key));
+		memcpy(&rt->key, data, data_len);
 		break;
 	case NFTNL_EXPR_RT_DREG:
-		memcpy(&rt->dreg, data, sizeof(rt->dreg));
+		memcpy(&rt->dreg, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/socket.c b/src/expr/socket.c
index d0d8e236c688a..7a25cdf806d12 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -33,13 +33,13 @@ nftnl_expr_socket_set(struct nftnl_expr *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_EXPR_SOCKET_KEY:
-		memcpy(&socket->key, data, sizeof(socket->key));
+		memcpy(&socket->key, data, data_len);
 		break;
 	case NFTNL_EXPR_SOCKET_DREG:
-		memcpy(&socket->dreg, data, sizeof(socket->dreg));
+		memcpy(&socket->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_SOCKET_LEVEL:
-		memcpy(&socket->level, data, sizeof(socket->level));
+		memcpy(&socket->level, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index 898d292f7116d..97c321b994fe5 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -23,13 +23,13 @@ static int nftnl_expr_synproxy_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_SYNPROXY_MSS:
-		memcpy(&synproxy->mss, data, sizeof(synproxy->mss));
+		memcpy(&synproxy->mss, data, data_len);
 		break;
 	case NFTNL_EXPR_SYNPROXY_WSCALE:
-		memcpy(&synproxy->wscale, data, sizeof(synproxy->wscale));
+		memcpy(&synproxy->wscale, data, data_len);
 		break;
 	case NFTNL_EXPR_SYNPROXY_FLAGS:
-		memcpy(&synproxy->flags, data, sizeof(synproxy->flags));
+		memcpy(&synproxy->flags, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/target.c b/src/expr/target.c
index 9bfd25bdd5654..8259a20a66cb5 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -46,7 +46,7 @@ nftnl_expr_target_set(struct nftnl_expr *e, uint16_t type,
 			 (const char *) data);
 		break;
 	case NFTNL_EXPR_TG_REV:
-		memcpy(&tg->rev, data, sizeof(tg->rev));
+		memcpy(&tg->rev, data, data_len);
 		break;
 	case NFTNL_EXPR_TG_INFO:
 		if (e->flags & (1 << NFTNL_EXPR_TG_INFO))
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 49483921df139..9391ce880cd3b 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -34,13 +34,13 @@ nftnl_expr_tproxy_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_TPROXY_FAMILY:
-		memcpy(&tproxy->family, data, sizeof(tproxy->family));
+		memcpy(&tproxy->family, data, data_len);
 		break;
 	case NFTNL_EXPR_TPROXY_REG_ADDR:
-		memcpy(&tproxy->sreg_addr, data, sizeof(tproxy->sreg_addr));
+		memcpy(&tproxy->sreg_addr, data, data_len);
 		break;
 	case NFTNL_EXPR_TPROXY_REG_PORT:
-		memcpy(&tproxy->sreg_port, data, sizeof(tproxy->sreg_port));
+		memcpy(&tproxy->sreg_port, data, data_len);
 		break;
 	}
 
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index 8089d0b585435..861e56dd64c27 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -31,10 +31,10 @@ static int nftnl_expr_tunnel_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_TUNNEL_KEY:
-		memcpy(&tunnel->key, data, sizeof(tunnel->key));
+		memcpy(&tunnel->key, data, data_len);
 		break;
 	case NFTNL_EXPR_TUNNEL_DREG:
-		memcpy(&tunnel->dreg, data, sizeof(tunnel->dreg));
+		memcpy(&tunnel->dreg, data, data_len);
 		break;
 	}
 	return 0;
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index dc867a24f78b4..2585579c3b549 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -33,16 +33,16 @@ nftnl_expr_xfrm_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_XFRM_KEY:
-		memcpy(&x->key, data, sizeof(x->key));
+		memcpy(&x->key, data, data_len);
 		break;
 	case NFTNL_EXPR_XFRM_DIR:
-		memcpy(&x->dir, data, sizeof(x->dir));
+		memcpy(&x->dir, data, data_len);
 		break;
 	case NFTNL_EXPR_XFRM_SPNUM:
-		memcpy(&x->spnum, data, sizeof(x->spnum));
+		memcpy(&x->spnum, data, data_len);
 		break;
 	case NFTNL_EXPR_XFRM_DREG:
-		memcpy(&x->dreg, data, sizeof(x->dreg));
+		memcpy(&x->dreg, data, data_len);
 		break;
 	default:
 		return -1;
-- 
2.43.0

