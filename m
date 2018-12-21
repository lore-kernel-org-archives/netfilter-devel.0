From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/37] netfilter: remove NFC_* cache bits
Date: Fri, 21 Dec 2018 01:28:12 +0100
Message-ID: <20181221002841.28587-9-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These are very very (for long time unused) caching infrastructure
definition, remove then. They have nothing to do with the NFC subsystem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter.h        |  4 ----
 include/uapi/linux/netfilter_decnet.h | 10 ----------
 include/uapi/linux/netfilter_ipv4.h   | 28 ----------------------------
 include/uapi/linux/netfilter_ipv6.h   | 29 -----------------------------
 4 files changed, 71 deletions(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index cca10e767cd8..ca9e63d6e0e4 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -34,10 +34,6 @@
 
 /* only for userspace compatibility */
 #ifndef __KERNEL__
-/* Generic cache responses from hook functions.
-   <= 0x2000 is used for protocol-flags. */
-#define NFC_UNKNOWN 0x4000
-#define NFC_ALTERED 0x8000
 
 /* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
 #define NF_VERDICT_BITS 16
diff --git a/include/uapi/linux/netfilter_decnet.h b/include/uapi/linux/netfilter_decnet.h
index 61f1c7dfd033..3c77f54560f2 100644
--- a/include/uapi/linux/netfilter_decnet.h
+++ b/include/uapi/linux/netfilter_decnet.h
@@ -15,16 +15,6 @@
 
 #include <limits.h> /* for INT_MIN, INT_MAX */
 
-/* IP Cache bits. */
-/* Src IP address. */
-#define NFC_DN_SRC		0x0001
-/* Dest IP address. */
-#define NFC_DN_DST		0x0002
-/* Input device. */
-#define NFC_DN_IF_IN		0x0004
-/* Output device. */
-#define NFC_DN_IF_OUT		0x0008
-
 /* kernel define is in netfilter_defs.h */
 #define NF_DN_NUMHOOKS		7
 #endif /* ! __KERNEL__ */
diff --git a/include/uapi/linux/netfilter_ipv4.h b/include/uapi/linux/netfilter_ipv4.h
index c3b060775e13..155e77d6a42d 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -13,34 +13,6 @@
 
 #include <limits.h> /* for INT_MIN, INT_MAX */
 
-/* IP Cache bits. */
-/* Src IP address. */
-#define NFC_IP_SRC		0x0001
-/* Dest IP address. */
-#define NFC_IP_DST		0x0002
-/* Input device. */
-#define NFC_IP_IF_IN		0x0004
-/* Output device. */
-#define NFC_IP_IF_OUT		0x0008
-/* TOS. */
-#define NFC_IP_TOS		0x0010
-/* Protocol. */
-#define NFC_IP_PROTO		0x0020
-/* IP options. */
-#define NFC_IP_OPTIONS		0x0040
-/* Frag & flags. */
-#define NFC_IP_FRAG		0x0080
-
-/* Per-protocol information: only matters if proto match. */
-/* TCP flags. */
-#define NFC_IP_TCPFLAGS		0x0100
-/* Source port. */
-#define NFC_IP_SRC_PT		0x0200
-/* Dest port. */
-#define NFC_IP_DST_PT		0x0400
-/* Something else about the proto */
-#define NFC_IP_PROTO_UNKNOWN	0x2000
-
 /* IP Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_IP_PRE_ROUTING	0
diff --git a/include/uapi/linux/netfilter_ipv6.h b/include/uapi/linux/netfilter_ipv6.h
index dc624fd24d25..80aa9b0799af 100644
--- a/include/uapi/linux/netfilter_ipv6.h
+++ b/include/uapi/linux/netfilter_ipv6.h
@@ -16,35 +16,6 @@
 
 #include <limits.h> /* for INT_MIN, INT_MAX */
 
-/* IP Cache bits. */
-/* Src IP address. */
-#define NFC_IP6_SRC              0x0001
-/* Dest IP address. */
-#define NFC_IP6_DST              0x0002
-/* Input device. */
-#define NFC_IP6_IF_IN            0x0004
-/* Output device. */
-#define NFC_IP6_IF_OUT           0x0008
-/* TOS. */
-#define NFC_IP6_TOS              0x0010
-/* Protocol. */
-#define NFC_IP6_PROTO            0x0020
-/* IP options. */
-#define NFC_IP6_OPTIONS          0x0040
-/* Frag & flags. */
-#define NFC_IP6_FRAG             0x0080
-
-
-/* Per-protocol information: only matters if proto match. */
-/* TCP flags. */
-#define NFC_IP6_TCPFLAGS         0x0100
-/* Source port. */
-#define NFC_IP6_SRC_PT           0x0200
-/* Dest port. */
-#define NFC_IP6_DST_PT           0x0400
-/* Something else about the proto */
-#define NFC_IP6_PROTO_UNKNOWN    0x2000
-
 /* IP6 Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_IP6_PRE_ROUTING	0
-- 
2.11.0
