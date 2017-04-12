From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next] nf_conntrack: remove double assignment
Date: Wed, 12 Apr 2017 16:32:54 -0400
Message-ID: <20170412203254.14625-1-aconole@bytheb.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The protonet pointer will unconditionally be rewritten, so just do the
needed assignment first.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/netfilter/nf_conntrack_proto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 2d6ee18..e6d2945 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -441,9 +441,8 @@ EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister_one);
 void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 					 struct nf_conntrack_l4proto *l4proto)
 {
-	struct nf_proto_net *pn = NULL;
+	struct nf_proto_net *pn = nf_ct_l4proto_net(net, l4proto);
 
-	pn = nf_ct_l4proto_net(net, l4proto);
 	if (pn == NULL)
 		return;
 
-- 
2.9.3
