Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A22627EE
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 12:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706532978; cv=none; b=URSd8HG1TJT5sSKD6ICYPiILQp0FcHbK/BeUMjJ1fT1t/oPdqJHDUgW7XKGAUbgjpTrj/nG79wTciC18XbJfcZpnFy8lm7LJpCHLPPazPF1wJSeqd+XipjXoI2GBbWzH4raaj6vB6akytcPbnikFM4yYErkNL38s5PWvqk8bBE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706532978; c=relaxed/simple;
	bh=RF54Bc0I5g7ZCJ+C8uS1Mloyhjahm0+3u7b4HWIa2ik=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=JCYKkwWb9l2giHOo92Rkb2Zhaif5cCh8KgrJh5fnHPG3owgWHhGkmLfQq6K8LuKTFgCSTCwI07kDlHzJsYAGZoq9nbQV1whJg3rWmVW9dwKgcXbIVQMwsU57ohv5zdzbAx6lHWu7MNUpqUdUT2CQxVOxjMsEkGJaTIfr1uQJik0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
Date: Mon, 29 Jan 2024 13:56:09 +0100
Message-Id: <20240129125609.196895-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bail out on using the tunnel dst template from other than netdev family.
Add the infrastructure to check for the family in objects.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 12 ++++++++----
 net/netfilter/nft_tunnel.c        |  1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4e1ea18eb5f0..001226c34621 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1351,6 +1351,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
  *	@type: stateful object numeric type
  *	@owner: module owner
  *	@maxattr: maximum netlink attribute
+ *	@family: address family for AF-specific object types
  *	@policy: netlink attribute policy
  */
 struct nft_object_type {
@@ -1360,6 +1361,7 @@ struct nft_object_type {
 	struct list_head		list;
 	u32				type;
 	unsigned int                    maxattr;
+	u8				family;
 	struct module			*owner;
 	const struct nla_policy		*policy;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c537104411e7..2d08d1360511 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7551,11 +7551,15 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
 	return -1;
 }
 
-static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
+static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
 	list_for_each_entry(type, &nf_tables_objects, list) {
+		if (type->family != NFPROTO_UNSPEC &&
+		    type->family != family)
+			continue;
+
 		if (objtype == type->type)
 			return type;
 	}
@@ -7563,11 +7567,11 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
 }
 
 static const struct nft_object_type *
-nft_obj_type_get(struct net *net, u32 objtype)
+nft_obj_type_get(struct net *net, u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
-	type = __nft_obj_type_get(objtype);
+	type = __nft_obj_type_get(objtype, family);
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
@@ -7674,7 +7678,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nft_use_inc(&table->use))
 		return -EMFILE;
 
-	type = nft_obj_type_get(net, objtype);
+	type = nft_obj_type_get(net, objtype, family);
 	if (IS_ERR(type)) {
 		err = PTR_ERR(type);
 		goto err_type;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 9f21953c7433..f735d79d8be5 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -713,6 +713,7 @@ static const struct nft_object_ops nft_tunnel_obj_ops = {
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
 	.type		= NFT_OBJECT_TUNNEL,
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_obj_ops,
 	.maxattr	= NFTA_TUNNEL_KEY_MAX,
 	.policy		= nft_tunnel_key_policy,
-- 
2.30.2

