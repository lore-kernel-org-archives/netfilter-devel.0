From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] netfilter: nf_tables: remove VLA usage
Date: Mon, 12 Mar 2018 22:16:17 -0500
Message-ID: <20180313031617.GA2204@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In preparation to enabling -Wvla, remove VLA and replace it
with dynamic memory allocation.

>From a security viewpoint, the use of Variable Length Arrays can be
a vector for stack overflow attacks. Also, in general, as the code
evolves it is easy to lose track of how big a VLA can get. Thus, we
can end up having segfaults that are hard to debug.

Also, fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Use kmalloc_array instead of kcalloc.

 net/netfilter/nf_tables_api.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3f815b6..5a42e97 100644
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
2.7.4
