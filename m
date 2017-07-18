From: Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH nf] netfilter: ipt_CLUSTERIP: fix use-after-free of proc entry
Date: Tue, 18 Jul 2017 14:56:17 +0200
Message-ID: <dcf5953ca3d90bddf3b496d7bb86c9d30f7069f4.1500381553.git.sd@queasysnail.net>
Cc: Xin Long <lucien.xin@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751371AbdGRM4Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 08:56:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When we delete a netns with a CLUSTERIP rule, clusterip_net_exit() is
called first, removing /proc/net/ipt_CLUSTERIP.
Then clusterip_config_entry_put() is called from clusterip_tg_destroy(),
and tries to remove its entry under /proc/net/ipt_CLUSTERIP/.

Fix this by checking that the parent directory of the entry to remove
hasn't already been deleted.

The following triggers a KASAN splat (stealing the reproducer from
202f59afd441, thanks to Jianlin Shi and Xin Long):

    ip netns add test
    ip link add veth0_in type veth peer name veth0_out
    ip link set veth0_in netns test
    ip netns exec test ip link set lo up
    ip netns exec test ip link set veth0_in up
    ip netns exec test iptables -I INPUT -d 1.2.3.4 -i veth0_in -j     \
        CLUSTERIP --new --clustermac 89:d4:47:eb:9a:fa --total-nodes 3 \
        --local-node 1 --hashmode sourceip-sourceport
    ip netns del test

Fixes: ce4ff76c15a8 ("netfilter: ipt_CLUSTERIP: make proc directory per net namespace")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 7d72decb80f9..efaa04dcc80e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -117,7 +117,8 @@ clusterip_config_entry_put(struct net *net, struct clusterip_config *c)
 		 * functions are also incrementing the refcount on their own,
 		 * so it's safe to remove the entry even if it's in use. */
 #ifdef CONFIG_PROC_FS
-		proc_remove(c->pde);
+		if (cn->procdir)
+			proc_remove(c->pde);
 #endif
 		return;
 	}
@@ -815,6 +816,7 @@ static void clusterip_net_exit(struct net *net)
 #ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 	proc_remove(cn->procdir);
+	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
 }
-- 
2.13.2

