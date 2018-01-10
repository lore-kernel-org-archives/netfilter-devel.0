From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] netfilter: improve flow table Kconfig dependencies
Date: Wed, 10 Jan 2018 18:10:59 +0100
Message-ID: <20180110171143.2528510-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The newly added NF_FLOW_TABLE options cause some build failures in
randconfig kernels:

- when CONFIG_NF_CONNTRACK is disabled, or is a loadable module but
  NF_FLOW_TABLE is built-in:

  In file included from net/netfilter/nf_flow_table.c:8:0:
  include/net/netfilter/nf_conntrack.h:59:22: error: field 'ct_general' has incomplete type
    struct nf_conntrack ct_general;
  include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
  include/net/netfilter/nf_conntrack.h:148:15: error: 'const struct sk_buff' has no member named '_nfct'
  include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
  include/net/netfilter/nf_conntrack.h:157:2: error: implicit declaration of function 'nf_conntrack_put'; did you mean 'nf_ct_put'? [-Werror=implicit-function-declaration]

  net/netfilter/nf_flow_table.o: In function `nf_flow_offload_work_gc':
  (.text+0x1540): undefined reference to `nf_ct_delete'

- when CONFIG_NF_TABLES is disabled:

  In file included from net/ipv6/netfilter/nf_flow_table_ipv6.c:13:0:
  include/net/netfilter/nf_tables.h: In function 'nft_gencursor_next':
  include/net/netfilter/nf_tables.h:1189:14: error: 'const struct net' has no member named 'nft'; did you mean 'nf'?

 - when CONFIG_NF_FLOW_TABLE_INET is enabled, but NF_FLOW_TABLE_IPV4
  or NF_FLOW_TABLE_IPV6 are not, or are loadable modules

  net/netfilter/nf_flow_table_inet.o: In function `nf_flow_offload_inet_hook':
  nf_flow_table_inet.c:(.text+0x94): undefined reference to `nf_flow_offload_ipv6_hook'
  nf_flow_table_inet.c:(.text+0x40): undefined reference to `nf_flow_offload_ip_hook'

- when CONFIG_NF_FLOW_TABLES is disabled, but the other options are
  enabled:

  net/netfilter/nf_flow_table_inet.o: In function `nf_flow_offload_inet_hook':
  nf_flow_table_inet.c:(.text+0x6c): undefined reference to `nf_flow_offload_ipv6_hook'
  net/netfilter/nf_flow_table_inet.o: In function `nf_flow_inet_module_exit':
  nf_flow_table_inet.c:(.exit.text+0x8): undefined reference to `nft_unregister_flowtable_type'
  net/netfilter/nf_flow_table_inet.o: In function `nf_flow_inet_module_init':
  nf_flow_table_inet.c:(.init.text+0x8): undefined reference to `nft_register_flowtable_type'
  net/ipv4/netfilter/nf_flow_table_ipv4.o: In function `nf_flow_ipv4_module_exit':
  nf_flow_table_ipv4.c:(.exit.text+0x8): undefined reference to `nft_unregister_flowtable_type'
  net/ipv4/netfilter/nf_flow_table_ipv4.o: In function `nf_flow_ipv4_module_init':
  nf_flow_table_ipv4.c:(.init.text+0x8): undefined reference to `nft_register_flowtable_type'

This adds additional Kconfig dependencies to ensure that NF_CONNTRACK and NF_TABLES
are always visible from NF_FLOW_TABLE, and that the internal dependencies between
the four new modules are met.

Fixes: 7c23b629a808 ("netfilter: flow table support for the mixed IPv4/IPv6 family")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/ipv4/netfilter/Kconfig | 3 ++-
 net/ipv6/netfilter/Kconfig | 3 ++-
 net/netfilter/Kconfig      | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7d5d444964aa..3ad46a90b0fc 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -79,8 +79,9 @@ config NF_TABLES_ARP
 endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV4
-	select NF_FLOW_TABLE
 	tristate "Netfilter flow table IPv4 module"
+	depends on NF_CONNTRACK && NF_TABLES
+	select NF_FLOW_TABLE
 	help
 	  This option adds the flow table IPv4 support.
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 806e95375ec8..3fb2818317b8 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -72,8 +72,9 @@ endif # NF_TABLES_IPV6
 endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV6
-	select NF_FLOW_TABLE
 	tristate "Netfilter flow table IPv6 module"
+	depends on NF_CONNTRACK && NF_TABLES
+	select NF_FLOW_TABLE
 	help
 	  This option adds the flow table IPv6 support.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0ee0fcf3abbf..ea447826e127 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -665,8 +665,9 @@ endif # NF_TABLES_NETDEV
 endif # NF_TABLES
 
 config NF_FLOW_TABLE_INET
-	select NF_FLOW_TABLE
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
+	depends on NF_FLOW_TABLE_IPV4 && NF_FLOW_TABLE_IPV6
+	select NF_FLOW_TABLE
 	help
           This option adds the flow table mixed IPv4/IPv6 support.
 
@@ -674,6 +675,7 @@ config NF_FLOW_TABLE_INET
 
 config NF_FLOW_TABLE
 	tristate "Netfilter flow table module"
+	depends on NF_CONNTRACK && NF_TABLES
 	help
 	  This option adds the flow table core infrastructure.
 
-- 
2.9.0
