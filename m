From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next 2/2] nf_set_hooks_head: acommodate different kconfig
Date: Mon, 26 Sep 2016 12:24:31 -0400
Message-ID: <1474907071-13591-3-git-send-email-aconole@bytheb.org>
References: <1474907071-13591-1-git-send-email-aconole@bytheb.org>
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474907071-13591-1-git-send-email-aconole@bytheb.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When CONFIG_NETFILTER_INGRESS is unset (or no), we need to handle
the request for registration properly by dropping the hook.  This
releases the entry during the set.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/netfilter/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e58e420..1d0a4c9 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -90,10 +90,14 @@ static void nf_set_hooks_head(struct net *net, const struct nf_hook_ops *reg,
 {
 	switch (reg->pf) {
 	case NFPROTO_NETDEV:
+#ifdef CONFIG_NETFILTER_INGRESS
 		/* We already checked in nf_register_net_hook() that this is
 		 * used from ingress.
 		 */
 		rcu_assign_pointer(reg->dev->nf_hooks_ingress, entry);
+#else
+		kfree(entry);
+#endif
 		break;
 	default:
 		rcu_assign_pointer(net->nf.hooks[reg->pf][reg->hooknum],
-- 
2.5.5
