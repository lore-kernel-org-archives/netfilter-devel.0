From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 7/7] nf: use counter to manage ipv4 defragmentation on bridge
Date: Mon, 05 May 2014 16:56:36 +0400
Message-ID: <53678A84.5000202@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27657 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbaEEM6K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:58:10 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index f82685c..40cbd05 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -87,6 +87,20 @@ static unsigned int ipv4_conntrack_defrag(const struct nf_hook_ops *ops,
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(ops->hooknum, skb);
 
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4) && defined (CONFIG_BRIDGE_NETFILTER)
+		if ((user >= IP_DEFRAG_CONNTRACK_BRIDGE_IN) &&
+		    (user <= __IP_DEFRAG_CONNTRACK_BRIDGE_IN)) {
+			struct net *net = sock_net(skb->sk);
+
+			/* A bridge should not defragment and fragment packets. 
+			 * However if connection tracking is enabled or
+			 * if some target (TPROXY) or matches (socket) are used 
+			 * we enable ipv4 defragmentation on bridge
+			 */
+			if (atomic_read(&net->br_defrag_ipv4_users_count) == 0)
+				return NF_ACCEPT;
+		}
+#endif
 		if (nf_ct_ipv4_gather_frags(skb, user))
 			return NF_STOLEN;
 	}
-- 
1.7.5.4

