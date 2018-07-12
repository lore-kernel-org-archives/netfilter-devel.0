From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: fix IPV6=m CONNTRACK=y link failure
Date: Thu, 12 Jul 2018 16:35:47 +0200
Message-ID: <20180712143547.2194-2-fw@strlen.de>
References: <20180712143547.2194-1-fw@strlen.de>
Cc: <netdev@vger.kernel.org>, arnd@arndb.de,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180712143547.2194-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

IPV6=m
DEFRAG_IPV6=m
CONNTRACK=y yields:

net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
net/netfilter/nf_conntrack_proto.c:802: undefined reference to `nf_defrag_ipv6_enable'
net/netfilter/nf_conntrack_proto.o:(.rodata+0x640): undefined reference to `nf_conntrack_l4proto_icmpv6'

After previous patch, DEFRAG_IPV6 and IPV6 are no longer retain any
dependencies, so we can tell Kconfig DEFRAG_IPV6 needs to be built-in as
well, this resolves missing nf_defrag_ipv6_enable.

Second error can be fixed via makefile, just make sure conntrack_proto_ipv6
is part of conntrack module.

based on earlier patch from Arnd Bergmann.

Fixes: 66c524acfb5186 ("netfilter: conntrack: remove l3proto abstraction")
Reported-by:  Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/Kconfig | 7 ++-----
 net/netfilter/Kconfig      | 2 +-
 net/netfilter/Makefile     | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 07516d5c2f80..339d0762b027 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,10 +5,6 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
-config NF_DEFRAG_IPV6
-	tristate
-	default n
-
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -349,6 +345,7 @@ config IP6_NF_TARGET_NPT
 endif # IP6_NF_NAT
 
 endif # IP6_NF_IPTABLES
-
 endmenu
 
+config NF_DEFRAG_IPV6
+	tristate
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6c65d756e603..e0ab50c58dc4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -50,7 +50,7 @@ config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
 	select NF_DEFRAG_IPV4
-	select NF_DEFRAG_IPV6 if IPV6
+	select NF_DEFRAG_IPV6 if IPV6 != n
 	help
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0b3851e825fa..53bd1ed1228a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -6,7 +6,7 @@ nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_exp
 		   nf_conntrack_proto_icmp.o \
 		   nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
 
-nf_conntrack-$(CONFIG_IPV6) += nf_conntrack_proto_icmpv6.o
+nf_conntrack-$(subst m,y,$(CONFIG_IPV6)) += nf_conntrack_proto_icmpv6.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
-- 
2.16.4
