From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/20] netfilter: nat: merge nf_nat_redirect into nf_nat
Date: Sat,  2 Jun 2018 02:22:42 +0200
Message-ID: <20180602002259.4024-4-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to previous patch, this time, merge redirect+nat.
The redirect module is just 2k in size, get rid of it and make
redirect part available from the nat core.

before:
   text    data     bss     dec     hex filename
  19461    1484    4138   25083    61fb net/netfilter/nf_nat.ko
   1236     792       0    2028     7ec net/netfilter/nf_nat_redirect.ko
after:
  20340    1508    4138   25986    6582 net/netfilter/nf_nat.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig           | 6 +-----
 net/netfilter/Makefile          | 2 +-
 net/netfilter/nf_nat_redirect.c | 4 ----
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a5b60e6a983e..3ec8886850b2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -433,11 +433,7 @@ config NF_NAT_TFTP
 	default NF_NAT && NF_CONNTRACK_TFTP
 
 config NF_NAT_REDIRECT
-        tristate "IPv4/IPv6 redirect support"
-	depends on NF_NAT
-        help
-          This is the kernel functionality to redirect packets to local
-          machine through NAT.
+	bool
 
 config NETFILTER_SYNPROXY
 	tristate
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1aa710b5d384..9b3434360d49 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -55,7 +55,7 @@ obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
 obj-$(CONFIG_NF_LOG_NETDEV) += nf_log_netdev.o
 
 obj-$(CONFIG_NF_NAT) += nf_nat.o
-obj-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
+nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 
 # NAT helpers
 obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 7c4bb0a773ca..adee04af8d43 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -15,7 +15,6 @@
 #include <linux/inetdevice.h>
 #include <linux/ip.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/netfilter.h>
 #include <linux/types.h>
@@ -124,6 +123,3 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_DST);
 }
 EXPORT_SYMBOL_GPL(nf_nat_redirect_ipv6);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-- 
2.11.0
