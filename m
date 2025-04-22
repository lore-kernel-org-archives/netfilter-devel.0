Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5349A2D0273;
	Tue, 22 Apr 2025 20:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353445; cv=none; b=f//iXggcboQKPirYff9IZqPUTZCCqtU9drc40saun93177AoM9oPqGFT+E+LACco3DJuQPsDU7x0isqgJssoq+OhN6ve7wqrgbyJzQ8B5vwqI1WzsSMCm/tfjLhhrp5fgCVvcJHQ+WZctiQomJNQSXod/QgM5/whgqjDoWe28qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353445; c=relaxed/simple;
	bh=c55dRsLUl9Gq5BXFIui8kGCinkzCZRnDPESjUrdEwzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IA0/gqgmqMOCxGwq+JTL41CG4W7Ksj0buGuJSKq0JWH85XH7Lz4cG745rTjSY1aYTdd1ci3bIV7fxxugXLGV35VWk2ui1mSDw/tnGDnn9MCEmOmqX2FtZOorj6rGWAiZSVgnOn+NtH+ETg3m0HxszpqxFoxdRMVvCpcwZ2JV+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MPMuPwsV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QdHYCkVB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MPMuPwsV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QdHYCkVB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D0388609C4; Tue, 22 Apr 2025 22:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353441;
	bh=FAOT1jNZrOCZ+sF/kWvc9O7N46hP0z5Izne/8tFGusc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPMuPwsVoPyMx9OCno7tQoDwhwWXPMbE4aA+ZZ2OJ7d45lfeD1CFYyivIUGXVw0Vj
	 mjTSQWnPVlYzhmG3CGyElYgM/R0INIpHiwGKQjg+XyizyzGF+eJZZw+wpALyvSFTie
	 bT9OdgZhElMmVHtJfog1anG/n+ZbBwS6aj2sWPto6RkXnczRcnUjwGakxHSJ5095cU
	 9qjq0+64Rvyh1Oqno8KvssG3MxN4YwhB5dV52qunt4llp9RWRwt+MwnFzvpVxD9UyA
	 8/xxXlk+wly3ize9eRfS7qR+9RuhxsxDKqKbP6XkANxMw8IJDB973DRlwPEV7o79+2
	 YJRKGReOtcV9A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 54B60609CB;
	Tue, 22 Apr 2025 22:23:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353433;
	bh=FAOT1jNZrOCZ+sF/kWvc9O7N46hP0z5Izne/8tFGusc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdHYCkVB5/CpMXspgxuMdWxYZtJRR/dahSWctHcXIPbHffvBmeuqm2zn2FjVHB7l2
	 XzJZmKjJC0vr4EnfMhnNpUK7xhDwKHpvNbxnPJIjYQ2STrXeaFu7P48+vTLBHIMJjV
	 dypIyLc7XRt1apmKqPCa/8iiDesu8xqD8L9JW66haujorL+nc7smz+oQ0ie2dYoyyW
	 Wa5QB53OKkjcY5jsB6phgGi2rHFfAv+0xd8NBZL+jdtwXG5EOpsSu4Q2PpF2Dq9smx
	 3RKy827P8j7O7q/pD+R1jb2OwwB2PlzC9pQUzZE4NpMnlUEXTQH8t6VF0KFFIEJqPO
	 jaGigfqH9F1lA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 7/7] netfilter: nf_tables: export set count and backend name to userspace
Date: Tue, 22 Apr 2025 22:23:27 +0200
Message-Id: <20250422202327.271536-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nf_tables picks a suitable set backend implementation (bitmap, hash,
rbtree..) based on the userspace requirements.

Figuring out the chosen backend requires information about the set flags
and the kernel version.  Export this to userspace so nft can include this
information in '--debug=netlink' output.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index a133e1c175ce..90e73462fb69 100644
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
2.30.2

