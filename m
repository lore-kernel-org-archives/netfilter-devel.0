Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B573F38384
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744120592; cv=none; b=RvE9YNj/DOgja4CleDHCUv59g04biL00oIYVZHySjWrL3RE0dTieiiKWpDT8D9otQCJXBEFo0oiJ3lvqcELmu065ZdNpzvspXyhGR/poAjzO2gmjQxD/OJ/LPjyLzmvibtgl5I8Yivrke73uaYeOCcqVJYgeTCHio0d9Rp0e/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744120592; c=relaxed/simple;
	bh=uFfFdcs8ywuzI0HrLqrIaYBBr1OQcun4OfOAu5KUltU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RdG8wFuSUY0bBy5dWmqj97lP+vHrAuprhV0uExUvMXGAAIlqj12kPZzqeLbx9a1FBPrDh2QISsyT0fELDrvhANwsq1q0tX3e7aDwjjhm60445Bi/e/8YEtt3xkSc6ymb3uRUWOC40t07KNbRW2opu89p/HDcxjqoVbawi9Sc3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29RD-0002fT-RD; Tue, 08 Apr 2025 15:56:27 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next] netfilter: nf_tables: export set count and backend name to userspace
Date: Tue,  8 Apr 2025 15:55:53 +0200
Message-ID: <20250408135556.21431-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_tables picks a suitable set backend implementation (bitmap, hash,
rbtree..) based on the userspace requirements.

Figuring out the chosen backend requires information about the set flags
and the kernel version.  Export this to userspace so nft can include this
information in '--debug=netlink' output.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: rename attributes, handle errors in nf_tables_fill_set_info (Pablo Neira)
     prefer snprintf to kasprintf
     use new nft_set_userspace_size() to not expose rbtree
     implementation details to userspace.

 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c            | 26 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 49c944e78463..7d6bc19a0153 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e950..dc12943558ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4569,6 +4569,8 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
 	[NFTA_SET_EXPRESSIONS]		= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
+	[NFTA_SET_TYPE]			= { .type = NLA_REJECT },
+	[NFTA_SET_COUNT]		= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
@@ -4763,6 +4765,27 @@ static u32 nft_set_userspace_size(const struct nft_set_ops *ops, u32 size)
 	return size;
 }
 
+static noinline_for_stack int
+nf_tables_fill_set_info(struct sk_buff *skb, const struct nft_set *set)
+{
+	unsigned int nelems;
+	char str[32];
+	int ret;
+
+	ret = snprintf(str, sizeof(str), "%ps", set->ops);
+
+	/* Not expected to happen and harmless: NFTA_SET_TYPE is dumped
+	 * to userspace purely for informational/debug purposes.
+	 */
+	DEBUG_NET_WARN_ON_ONCE(ret >= sizeof(str));
+
+	if (nla_put_string(skb, NFTA_SET_TYPE, str))
+		return -EMSGSIZE;
+
+	nelems = nft_set_userspace_size(set->ops, atomic_read(&set->nelems));
+	return nla_put_be32(skb, NFTA_SET_COUNT, htonl(nelems));
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -4843,6 +4866,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	nla_nest_end(skb, nest);
 
+	if (nf_tables_fill_set_info(skb, set))
+		goto nla_put_failure;
+
 	if (set->num_exprs == 1) {
 		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
 		if (nf_tables_fill_expr_info(skb, set->exprs[0], false) < 0)
-- 
2.49.0

