Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD23F105D
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787863704; cv=none; b=c1dbKpCo2cZZjlEzHdB2/AlXgtypTuM7hfHooCnEf7/jdeuK9l3Sc8YQqTuXWbPDT1xvedoO9Jfv8OboxaQ+tK9pmE6X4cVq3Iqgoui82wehmoIf8QpqF+wG/pQHU/a8iRLl6pfdeIE+sQRwgW4ivymXXlPs9xxqhpjx6K+r9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787863704; c=relaxed/simple;
	bh=lKanhkh+VS3KM2vuuh8Y4xkUrSJ7TNraZs7MU/GHvSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nsP0B8YbiEWAYcHUJxb+7U0N203QEyCBQNAuwOkUOJnWA04Uxi4EnUYyYqO8K95m6oPA0R41dEmSfN/5lLjGkgwg8yCHh/jUkNOqeFDr4ZlthOo4RlTOzluyEgMQirXxATvU5eKvmf+91cyAUzYXli9LeS9NxfzS1nAJ6oRVT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nlPGcTFx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nlPGcTFx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KPopY9bneivA+3OCj84p//mRC/eODZDG7m9weyh5xzc=; b=nlPGcTFxkFCi0C8yW9V/P4nGIA
	xknO7Dw6t7hjxPgaH9KI854n+hOjd9WV02pfJ+9qaH6kKWLg9gjsPN9aMuwicH0fTX/8wp/5xVR/d
	lwSxedHc1uFQssYgqzffitMdrpIwFk7GQNNsn0HfrWgaP7CZYbMbS5LlvVKD702ZA5QcNsfwkkqQC
	AZhtoApAmhS6d9k+/S5jMkpMAC1Q906urLhdCKVClaFfITKoDbLkaFFHEUMJ3/oY+sUas9uBEpFLR
	wtUTy6hGB6VHliB4QiW2X1nxpSNwp+3qBh6FFxNI3Ikumxs5gpeJlZzaQOfgUzAQ4C0/xyrUZm5Ah
	1Ftn+xCQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzh1I-0000000010X-1daq;
	Thu, 27 Aug 2026 22:48:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [nf PATCH] netfilter: nf_tables: Fix netdev hook sanity checks
Date: Thu, 27 Aug 2026 22:48:15 +0200
Message-ID: <20260827204815.275949-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wildcard interface names were confused with non-wildcard ones or those
matching the wildcard's prefix. Fix for odd behaviour when updating
flowtable or netdev chain hook devices.

Unify behaviour between flowtable and netdev chain parsers by having
both call the same parsing/validating code, also with old NFTA_HOOK_DEV
attribute (which is still used for single hook updates by user space).

The validating code must distinguish between hooks being added or
deleted (duplicates are ignored in the former case). Transport this info
in a 'bool add' parameter, but rename the existing one with same name
first since that actually reflects whether the code is parsing hooks for
a new object or an existing one.

Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This is a follow-up to Fernando's "netfilter: nf_tables: fix device name
and prefix match in hook lookup", sorting odd behaviour in similar,
other cases, too. With his v4 and this patch in place, the new nftables
shell tests pass for me.
---
 net/netfilter/nf_tables_api.c | 102 +++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 500ef483e485..8fac88f07d74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2450,10 +2450,44 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	return NULL;
 }
 
+static struct nft_hook *
+nf_tables_parse_netdev_hook(struct net *net,
+			    const struct nlattr *tmp,
+			    struct list_head *hook_list,
+			    struct list_head *old_hook_list,
+			    bool prefix, bool add)
+{
+	struct nft_hook *hook;
+
+	hook = nft_netdev_hook_alloc(net, tmp, prefix);
+	if (IS_ERR(hook))
+		return hook;
+
+	/* Reject new hooks which overlap */
+	if (nft_hook_list_find(hook_list, hook, false)) {
+		nft_netdev_hook_free(hook);
+		return ERR_PTR(-EEXIST);
+	}
+	/* Skip this exact duplicate when adding */
+	if (nft_hook_list_find(old_hook_list, hook, true)) {
+		if (add) {
+			nft_netdev_hook_free(hook);
+			return NULL;
+		}
+	/* Reject partial overlaps in either case */
+	} else if (nft_hook_list_find(old_hook_list, hook, false)) {
+		nft_netdev_hook_free(hook);
+		return ERR_PTR(add ? -EEXIST : -ENOENT);
+	}
+	return hook;
+}
+
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
 					struct list_head *hook_list,
-					struct netlink_ext_ack *extack)
+					struct list_head *old_hook_list,
+					struct netlink_ext_ack *extack,
+					bool add)
 {
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
@@ -2473,18 +2507,17 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			goto err_hook;
 		}
 
-		hook = nft_netdev_hook_alloc(net, tmp, prefix);
+		hook = nf_tables_parse_netdev_hook(net, tmp, hook_list,
+						   old_hook_list, prefix, add);
+		if (!hook)
+			continue;
+
 		if (IS_ERR(hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
-		if (nft_hook_list_find(hook_list, hook, false)) {
-			NL_SET_BAD_ATTR(extack, tmp);
-			nft_netdev_hook_free(hook);
-			err = -EEXIST;
-			goto err_hook;
-		}
+
 		list_add_tail(&hook->list, hook_list);
 		n++;
 
@@ -2513,13 +2546,17 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 				  struct list_head *hook_list,
-				  struct netlink_ext_ack *extack, u32 flags)
+				  struct list_head *old_hook_list,
+				  struct netlink_ext_ack *extack, u32 flags,
+				  bool add)
 {
 	struct nft_hook *hook;
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
-		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV], false);
+		hook = nf_tables_parse_netdev_hook(net, tb[NFTA_HOOK_DEV],
+						   hook_list, old_hook_list,
+						   false, false);
 		if (IS_ERR(hook)) {
 			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
@@ -2528,7 +2565,8 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 		list_add_tail(&hook->list, hook_list);
 	} else if (tb[NFTA_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
-						   hook_list, extack);
+						   hook_list, old_hook_list,
+						   extack, add);
 		if (err < 0)
 			return err;
 
@@ -2544,8 +2582,10 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 static int nft_chain_parse_hook(struct net *net,
 				struct nft_base_chain *basechain,
 				const struct nlattr * const nla[],
-				struct nft_chain_hook *hook, u8 family,
-				u32 flags, struct netlink_ext_ack *extack)
+				struct nft_chain_hook *hook,
+				struct list_head *old_hook_list, u8 family,
+				u32 flags, struct netlink_ext_ack *extack,
+				bool add)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -2623,7 +2663,8 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
+		err = nft_chain_parse_netdev(net, ha, &hook->list,
+					     old_hook_list, extack, flags, add);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -2756,6 +2797,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook = {};
+		LIST_HEAD(empty);
 
 		if (table->flags & __NFT_TABLE_F_UPDATE)
 			return -EINVAL;
@@ -2763,8 +2805,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, flags,
-					   extack);
+		err = nft_chain_parse_hook(net, NULL, nla, &hook, &empty,
+					   family, flags, extack, true);
 		if (err < 0)
 			return err;
 
@@ -2916,7 +2958,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		basechain = nft_base_chain(chain);
 		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
-					   ctx->family, flags, extack);
+					   &basechain->hook_list,
+					   ctx->family, flags, extack, true);
 		if (err < 0)
 			return err;
 
@@ -2936,7 +2979,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					ops->hook	= basechain->ops.hook;
 				}
 
-				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
+				if (nft_hook_list_find(&basechain->hook_list, h, true)) {
 					list_del(&h->list);
 					nft_netdev_hook_free(h);
 					continue;
@@ -3246,7 +3289,8 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
-				   ctx->family, chain->flags, extack);
+				   &basechain->hook_list, ctx->family,
+				   chain->flags, extack, false);
 	if (err < 0)
 		return err;
 
@@ -8866,7 +8910,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    const struct nlattr * const nla[],
 				    struct nft_flowtable_hook *flowtable_hook,
 				    struct nft_flowtable *flowtable,
-				    struct netlink_ext_ack *extack, bool add)
+				    struct netlink_ext_ack *extack,
+				    bool new, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nf_hook_ops *ops;
@@ -8882,7 +8927,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (add) {
+	if (new) {
 		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
 		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
@@ -8918,7 +8963,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 		err = nf_tables_parse_netdev_hooks(ctx->net,
 						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
 						   &flowtable_hook->list,
-						   extack);
+						   &flowtable->hook_list,
+						   extack, add);
 		if (err < 0)
 			return err;
 	}
@@ -9112,17 +9158,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
-				       extack, false);
+				       extack, false, true);
 	if (err < 0)
 		return err;
 
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
-			list_del(&hook->list);
-			nft_netdev_hook_free(hook);
-			continue;
-		}
-
 		nft_net = nft_pernet(ctx->net);
 		list_for_each_entry(trans, &nft_net->commit_list, list) {
 			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
@@ -9279,7 +9319,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err3;
 
 	err = nft_flowtable_parse_hook(&ctx, nla, &flowtable_hook, flowtable,
-				       extack, true);
+				       extack, true, true);
 	if (err < 0)
 		goto err_flowtable_parse_hooks;
 
@@ -9345,7 +9385,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
-				       extack, false);
+				       extack, false, false);
 	if (err < 0)
 		return err;
 
-- 
2.54.0

