From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] ipvs: fix dependency on nf_defrag_ipv6
Date: Wed, 13 Feb 2019 18:47:57 +0100
Message-ID: <20190213174758.17275-3-pablo@netfilter.org>
References: <20190213174758.17275-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213174758.17275-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

ipvs relies on nf_defrag_ipv6 module to manage IPv6 fragmentation,
but lacks proper Kconfig dependencies and does not explicitly
request defrag features.

As a result, if netfilter hooks are not loaded, when IPv6 fragmented
packet are handled by ipvs only the first fragment makes through.

Fix it properly declaring the dependency on Kconfig and registering
netfilter hooks on ip_vs_add_service() and ip_vs_new_dest().

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/Kconfig      |  1 +
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++------
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 ++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index cad48d07c818..8401cefd9f65 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -29,6 +29,7 @@ config	IP_VS_IPV6
 	bool "IPv6 support for IPVS"
 	depends on IPV6 = y || IP_VS = IPV6
 	select IP6_NF_IPTABLES
+	select NF_DEFRAG_IPV6
 	---help---
 	  Add IPv6 support to IPVS.
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fe9abf3cc10a..235205c93e14 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1536,14 +1536,12 @@ ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		/* sorry, all this trouble for a no-hit :) */
 		IP_VS_DBG_PKT(12, af, pp, skb, iph->off,
 			      "ip_vs_in: packet continues traversal as normal");
-		if (iph->fragoffs) {
-			/* Fragment that couldn't be mapped to a conn entry
-			 * is missing module nf_defrag_ipv6
-			 */
-			IP_VS_DBG_RL("Unhandled frag, load nf_defrag_ipv6\n");
+
+		/* Fragment couldn't be mapped to a conn entry */
+		if (iph->fragoffs)
 			IP_VS_DBG_PKT(7, af, pp, skb, iph->off,
 				      "unhandled fragment");
-		}
+
 		*verdict = NF_ACCEPT;
 		return 0;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7d6318664eb2..86afacb07e5f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -43,6 +43,7 @@
 #ifdef CONFIG_IP_VS_IPV6
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #endif
 #include <net/route.h>
 #include <net/sock.h>
@@ -895,6 +896,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
+	int ret = 0;
 
 	EnterFunction(2);
 
@@ -905,6 +907,10 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 			atype & IPV6_ADDR_LINKLOCAL) &&
 			!__ip_vs_addr_is_local_v6(svc->ipvs->net, &udest->addr.in6))
 			return -EINVAL;
+
+		ret = nf_defrag_ipv6_enable(svc->ipvs->net);
+		if (ret)
+			return ret;
 	} else
 #endif
 	{
@@ -1228,6 +1234,10 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 			ret = -EINVAL;
 			goto out_err;
 		}
+
+		ret = nf_defrag_ipv6_enable(ipvs->net);
+		if (ret)
+			goto out_err;
 	}
 #endif
 
-- 
2.11.0
