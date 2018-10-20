From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/10] netfilter: nft_osf: Add ttl option support
Date: Sat, 20 Oct 2018 11:43:10 +0200
Message-ID: <20181020094317.16011-4-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add ttl option support to the nftables "osf" expression.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_osf.h  |  3 ++-
 include/uapi/linux/netfilter/nf_tables.h |  7 +++++
 net/netfilter/nfnetlink_osf.c            | 46 +++++++++++++++-----------------
 net/netfilter/nft_osf.c                  | 15 ++++++++++-
 4 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
index ecf7dab81e9e..c6000046c966 100644
--- a/include/linux/netfilter/nfnetlink_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -27,6 +27,7 @@ bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 		  const struct list_head *nf_osf_fingers);
 
 const char *nf_osf_find(const struct sk_buff *skb,
-                        const struct list_head *nf_osf_fingers);
+			const struct list_head *nf_osf_fingers,
+			const int ttl_check);
 
 #endif /* _NFOSF_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5444e76870bb..579974b0bf0d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1511,9 +1511,16 @@ enum nft_flowtable_hook_attributes {
 };
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
 
+/**
+ * enum nft_osf_attributes - nftables osf expression netlink attributes
+ *
+ * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
+	NFTA_OSF_TTL,
 	__NFTA_OSF_MAX,
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 00db27dfd2ff..6f41dd74729d 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -30,32 +30,27 @@ EXPORT_SYMBOL_GPL(nf_osf_fingers);
 static inline int nf_osf_ttl(const struct sk_buff *skb,
 			     int ttl_check, unsigned char f_ttl)
 {
+	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
 	const struct iphdr *ip = ip_hdr(skb);
-
-	if (ttl_check != -1) {
-		if (ttl_check == NF_OSF_TTL_TRUE)
-			return ip->ttl == f_ttl;
-		if (ttl_check == NF_OSF_TTL_NOCHECK)
-			return 1;
-		else if (ip->ttl <= f_ttl)
-			return 1;
-		else {
-			struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
-			int ret = 0;
-
-			for_ifa(in_dev) {
-				if (inet_ifa_match(ip->saddr, ifa)) {
-					ret = (ip->ttl == f_ttl);
-					break;
-				}
-			}
-			endfor_ifa(in_dev);
-
-			return ret;
+	int ret = 0;
+
+	if (ttl_check == NF_OSF_TTL_TRUE)
+		return ip->ttl == f_ttl;
+	if (ttl_check == NF_OSF_TTL_NOCHECK)
+		return 1;
+	else if (ip->ttl <= f_ttl)
+		return 1;
+
+	for_ifa(in_dev) {
+		if (inet_ifa_match(ip->saddr, ifa)) {
+			ret = (ip->ttl == f_ttl);
+			break;
 		}
 	}
 
-	return ip->ttl == f_ttl;
+	endfor_ifa(in_dev);
+
+	return ret;
 }
 
 struct nf_osf_hdr_ctx {
@@ -213,7 +208,7 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	if (!tcp)
 		return false;
 
-	ttl_check = (info->flags & NF_OSF_TTL) ? info->ttl : -1;
+	ttl_check = (info->flags & NF_OSF_TTL) ? info->ttl : 0;
 
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 
@@ -257,7 +252,8 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 EXPORT_SYMBOL_GPL(nf_osf_match);
 
 const char *nf_osf_find(const struct sk_buff *skb,
-			const struct list_head *nf_osf_fingers)
+			const struct list_head *nf_osf_fingers,
+			const int ttl_check)
 {
 	const struct iphdr *ip = ip_hdr(skb);
 	const struct nf_osf_user_finger *f;
@@ -275,7 +271,7 @@ const char *nf_osf_find(const struct sk_buff *skb,
 
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 		f = &kf->finger;
-		if (!nf_osf_match_one(skb, f, -1, &ctx))
+		if (!nf_osf_match_one(skb, f, ttl_check, &ctx))
 			continue;
 
 		genre = f->genre;
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index a35fb59ace73..0b452fd470c4 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -6,10 +6,12 @@
 
 struct nft_osf {
 	enum nft_registers	dreg:8;
+	u8			ttl;
 };
 
 static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
 	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
+	[NFTA_OSF_TTL]		= { .type = NLA_U8 },
 };
 
 static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
@@ -33,7 +35,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	os_name = nf_osf_find(skb, nf_osf_fingers);
+	os_name = nf_osf_find(skb, nf_osf_fingers, priv->ttl);
 	if (!os_name)
 		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
 	else
@@ -46,6 +48,14 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 {
 	struct nft_osf *priv = nft_expr_priv(expr);
 	int err;
+	u8 ttl;
+
+	if (nla_get_u8(tb[NFTA_OSF_TTL])) {
+		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
+		if (ttl > 2)
+			return -EINVAL;
+		priv->ttl = ttl;
+	}
 
 	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
 	err = nft_validate_register_store(ctx, priv->dreg, NULL,
@@ -60,6 +70,9 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_osf *priv = nft_expr_priv(expr);
 
+	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
+		goto nla_put_failure;
+
 	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
 		goto nla_put_failure;
 
-- 
2.11.0
