From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/47] netfilter: cttimeout: remove VLA usage
Date: Fri, 30 Mar 2018 13:43:12 +0200
Message-ID: <20180330114334.18664-6-pablo@netfilter.org>
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

While at it, remove likely() notation which is not necessary from the
control plane code.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 95b04702a655..9ee5fa551fa6 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -51,19 +51,27 @@ ctnl_timeout_parse_policy(void *timeouts,
 			  const struct nf_conntrack_l4proto *l4proto,
 			  struct net *net, const struct nlattr *attr)
 {
+	struct nlattr **tb;
 	int ret = 0;
 
-	if (likely(l4proto->ctnl_timeout.nlattr_to_obj)) {
-		struct nlattr *tb[l4proto->ctnl_timeout.nlattr_max+1];
+	if (!l4proto->ctnl_timeout.nlattr_to_obj)
+		return 0;
 
-		ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max,
-				       attr, l4proto->ctnl_timeout.nla_policy,
-				       NULL);
-		if (ret < 0)
-			return ret;
+	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
+		     GFP_KERNEL);
 
-		ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
-	}
+	if (!tb)
+		return -ENOMEM;
+
+	ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max, attr,
+			       l4proto->ctnl_timeout.nla_policy, NULL);
+	if (ret < 0)
+		goto err;
+
+	ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
+
+err:
+	kfree(tb);
 	return ret;
 }
 
-- 
2.11.0
