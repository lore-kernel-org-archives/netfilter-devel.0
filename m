From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: conntrack: add weak IPV6 dependency
Date: Fri,  6 Jul 2018 14:59:52 +0200
Message-ID: <20180706130005.3640993-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Now that the conntrack module contains code for ipv6, we can no longer
have it built-in while IPv6 itself is a loadable module:

net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
nf_conntrack_proto.c:(.text+0x88c): undefined reference to `nf_defrag_ipv6_enable'
net/netfilter/nf_conntrack_proto.o:(.rodata+0x178): undefined reference to `nf_conntrack_l4proto_icmpv6'

This adds a dependency on IPv6 that makes it possible to still build
the conntrack module with IPv6 disabled, but avoids the broken configuration.

Fixes: 66c524acfb51 ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 74df382bf2ba..e42c38c99741 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -49,6 +49,7 @@ config NETFILTER_NETLINK_LOG
 config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
+	depends on IPV6 || !IPV6
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IPV6
 	help
-- 
2.9.0
