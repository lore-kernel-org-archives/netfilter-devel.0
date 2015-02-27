From: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Subject: [PATCH] Add kernel headers needed from v3.16
Date: Fri, 27 Feb 2015 11:54:10 +0000
Message-ID: <1425038050-31511-2-git-send-email-pedro.alvarez@codethink.co.uk>
References: <54EFA21A.5090507@codethink.co.uk>
 <1425038050-31511-1-git-send-email-pedro.alvarez@codethink.co.uk>
Cc: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36477 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbbB0LyX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Feb 2015 06:54:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTP id 31669460A25
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Feb 2015 11:54:22 +0000 (GMT)
In-Reply-To: <1425038050-31511-1-git-send-email-pedro.alvarez@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ebtables fails to compile with versions of the linux headers greater
than v3.16 with this error:

  extensions/ebt_ulog.c:17:45: fatal error: linux/netfilter_bridge/ebt_ulog.h: No such file or directory
   #include <linux/netfilter_bridge/ebt_ulog.h>

This patch adds netfilter_bridge headers for every supported
extension, including filter.h and types.h, to avoid this problem and
future problems with changes in the kernel headers.
---
 include/linux/netfilter_bridge.h              | 27 +++++++++++
 include/linux/netfilter_bridge/ebt_802_3.h    | 63 ++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_among.h    | 64 +++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_arp.h      | 36 +++++++++++++++
 include/linux/netfilter_bridge/ebt_arpreply.h | 10 +++++
 include/linux/netfilter_bridge/ebt_ip.h       | 44 ++++++++++++++++++
 include/linux/netfilter_bridge/ebt_ip6.h      | 50 +++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_limit.h    | 24 ++++++++++
 include/linux/netfilter_bridge/ebt_log.h      | 20 +++++++++
 include/linux/netfilter_bridge/ebt_mark_m.h   | 16 +++++++
 include/linux/netfilter_bridge/ebt_mark_t.h   | 23 ++++++++++
 include/linux/netfilter_bridge/ebt_nat.h      | 13 ++++++
 include/linux/netfilter_bridge/ebt_nflog.h    | 23 ++++++++++
 include/linux/netfilter_bridge/ebt_pkttype.h  | 12 +++++
 include/linux/netfilter_bridge/ebt_redirect.h | 10 +++++
 include/linux/netfilter_bridge/ebt_stp.h      | 46 +++++++++++++++++++
 include/linux/netfilter_bridge/ebt_ulog.h     | 38 ++++++++++++++++
 include/linux/netfilter_bridge/ebt_vlan.h     | 22 +++++++++
 include/linux/types.h                         | 51 +++++++++++++++++++++
 19 files changed, 592 insertions(+)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebt_802_3.h
 create mode 100644 include/linux/netfilter_bridge/ebt_among.h
 create mode 100644 include/linux/netfilter_bridge/ebt_arp.h
 create mode 100644 include/linux/netfilter_bridge/ebt_arpreply.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ip.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ip6.h
 create mode 100644 include/linux/netfilter_bridge/ebt_limit.h
 create mode 100644 include/linux/netfilter_bridge/ebt_log.h
 create mode 100644 include/linux/netfilter_bridge/ebt_mark_m.h
 create mode 100644 include/linux/netfilter_bridge/ebt_mark_t.h
 create mode 100644 include/linux/netfilter_bridge/ebt_nat.h
 create mode 100644 include/linux/netfilter_bridge/ebt_nflog.h
 create mode 100644 include/linux/netfilter_bridge/ebt_pkttype.h
 create mode 100644 include/linux/netfilter_bridge/ebt_redirect.h
 create mode 100644 include/linux/netfilter_bridge/ebt_stp.h
 create mode 100644 include/linux/netfilter_bridge/ebt_ulog.h
 create mode 100644 include/linux/netfilter_bridge/ebt_vlan.h
 create mode 100644 include/linux/types.h

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
new file mode 100644
index 0000000..c4dbfd9
--- /dev/null
+++ b/include/linux/netfilter_bridge.h
@@ -0,0 +1,27 @@
+#ifndef __LINUX_BRIDGE_NETFILTER_H
+#define __LINUX_BRIDGE_NETFILTER_H
+
+/* bridge-specific defines for netfilter. 
+ */
+
+#include <linux/netfilter.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/if_pppox.h>
+
+/* Bridge Hooks */
+/* After promisc drops, checksum checks. */
+#define NF_BR_PRE_ROUTING	0
+/* If the packet is destined for this box. */
+#define NF_BR_LOCAL_IN		1
+/* If the packet is destined for another interface. */
+#define NF_BR_FORWARD		2
+/* Packets coming from a local process. */
+#define NF_BR_LOCAL_OUT		3
+/* Packets about to hit the wire. */
+#define NF_BR_POST_ROUTING	4
+/* Not really a hook, but used for the ebtables broute table */
+#define NF_BR_BROUTING		5
+#define NF_BR_NUMHOOKS		6
+
+#endif /* __LINUX_BRIDGE_NETFILTER_H */
diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
new file mode 100644
index 0000000..70028c1
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_802_3.h
@@ -0,0 +1,63 @@
+#ifndef __LINUX_BRIDGE_EBT_802_3_H
+#define __LINUX_BRIDGE_EBT_802_3_H
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define EBT_802_3_SAP 0x01
+#define EBT_802_3_TYPE 0x02
+
+#define EBT_802_3_MATCH "802_3"
+
+/*
+ * If frame has DSAP/SSAP value 0xaa you must check the SNAP type
+ * to discover what kind of packet we're carrying. 
+ */
+#define CHECK_TYPE 0xaa
+
+/*
+ * Control field may be one or two bytes.  If the first byte has
+ * the value 0x03 then the entire length is one byte, otherwise it is two.
+ * One byte controls are used in Unnumbered Information frames.
+ * Two byte controls are used in Numbered Information frames.
+ */
+#define IS_UI 0x03
+
+#define EBT_802_3_MASK (EBT_802_3_SAP | EBT_802_3_TYPE | EBT_802_3)
+
+/* ui has one byte ctrl, ni has two */
+struct hdr_ui {
+	__u8 dsap;
+	__u8 ssap;
+	__u8 ctrl;
+	__u8 orig[3];
+	__be16 type;
+};
+
+struct hdr_ni {
+	__u8 dsap;
+	__u8 ssap;
+	__be16 ctrl;
+	__u8  orig[3];
+	__be16 type;
+};
+
+struct ebt_802_3_hdr {
+	__u8  daddr[ETH_ALEN];
+	__u8  saddr[ETH_ALEN];
+	__be16 len;
+	union {
+		struct hdr_ui ui;
+		struct hdr_ni ni;
+	} llc;
+};
+
+
+struct ebt_802_3_info {
+	__u8  sap;
+	__be16 type;
+	__u8  bitmask;
+	__u8  invflags;
+};
+
+#endif /* __LINUX_BRIDGE_EBT_802_3_H */
diff --git a/include/linux/netfilter_bridge/ebt_among.h b/include/linux/netfilter_bridge/ebt_among.h
new file mode 100644
index 0000000..bd4e3ad
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_among.h
@@ -0,0 +1,64 @@
+#ifndef __LINUX_BRIDGE_EBT_AMONG_H
+#define __LINUX_BRIDGE_EBT_AMONG_H
+
+#include <linux/types.h>
+
+#define EBT_AMONG_DST 0x01
+#define EBT_AMONG_SRC 0x02
+
+/* Grzegorz Borowiak <grzes@gnu.univ.gda.pl> 2003
+ * 
+ * Write-once-read-many hash table, used for checking if a given
+ * MAC address belongs to a set or not and possibly for checking
+ * if it is related with a given IPv4 address.
+ *
+ * The hash value of an address is its last byte.
+ * 
+ * In real-world ethernet addresses, values of the last byte are
+ * evenly distributed and there is no need to consider other bytes.
+ * It would only slow the routines down.
+ *
+ * For MAC address comparison speedup reasons, we introduce a trick.
+ * MAC address is mapped onto an array of two 32-bit integers.
+ * This pair of integers is compared with MAC addresses in the
+ * hash table, which are stored also in form of pairs of integers
+ * (in `cmp' array). This is quick as it requires only two elementary
+ * number comparisons in worst case. Further, we take advantage of
+ * fact that entropy of 3 last bytes of address is larger than entropy
+ * of 3 first bytes. So first we compare 4 last bytes of addresses and
+ * if they are the same we compare 2 first.
+ *
+ * Yes, it is a memory overhead, but in 2003 AD, who cares?
+ */
+
+struct ebt_mac_wormhash_tuple {
+	__u32 cmp[2];
+	__be32 ip;
+};
+
+struct ebt_mac_wormhash {
+	int table[257];
+	int poolsize;
+	struct ebt_mac_wormhash_tuple pool[0];
+};
+
+#define ebt_mac_wormhash_size(x) ((x) ? sizeof(struct ebt_mac_wormhash) \
+		+ (x)->poolsize * sizeof(struct ebt_mac_wormhash_tuple) : 0)
+
+struct ebt_among_info {
+	int wh_dst_ofs;
+	int wh_src_ofs;
+	int bitmask;
+};
+
+#define EBT_AMONG_DST_NEG 0x1
+#define EBT_AMONG_SRC_NEG 0x2
+
+#define ebt_among_wh_dst(x) ((x)->wh_dst_ofs ? \
+	(struct ebt_mac_wormhash*)((char*)(x) + (x)->wh_dst_ofs) : NULL)
+#define ebt_among_wh_src(x) ((x)->wh_src_ofs ? \
+	(struct ebt_mac_wormhash*)((char*)(x) + (x)->wh_src_ofs) : NULL)
+
+#define EBT_AMONG_MATCH "among"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_arp.h b/include/linux/netfilter_bridge/ebt_arp.h
new file mode 100644
index 0000000..522f3e4
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_arp.h
@@ -0,0 +1,36 @@
+#ifndef __LINUX_BRIDGE_EBT_ARP_H
+#define __LINUX_BRIDGE_EBT_ARP_H
+
+#include <linux/types.h>
+
+#define EBT_ARP_OPCODE 0x01
+#define EBT_ARP_HTYPE 0x02
+#define EBT_ARP_PTYPE 0x04
+#define EBT_ARP_SRC_IP 0x08
+#define EBT_ARP_DST_IP 0x10
+#define EBT_ARP_SRC_MAC 0x20
+#define EBT_ARP_DST_MAC 0x40
+#define EBT_ARP_GRAT 0x80
+#define EBT_ARP_MASK (EBT_ARP_OPCODE | EBT_ARP_HTYPE | EBT_ARP_PTYPE | \
+   EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC | \
+   EBT_ARP_GRAT)
+#define EBT_ARP_MATCH "arp"
+
+struct ebt_arp_info
+{
+	__be16 htype;
+	__be16 ptype;
+	__be16 opcode;
+	__be32 saddr;
+	__be32 smsk;
+	__be32 daddr;
+	__be32 dmsk;
+	unsigned char smaddr[ETH_ALEN];
+	unsigned char smmsk[ETH_ALEN];
+	unsigned char dmaddr[ETH_ALEN];
+	unsigned char dmmsk[ETH_ALEN];
+	__u8  bitmask;
+	__u8  invflags;
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_arpreply.h b/include/linux/netfilter_bridge/ebt_arpreply.h
new file mode 100644
index 0000000..7e77896
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_arpreply.h
@@ -0,0 +1,10 @@
+#ifndef __LINUX_BRIDGE_EBT_ARPREPLY_H
+#define __LINUX_BRIDGE_EBT_ARPREPLY_H
+
+struct ebt_arpreply_info {
+	unsigned char mac[ETH_ALEN];
+	int target;
+};
+#define EBT_ARPREPLY_TARGET "arpreply"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_ip.h b/include/linux/netfilter_bridge/ebt_ip.h
new file mode 100644
index 0000000..c4bbc41
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_ip.h
@@ -0,0 +1,44 @@
+/*
+ *  ebt_ip
+ *
+ *	Authors:
+ *	Bart De Schuymer <bart.de.schuymer@pandora.be>
+ *
+ *  April, 2002
+ *
+ *  Changes:
+ *    added ip-sport and ip-dport
+ *    Innominate Security Technologies AG <mhopf@innominate.com>
+ *    September, 2002
+ */
+
+#ifndef __LINUX_BRIDGE_EBT_IP_H
+#define __LINUX_BRIDGE_EBT_IP_H
+
+#include <linux/types.h>
+
+#define EBT_IP_SOURCE 0x01
+#define EBT_IP_DEST 0x02
+#define EBT_IP_TOS 0x04
+#define EBT_IP_PROTO 0x08
+#define EBT_IP_SPORT 0x10
+#define EBT_IP_DPORT 0x20
+#define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
+ EBT_IP_SPORT | EBT_IP_DPORT )
+#define EBT_IP_MATCH "ip"
+
+/* the same values are used for the invflags */
+struct ebt_ip_info {
+	__be32 saddr;
+	__be32 daddr;
+	__be32 smsk;
+	__be32 dmsk;
+	__u8  tos;
+	__u8  protocol;
+	__u8  bitmask;
+	__u8  invflags;
+	__u16 sport[2];
+	__u16 dport[2];
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_ip6.h b/include/linux/netfilter_bridge/ebt_ip6.h
new file mode 100644
index 0000000..42b8896
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_ip6.h
@@ -0,0 +1,50 @@
+/*
+ *  ebt_ip6
+ *
+ *	Authors:
+ * Kuo-Lang Tseng <kuo-lang.tseng@intel.com>
+ * Manohar Castelino <manohar.r.castelino@intel.com>
+ *
+ *  Jan 11, 2008
+ *
+ */
+
+#ifndef __LINUX_BRIDGE_EBT_IP6_H
+#define __LINUX_BRIDGE_EBT_IP6_H
+
+#include <linux/types.h>
+
+#define EBT_IP6_SOURCE 0x01
+#define EBT_IP6_DEST 0x02
+#define EBT_IP6_TCLASS 0x04
+#define EBT_IP6_PROTO 0x08
+#define EBT_IP6_SPORT 0x10
+#define EBT_IP6_DPORT 0x20
+#define EBT_IP6_ICMP6 0x40
+
+#define EBT_IP6_MASK (EBT_IP6_SOURCE | EBT_IP6_DEST | EBT_IP6_TCLASS |\
+		      EBT_IP6_PROTO | EBT_IP6_SPORT | EBT_IP6_DPORT | \
+		      EBT_IP6_ICMP6)
+#define EBT_IP6_MATCH "ip6"
+
+/* the same values are used for the invflags */
+struct ebt_ip6_info {
+	struct in6_addr saddr;
+	struct in6_addr daddr;
+	struct in6_addr smsk;
+	struct in6_addr dmsk;
+	__u8  tclass;
+	__u8  protocol;
+	__u8  bitmask;
+	__u8  invflags;
+	union {
+		__u16 sport[2];
+		__u8 icmpv6_type[2];
+	};
+	union {
+		__u16 dport[2];
+		__u8 icmpv6_code[2];
+	};
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_limit.h b/include/linux/netfilter_bridge/ebt_limit.h
new file mode 100644
index 0000000..66d80b3
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_limit.h
@@ -0,0 +1,24 @@
+#ifndef __LINUX_BRIDGE_EBT_LIMIT_H
+#define __LINUX_BRIDGE_EBT_LIMIT_H
+
+#include <linux/types.h>
+
+#define EBT_LIMIT_MATCH "limit"
+
+/* timings are in milliseconds. */
+#define EBT_LIMIT_SCALE 10000
+
+/* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
+   seconds, or one every 59 hours. */
+
+struct ebt_limit_info {
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
+
+	/* Used internally by the kernel */
+	unsigned long prev;
+	__u32 credit;
+	__u32 credit_cap, cost;
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_log.h b/include/linux/netfilter_bridge/ebt_log.h
new file mode 100644
index 0000000..7e7f1d1
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_log.h
@@ -0,0 +1,20 @@
+#ifndef __LINUX_BRIDGE_EBT_LOG_H
+#define __LINUX_BRIDGE_EBT_LOG_H
+
+#include <linux/types.h>
+
+#define EBT_LOG_IP 0x01 /* if the frame is made by ip, log the ip information */
+#define EBT_LOG_ARP 0x02
+#define EBT_LOG_NFLOG 0x04
+#define EBT_LOG_IP6 0x08
+#define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP | EBT_LOG_IP6)
+#define EBT_LOG_PREFIX_SIZE 30
+#define EBT_LOG_WATCHER "log"
+
+struct ebt_log_info {
+	__u8 loglevel;
+	__u8 prefix[EBT_LOG_PREFIX_SIZE];
+	__u32 bitmask;
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_mark_m.h b/include/linux/netfilter_bridge/ebt_mark_m.h
new file mode 100644
index 0000000..410f9e5
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_mark_m.h
@@ -0,0 +1,16 @@
+#ifndef __LINUX_BRIDGE_EBT_MARK_M_H
+#define __LINUX_BRIDGE_EBT_MARK_M_H
+
+#include <linux/types.h>
+
+#define EBT_MARK_AND 0x01
+#define EBT_MARK_OR 0x02
+#define EBT_MARK_MASK (EBT_MARK_AND | EBT_MARK_OR)
+struct ebt_mark_m_info {
+	unsigned long mark, mask;
+	__u8 invert;
+	__u8 bitmask;
+};
+#define EBT_MARK_MATCH "mark_m"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_mark_t.h b/include/linux/netfilter_bridge/ebt_mark_t.h
new file mode 100644
index 0000000..7d5a268
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_mark_t.h
@@ -0,0 +1,23 @@
+#ifndef __LINUX_BRIDGE_EBT_MARK_T_H
+#define __LINUX_BRIDGE_EBT_MARK_T_H
+
+/* The target member is reused for adding new actions, the
+ * value of the real target is -1 to -NUM_STANDARD_TARGETS.
+ * For backward compatibility, the 4 lsb (2 would be enough,
+ * but let's play it safe) are kept to designate this target.
+ * The remaining bits designate the action. By making the set
+ * action 0xfffffff0, the result will look ok for older
+ * versions. [September 2006] */
+#define MARK_SET_VALUE (0xfffffff0)
+#define MARK_OR_VALUE  (0xffffffe0)
+#define MARK_AND_VALUE (0xffffffd0)
+#define MARK_XOR_VALUE (0xffffffc0)
+
+struct ebt_mark_t_info {
+	unsigned long mark;
+	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
+	int target;
+};
+#define EBT_MARK_TARGET "mark"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_nat.h b/include/linux/netfilter_bridge/ebt_nat.h
new file mode 100644
index 0000000..5e74e3b
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_nat.h
@@ -0,0 +1,13 @@
+#ifndef __LINUX_BRIDGE_EBT_NAT_H
+#define __LINUX_BRIDGE_EBT_NAT_H
+
+#define NAT_ARP_BIT  (0x00000010)
+struct ebt_nat_info {
+	unsigned char mac[ETH_ALEN];
+	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
+	int target;
+};
+#define EBT_SNAT_TARGET "snat"
+#define EBT_DNAT_TARGET "dnat"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_nflog.h b/include/linux/netfilter_bridge/ebt_nflog.h
new file mode 100644
index 0000000..df829fc
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_nflog.h
@@ -0,0 +1,23 @@
+#ifndef __LINUX_BRIDGE_EBT_NFLOG_H
+#define __LINUX_BRIDGE_EBT_NFLOG_H
+
+#include <linux/types.h>
+
+#define EBT_NFLOG_MASK 0x0
+
+#define EBT_NFLOG_PREFIX_SIZE 64
+#define EBT_NFLOG_WATCHER "nflog"
+
+#define EBT_NFLOG_DEFAULT_GROUP		0x1
+#define EBT_NFLOG_DEFAULT_THRESHOLD	1
+
+struct ebt_nflog_info {
+	__u32 len;
+	__u16 group;
+	__u16 threshold;
+	__u16 flags;
+	__u16 pad;
+	char prefix[EBT_NFLOG_PREFIX_SIZE];
+};
+
+#endif				/* __LINUX_BRIDGE_EBT_NFLOG_H */
diff --git a/include/linux/netfilter_bridge/ebt_pkttype.h b/include/linux/netfilter_bridge/ebt_pkttype.h
new file mode 100644
index 0000000..c241bad
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_pkttype.h
@@ -0,0 +1,12 @@
+#ifndef __LINUX_BRIDGE_EBT_PKTTYPE_H
+#define __LINUX_BRIDGE_EBT_PKTTYPE_H
+
+#include <linux/types.h>
+
+struct ebt_pkttype_info {
+	__u8 pkt_type;
+	__u8 invert;
+};
+#define EBT_PKTTYPE_MATCH "pkttype"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_redirect.h b/include/linux/netfilter_bridge/ebt_redirect.h
new file mode 100644
index 0000000..dd9622c
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_redirect.h
@@ -0,0 +1,10 @@
+#ifndef __LINUX_BRIDGE_EBT_REDIRECT_H
+#define __LINUX_BRIDGE_EBT_REDIRECT_H
+
+struct ebt_redirect_info {
+	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
+	int target;
+};
+#define EBT_REDIRECT_TARGET "redirect"
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_stp.h b/include/linux/netfilter_bridge/ebt_stp.h
new file mode 100644
index 0000000..1025b9f
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_stp.h
@@ -0,0 +1,46 @@
+#ifndef __LINUX_BRIDGE_EBT_STP_H
+#define __LINUX_BRIDGE_EBT_STP_H
+
+#include <linux/types.h>
+
+#define EBT_STP_TYPE		0x0001
+
+#define EBT_STP_FLAGS		0x0002
+#define EBT_STP_ROOTPRIO	0x0004
+#define EBT_STP_ROOTADDR	0x0008
+#define EBT_STP_ROOTCOST	0x0010
+#define EBT_STP_SENDERPRIO	0x0020
+#define EBT_STP_SENDERADDR	0x0040
+#define EBT_STP_PORT		0x0080
+#define EBT_STP_MSGAGE		0x0100
+#define EBT_STP_MAXAGE		0x0200
+#define EBT_STP_HELLOTIME	0x0400
+#define EBT_STP_FWDD		0x0800
+
+#define EBT_STP_MASK		0x0fff
+#define EBT_STP_CONFIG_MASK	0x0ffe
+
+#define EBT_STP_MATCH "stp"
+
+struct ebt_stp_config_info {
+	__u8 flags;
+	__u16 root_priol, root_priou;
+	char root_addr[6], root_addrmsk[6];
+	__u32 root_costl, root_costu;
+	__u16 sender_priol, sender_priou;
+	char sender_addr[6], sender_addrmsk[6];
+	__u16 portl, portu;
+	__u16 msg_agel, msg_ageu;
+	__u16 max_agel, max_ageu;
+	__u16 hello_timel, hello_timeu;
+	__u16 forward_delayl, forward_delayu;
+};
+
+struct ebt_stp_info {
+	__u8 type;
+	struct ebt_stp_config_info config;
+	__u16 bitmask;
+	__u16 invflags;
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebt_ulog.h b/include/linux/netfilter_bridge/ebt_ulog.h
new file mode 100644
index 0000000..89a6bec
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_ulog.h
@@ -0,0 +1,38 @@
+#ifndef _EBT_ULOG_H
+#define _EBT_ULOG_H
+
+#include <linux/types.h>
+
+#define EBT_ULOG_DEFAULT_NLGROUP 0
+#define EBT_ULOG_DEFAULT_QTHRESHOLD 1
+#define EBT_ULOG_MAXNLGROUPS 32 /* hardcoded netlink max */
+#define EBT_ULOG_PREFIX_LEN 32
+#define EBT_ULOG_MAX_QLEN 50
+#define EBT_ULOG_WATCHER "ulog"
+#define EBT_ULOG_VERSION 1
+
+struct ebt_ulog_info {
+	__u32 nlgroup;
+	unsigned int cprange;
+	unsigned int qthreshold;
+	char prefix[EBT_ULOG_PREFIX_LEN];
+};
+
+typedef struct ebt_ulog_packet_msg {
+	int version;
+	char indev[IFNAMSIZ];
+	char outdev[IFNAMSIZ];
+	char physindev[IFNAMSIZ];
+	char physoutdev[IFNAMSIZ];
+	char prefix[EBT_ULOG_PREFIX_LEN];
+	struct timeval stamp;
+	unsigned long mark;
+	unsigned int hook;
+	size_t data_len;
+	/* The complete packet, including Ethernet header and perhaps
+	 * the VLAN header is appended */
+	unsigned char data[0] __attribute__
+	                      ((aligned (__alignof__(struct ebt_ulog_info))));
+} ebt_ulog_packet_msg_t;
+
+#endif /* _EBT_ULOG_H */
diff --git a/include/linux/netfilter_bridge/ebt_vlan.h b/include/linux/netfilter_bridge/ebt_vlan.h
new file mode 100644
index 0000000..967d1d5
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_vlan.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_BRIDGE_EBT_VLAN_H
+#define __LINUX_BRIDGE_EBT_VLAN_H
+
+#include <linux/types.h>
+
+#define EBT_VLAN_ID	0x01
+#define EBT_VLAN_PRIO	0x02
+#define EBT_VLAN_ENCAP	0x04
+#define EBT_VLAN_MASK (EBT_VLAN_ID | EBT_VLAN_PRIO | EBT_VLAN_ENCAP)
+#define EBT_VLAN_MATCH "vlan"
+
+struct ebt_vlan_info {
+	__u16 id;		/* VLAN ID {1-4095} */
+	__u8 prio;		/* VLAN User Priority {0-7} */
+	__be16 encap;		/* VLAN Encapsulated frame code {0-65535} */
+	__u8 bitmask;		/* Args bitmask bit 1=1 - ID arg,
+				   bit 2=1 User-Priority arg, bit 3=1 encap*/
+	__u8 invflags;		/* Inverse bitmask  bit 1=1 - inversed ID arg, 
+				   bit 2=1 - inversed Pirority arg */
+};
+
+#endif
diff --git a/include/linux/types.h b/include/linux/types.h
new file mode 100644
index 0000000..23ea78f
--- /dev/null
+++ b/include/linux/types.h
@@ -0,0 +1,51 @@
+#ifndef _LINUX_TYPES_H
+#define _LINUX_TYPES_H
+
+#include <asm/types.h>
+
+#ifndef __ASSEMBLY__
+
+#include <linux/posix_types.h>
+
+
+/*
+ * Below are truly Linux-specific types that should never collide with
+ * any application/library that wants linux/types.h.
+ */
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+/*
+ * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
+ * common 32/64-bit compat problems.
+ * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
+ * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
+ * aligned_64 type enforces 8-byte alignment so that structs containing
+ * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
+ * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
+ */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
+#endif /*  __ASSEMBLY__ */
+#endif /* _LINUX_TYPES_H */
-- 
2.1.4

