From: pablo@netfilter.org
Subject: [PATCH 09/14] netfilter: export NAT definitions through linux/netfilter_ipv4/nf_nat.h
Date: Tue,  1 Nov 2011 10:11:31 +0100
Message-ID: <1320138696-28048-10-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1KAJMI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:08 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch exports several definitions that used to live under
include/net/netfilter/nf_nat.h. These definitions, although not
exported, have been used by iptables and other userspace
applications like miniupnpd since long time. Basically, these
userspace tools included some internal definition of the required
structures and they assume no changes in the binary representation
(which is OK indeed).

To resolve this situation, this patch makes public the required
structure and install them in INSTALL_HDR_PATH.

See: https://bugs.gentoo.org/376873, for more information.

This patch is heavily based on the initial patch sent by:

Anthony G. Basile <blueness@gentoo.org>

Which was entitled:

netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/Kbuild        |    1 +
 include/linux/netfilter_ipv4/nf_nat.h      |   58 ++++++++++++++++++++++++++++
 include/net/netfilter/nf_conntrack_tuple.h |   27 +------------
 include/net/netfilter/nf_nat.h             |   26 +------------
 4 files changed, 61 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/netfilter_ipv4/nf_nat.h

diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index f9930c8..c3b4548 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -12,3 +12,4 @@ header-y += ipt_ah.h
 header-y += ipt_ecn.h
 header-y += ipt_realm.h
 header-y += ipt_ttl.h
+header-y += nf_nat.h
diff --git a/include/linux/netfilter_ipv4/nf_nat.h b/include/linux/netfilter_ipv4/nf_nat.h
new file mode 100644
index 0000000..7a861d0
--- /dev/null
+++ b/include/linux/netfilter_ipv4/nf_nat.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_NF_NAT_H
+#define _LINUX_NF_NAT_H
+
+#include <linux/types.h>
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
+#define IP_NAT_RANGE_PERSISTENT 8
+
+/* The protocol-specific manipulable parts of the tuple. */
+union nf_conntrack_man_proto {
+	/* Add other protocols here. */
+	__be16 all;
+
+	struct {
+		__be16 port;
+	} tcp;
+	struct {
+		__be16 port;
+	} udp;
+	struct {
+		__be16 id;
+	} icmp;
+	struct {
+		__be16 port;
+	} dccp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
+/* Single range specification. */
+struct nf_nat_range {
+	/* Set to OR of flags above. */
+	unsigned int flags;
+
+	/* Inclusive: network order. */
+	__be32 min_ip, max_ip;
+
+	/* Inclusive: network order */
+	union nf_conntrack_man_proto min, max;
+};
+
+/* For backwards compat: don't use in modern code. */
+struct nf_nat_multi_range_compat {
+	unsigned int rangesize; /* Must be 1. */
+
+	/* hangs off end. */
+	struct nf_nat_range range[1];
+};
+
+#define nf_nat_multi_range nf_nat_multi_range_compat
+
+#endif
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 7ca6bdd..2f8fb77 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -12,6 +12,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/netfilter_ipv4/nf_nat.h>
 #include <linux/list_nulls.h>
 
 /* A `tuple' is a structure containing the information to uniquely
@@ -24,32 +25,6 @@
 
 #define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
 
-/* The protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_man_proto {
-	/* Add other protocols here. */
-	__be16 all;
-
-	struct {
-		__be16 port;
-	} tcp;
-	struct {
-		__be16 port;
-	} udp;
-	struct {
-		__be16 id;
-	} icmp;
-	struct {
-		__be16 port;
-	} dccp;
-	struct {
-		__be16 port;
-	} sctp;
-	struct {
-		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
-	} gre;
-};
-
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man {
 	union nf_inet_addr u3;
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0346b00..b8872df 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -1,6 +1,7 @@
 #ifndef _NF_NAT_H
 #define _NF_NAT_H
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/nf_nat.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 #define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
@@ -14,11 +15,6 @@ enum nf_nat_manip_type {
 #define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
 			     (hooknum) != NF_INET_LOCAL_IN)
 
-#define IP_NAT_RANGE_MAP_IPS 1
-#define IP_NAT_RANGE_PROTO_SPECIFIED 2
-#define IP_NAT_RANGE_PROTO_RANDOM 4
-#define IP_NAT_RANGE_PERSISTENT 8
-
 /* NAT sequence number modifications */
 struct nf_nat_seq {
 	/* position of the last TCP sequence number modification (if any) */
@@ -28,26 +24,6 @@ struct nf_nat_seq {
 	int16_t offset_before, offset_after;
 };
 
-/* Single range specification. */
-struct nf_nat_range {
-	/* Set to OR of flags above. */
-	unsigned int flags;
-
-	/* Inclusive: network order. */
-	__be32 min_ip, max_ip;
-
-	/* Inclusive: network order */
-	union nf_conntrack_man_proto min, max;
-};
-
-/* For backwards compat: don't use in modern code. */
-struct nf_nat_multi_range_compat {
-	unsigned int rangesize; /* Must be 1. */
-
-	/* hangs off end. */
-	struct nf_nat_range range[1];
-};
-
 #include <linux/list.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 #include <net/netfilter/nf_conntrack_extend.h>
-- 
1.7.2.5

