From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 2/2] netfilter: nf_defrag: move NF_CONNTRACK bits into #ifdef
Date: Mon, 15 Jan 2018 16:49:06 +0100
Message-ID: <20180115154918.4176669-2-arnd@arndb.de>
References: <20180115154918.4176669-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:54898 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934920AbeAOPt6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 10:49:58 -0500
In-Reply-To: <20180115154918.4176669-1-arnd@arndb.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---
Please double-check what the right behavior for !CONFIG_NF_CONNTRACK
should be, I was only guessing here.
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
2.9.0

