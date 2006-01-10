From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: net/ipv[46]/netfilter.c cleanups
Date: Tue, 10 Jan 2006 01:38:38 +0100
Message-ID: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following are a couple of netfilter fixes and cleanup patches. The first two
PPTP patches fix critical bugs, I'm going to push them to -stable as well.



[NETFILTER]: net/ipv[46]/netfilter.c cleanups

Don't wrap entire file in #ifdef CONFIG_NETFILTER, remove a few
unneccessary includes.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9d179ec0f5dc92411afd56e51010bbb57fa17b57
tree a99790588288e9d04ce1247d9fc64fa133b69eb8
parent 16e6d946e635f88097c2e9303b9fde04e3b6e754
author Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 07:48:28 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jan 2006 07:48:28 +0100

 include/linux/netfilter_ipv6.h |    5 +++++
 net/ipv4/Makefile              |    4 ++--
 net/ipv4/netfilter.c           |   10 ----------
 net/ipv6/Makefile              |    5 ++---
 net/ipv6/netfilter.c           |   19 ++-----------------
 5 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 53b2983..14f2bd0 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -72,7 +72,12 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_LAST = INT_MAX,
 };
 
+#ifdef CONFIG_NETFILTER
 extern int ipv6_netfilter_init(void);
 extern void ipv6_netfilter_fini(void);
+#else /* CONFIG_NETFILTER */
+static inline int ipv6_netfilter_init(void) { return 0; }
+static inline void ipv6_netfilter_fini(void) { return; }
+#endif /* CONFIG_NETFILTER */
 
 #endif /*__LINUX_IP6_NETFILTER_H*/
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index c54edd7..35e5f59 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -9,7 +9,7 @@ obj-y     := route.o inetpeer.o protocol
 	     tcp.o tcp_input.o tcp_output.o tcp_timer.o tcp_ipv4.o \
 	     tcp_minisocks.o tcp_cong.o \
 	     datagram.o raw.o udp.o arp.o icmp.o devinet.o af_inet.o igmp.o \
-	     sysctl_net_ipv4.o fib_frontend.o fib_semantics.o netfilter.o
+	     sysctl_net_ipv4.o fib_frontend.o fib_semantics.o
 
 obj-$(CONFIG_IP_FIB_HASH) += fib_hash.o
 obj-$(CONFIG_IP_FIB_TRIE) += fib_trie.o
@@ -28,7 +28,7 @@ obj-$(CONFIG_IP_ROUTE_MULTIPATH_RR) += m
 obj-$(CONFIG_IP_ROUTE_MULTIPATH_RANDOM) += multipath_random.o
 obj-$(CONFIG_IP_ROUTE_MULTIPATH_WRANDOM) += multipath_wrandom.o
 obj-$(CONFIG_IP_ROUTE_MULTIPATH_DRR) += multipath_drr.o
-obj-$(CONFIG_NETFILTER)	+= netfilter/
+obj-$(CONFIG_NETFILTER)	+= netfilter.o netfilter/
 obj-$(CONFIG_IP_VS) += ipvs/
 obj-$(CONFIG_INET_DIAG) += inet_diag.o 
 obj-$(CONFIG_IP_ROUTE_MULTIPATH_CACHED) += multipath.o
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 3321092..52a3d7c 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -1,16 +1,8 @@
 /* IPv4 specific functions of netfilter core */
-
-#include <linux/config.h>
-#ifdef CONFIG_NETFILTER
-
 #include <linux/kernel.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
-
 #include <linux/ip.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-#include <linux/icmp.h>
 #include <net/route.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
@@ -146,5 +138,3 @@ static void fini(void)
 
 module_init(init);
 module_exit(fini);
-
-#endif /* CONFIG_NETFILTER */
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 9601fd7..bf18cff 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -8,8 +8,7 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_ou
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o raw.o \
 		protocol.o icmp.o mcast.o reassembly.o tcp_ipv6.o \
 		exthdrs.o sysctl_net_ipv6.o datagram.o proc.o \
-		ip6_flowlabel.o ipv6_syms.o netfilter.o \
-		inet6_connection_sock.o
+		ip6_flowlabel.o ipv6_syms.o inet6_connection_sock.o
 
 ipv6-$(CONFIG_XFRM) += xfrm6_policy.o xfrm6_state.o xfrm6_input.o \
 	xfrm6_output.o
@@ -19,7 +18,7 @@ obj-$(CONFIG_INET6_AH) += ah6.o
 obj-$(CONFIG_INET6_ESP) += esp6.o
 obj-$(CONFIG_INET6_IPCOMP) += ipcomp6.o
 obj-$(CONFIG_INET6_TUNNEL) += xfrm6_tunnel.o 
-obj-$(CONFIG_NETFILTER)	+= netfilter/
+obj-$(CONFIG_NETFILTER)	+= netfilter.o netfilter/
 
 obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index b636783..1ab62f0 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -1,9 +1,5 @@
-#include <linux/config.h>
-#include <linux/init.h>
-
-#ifdef CONFIG_NETFILTER
-
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/ipv6.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
@@ -94,18 +90,7 @@ int __init ipv6_netfilter_init(void)
 	return nf_register_queue_rerouter(PF_INET6, &ip6_reroute);
 }
 
-void ipv6_netfilter_fini(void)
+void __exit ipv6_netfilter_fini(void)
 {
 	nf_unregister_queue_rerouter(PF_INET6);
 }
-
-#else /* CONFIG_NETFILTER */
-int __init ipv6_netfilter_init(void)
-{
-	return 0;
-}
-
-void ipv6_netfilter_fini(void)
-{
-}
-#endif /* CONFIG_NETFILTER */
