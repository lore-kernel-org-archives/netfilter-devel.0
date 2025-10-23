Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECA4270ED2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235578; cv=none; b=f6wHAdnWRENc5oFOn3MVzyEGHr7N7Wb7VQvfW2+OilG5ASsTgLwvbf2RUQsGL0FYW1cyKx46fKg5Hw/iwjd9WZJZBsZMbMqrA7g6iUGcYMogmwNfmhvgqE5X4X3p7IZE/IU9s5xEKKLzLo+L3w9AWurYb3LPmNwhPkUBfVMwS+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235578; c=relaxed/simple;
	bh=kKNu1wv4qfbym/7u0V36SuLhZiayVRczJCNblxWLkA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg3aPqmArL7MFGVuNoeqYGB1fACZZgm+UOJCP8YxKhqerLHfYchRwRqv+TWZWzwEVPAtN38HvJNeeC0a6WV6pE9REt4BmyErjJJYwrXqk6QvDRlugQJYKRDzVqcaNniSPfmfXYVPyUHRM48kDfQhDG6v3dQOcGMOiGuo181z/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U+BDt6U2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U+BDt6U2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ra/SKJ8pWufO67rU3Kb9FPiz446fhv9DoKBm3Xk/1NE=; b=U+BDt6U2TIql1/ysmtBXaJ5ZQ5
	3Zfv3TRMnEQ02igeAd+3FYGfX8XPrYf9epwNOnmMJOwynLAXVb3D1WRx+aC3GLk1HS1LQFhsBPaHK
	W9hpDhPmIgHX7AistsWmnWEad3tVXGOopMtx6P4voOP38qYqi1O5EQGN/FaqZXUYA7JH2nulzFNXQ
	6jD7LQOd52dXNFYxgkO2+gUukAhk4jI33EZtvimmxOXTwPr12AycbUDahkaKZdj0OcZnr7nV8uRNB
	0CIqJ+u4ymyDnEUpWG6i+QV1IZap3zv7B673m2SPvRNV7OeIk+FlHVOJGqVTrfmf+wxsdshjSg+cS
	bBU5lVKg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpN-000000007fm-1kYp;
	Thu, 23 Oct 2025 18:06:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 3/9] expr: Pass byteorder to struct expr_ops::set callback
Date: Thu, 23 Oct 2025 18:05:41 +0200
Message-ID: <20251023160547.10928-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023160547.10928-1-phil@nwl.cc>
References: <20251023160547.10928-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare for storing data reg byteorder, no functional change intended.

Note the odd case in expr/byteorder.c since there is a local variable
with same name already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expr_ops.h      |  2 +-
 src/expr.c              | 15 +++++++++++----
 src/expr/bitwise.c      |  2 +-
 src/expr/byteorder.c    |  2 +-
 src/expr/cmp.c          |  2 +-
 src/expr/connlimit.c    |  2 +-
 src/expr/counter.c      |  2 +-
 src/expr/ct.c           |  2 +-
 src/expr/dup.c          |  5 +++--
 src/expr/dynset.c       |  2 +-
 src/expr/exthdr.c       |  2 +-
 src/expr/fib.c          |  2 +-
 src/expr/flow_offload.c |  5 +++--
 src/expr/fwd.c          |  5 +++--
 src/expr/hash.c         |  2 +-
 src/expr/immediate.c    |  2 +-
 src/expr/inner.c        |  2 +-
 src/expr/last.c         |  5 +++--
 src/expr/limit.c        |  2 +-
 src/expr/log.c          |  5 +++--
 src/expr/lookup.c       |  2 +-
 src/expr/masq.c         |  2 +-
 src/expr/match.c        |  2 +-
 src/expr/meta.c         |  2 +-
 src/expr/nat.c          |  2 +-
 src/expr/numgen.c       |  2 +-
 src/expr/objref.c       |  5 +++--
 src/expr/osf.c          |  5 +++--
 src/expr/payload.c      |  2 +-
 src/expr/queue.c        |  5 +++--
 src/expr/quota.c        |  5 +++--
 src/expr/range.c        |  5 +++--
 src/expr/redir.c        |  2 +-
 src/expr/reject.c       |  5 +++--
 src/expr/rt.c           |  2 +-
 src/expr/socket.c       |  2 +-
 src/expr/synproxy.c     |  5 +++--
 src/expr/target.c       |  2 +-
 src/expr/tproxy.c       |  2 +-
 src/expr/tunnel.c       |  5 +++--
 src/expr/xfrm.c         |  2 +-
 41 files changed, 77 insertions(+), 57 deletions(-)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index 6cfb3b5832083..9c816c085719a 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -19,7 +19,7 @@ struct expr_ops {
 	struct attr_policy *attr_policy;
 	void	(*init)(const struct nftnl_expr *e);
 	void	(*free)(const struct nftnl_expr *e);
-	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
+	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len, uint32_t byteorder);
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
diff --git a/src/expr.c b/src/expr.c
index 65180d6849cd8..d07e7332efd78 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -59,9 +59,9 @@ bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type)
 	return expr->flags & (1 << type);
 }
 
-EXPORT_SYMBOL(nftnl_expr_set);
-int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
-		   const void *data, uint32_t data_len)
+static int __nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
+			    const void *data, uint32_t data_len,
+			    uint32_t byteorder)
 {
 	switch(type) {
 	case NFTNL_EXPR_NAME:	/* cannot be modified */
@@ -77,13 +77,20 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 		    expr->ops->attr_policy[type].maxlen < data_len)
 			return -1;
 
-		if (expr->ops->set(expr, type, data, data_len) < 0)
+		if (expr->ops->set(expr, type, data, data_len, byteorder) < 0)
 			return -1;
 	}
 	expr->flags |= (1 << type);
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_expr_set);
+int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
+		   const void *data, uint32_t data_len)
+{
+	return __nftnl_expr_set(expr, type, data, data_len, 0);
+}
+
 EXPORT_SYMBOL(nftnl_expr_set_u8);
 void
 nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data)
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 2da83b7ba0441..da2b6d2ee57ec 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -30,7 +30,7 @@ struct nftnl_expr_bitwise {
 
 static int
 nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		       const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 4171d0633728c..baa11a1401019 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -27,7 +27,7 @@ struct nftnl_expr_byteorder {
 
 static int
 nftnl_expr_byteorder_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+			  const void *data, uint32_t data_len, uint32_t byteorderp)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index ec1dc31894771..4bcf2e4bce83e 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -26,7 +26,7 @@ struct nftnl_expr_cmp {
 
 static int
 nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
-		      const void *data, uint32_t data_len)
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 02b9ecc87d258..f45129d60486d 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -23,7 +23,7 @@ struct nftnl_expr_connlimit {
 
 static int
 nftnl_expr_connlimit_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+			  const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_connlimit *connlimit = nftnl_expr_data(e);
 
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 80f21d7a177ea..21e641b0b939a 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -25,7 +25,7 @@ struct nftnl_expr_counter {
 
 static int
 nftnl_expr_counter_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+		       const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_counter *ctr = nftnl_expr_data(e);
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 8f8c2a6e73713..4117eeeb93863 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -29,7 +29,7 @@ struct nftnl_expr_ct {
 
 static int
 nftnl_expr_ct_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		  const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 
diff --git a/src/expr/dup.c b/src/expr/dup.c
index d49cdb77c1081..bb0f9c6c0be7e 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -21,8 +21,9 @@ struct nftnl_expr_dup {
 	enum nft_registers	sreg_dev;
 };
 
-static int nftnl_expr_dup_set(struct nftnl_expr *e, uint16_t type,
-			      const void *data, uint32_t data_len)
+static int
+nftnl_expr_dup_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index dc74fbbe75b3c..f513b3736b43c 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -30,7 +30,7 @@ struct nftnl_expr_dynset {
 
 static int
 nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
-			 const void *data, uint32_t data_len)
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nftnl_expr *expr, *next;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index ddebe43eabf52..c936ac0928200 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -36,7 +36,7 @@ struct nftnl_expr_exthdr {
 
 static int
 nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
 
diff --git a/src/expr/fib.c b/src/expr/fib.c
index c378f4f51bb11..31750da05fabe 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -25,7 +25,7 @@ struct nftnl_expr_fib {
 
 static int
 nftnl_expr_fib_set(struct nftnl_expr *e, uint16_t result,
-		    const void *data, uint32_t data_len)
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
 
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index ce22ec419a944..f9a999bd48432 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -14,8 +14,9 @@ struct nftnl_expr_flow {
 	char			*table_name;
 };
 
-static int nftnl_expr_flow_set(struct nftnl_expr *e, uint16_t type,
-			       const void *data, uint32_t data_len)
+static int
+nftnl_expr_flow_set(struct nftnl_expr *e, uint16_t type,
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
 
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index d543e2239af20..5f6a56c7e939c 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -22,8 +22,9 @@ struct nftnl_expr_fwd {
 	uint32_t		nfproto;
 };
 
-static int nftnl_expr_fwd_set(struct nftnl_expr *e, uint16_t type,
-				  const void *data, uint32_t data_len)
+static int
+nftnl_expr_fwd_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
 
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 050e4b9b1c599..c0cf8d943ba50 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -27,7 +27,7 @@ struct nftnl_expr_hash {
 
 static int
 nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
-		    const void *data, uint32_t data_len)
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	switch (type) {
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 6dffaf9ce4ad9..27ee6003d3f08 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -23,7 +23,7 @@ struct nftnl_expr_immediate {
 
 static int
 nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
-			    const void *data, uint32_t data_len)
+			 const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 8a56bb336cff5..516cda62985d8 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -35,7 +35,7 @@ static void nftnl_expr_inner_free(const struct nftnl_expr *e)
 
 static int
 nftnl_expr_inner_set(struct nftnl_expr *e, uint16_t type,
-		     const void *data, uint32_t data_len)
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
 
diff --git a/src/expr/last.c b/src/expr/last.c
index 427d4b52a1aec..ebdaf2a75d40d 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -21,8 +21,9 @@ struct nftnl_expr_last {
 	uint32_t	set;
 };
 
-static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
-				const void *data, uint32_t data_len)
+static int
+nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_last *last = nftnl_expr_data(e);
 
diff --git a/src/expr/limit.c b/src/expr/limit.c
index b77b27e024acb..36444975db045 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -28,7 +28,7 @@ struct nftnl_expr_limit {
 
 static int
 nftnl_expr_limit_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 
diff --git a/src/expr/log.c b/src/expr/log.c
index ead243799863c..f8456bcce4bf1 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -27,8 +27,9 @@ struct nftnl_expr_log {
 	const char		*prefix;
 };
 
-static int nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
-				 const void *data, uint32_t data_len)
+static int
+nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 4f76c5b71bb2b..c6a36a68d0b08 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -27,7 +27,7 @@ struct nftnl_expr_lookup {
 
 static int
 nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_lookup *lookup = nftnl_expr_data(e);
 
diff --git a/src/expr/masq.c b/src/expr/masq.c
index da4f437f136c0..e0d9eb698bf80 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -24,7 +24,7 @@ struct nftnl_expr_masq {
 
 static int
 nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
diff --git a/src/expr/match.c b/src/expr/match.c
index 2c5bd6bb74d19..b7e99b8869aff 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -32,7 +32,7 @@ struct nftnl_expr_match {
 
 static int
 nftnl_expr_match_set(struct nftnl_expr *e, uint16_t type,
-			 const void *data, uint32_t data_len)
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_match *mt = nftnl_expr_data(e);
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 7c56fdca08451..753975d988187 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -29,7 +29,7 @@ struct nftnl_expr_meta {
 
 static int
 nftnl_expr_meta_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 
diff --git a/src/expr/nat.c b/src/expr/nat.c
index f7e24cb34d515..89e7f15d656c9 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -32,7 +32,7 @@ struct nftnl_expr_nat {
 
 static int
 nftnl_expr_nat_set(struct nftnl_expr *e, uint16_t type,
-		      const void *data, uint32_t data_len)
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
 
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index e3af372410720..5243d9d996f7f 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -24,7 +24,7 @@ struct nftnl_expr_ng {
 
 static int
 nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
-		  const void *data, uint32_t data_len)
+		  const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
 
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 1b27e94a6fa2c..481103e7883c0 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -28,8 +28,9 @@ struct nftnl_expr_objref {
 	} set;
 };
 
-static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
-				 const void *data, uint32_t data_len)
+static int
+nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
 
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 293a81420a322..35a31cf13bd09 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -18,8 +18,9 @@ struct nftnl_expr_osf {
 	uint32_t		flags;
 };
 
-static int nftnl_expr_osf_set(struct nftnl_expr *e, uint16_t type,
-			      const void *data, uint32_t data_len)
+static int
+nftnl_expr_osf_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 593b8422c44e6..476eaab0afd14 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -33,7 +33,7 @@ struct nftnl_expr_payload {
 
 static int
 nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+		       const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 0160d5e25f836..f5e3f3284de70 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -22,8 +22,9 @@ struct nftnl_expr_queue {
 	uint16_t		flags;
 };
 
-static int nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
-				    const void *data, uint32_t data_len)
+static int
+nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
 
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 108c87c04530d..6a8dc948530cb 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -22,8 +22,9 @@ struct nftnl_expr_quota {
 	uint32_t	flags;
 };
 
-static int nftnl_expr_quota_set(struct nftnl_expr *e, uint16_t type,
-				const void *data, uint32_t data_len)
+static int
+nftnl_expr_quota_set(struct nftnl_expr *e, uint16_t type,
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_quota *quota = nftnl_expr_data(e);
 
diff --git a/src/expr/range.c b/src/expr/range.c
index 564d14f0edbbb..cd6d6fbeb4ea2 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -23,8 +23,9 @@ struct nftnl_expr_range {
 	enum nft_range_ops	op;
 };
 
-static int nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
-				const void *data, uint32_t data_len)
+static int
+nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
 
diff --git a/src/expr/redir.c b/src/expr/redir.c
index be38f6257a8f1..3565d3ffa74e9 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -24,7 +24,7 @@ struct nftnl_expr_redir {
 
 static int
 nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
-			const void *data, uint32_t data_len)
+		     const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 5d8763ebb5ef0..df8f92635ca44 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -22,8 +22,9 @@ struct nftnl_expr_reject {
 	uint8_t			icmp_code;
 };
 
-static int nftnl_expr_reject_set(struct nftnl_expr *e, uint16_t type,
-				    const void *data, uint32_t data_len)
+static int
+nftnl_expr_reject_set(struct nftnl_expr *e, uint16_t type,
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_reject *reject = nftnl_expr_data(e);
 
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 4f2e96b53cad4..c0d43110eaf8c 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -22,7 +22,7 @@ struct nftnl_expr_rt {
 
 static int
 nftnl_expr_rt_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		  const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_rt *rt = nftnl_expr_data(e);
 
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 822ee8b9b832e..98a8565024df6 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -23,7 +23,7 @@ struct nftnl_expr_socket {
 
 static int
 nftnl_expr_socket_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		       const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_socket *socket = nftnl_expr_data(e);
 
diff --git a/src/expr/synproxy.c b/src/expr/synproxy.c
index b5a1fef9f4064..ad2f0f0d20305 100644
--- a/src/expr/synproxy.c
+++ b/src/expr/synproxy.c
@@ -16,8 +16,9 @@ struct nftnl_expr_synproxy {
 	uint32_t	flags;
 };
 
-static int nftnl_expr_synproxy_set(struct nftnl_expr *e, uint16_t type,
-				   const void *data, uint32_t data_len)
+static int
+nftnl_expr_synproxy_set(struct nftnl_expr *e, uint16_t type,
+			const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_synproxy *synproxy = nftnl_expr_data(e);
 
diff --git a/src/expr/target.c b/src/expr/target.c
index 3549456b430ff..6b590f5a4b767 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -32,7 +32,7 @@ struct nftnl_expr_target {
 
 static int
 nftnl_expr_target_set(struct nftnl_expr *e, uint16_t type,
-			 const void *data, uint32_t data_len)
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_target *tg = nftnl_expr_data(e);
 
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 4cc9125f1de65..630dffe040c7d 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -24,7 +24,7 @@ struct nftnl_expr_tproxy {
 
 static int
 nftnl_expr_tproxy_set(struct nftnl_expr *e, uint16_t type,
-		      const void *data, uint32_t data_len)
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_tproxy *tproxy = nftnl_expr_data(e);
 
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index b51b6c7513086..bdfbc290a8872 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -20,8 +20,9 @@ struct nftnl_expr_tunnel {
 	enum nft_registers	dreg;
 };
 
-static int nftnl_expr_tunnel_set(struct nftnl_expr *e, uint16_t type,
-				 const void *data, uint32_t data_len)
+static int
+nftnl_expr_tunnel_set(struct nftnl_expr *e, uint16_t type,
+		      const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_tunnel *tunnel = nftnl_expr_data(e);
 
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index ba2107d63c082..d247b74e01e22 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -22,7 +22,7 @@ struct nftnl_expr_xfrm {
 
 static int
 nftnl_expr_xfrm_set(struct nftnl_expr *e, uint16_t type,
-		    const void *data, uint32_t data_len)
+		    const void *data, uint32_t data_len, uint32_t byteorder)
 {
 	struct nftnl_expr_xfrm *x = nftnl_expr_data(e);
 
-- 
2.51.0

