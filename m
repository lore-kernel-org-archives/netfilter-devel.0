From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: avoid erronous array bounds warning
Date: Tue,  2 Oct 2018 00:37:44 +0200
Message-ID: <20181001223745.29010-6-pablo@netfilter.org>
References: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001223745.29010-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Unfortunately some versions of gcc emit following warning:
  $ make net/xfrm/xfrm_output.o
  linux/compiler.h:252:20: warning: array subscript is above array bounds [-Warray-bounds]
  hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
                            ^~~~~~~~~~~~~~~~~~~~~
xfrm_output_resume passes skb_dst(skb)->ops->family as its 'pf' arg so compiler
can't know that we'll never access hooks_arp[].
(NFPROTO_IPV4 or NFPROTO_IPV6 are only possible cases).

Avoid this by adding an explicit WARN_ON_ONCE() check.

This patch has no effect if the family is a compile-time constant as gcc
will remove the switch() construct entirely.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 07efffd0c759..bbe99d2b28b4 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -215,6 +215,8 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 		break;
 	case NFPROTO_ARP:
 #ifdef CONFIG_NETFILTER_FAMILY_ARP
+		if (WARN_ON_ONCE(hook >= ARRAY_SIZE(net->nf.hooks_arp)))
+			break;
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 #endif
 		break;
-- 
2.11.0
