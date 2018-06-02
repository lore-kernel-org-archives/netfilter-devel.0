From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/20] netfilter: nat: merge ipv4/ipv6 masquerade code into main nat module
Date: Sat,  2 Jun 2018 02:22:41 +0200
Message-ID: <20180602002259.4024-3-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of using extra modules for these, turn the config options into
an implicit dependency that adds masq feature to the protocol specific nf_nat module.

before:
   text    data     bss     dec     hex filename
   2001     860       4    2865     b31 net/ipv4/netfilter/nf_nat_masquerade_ipv4.ko
   5579     780       2    6361    18d9 net/ipv4/netfilter/nf_nat_ipv4.ko
   2860     836       8    3704     e78 net/ipv6/netfilter/nf_nat_masquerade_ipv6.ko
   6648     780       2    7430    1d06 net/ipv6/netfilter/nf_nat_ipv6.ko

after:
   text    data     bss     dec     hex filename
   7245     872       8    8125    1fbd net/ipv4/netfilter/nf_nat_ipv4.ko
   9165     848      12   10025    2729 net/ipv6/netfilter/nf_nat_ipv6.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig                  | 5 +----
 net/ipv4/netfilter/Makefile                 | 4 +---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 4 ----
 net/ipv6/netfilter/Kconfig                  | 5 +----
 net/ipv6/netfilter/Makefile                 | 2 +-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 4 ----
 6 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 280048e1e395..d03bc5a01a70 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -129,10 +129,7 @@ config NFT_CHAIN_NAT_IPV4
 	  source and destination ports.
 
 config NF_NAT_MASQUERADE_IPV4
-	tristate "IPv4 masquerade support"
-	help
-	  This is the kernel functionality to provide NAT in the masquerade
-	  flavour (automatic source address selection).
+	bool
 
 config NFT_MASQ_IPV4
 	tristate "IPv4 masquerading support for nf_tables"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 0e5edd0c7926..c4b05b174091 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -10,6 +10,7 @@ nf_conntrack_ipv4-y	:=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
 obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
 
 nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o nf_nat_proto_icmp.o
+nf_nat_ipv4-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
 
 # defrag
@@ -32,9 +33,6 @@ nf_nat_snmp_basic-y := nf_nat_snmp_basic.asn1.o nf_nat_snmp_basic_main.o
 $(obj)/nf_nat_snmp_basic_main.o: $(obj)/nf_nat_snmp_basic.asn1.h
 obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 
-obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
-
-
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index f538c5001547..ad3aeff152ed 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/atomic.h>
 #include <linux/inetdevice.h>
 #include <linux/ip.h>
@@ -157,6 +156,3 @@ void nf_nat_masquerade_ipv4_unregister_notifier(void)
 	unregister_inetaddr_notifier(&masq_inet_notifier);
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_unregister_notifier);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index ce77bcc2490c..9f5b00a39adf 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -136,10 +136,7 @@ config NF_NAT_IPV6
 if NF_NAT_IPV6
 
 config NF_NAT_MASQUERADE_IPV6
-	tristate "IPv6 masquerade support"
-	help
-	  This is the kernel functionality to provide NAT in the masquerade
-	  flavour (automatic source address selection) for IPv6.
+	bool
 
 endif # NF_NAT_IPV6
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 44273d6f03a5..71518f22ae39 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -18,8 +18,8 @@ nf_conntrack_ipv6-y  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
 
 nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o nf_nat_proto_icmpv6.o
+nf_nat_ipv6-$(CONFIG_NF_NAT_MASQUERADE_IPV6) += nf_nat_masquerade_ipv6.o
 obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
-obj-$(CONFIG_NF_NAT_MASQUERADE_IPV6) += nf_nat_masquerade_ipv6.o
 
 # defrag
 nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 9dfc2b90c362..e6eb7cf9b54f 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/atomic.h>
 #include <linux/netdevice.h>
 #include <linux/ipv6.h>
@@ -186,6 +185,3 @@ void nf_nat_masquerade_ipv6_unregister_notifier(void)
 	unregister_netdevice_notifier(&masq_dev_notifier);
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_unregister_notifier);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-- 
2.11.0
