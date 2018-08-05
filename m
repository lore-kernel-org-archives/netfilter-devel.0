From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/21] netfilter: nf_osf: rename nf_osf.c to nfnetlink_osf.c
Date: Sun,  5 Aug 2018 23:21:24 +0200
Message-ID: <20180805212141.3033-5-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Rename nf_osf.c to nfnetlink_osf.c as we introduce nfnetlink_osf which is
the OSF infraestructure.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig                       | 15 ++++++++++-----
 net/netfilter/Makefile                      |  2 +-
 net/netfilter/{nf_osf.c => nfnetlink_osf.c} |  0
 3 files changed, 11 insertions(+), 6 deletions(-)
 rename net/netfilter/{nf_osf.c => nfnetlink_osf.c} (100%)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6f6c959aeb8f..85333431e524 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -46,6 +46,14 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
+config NETFILTER_NETLINK_OSF
+	tristate "Netfilter OSF over NFNETLINK interface"
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK
+	help
+	  If this option is enabled, the kernel will include support
+	  for passive OS fingerprint via NFNETLINK.
+
 config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
@@ -442,9 +450,6 @@ config NETFILTER_SYNPROXY
 
 endif # NF_CONNTRACK
 
-config NF_OSF
-	tristate
-
 config NF_TABLES
 	select NETFILTER_NETLINK
 	tristate "Netfilter nf_tables support"
@@ -1368,8 +1373,8 @@ config NETFILTER_XT_MATCH_NFACCT
 
 config NETFILTER_XT_MATCH_OSF
 	tristate '"osf" Passive OS fingerprint match'
-	depends on NETFILTER_ADVANCED && NETFILTER_NETLINK
-	select NF_OSF
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK_OSF
 	help
 	  This option selects the Passive OS Fingerprinting match module
 	  that allows to passively match the remote operating system by
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index dd26e4961f43..e684f9b8a9c3 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
+obj-$(CONFIG_NETFILTER_NETLINK_OSF) += nfnetlink_osf.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
@@ -108,7 +109,6 @@ obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_FIB)		+= nft_fib.o
 obj-$(CONFIG_NFT_FIB_INET)	+= nft_fib_inet.o
 obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
-obj-$(CONFIG_NF_OSF)		+= nf_osf.o
 obj-$(CONFIG_NFT_SOCKET)	+= nft_socket.o
 
 # nf_tables netdev
diff --git a/net/netfilter/nf_osf.c b/net/netfilter/nfnetlink_osf.c
similarity index 100%
rename from net/netfilter/nf_osf.c
rename to net/netfilter/nfnetlink_osf.c
-- 
2.11.0
