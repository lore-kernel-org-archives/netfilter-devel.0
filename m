Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E59A78C76
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732101408; cv=none; b=StR3jGRRD8n6E56G/2OYHJ+buGdv7aBqZpVLcVWFI60e6jaTmFpOUc1HnrlCPp8jjX/Go0NhSSLOvA7/Yy5PCFBhqDmwX5wK1qFuZ2JwybxzqoDoTZQBEbH9UTtXCJyX4XxWl7RqU0SfmIn6hW/sNXpF1cUk3wc7WjEvlC1eg0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732101408; c=relaxed/simple;
	bh=sSWLTqjniDWsCUaIM8GxpZFN5g9FIwcdinIqK8CSugA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FH4IuIkrLv+Avl31nBX3MXLwZeklaVCXQ0OI7CylaqK3p33P9aM04dhQi1Nx0MkIlijdZcvNuGkEKSQ2UThrg/HncSY0Zyds1QC3zIIe0zUXW4wPtBNpBnxrJkyEP2IMB0q+z5EQsRlpiaUDlFqMh8CPd5IYXneiwVpNK6RJPPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tDihP-0004Yi-5Z; Wed, 20 Nov 2024 12:16:43 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: export set count and backend name to userspace
Date: Wed, 20 Nov 2024 10:52:33 +0100
Message-ID: <20241120095236.10532-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
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
information in debug stats.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c            | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 49c944e78463..6e87d704d3a8 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -394,6 +394,8 @@ enum nft_set_field_attributes {
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_EXPRESSION: list of expressions (NLA_NESTED: nft_list_attributes)
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 21b6f7410a1f..da308e295b95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4565,6 +4565,8 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
 	[NFTA_SET_EXPRESSIONS]		= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
+	[NFTA_SET_OPSNAME]		= { .type = NLA_REJECT },
+	[NFTA_SET_NELEMS]		= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
@@ -4751,6 +4753,21 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 	return 0;
 }
 
+/* no error checking: non-essential debug info */
+static void nf_tables_fill_set_info(struct sk_buff *skb,
+				    const struct nft_set *set)
+{
+	unsigned int nelems = atomic_read(&set->nelems);
+	const char *str = kasprintf(GFP_ATOMIC, "%ps", set->ops);
+
+	nla_put_be32(skb, NFTA_SET_NELEMS, htonl(nelems));
+
+	if (str)
+		nla_put_string(skb, NFTA_SET_OPSNAME, str);
+
+	kfree(str);
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -4830,6 +4847,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	nla_nest_end(skb, nest);
 
+	nf_tables_fill_set_info(skb, set);
+
 	if (set->num_exprs == 1) {
 		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
 		if (nf_tables_fill_expr_info(skb, set->exprs[0], false) < 0)
-- 
2.45.2

