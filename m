Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB11366
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2024 10:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732618697; cv=none; b=fHKpgFbM03SNCaf5KOMqCETDrjcsNn4b9/ABBhFHZQt5mZhFBENxC3ZGh+B20+Z1H01CJAHrJs7Pavc4U6QXGEqtd3Fwjja7WEQsmdA5Mud07C8QF/etqLWTGQ444+FKhWpzHtwG/dPYiit7TS4ya9ceQAEmiPga96uf32psnF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732618697; c=relaxed/simple;
	bh=unYtkKvFOyNAZQClNyBhCAS+LCogtvtofQVQFklscIU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kUo8TI4CJy9klk0POyxsr+erN6XdKjh3TJHPeNnRzNsdMsjofGjctYO/MBOzE/Y3ZTxvt4K40UADNHID7tiNtOMKaAjoN9aB1sxxzuwfKRwa6lZSBq0jiHZQHqH93L2YOY6XjdsxABv/jetH78xS/iudTJyPdHJmdwFm1c+HfXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next] netfilter: nf_tables: fix set size with rbtree backend
Date: Tue, 26 Nov 2024 11:58:02 +0100
Message-Id: <20241126105802.12782-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing rbtree implementation uses singleton elements to represent
ranges, however, userspace provides a set size according to the number
of ranges in the set.

Adjust provided userspace set size to the number of singleton elements
in the kernel by multiplying the range by two. Add the non-matching all
zero element too.

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
table ip x {
        set y {
                type ipv4_addr
                size 1
                flags interval
        }
}

add element x y { 1.1.1.1 }

results in: Too many open files in system.

interval sets do not support for dynamic sets, usecase for size in this
case is limited, but it is broken anyway because it is leaking internal
implementation details.

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 26 +++++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c    | 19 +++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 066a3ea33b12..f0428b652b0d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -495,6 +495,8 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
+	u32				(*ksize)(u32 size);
+	u32				(*usize)(u32 size);
 	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 588a2757986c..bea6b39cf7a8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4630,6 +4630,14 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 	return 0;
 }
 
+static u32 nft_set_userspace_size(const struct nft_set_ops *ops, u32 size)
+{
+	if (ops->usize)
+		return ops->usize(size);
+
+	return size;
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -4700,7 +4708,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (!nest)
 		goto nla_put_failure;
 	if (set->size &&
-	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
+	    nla_put_be32(skb, NFTA_SET_DESC_SIZE,
+			 htonl(nft_set_userspace_size(set->ops, set->size))))
 		goto nla_put_failure;
 
 	if (set->field_count > 1 &&
@@ -5068,6 +5077,15 @@ static bool nft_set_is_same(const struct nft_set *set,
 	return true;
 }
 
+static u32 nft_set_kernel_size(const struct nft_set_ops *ops,
+			       const struct nft_set_desc *desc)
+{
+	if (ops->ksize)
+		return ops->ksize(desc->size);
+
+	return desc->size;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -5250,6 +5268,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		if (desc.size)
+			desc.size = nft_set_kernel_size(set->ops, &desc);
+
 		err = 0;
 		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
@@ -5272,6 +5293,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
+	if (desc.size)
+		desc.size = nft_set_kernel_size(ops, &desc);
+
 	udlen = 0;
 	if (nla[NFTA_SET_USERDATA])
 		udlen = nla_len(nla[NFTA_SET_USERDATA]);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b7ea21327549..e135c9d8f5a4 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -750,6 +750,23 @@ static void nft_rbtree_gc_init(const struct nft_set *set)
 	priv->last_gc = jiffies;
 }
 
+/* rbtree stores ranges as singleton elements, each range is composed of two
+ * elements. Add the non-matching all zero element too.
+ */
+static u32 nft_rbtree_ksize(u32 size)
+{
+	return size * 2 + 1;
+}
+
+/* ... and hide this detail to userspace. */
+static u32 nft_rbtree_usize(u32 size)
+{
+	if (!size)
+		return 0;
+
+	return (size - 1) / 2;
+}
+
 const struct nft_set_type nft_set_rbtree_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
@@ -768,5 +785,7 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
 		.get		= nft_rbtree_get,
+		.ksize		= nft_rbtree_ksize,
+		.usize		= nft_rbtree_usize,
 	},
 };
-- 
2.30.2

