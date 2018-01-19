From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/32] netfilter: nf_defrag: move NF_CONNTRACK bits into #ifdef
Date: Fri, 19 Jan 2018 20:10:30 +0100
Message-ID: <20180119191041.25804-22-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

We cannot access the skb->_nfct field when CONFIG_NF_CONNTRACK is
disabled:

net/ipv4/netfilter/nf_defrag_ipv4.c: In function 'ipv4_conntrack_defrag':
net/ipv4/netfilter/nf_defrag_ipv4.c:83:9: error: 'struct sk_buff' has no member named '_nfct'
net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'ipv6_defrag':
net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:68:9: error: 'struct sk_buff' has no member named '_nfct'

Both functions already have an #ifdef for this, so let's move the
check in there.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c       | 4 +++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index cbd987f6b1f8..a0d3ad60a411 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -78,9 +78,11 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 	if (skb_nfct(skb) && !nf_ct_is_template((struct nf_conn *)skb_nfct(skb)))
 		return NF_ACCEPT;
 #endif
+	if (skb->_nfct == IP_CT_UNTRACKED)
+		return NF_ACCEPT;
 #endif
 	/* Gather fragments. */
-	if (skb->_nfct != IP_CT_UNTRACKED && ip_is_fragment(ip_hdr(skb))) {
+	if (ip_is_fragment(ip_hdr(skb))) {
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(state->hook, skb);
 
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 87b503a8f5ef..c87b48359e8f 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -63,10 +63,10 @@ static unsigned int ipv6_defrag(void *priv,
 	/* Previously seen (loopback)?	*/
 	if (skb_nfct(skb) && !nf_ct_is_template((struct nf_conn *)skb_nfct(skb)))
 		return NF_ACCEPT;
-#endif
 
 	if (skb->_nfct == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
+#endif
 
 	err = nf_ct_frag6_gather(state->net, skb,
 				 nf_ct6_defrag_user(state->hook, skb));
-- 
2.11.0
