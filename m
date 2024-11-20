Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463617F7
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732101962; cv=none; b=QZ3FnIMlMokeUR3EPwoppRKZTBJ9jphhkJhPa4uDyuKqe3x0/GkgtcglC4StRAgQxAMpDzkvUow3106njtZbrYIRC3QTQglrCZ34u1tyBxf6i6kSsLDd6CKTBLcgv5RdWYIpO9l2GgMV7a+B5wY/unb+9oKDwFeOIyFLQoFSpc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732101962; c=relaxed/simple;
	bh=OY71PspaRC0MaoRYOROn1QHWIaW+P2N4w3jLiqLHac0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qoWwXqb0fmdSFwauY52fT9Z/kt6bGZALUbevOnmcZMb5UolBEKt9VyQ93d2hQS5xRvHsFKbxw1jCx07tf25f5IjJSO02V0dvgNWH/ixcaVKdwddHo5CvVGzrrRQtMBkgkHTVs2x3piU2PMqeCBvsDs8M2xy1/Mhl14g4d92OXi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tDiqL-0004cM-Q7; Wed, 20 Nov 2024 12:25:57 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] set: dump set backend name (hash, rbtree...) and elem count, if available
Date: Wed, 20 Nov 2024 11:01:48 +0100
Message-ID: <20241120100151.10953-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
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
family 2 __set0 t 3 size 3 backend nft_set_hash_fast_type nelems 3
family 2 __set1 t 3 size 2 backend nft_set_bitmap_type nelems 2
[..]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h |  4 ++++
 include/set.h                       |  2 ++
 src/set.c                           | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9e9079321380..c91117d60c94 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -394,6 +394,8 @@ enum nft_set_field_attributes {
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
+ * @NFTA_SET_OPSNAME: set backend type (NLA_STRING)
+ * @NFTA_SET_NELEMS: number of set elements (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -415,6 +417,8 @@ enum nft_set_attributes {
 	NFTA_SET_HANDLE,
 	NFTA_SET_EXPR,
 	NFTA_SET_EXPRESSIONS,
+	NFTA_SET_OPSNAME,
+	NFTA_SET_NELEMS,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 55018b6b9ba9..3c7949d67425 100644
--- a/include/set.h
+++ b/include/set.h
@@ -11,6 +11,7 @@ struct nftnl_set {
 	uint32_t		set_flags;
 	const char		*table;
 	const char		*name;
+	const char		*opsname;
 	uint64_t		handle;
 	uint32_t		key_type;
 	uint32_t		key_len;
@@ -31,6 +32,7 @@ struct nftnl_set {
 	struct list_head	element_list;
 
 	uint32_t		flags;
+	uint32_t		nelems;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
 	struct list_head	expr_list;
diff --git a/src/set.c b/src/set.c
index 75ad64e03850..c35c2472375a 100644
--- a/src/set.c
+++ b/src/set.c
@@ -63,6 +63,8 @@ void nftnl_set_free(const struct nftnl_set *s)
 		list_del(&elem->head);
 		nftnl_set_elem_free(elem);
 	}
+
+	xfree(s->opsname);
 	xfree(s);
 }
 
@@ -383,6 +385,8 @@ struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 		list_add_tail(&newelem->head, &newset->element_list);
 	}
 
+	newset->opsname = NULL;
+
 	return newset;
 err:
 	nftnl_set_free(newset);
@@ -525,6 +529,7 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_SET_TABLE:
 	case NFTA_SET_NAME:
+	case NFTA_SET_OPSNAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
@@ -540,6 +545,7 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_ID:
 	case NFTA_SET_POLICY:
 	case NFTA_SET_GC_INTERVAL:
+	case NFTA_SET_NELEMS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -740,6 +746,14 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->flags |= (1 << NFTNL_SET_EXPRESSIONS);
 	}
 
+	if (tb[NFTA_SET_OPSNAME]) {
+		xfree(s->opsname);
+		s->opsname = strdup(mnl_attr_get_str(tb[NFTA_SET_OPSNAME]));
+	}
+
+	if (tb[NFTA_SET_NELEMS])
+		s->nelems = ntohl(mnl_attr_get_u32(tb[NFTA_SET_NELEMS]));
+
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
 
@@ -804,6 +818,16 @@ static int nftnl_set_snprintf_default(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
+	if (s->opsname) {
+		ret = snprintf(buf + offset, remain, " backend %s", s->opsname);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
+	if (s->nelems) {
+		ret = snprintf(buf + offset, remain, " nelems %u", s->nelems);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list))
 		return offset;
-- 
2.47.0

