From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/47] netfilter: nfnetlink_cthelper: Remove VLA usage
Date: Fri, 30 Mar 2018 13:43:13 +0200
Message-ID: <20180330114334.18664-7-pablo@netfilter.org>
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
 net/netfilter/nfnetlink_cthelper.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d33ce6d5ebce..4a4b293fb2e5 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -314,23 +314,30 @@ nfnl_cthelper_update_policy_one(const struct nf_conntrack_expect_policy *policy,
 static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 					   struct nf_conntrack_helper *helper)
 {
-	struct nf_conntrack_expect_policy new_policy[helper->expect_class_max + 1];
+	struct nf_conntrack_expect_policy *new_policy;
 	struct nf_conntrack_expect_policy *policy;
-	int i, err;
+	int i, ret = 0;
+
+	new_policy = kmalloc_array(helper->expect_class_max + 1,
+				   sizeof(*new_policy), GFP_KERNEL);
+	if (!new_policy)
+		return -ENOMEM;
 
 	/* Check first that all policy attributes are well-formed, so we don't
 	 * leave things in inconsistent state on errors.
 	 */
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 
-		if (!tb[NFCTH_POLICY_SET + i])
-			return -EINVAL;
+		if (!tb[NFCTH_POLICY_SET + i]) {
+			ret = -EINVAL;
+			goto err;
+		}
 
-		err = nfnl_cthelper_update_policy_one(&helper->expect_policy[i],
+		ret = nfnl_cthelper_update_policy_one(&helper->expect_policy[i],
 						      &new_policy[i],
 						      tb[NFCTH_POLICY_SET + i]);
-		if (err < 0)
-			return err;
+		if (ret < 0)
+			goto err;
 	}
 	/* Now we can safely update them. */
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
@@ -340,7 +347,9 @@ static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 		policy->timeout	= new_policy->timeout;
 	}
 
-	return 0;
+err:
+	kfree(new_policy);
+	return ret;
 }
 
 static int nfnl_cthelper_update_policy(struct nf_conntrack_helper *helper,
-- 
2.11.0
