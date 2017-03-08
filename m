From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: provide nft_ctxc in object init function
Date: Wed,  8 Mar 2017 16:48:43 +0100
Message-ID: <20170308154844.18065-2-fw@strlen.de>
References: <20170308154844.18065-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37666 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753854AbdCHQR6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:17:58 -0500
In-Reply-To: <20170308154844.18065-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this is needed by the upcoming ct helper object type --
we'd like to be able use the table family (ip, ip6, inet) to figure
out which helper has to be requested.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 net/netfilter/nf_tables_api.c     | 7 ++++---
 net/netfilter/nft_counter.c       | 3 ++-
 net/netfilter/nft_quota.c         | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ac84686aaafb..9fdb6f560995 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1016,7 +1016,8 @@ struct nft_object_type {
 	unsigned int			maxattr;
 	struct module			*owner;
 	const struct nla_policy		*policy;
-	int				(*init)(const struct nlattr * const tb[],
+	int				(*init)(const struct nft_ctx *ctx,
+						const struct nlattr *const tb[],
 						struct nft_object *obj);
 	void				(*destroy)(struct nft_object *obj);
 	int				(*dump)(struct sk_buff *skb,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff7304ae58ac..2a34de1e2103 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4084,7 +4084,8 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 };
 
-static struct nft_object *nft_obj_init(const struct nft_object_type *type,
+static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
+				       const struct nft_object_type *type,
 				       const struct nlattr *attr)
 {
 	struct nlattr *tb[type->maxattr + 1];
@@ -4104,7 +4105,7 @@ static struct nft_object *nft_obj_init(const struct nft_object_type *type,
 	if (obj == NULL)
 		goto err1;
 
-	err = type->init((const struct nlattr * const *)tb, obj);
+	err = type->init(ctx, (const struct nlattr * const *)tb, obj);
 	if (err < 0)
 		goto err2;
 
@@ -4212,7 +4213,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-	obj = nft_obj_init(type, nla[NFTA_OBJ_DATA]);
+	obj = nft_obj_init(&ctx, type, nla[NFTA_OBJ_DATA]);
 	if (IS_ERR(obj)) {
 		err = PTR_ERR(obj);
 		goto err1;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 7f8422213341..67a710ebde09 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -82,7 +82,8 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	return 0;
 }
 
-static int nft_counter_obj_init(const struct nlattr * const tb[],
+static int nft_counter_obj_init(const struct nft_ctx *ctx,
+				const struct nlattr * const tb[],
 				struct nft_object *obj)
 {
 	struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 2d6fe3559912..25e33159be57 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -99,7 +99,8 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 	return 0;
 }
 
-static int nft_quota_obj_init(const struct nlattr * const tb[],
+static int nft_quota_obj_init(const struct nft_ctx *ctx,
+			      const struct nlattr * const tb[],
 			      struct nft_object *obj)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
-- 
2.10.2

