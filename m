From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/21] netfilter: conntrack: avoid use-after free on rmmod
Date: Sun,  5 Aug 2018 23:21:40 +0200
Message-ID: <20180805212141.3033-21-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When the conntrack module is removed, we call nf_ct_iterate_destroy via
nf_ct_l4proto_unregister().

Problem is that nf_conntrack_proto_fini() gets called after the
conntrack hash table has already been freed.

Just remove the l4proto unregister call, its unecessary as the
nf_ct_protos[] array gets free'd right after anyway.

v2: add comment wrt. missing unreg call.

Fixes: a0ae2562c6c4b2 ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 803607a90102..30070732ee50 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -940,14 +940,13 @@ void nf_conntrack_proto_fini(void)
 {
 	unsigned int i;
 
-	nf_ct_l4proto_unregister(builtin_l4proto,
-				 ARRAY_SIZE(builtin_l4proto));
 	nf_unregister_sockopt(&so_getorigdst);
 #if IS_ENABLED(CONFIG_IPV6)
 	nf_unregister_sockopt(&so_getorigdst6);
 #endif
-
-	/* free l3proto protocol tables */
+	/* No need to call nf_ct_l4proto_unregister(), the register
+	 * tables are free'd here anyway.
+	 */
 	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
 		kfree(nf_ct_protos[i]);
 }
-- 
2.11.0
