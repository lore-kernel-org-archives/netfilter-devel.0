From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/47] netfilter: nf_tables: remove VLA usage
Date: Fri, 30 Mar 2018 13:43:14 +0200
Message-ID: <20180330114334.18664-8-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

In preparation to enabling -Wvla, remove VLA and replace it
with dynamic memory allocation.

>From a security viewpoint, the use of Variable Length Arrays can be
a vector for stack overflow attacks. Also, in general, as the code
evolves it is easy to lose track of how big a VLA can get. Thus, we
can end up having segfaults that are hard to debug.

Also, fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8cc7fc970f0c..92f5606b0dea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4357,16 +4357,20 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 				       const struct nft_object_type *type,
 				       const struct nlattr *attr)
 {
-	struct nlattr *tb[type->maxattr + 1];
+	struct nlattr **tb;
 	const struct nft_object_ops *ops;
 	struct nft_object *obj;
-	int err;
+	int err = -ENOMEM;
+
+	tb = kmalloc_array(type->maxattr + 1, sizeof(*tb), GFP_KERNEL);
+	if (!tb)
+		goto err1;
 
 	if (attr) {
 		err = nla_parse_nested(tb, type->maxattr, attr, type->policy,
 				       NULL);
 		if (err < 0)
-			goto err1;
+			goto err2;
 	} else {
 		memset(tb, 0, sizeof(tb[0]) * (type->maxattr + 1));
 	}
@@ -4375,7 +4379,7 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 		ops = type->select_ops(ctx, (const struct nlattr * const *)tb);
 		if (IS_ERR(ops)) {
 			err = PTR_ERR(ops);
-			goto err1;
+			goto err2;
 		}
 	} else {
 		ops = type->ops;
@@ -4383,18 +4387,21 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 
 	err = -ENOMEM;
 	obj = kzalloc(sizeof(*obj) + ops->size, GFP_KERNEL);
-	if (obj == NULL)
-		goto err1;
+	if (!obj)
+		goto err2;
 
 	err = ops->init(ctx, (const struct nlattr * const *)tb, obj);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	obj->ops = ops;
 
+	kfree(tb);
 	return obj;
-err2:
+err3:
 	kfree(obj);
+err2:
+	kfree(tb);
 err1:
 	return ERR_PTR(err);
 }
-- 
2.11.0
