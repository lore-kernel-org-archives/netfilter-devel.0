From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: nf_ct_helper: Fix possible panic after nf_conntrack_helper_unregister
Date: Wed, 27 Jun 2018 17:22:20 +0200
Message-ID: <20180627152223.3633-4-pablo@netfilter.org>
References: <20180627152223.3633-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627152223.3633-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The helper module would be unloaded after nf_conntrack_helper_unregister,
so it may cause a possible panic caused by race.

nf_ct_iterate_destroy(unhelp, me) reset the helper of conntrack as NULL,
but maybe someone has gotten the helper pointer during this period. Then
it would panic, when it accesses the helper and the module was unloaded.

Take an example as following:
CPU0                                                   CPU1
ctnetlink_dump_helpinfo
helper = rcu_dereference(help->helper);
                                                       unhelp
                                                       set helper as NULL
                                                       unload helper module
helper->to_nlattr(skb, ct);

As above, the cpu0 tries to access the helper and its module is unloaded,
then the panic happens.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 551a1eddf0fa..a75b11c39312 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -465,6 +465,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
 	nf_ct_iterate_destroy(unhelp, me);
+
+	/* Maybe someone has gotten the helper already when unhelp above.
+	 * So need to wait it.
+	 */
+	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
-- 
2.11.0
