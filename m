Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AF535DA64;
	Fri,  2 Oct 2026 04:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790915226; cv=none; b=jrMOMmR8A+7VDvEu9HTaP2mKRTxw0TILJhR0rdEqUR/xMxWSB+vJrfSWmgwNeGjz4eDjgcdvS3L48I4deKHAlS9nrmEh9wW4uwvxGiUz0O8pEwZ+lQMHo3TJzvdx8x/jqqvkHtVqA3OXNc+ZMFNmaEEZWv7ETg9wKw3+a+Kv1Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790915226; c=relaxed/simple;
	bh=pQ2UtfeSkvovhxTM0sr3uRqSMrdi6pXbcu1lV7pG2WA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Do354OYhceUqmrOnMK+K8circsZ82hYM7+LiMq0sl3O2Y1i3UukCOagZ3SXAPTstliO7VqT2gqXrpnPuUAZ3TwEt+dEyxDfyEPxXlvVBzFQRImKpIwT5AE8l5K4zVNU13YyMM0CS/iZCnlv0fyVyjM+r+NO/dolQQrQKTWK3kJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kfoCy1du; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kfoCy1du"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790915209; bh=W6qyylexdfa0OADX/726jPQz9x3dbq6Ri+jM4lNuhtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfoCy1duE0DUSplRM2R5wxu9ljKJs6UVBL8DoEubtWFZUYmX8G4De9QKJ5y8azJfB
	 1qH1Rj6KXwZ8/NbNocl98aIQMFqD2CZWavRERZeDR4owQIY6mYvtfZ4iRbRJlUxdtk
	 MHZt2mlJRnjpaEOqF9Y74fSxlaE44ugcPGuTSTgA=
Received: from localhost.localdomain ([182.239.119.53])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 6579C811; Fri, 02 Oct 2026 12:25:23 +0800
X-QQ-mid: xmsmtpt1790915126t20z14akp
Message-ID: <tencent_B04828F60CC032BF011D6E603DACE7EBCC0A@qq.com>
X-QQ-XMAILINFO: MLY5ETzUs2WLr256sVDuDGRcVHwGKpr54ApTSPpOxDkB+1wJgb7oi7AblJG/BM
	 5DxuvRZV0biKVkmeYGqX8SzRFnIeanTdWQiixviZiqDmnNHuhTljHeOvhakE26aDX5zta5Mh60c6
	 MFd/qjOnSqzRVA7tXRbTfh6cB2sS9BM8b/EZoidMr7EiZDokd9sO8vPh3VJfUSgsg4P4PFUtu8uk
	 9sCvwsJprcoTzB/2oGwYenDxPb3naoYtWEpHtY8JWNjRRsvKNHoy88oVV5aXfJ1no6RkfJ0pvixG
	 HuxDnv5TbMbnQG9PGIPncEHhjv1a8ORG847JgTnkgPM7cgePKu17DmTxfrsaZuvrxnjCP0Iofbo3
	 deiM6WnzOiK+mZhh5cNVdkNAksyIM67cTNkxyocDW70f6W8jA8VT+L6liNq+ZBU9BEi5k9mvkZUq
	 TaQ72E1i3L+puFXHug7re+/ev983GS+Ice7BVq5C6t/Sxk02eup9IL/Mwk2hBlSlygqiFEQsz2NH
	 z9xu2Ldadz6yDsOw1Xas+e7uOWHPUJqzG3Sio0ZSfpLhCo7SmrvSr/E/Q+rkgNwfpUT/36I2cFSt
	 SekKUYd81B+yEmkU7bibmaZvXWR/cLRIv1yssxYuNH9MW7N2sxisAcufQrqrEXuT1HzAcmpp8+wn
	 O2fcZrqoLwaJsxesG6lH0WfU3iAoZmGo3GhxUeBx9SLuSrJk0CUdVo5oRuy2U1UGGO6Jl8QSPovr
	 GsBFq1cXreuyJUUHBtgyrtX9OIEyaoaOUn6btqU55+c9wokKTDas5HjlpxBt9DdJ4IGGo348Hl85
	 5wLc/a3HhRt5T8KcqKm1zYX901Ygy09BNwD3h+Ku8mGLWXrjuzJn2RofpAkeN15wkCIQRNSMKKwi
	 gShDui946gsjaaT9Jsp0SPoNq45MjeN1IGUayDoXwuX2dh4W6//J4+8ZJf6vUofuOBqky4Z6uxR0
	 KTl8Ms5e9FcbUHkaj7ZYDSuyb+lTlowiVWCun9e9g7/AkG097J57JBHrddEOjp3Zd/3IKtzrrDN5
	 7g7QCAqA7Y/eC6GwALhw7kE1ls+p5jNSkKN4uJ2w==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1 2/2] netfilter: nf_tables: support for adding new devices to an existing netdev chain
Date: Fri,  2 Oct 2026 12:25:09 +0800
X-OQ-MSGID: <20261002042509.711-2-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20261002042509.711-1-1564938642@qq.com>
References: <ar4d_JbuojZJuazs@chamomile>
 <20261002042509.711-1-1564938642@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch allows users to add devices to an existing netdev chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ma Xinmeng <1564938642@qq.com>

This is a 6.1 backport of upstream commit b9703ed44ffb, adapted to 6.1's
nft_chain_parse_hook() and nf_tables_chain_destroy() signatures.
---
 include/net/netfilter/nf_tables.h |   6 +
 net/netfilter/nf_tables_api.c     | 213 +++++++++++++++++++-----------
 2 files changed, 140 insertions(+), 79 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7e63281f2..e79d5f294 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1625,6 +1625,8 @@ struct nft_trans_chain {
 	u8				policy;
 	bool				bound;
 	u32				chain_id;
+	struct nft_base_chain		*basechain;
+	struct list_head		hook_list;
 };
 
 #define nft_trans_chain(trans)	\
@@ -1641,6 +1643,10 @@ struct nft_trans_chain {
 	(((struct nft_trans_chain *)trans->data)->bound)
 #define nft_trans_chain_id(trans)	\
 	(((struct nft_trans_chain *)trans->data)->chain_id)
+#define nft_trans_basechain(trans)	\
+	(((struct nft_trans_chain *)trans->data)->basechain)
+#define nft_trans_chain_hooks(trans)	\
+	(((struct nft_trans_chain *)trans->data)->hook_list)
 
 struct nft_trans_table {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 18aa388d5..df26de2eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1750,7 +1750,8 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 }
 
 static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
-				   const struct nft_base_chain *basechain)
+				   const struct nft_base_chain *basechain,
+				   const struct list_head *hook_list)
 {
 	const struct nf_hook_ops *ops = &basechain->ops;
 	struct nft_hook *hook, *first = NULL;
@@ -1767,7 +1768,11 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 
 	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
-		list_for_each_entry(hook, &basechain->hook_list, list) {
+
+		if (!hook_list)
+			hook_list = &basechain->hook_list;
+
+		list_for_each_entry(hook, hook_list, list) {
 			if (!first)
 				first = hook;
 
@@ -1792,7 +1797,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
-				     const struct nft_chain *chain)
+				     const struct nft_chain *chain,
+				     const struct list_head *hook_list)
 {
 	struct nlmsghdr *nlh;
 
@@ -1814,7 +1820,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, family, basechain))
+		if (nft_dump_basechain_hook(skb, family, basechain, hook_list))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
@@ -1849,7 +1855,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
+				   const struct list_head *hook_list)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
@@ -1869,7 +1876,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
 					event, flags, ctx->family, ctx->table,
-					ctx->chain);
+					ctx->chain, hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -1915,7 +1922,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 						      NFT_MSG_NEWCHAIN,
 						      NLM_F_MULTI,
 						      table->family, table,
-						      chain) < 0)
+						      chain, NULL) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -1969,7 +1976,7 @@ static int nf_tables_getchain(struct sk_buff *skb, const struct nfnl_info *info,
 
 	err = nf_tables_fill_chain_info(skb2, net, NETLINK_CB(skb).portid,
 					info->nlh->nlmsg_seq, NFT_MSG_NEWCHAIN,
-					0, family, table, chain);
+					0, family, table, chain, NULL);
 	if (err < 0)
 		goto err_fill_chain_info;
 
@@ -2207,6 +2214,7 @@ static int nft_chain_parse_netdev(struct net *net,
 }
 
 static int nft_chain_parse_hook(struct net *net,
+				struct nft_base_chain *basechain,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
 				struct netlink_ext_ack *extack, bool autoload,
@@ -2226,31 +2234,46 @@ static int nft_chain_parse_hook(struct net *net,
 	if (err < 0)
 		return err;
 
-	if (ha[NFTA_HOOK_HOOKNUM] == NULL ||
-	    ha[NFTA_HOOK_PRIORITY] == NULL)
-		return -EINVAL;
+	if (!basechain) {
+		if (!ha[NFTA_HOOK_HOOKNUM] ||
+		    !ha[NFTA_HOOK_PRIORITY])
+			return -EINVAL;
 
-	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
-	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
+		hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
+		hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
-	if (!type)
-		return -EOPNOTSUPP;
+		type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+		if (!type)
+			return -EOPNOTSUPP;
 
-	if (nla[NFTA_CHAIN_TYPE]) {
-		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
-						   family, autoload);
-		if (IS_ERR(type)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
-			return PTR_ERR(type);
+		if (nla[NFTA_CHAIN_TYPE]) {
+			type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
+							   family, autoload);
+			if (IS_ERR(type)) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
+				return PTR_ERR(type);
+			}
 		}
-	}
-	if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
-		return -EOPNOTSUPP;
+		if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
+			return -EOPNOTSUPP;
 
-	if (type->type == NFT_CHAIN_T_NAT &&
-	    hook->priority <= NF_IP_PRI_CONNTRACK)
-		return -EOPNOTSUPP;
+		if (type->type == NFT_CHAIN_T_NAT &&
+		    hook->priority <= NF_IP_PRI_CONNTRACK)
+			return -EOPNOTSUPP;
+	} else {
+		if (ha[NFTA_HOOK_HOOKNUM]) {
+			hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
+			if (hook->num != basechain->ops.hooknum)
+				return -EOPNOTSUPP;
+		}
+		if (ha[NFTA_HOOK_PRIORITY]) {
+			hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
+			if (hook->priority != basechain->ops.priority)
+				return -EOPNOTSUPP;
+		}
+
+		type = basechain->type;
+	}
 
 	if (!try_module_get(type->owner)) {
 		if (nla[NFTA_CHAIN_TYPE])
@@ -2348,12 +2371,8 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 		list_splice_init(&hook->list, &basechain->hook_list);
 		list_for_each_entry(h, &basechain->hook_list, list)
 			nft_basechain_hook_init(&h->ops, family, hook, chain);
-
-		basechain->ops.hooknum	= hook->num;
-		basechain->ops.priority	= hook->priority;
-	} else {
-		nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 	}
+	nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
@@ -2401,7 +2420,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_stats __percpu *stats = NULL;
-		struct nft_chain_hook hook;
+		struct nft_chain_hook hook = {};
 
 		if (table->flags & __NFT_TABLE_F_UPDATE)
 			return -EINVAL;
@@ -2409,7 +2428,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, nla, &hook, family, extack,
+		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, extack,
 					   true, flags);
 		if (err < 0)
 			return err;
@@ -2533,65 +2552,57 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	return err;
 }
 
-static bool nft_hook_list_equal(struct list_head *hook_list1,
-				struct list_head *hook_list2)
-{
-	struct nft_hook *hook;
-	int n = 0, m = 0;
-
-	n = 0;
-	list_for_each_entry(hook, hook_list2, list) {
-		if (!nft_hook_list_find(hook_list1, hook))
-			return false;
-
-		n++;
-	}
-	list_for_each_entry(hook, hook_list1, list)
-		m++;
-
-	return n == m;
-}
-
 static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			      u32 flags, const struct nlattr *attr,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_base_chain *basechain = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
-	struct nft_base_chain *basechain;
+	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
-	struct nft_chain_hook hook;
+	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
+	bool unregister = false;
 	int err;
 
 	if (chain->flags ^ flags)
 		return -EOPNOTSUPP;
 
+	INIT_LIST_HEAD(&hook.list);
+
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain)) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
-		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   extack, false, flags);
+
+		basechain = nft_base_chain(chain);
+		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
+					   ctx->family, extack, false, flags);
 		if (err < 0)
 			return err;
 
-		basechain = nft_base_chain(chain);
 		if (basechain->type != hook.type) {
 			nft_chain_release_hook(&hook);
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
 
-		if (nft_base_chain_netdev(ctx->family, hook.num)) {
-			if (!nft_hook_list_equal(&basechain->hook_list,
-						 &hook.list)) {
-				nft_chain_release_hook(&hook);
-				NL_SET_BAD_ATTR(extack, attr);
-				return -EEXIST;
+		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+			list_for_each_entry_safe(h, next, &hook.list, list) {
+				h->ops.pf	= basechain->ops.pf;
+				h->ops.hooknum	= basechain->ops.hooknum;
+				h->ops.priority	= basechain->ops.priority;
+				h->ops.priv	= basechain->ops.priv;
+				h->ops.hook	= basechain->ops.hook;
+
+				if (nft_hook_list_find(&basechain->hook_list, h)) {
+					list_del(&h->list);
+					kfree(h);
+				}
 			}
 		} else {
 			ops = &basechain->ops;
@@ -2602,7 +2613,6 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				return -EEXIST;
 			}
 		}
-		nft_chain_release_hook(&hook);
 	}
 
 	if (nla[NFTA_CHAIN_HANDLE] &&
@@ -2613,24 +2623,43 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					  nla[NFTA_CHAIN_NAME], genmask);
 		if (!IS_ERR(chain2)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
-			return -EEXIST;
+			err = -EEXIST;
+			goto err_hooks;
 		}
 	}
 
 	if (nla[NFTA_CHAIN_COUNTERS]) {
-		if (!nft_is_base_chain(chain))
-			return -EOPNOTSUPP;
+		if (!nft_is_base_chain(chain)) {
+			err = -EOPNOTSUPP;
+			goto err_hooks;
+		}
 
 		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats))
-			return PTR_ERR(stats);
+		if (IS_ERR(stats)) {
+			err = PTR_ERR(stats);
+			goto err_hooks;
+		}
 	}
 
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    nft_is_base_chain(chain) &&
+	    !list_empty(&hook.list)) {
+		basechain = nft_base_chain(chain);
+		ops = &basechain->ops;
+
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
+			err = nft_netdev_register_hooks(ctx->net, &hook.list);
+			if (err < 0)
+				goto err_hooks;
+		}
+	}
+
+	unregister = true;
 	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
 	if (trans == NULL)
-		goto err;
+		goto err_trans;
 
 	nft_trans_chain_stats(trans) = stats;
 	nft_trans_chain_update(trans) = true;
@@ -2649,7 +2678,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		err = -ENOMEM;
 		name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL_ACCOUNT);
 		if (!name)
-			goto err;
+			goto err_trans;
 
 		err = -EEXIST;
 		list_for_each_entry(tmp, &nft_net->commit_list, list) {
@@ -2660,18 +2689,35 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			    strcmp(name, nft_trans_chain_name(tmp)) == 0) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
 				kfree(name);
-				goto err;
+				goto err_trans;
 			}
 		}
 
 		nft_trans_chain_name(trans) = name;
 	}
+
+	nft_trans_basechain(trans) = basechain;
+	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
+	list_splice(&hook.list, &nft_trans_chain_hooks(trans));
+
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
-err:
+
+err_trans:
 	free_percpu(stats);
 	kfree(trans);
+err_hooks:
+	if (nla[NFTA_CHAIN_HOOK]) {
+		list_for_each_entry_safe(h, next, &hook.list, list) {
+			if (unregister)
+				nf_unregister_net_hook(ctx->net, &h->ops);
+			list_del(&h->list);
+			kfree_rcu(h, rcu);
+		}
+		module_put(hook.type->owner);
+	}
+
 	return err;
 }
 
@@ -9876,18 +9922,21 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(trans);
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
+						       &nft_trans_chain_hooks(trans));
+				list_splice(&nft_trans_chain_hooks(trans),
+					    &nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(trans);
 				nft_clear(net, trans->ctx.chain);
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
 			nft_chain_del(trans->ctx.chain);
-			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
+			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN, NULL);
 			nf_tables_unregister_hook(trans->ctx.net,
 						  trans->ctx.table,
 						  trans->ctx.chain);
@@ -10066,7 +10115,10 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(nft_trans_chain(trans));
+		if (nft_trans_chain_update(trans))
+			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+		else
+			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -10144,6 +10196,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
+				nft_netdev_unregister_hooks(net,
+							    &nft_trans_chain_hooks(trans),
+							    true);
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.43.0

