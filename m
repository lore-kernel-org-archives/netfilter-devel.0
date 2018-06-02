From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: nf_tables: add connlimit support
Date: Sun,  3 Jun 2018 01:14:12 +0200
Message-ID: <20180602231413.31974-9-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This features which allows you to limit the maximum number of
connections per arbitrary key. The connlimit expression is stateful,
therefore it can be used from meters to dynamically populate a set, this
provides a mapping to the iptables' connlimit match. This patch also
comes that allows you define static connlimit policies.

This extension depends on the nf_conncount infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 21 ++++++++++++++++++++-
 net/netfilter/Kconfig                    |  9 +++++++++
 net/netfilter/Makefile                   |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a089af092a29..ae00a3c49b8a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1043,6 +1043,24 @@ enum nft_limit_attributes {
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
 
+enum nft_connlimit_flags {
+	NFT_CONNLIMIT_F_INV	= (1 << 0),
+};
+
+/**
+ * enum nft_connlimit_attributes - nf_tables connlimit expression netlink attributes
+ *
+ * @NFTA_CONNLIMIT_COUNT: number of connections (NLA_U32)
+ * @NFTA_CONNLIMIT_FLAGS: flags (NLA_U32: enum nft_connlimit_flags)
+ */
+enum nft_connlimit_attributes {
+	NFTA_CONNLIMIT_UNSPEC,
+	NFTA_CONNLIMIT_COUNT,
+	NFTA_CONNLIMIT_FLAGS,
+	__NFTA_CONNLIMIT_MAX
+};
+#define NFTA_CONNLIMIT_MAX	(__NFTA_CONNLIMIT_MAX - 1)
+
 /**
  * enum nft_counter_attributes - nf_tables counter expression netlink attributes
  *
@@ -1357,7 +1375,8 @@ enum nft_ct_helper_attributes {
 #define NFT_OBJECT_QUOTA	2
 #define NFT_OBJECT_CT_HELPER	3
 #define NFT_OBJECT_LIMIT	4
-#define __NFT_OBJECT_MAX	5
+#define NFT_OBJECT_CONNLIMIT	5
+#define __NFT_OBJECT_MAX	6
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 41240abd755f..dbd7d1fad277 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -517,6 +517,15 @@ config NFT_COUNTER
 	  This option adds the "counter" expression that you can use to
 	  include packet and byte counters in a rule.
 
+config NFT_CONNLIMIT
+	tristate "Netfilter nf_tables connlimit module"
+	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_CONNCOUNT
+	help
+	  This option adds the "connlimit" expression that you can use to
+	  ratelimit rule matchings per connections.
+
 config NFT_LOG
 	tristate "Netfilter nf_tables log module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index eec169555731..44449389e527 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -80,6 +80,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
+obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
-- 
2.11.0
