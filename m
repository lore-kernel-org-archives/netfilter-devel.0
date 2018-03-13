From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] netfilter: nfnetlink_cthelper: Remove VLA usage
Date: Mon, 12 Mar 2018 19:21:38 -0500
Message-ID: <20180313002138.GA27280@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
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
 net/netfilter/nfnetlink_cthelper.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d33ce6d..4a4b293 100644
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
2.7.4
