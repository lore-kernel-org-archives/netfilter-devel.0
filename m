Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF7279C4
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394068; cv=none; b=NhdJrtaGAMCUS9ifKTfLdfWySETCJzMMpEH4m+GHU9uUjyO/dZm1tIzsTuYO5YL0K95rXs1u0QYuTD8qefgb+lsEokmMbkxqNJd5GONYhxy61iPWtBIuHqmecBrVwHLgmGwUUKIQBL9fsjlr2zYzcipbSOzBh+mxnQYfW41crr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394068; c=relaxed/simple;
	bh=+bKuokGuhYnkEY6klwPXdGH5eu2Q2C/+34a3LKRS07Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bj40Oq05t49T+s7T3a8evx2hskjeQdUqLCbpcmgH+pI05o5aPMXtCJxtChDQ9IMxbgbZQrEJDk+IusUZS/nYOLbXM6XDVsfDuUs4T+qOAwFgnOXZs49gMz2UczUNFAAwjTLp+aHMYC+Eq8uFnpP5fAK0bKdJ1Vs3WYPUjfKtu7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R9iQBzXO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R9iQBzXO"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22423adf751so123075145ad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 07:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742394065; x=1742998865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5W59Vexp2NU46giJO07wlTSDmoYdOuPnJMYRi2MxotQ=;
        b=R9iQBzXOhbnIh3VgfIdPthIu3vUGnvdKwkhKxI4goOVzhjb3YiccbGys223l/sHAAf
         LH8Dq5a0H2+lmpc6+xrFnZhQy2UQT35bphGVwm9vX25nV0DKTGgjUoQZz0lBMzp63fna
         RL3CDqWTqnVusy4aB8NRn2lQMVlciNgcKY7xnSL5doi+P5F+PKeodF08Qs7Cyw9THpjN
         NlU7dYLCK7yitocO3c5x2kbWX0ayKj2+BErkmQjtvhiZK8lH5bKsIaoKKO5JdSDAPjS9
         ZLblxXHszJW1Ahw+od8854fHC4OsnuNwQUyN7zpf/ubvAfuGp5htxTwVly2bf2vS1Jtn
         jpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742394065; x=1742998865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5W59Vexp2NU46giJO07wlTSDmoYdOuPnJMYRi2MxotQ=;
        b=HTbuMZ7NIwjt4RKpEbYlDcjwZ21+TzUnS+o96mBX+jS5nuWn8Z21lnLSYDvSb96UJq
         m+I6iBN+yhtRmZGH7oBur6+zfs1RJ65BWCz42fwPprQLDV9j4uRCstSMo7dGrxs7kKr7
         Ue8MzDHklhTkCJg1VCWSl/rf9d9U0b/6APa+Mc0Lqxr7OHrV31K4z2EkdqTKTL3arJwS
         VNZB60VSpaoqLwThKQvaNvhfSzhL41lXh64JyUM7NmKDwW+wZ55yq0c5ZB90bVJUb57r
         sR9djQ9PnNPY/PMRARtnUAWplVM6+DAC+f9nhs8zU0jK9YvZETiI6EwwFJQlDZnUdl3N
         HSsA==
X-Gm-Message-State: AOJu0YxnprklowJZe9l228vcEgzoT8bA6ABJCYfd8kp4DfkQH/LKTLPG
	Eqe1w8uJ1SP+FANQpNV4j05fmt9arp3HVsobnb634SAvTE//gS4IVKzQ0A==
X-Gm-Gg: ASbGncssW9c8/di9gXIoAC72T8hai0eoArG9mCg1Vd/i7RtVTixxIV1Mji5U/+FkLV9
	XjQfx/wr6vNezBwPvLZisQIKx23s9QhdzBs+G5c2wUr92WU9yox1zoJEPq32Uv+f+te2NCMvoOH
	3ezGhVfpvlgBOaSz0OzJLCBywRI3LU+mzlfHgXZWcyvxTyJB0BI01Yi2FAX2mCWw83pCGDqGk86
	gGFlhWUdacFLMZlspR/ffsPiKTOrCK7cabvwdaOvWJrzi+aqFbU6bm2X/0YFUOoHoxKnBLunJkQ
	CT5VujFf/a/reeqeX3bN0xEo7EdY
X-Google-Smtp-Source: AGHT+IEAsqrGAjSqOOBtCXbQDYx3PCAiLOWQ4RAMTQtOGv8O0TzNTxewdkzS+VH2Tt6PnbGZU4LP6w==
X-Received: by 2002:a17:903:178b:b0:21a:8300:b9ce with SMTP id d9443c01a7336-22649c9580dmr43504805ad.49.1742394065289;
        Wed, 19 Mar 2025 07:21:05 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bd4e8dsm114022955ad.228.2025.03.19.07.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 07:21:04 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH libnftnl] src: remove unused str2XXX helper
Date: Wed, 19 Mar 2025 14:20:53 +0000
Message-ID: <20250319142053.124749-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 80077787f8f2 ("src: remove json support"), these internal
functions are no longer used:

nftnl_str2hooknum
nftnl_str2ntoh
nftnl_str2cmp
str2ctkey
str2ctdir
str2exthdr_op
str2exthdr_type
str2meta_key
nftnl_str2nat
nftnl_str2range
str2rt_key
nftnl_str2hooknum

Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/chain.c          | 11 -----------
 src/expr/byteorder.c | 12 ------------
 src/expr/cmp.c       | 20 --------------------
 src/expr/ct.c        | 27 ---------------------------
 src/expr/exthdr.c    | 27 ---------------------------
 src/expr/meta.c      | 13 -------------
 src/expr/nat.c       | 12 ------------
 src/expr/range.c     | 12 ------------
 src/expr/rt.c        | 13 -------------
 src/flowtable.c      | 11 -----------
 10 files changed, 158 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 7287dcd98e89..895108cddad5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -739,17 +739,6 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 	return ret;
 }
 
-static inline int nftnl_str2hooknum(int family, const char *hook)
-{
-	int hooknum;
-
-	for (hooknum = 0; hooknum < NF_INET_NUMHOOKS; hooknum++) {
-		if (strcmp(hook, nftnl_hooknum2str(family, hooknum)) == 0)
-			return hooknum;
-	}
-	return -1;
-}
-
 static int nftnl_chain_snprintf_default(char *buf, size_t remain,
 					const struct nftnl_chain *c)
 {
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 903c775bf196..4171d0633728 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -179,18 +179,6 @@ static const char *bo2str(uint32_t type)
 	return expr_byteorder_str[type];
 }
 
-static inline int nftnl_str2ntoh(const char *op)
-{
-	if (strcmp(op, "ntoh") == 0)
-		return NFT_BYTEORDER_NTOH;
-	else if (strcmp(op, "hton") == 0)
-		return NFT_BYTEORDER_HTON;
-	else {
-		errno = EINVAL;
-		return -1;
-	}
-}
-
 static int
 nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
 			      uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f55a8c0299e1..2908f56325b4 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -148,26 +148,6 @@ static const char *cmp2str(uint32_t op)
 	return expr_cmp_str[op];
 }
 
-static inline int nftnl_str2cmp(const char *op)
-{
-	if (strcmp(op, "eq") == 0)
-		return NFT_CMP_EQ;
-	else if (strcmp(op, "neq") == 0)
-		return NFT_CMP_NEQ;
-	else if (strcmp(op, "lt") == 0)
-		return NFT_CMP_LT;
-	else if (strcmp(op, "lte") == 0)
-		return NFT_CMP_LTE;
-	else if (strcmp(op, "gt") == 0)
-		return NFT_CMP_GT;
-	else if (strcmp(op, "gte") == 0)
-		return NFT_CMP_GTE;
-	else {
-		errno = EINVAL;
-		return -1;
-	}
-}
-
 static int
 nftnl_expr_cmp_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index b01fbc58bd28..1c46dd97ba6c 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -177,18 +177,6 @@ static const char *ctkey2str(uint32_t ctkey)
 	return ctkey2str_array[ctkey];
 }
 
-static inline int str2ctkey(const char *ctkey)
-{
-	int i;
-
-	for (i = 0; i < NFT_CT_MAX; i++) {
-		if (strcmp(ctkey2str_array[i], ctkey) == 0)
-			return i;
-	}
-
-	return -1;
-}
-
 static const char *ctdir2str(uint8_t ctdir)
 {
 	switch (ctdir) {
@@ -201,21 +189,6 @@ static const char *ctdir2str(uint8_t ctdir)
 	}
 }
 
-static inline int str2ctdir(const char *str, uint8_t *ctdir)
-{
-	if (strcmp(str, "original") == 0) {
-		*ctdir = IP_CT_DIR_ORIGINAL;
-		return 0;
-	}
-
-	if (strcmp(str, "reply") == 0) {
-		*ctdir = IP_CT_DIR_REPLY;
-		return 0;
-	}
-
-	return -1;
-}
-
 static int
 nftnl_expr_ct_snprintf(char *buf, size_t remain,
 		       uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 339527dcd193..ddebe43eabf5 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -202,33 +202,6 @@ static const char *op2str(uint8_t op)
 	}
 }
 
-static inline int str2exthdr_op(const char* str)
-{
-	if (!strcmp(str, "tcpopt"))
-		return NFT_EXTHDR_OP_TCPOPT;
-	if (!strcmp(str, "ipv4"))
-		return NFT_EXTHDR_OP_IPV4;
-
-	/* if str == "ipv6" or anything else */
-	return NFT_EXTHDR_OP_IPV6;
-}
-
-static inline int str2exthdr_type(const char *str)
-{
-	if (strcmp(str, "hopopts") == 0)
-		return IPPROTO_HOPOPTS;
-	else if (strcmp(str, "routing") == 0)
-		return IPPROTO_ROUTING;
-	else if (strcmp(str, "fragment") == 0)
-		return IPPROTO_FRAGMENT;
-	else if (strcmp(str, "dstopts") == 0)
-		return IPPROTO_DSTOPTS;
-	else if (strcmp(str, "mh") == 0)
-		return IPPROTO_MH;
-
-	return -1;
-}
-
 static int
 nftnl_expr_exthdr_snprintf(char *buf, size_t len,
 			   uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 56d3ddaffa22..d1ff6c4d2339 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -173,19 +173,6 @@ static const char *meta_key2str(uint8_t key)
 	return "unknown";
 }
 
-static inline int str2meta_key(const char *str)
-{
-	int i;
-
-	for (i = 0; i < NFT_META_MAX; i++) {
-		if (strcmp(str, meta_key2str_array[i]) == 0)
-			return i;
-	}
-
-	errno = EINVAL;
-	return -1;
-}
-
 static int
 nftnl_expr_meta_snprintf(char *buf, size_t len,
 			 uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 3ce1aafda55e..f7e24cb34d51 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -202,18 +202,6 @@ static inline const char *nat2str(uint16_t nat)
 	}
 }
 
-static inline int nftnl_str2nat(const char *nat)
-{
-	if (strcmp(nat, "snat") == 0)
-		return NFT_NAT_SNAT;
-	else if (strcmp(nat, "dnat") == 0)
-		return NFT_NAT_DNAT;
-	else {
-		errno = EINVAL;
-		return -1;
-	}
-}
-
 static int
 nftnl_expr_nat_snprintf(char *buf, size_t remain,
 			uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/expr/range.c b/src/expr/range.c
index b05724fc5fa4..50a8ed092e38 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -162,18 +162,6 @@ static const char *range2str(uint32_t op)
 	return expr_range_str[op];
 }
 
-static inline int nftnl_str2range(const char *op)
-{
-	if (strcmp(op, "eq") == 0)
-		return NFT_RANGE_EQ;
-	else if (strcmp(op, "neq") == 0)
-		return NFT_RANGE_NEQ;
-	else {
-		errno = EINVAL;
-		return -1;
-	}
-}
-
 static int nftnl_expr_range_snprintf(char *buf, size_t remain,
 				     uint32_t flags, const struct nftnl_expr *e)
 {
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 633031e1427c..4f2e96b53cad 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -122,19 +122,6 @@ static const char *rt_key2str(uint8_t key)
 	return "unknown";
 }
 
-static inline int str2rt_key(const char *str)
-{
-	int i;
-
-	for (i = 0; i < NFT_RT_MAX; i++) {
-		if (strcmp(str, rt_key2str_array[i]) == 0)
-			return i;
-	}
-
-	errno = EINVAL;
-	return -1;
-}
-
 static int
 nftnl_expr_rt_snprintf(char *buf, size_t len,
 		       uint32_t flags, const struct nftnl_expr *e)
diff --git a/src/flowtable.c b/src/flowtable.c
index 2a8d374541b0..fbbe0a866368 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -488,17 +488,6 @@ static const char *nftnl_hooknum2str(int family, int hooknum)
 	return "unknown";
 }
 
-static inline int nftnl_str2hooknum(int family, const char *hook)
-{
-	int hooknum;
-
-	for (hooknum = 0; hooknum < NF_INET_NUMHOOKS; hooknum++) {
-		if (strcmp(hook, nftnl_hooknum2str(family, hooknum)) == 0)
-			return hooknum;
-	}
-	return -1;
-}
-
 EXPORT_SYMBOL(nftnl_flowtable_parse);
 int nftnl_flowtable_parse(struct nftnl_flowtable *c, enum nftnl_parse_type type,
 			  const char *data, struct nftnl_parse_err *err)
-- 
2.43.0

