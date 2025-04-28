Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA6210F5D;
	Mon, 28 Apr 2025 22:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878404; cv=none; b=FkhC/9PCcqUJaJpV/QdemXp90OIPNvFx4QtyWuGhZTNpNt8D1S/utOLLmpp/iFglQvPeNae5P9MFITtUShu7p5AhmmboatnXfMu4CH1dtGEMuAGnbO7SPu+RDosd+9KKn5kONDR9We71dGQVKVTolu72NAMomxZd4WCt9pMgKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878404; c=relaxed/simple;
	bh=xjQUqdHomWBGV+L9OFBYKbZJrG26ub27QJgU0MZfnfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rKK9wwqSHacSkm4BkN82kA5AX4wB21/MolzamofD951XNKA/wye/P8qVb64mhyiYAl0yyGE4KEzevmjaN9E4D898CZRngRdB3pthdxR2CTZheTc2hs3MvxlGlURp5swqrbMAmXr2XbnnEhH7taSuQQxI5/Wtgl/Fh5zR989uQVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TPpvGsXa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dvJu3bC1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TPpvGsXa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dvJu3bC1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F1F80603A0; Tue, 29 Apr 2025 00:13:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878400;
	bh=Kx0D9pn3i6pERyxfuCLZBf3n2d0K6uejemARtibfXZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPpvGsXaQPU4c5TrOn9R1P4sPj1kUY6Kf0pu+bi8yIu7E7Kjpv2cdTF2D8PaLbkJd
	 G8w8alD6wup0Na3pDq9DHSoyuoRrti1WSWvFTW40SrqJJ4wC0nau7HCG7vTAi31bAQ
	 vRT0kBLuXFfXqFGfCdbG1n6e/+9I0TCzzMKaPQgqaupNoc7nCECYZV/SX2QxT3ojbs
	 hZ/RGoiJuoXiOuqbF17Abq6TnxJX+CJFzQBBK00azInqi6lxEES6/7B8PDgLsWzcSy
	 rG3b9CU3xXSfz6Hsmx6vP0/5VoT2Wk6pAndgE0hKKH7LzeC7vUBVAX2GlSNvkWz6fe
	 3A7vX9lSkBSzg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CF31D6039F;
	Tue, 29 Apr 2025 00:13:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878397;
	bh=Kx0D9pn3i6pERyxfuCLZBf3n2d0K6uejemARtibfXZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvJu3bC1FIZ5ppfAhQL25bRwdEaUhonH79Df3eCF7xgnCB3zoaQ66W3RVTfOOmuig
	 Etp6SPj8qCyqCtPeblb0pDt2C3VM1K5UyJbB1egzrcnVKDqxzEgYKkyvZ0tnEO8g+c
	 Fm0NX+oruo5ZhbDRGkxAMF7ugIh29jboIWnpgxMoVdgfGoS+8Ey69BC0oFOZBUmik5
	 m6QgNWwxEb/4zy1kTpU/w+4pJGxvNiaTalTsSisQMDsQiG8aJSbgkY4okG1Pw7jpOg
	 i18muu2KpY5vtRV3boOZJ/XNig4VJ6nQ6oNKdIY87t/mO0wd5k8A3ZRFcW8nXshFdK
	 sxjH3qJvL85ZA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 6/6] netfilter: nf_tables: export set count and backend name to userspace
Date: Tue, 29 Apr 2025 00:12:54 +0200
Message-Id: <20250428221254.3853-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250428221254.3853-1-pablo@netfilter.org>
References: <20250428221254.3853-1-pablo@netfilter.org>
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
index a133e1c175ce..b28f6730e26d 100644
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
+	char str[40];
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

