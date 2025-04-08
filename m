Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C1919E96A
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744120760; cv=none; b=BIu10cupvSAfkWrrE92MeKqoYM3rdBiQv+gxDtQhTiRHxAPCjFtq3s+fpXUXdF4QTPFgCYGjMbA/ofWvMM7gxpPtfjrMlPNCxkJX8tbo6qBDp8PZK+w259w4ImYsLkmD2atEidxcN7XLA88T7giUnxqhnX0DGGw6Y4bSbC7CI+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744120760; c=relaxed/simple;
	bh=wqMOrOnyzdo/M1sk8Uvzic1pNNfjY3NrmLBAnAB32yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4Zugpdpp5mLFYTQgSMAFIcvk6BhApol9jhyxY8iRpLmD9K2WNiiCYDYzi5O+WKcj57OFvbfkJEoW7fQaBmws3F8Rqoira/qPsuTYmSxi0g0hW1lGuGRfnQB51iT4syy3CZQZ+35cotL08YwDNAu/3QZtLD9uc6YnhzB5WSL0CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29Tx-0002h5-0P; Tue, 08 Apr 2025 15:59:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 libnftnl] set: dump set backend name (hash, rbtree...) and elem count, if available
Date: Tue,  8 Apr 2025 15:58:42 +0200
Message-ID: <20250408135845.21621-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case kernel provided the information do include it in debug dump:

nft --debug=netlink list ruleset
family 2 s t 0 backend nft_set_rhash_type
family 2 __set0 t 3 size 3 backend nft_set_hash_fast_type count 3
family 2 __set1 t 3 size 2 backend nft_set_bitmap_type count 2
[..]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: add NFTNL_SET_COUNT so existing nftnl_set_get_u32() can be used to
     retrieve the real set element number reported by the kernel.

 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  4 ++++
 include/set.h                       |  2 ++
 src/set.c                           | 34 +++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index e2e5795aa9b4..cad5e8e81c7a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -32,6 +32,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_DESC_CONCAT,
 	NFTNL_SET_EXPR,
 	NFTNL_SET_EXPRESSIONS,
+	NFTNL_SET_COUNT,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 49c944e78463..7d6bc19a0153 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -394,6 +394,8 @@ enum nft_set_field_attributes {
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
+ * @NFTA_SET_TYPE: set backend type (NLA_STRING)
+ * @NFTA_SET_COUNT: number of set elements (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -415,6 +417,8 @@ enum nft_set_attributes {
 	NFTA_SET_HANDLE,
 	NFTA_SET_EXPR,
 	NFTA_SET_EXPRESSIONS,
+	NFTA_SET_TYPE,
+	NFTA_SET_COUNT,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 55018b6b9ba9..bda80685590d 100644
--- a/include/set.h
+++ b/include/set.h
@@ -11,6 +11,7 @@ struct nftnl_set {
 	uint32_t		set_flags;
 	const char		*table;
 	const char		*name;
+	const char		*type;
 	uint64_t		handle;
 	uint32_t		key_type;
 	uint32_t		key_len;
@@ -31,6 +32,7 @@ struct nftnl_set {
 	struct list_head	element_list;
 
 	uint32_t		flags;
+	uint32_t		elemcount;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
 	struct list_head	expr_list;
diff --git a/src/set.c b/src/set.c
index a0208441f31e..412bdac627d3 100644
--- a/src/set.c
+++ b/src/set.c
@@ -59,6 +59,8 @@ void nftnl_set_free(const struct nftnl_set *s)
 		list_del(&elem->head);
 		nftnl_set_elem_free(elem);
 	}
+
+	xfree(s->type);
 	xfree(s);
 }
 
@@ -97,6 +99,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_DESC_CONCAT:
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
+	case NFTNL_SET_COUNT:
 		break;
 	case NFTNL_SET_USERDATA:
 		xfree(s->user.data);
@@ -129,6 +132,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_DESC_SIZE]	= sizeof(uint32_t),
 	[NFTNL_SET_TIMEOUT]		= sizeof(uint64_t),
 	[NFTNL_SET_GC_INTERVAL]	= sizeof(uint32_t),
+	[NFTNL_SET_COUNT]	= sizeof(uint32_t),
 };
 
 EXPORT_SYMBOL(nftnl_set_set_data);
@@ -198,6 +202,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	case NFTNL_SET_GC_INTERVAL:
 		memcpy(&s->gc_interval, data, sizeof(s->gc_interval));
 		break;
+	case NFTNL_SET_COUNT:
+		memcpy(&s->elemcount, data, sizeof(s->elemcount));
+		break;
 	case NFTNL_SET_USERDATA:
 		if (s->flags & (1 << NFTNL_SET_USERDATA))
 			xfree(s->user.data);
@@ -304,6 +311,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_GC_INTERVAL:
 		*data_len = sizeof(uint32_t);
 		return &s->gc_interval;
+	case NFTNL_SET_COUNT:
+		*data_len = sizeof(uint32_t);
+		return &s->elemcount;
 	case NFTNL_SET_USERDATA:
 		*data_len = s->user.len;
 		return s->user.data;
@@ -381,6 +391,8 @@ struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 		list_add_tail(&newelem->head, &newset->element_list);
 	}
 
+	newset->type = NULL;
+
 	return newset;
 err:
 	nftnl_set_free(newset);
@@ -523,6 +535,7 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_SET_TABLE:
 	case NFTA_SET_NAME:
+	case NFTA_SET_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
@@ -538,6 +551,7 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_ID:
 	case NFTA_SET_POLICY:
 	case NFTA_SET_GC_INTERVAL:
+	case NFTA_SET_COUNT:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -738,6 +752,16 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->flags |= (1 << NFTNL_SET_EXPRESSIONS);
 	}
 
+	if (tb[NFTA_SET_TYPE]) {
+		xfree(s->type);
+		s->type = strdup(mnl_attr_get_str(tb[NFTA_SET_TYPE]));
+	}
+
+	if (tb[NFTA_SET_COUNT]) {
+		s->elemcount = ntohl(mnl_attr_get_u32(tb[NFTA_SET_COUNT]));
+		s->flags |= (1 << NFTNL_SET_COUNT);
+	}
+
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
 
@@ -802,6 +826,16 @@ static int nftnl_set_snprintf_default(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
+	if (s->type) {
+		ret = snprintf(buf + offset, remain, " backend %s", s->type);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	if (s->elemcount) {
+		ret = snprintf(buf + offset, remain, " count %u", s->elemcount);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list))
 		return offset;
-- 
2.49.0

