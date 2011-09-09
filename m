From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: [PATCH] netfilter: install nf_nat.h and nf_conntrack_tuple.h to INSTALL_HDR_PATH
Date: Thu,  8 Sep 2011 20:16:17 -0400
Message-ID: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu>
Cc: kaber@trash.net, basile@opensource.dyc.edu, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.ddl.dyc.edu ([67.151.215.230]:45629 "EHLO ddl.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1IIAP1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:15:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Anthony G. Basile" <basile@opensource.dyc.edu>

This exports sanitized versions of nf_nat.h, nf_conntrack_tuple.h for
userland applications, like iptables and miniupnpd, which make use of
binary representations of NAT in the kernel's netfilter API.

This patch makes these headers public by installing them in
INSTALL_HDR_PATH.

See: https://bugs.gentoo.org/376873

Signed-off-by: Anthony G. Basile <blueness@gentoo.org>
---
 include/linux/netfilter/Kbuild               |    2 +
 include/linux/netfilter/nf_conntrack_tuple.h |  110 ++++++++++++++++++++++++++
 include/linux/netfilter/nf_nat.h             |   52 ++++++++++++
 3 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_tuple.h
 create mode 100644 include/linux/netfilter/nf_nat.h

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index a1b410c..e9ee3eb 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -5,6 +5,8 @@ header-y += nf_conntrack_ftp.h
 header-y += nf_conntrack_sctp.h
 header-y += nf_conntrack_tcp.h
 header-y += nf_conntrack_tuple_common.h
+header-y += nf_conntrack_tuple.h
+header-y += nf_nat.h
 header-y += nfnetlink.h
 header-y += nfnetlink_compat.h
 header-y += nfnetlink_conntrack.h
diff --git a/include/linux/netfilter/nf_conntrack_tuple.h b/include/linux/netfilter/nf_conntrack_tuple.h
new file mode 100644
index 0000000..5771622
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_tuple.h
@@ -0,0 +1,110 @@
+/* This file was manually copied from the Linux kernel source
+ * and manually stripped from __KERNEL__ sections and unused functions.
+ */
+
+/*
+ * Definitions and Declarations for tuple.
+ *
+ * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *	- generalize L3 protocol dependent part.
+ *
+ * Derived from include/linux/netfiter_ipv4/ip_conntrack_tuple.h
+ */
+
+#ifndef _NF_CONNTRACK_TUPLE_H
+#define _NF_CONNTRACK_TUPLE_H
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
+/* A `tuple' is a structure containing the information to uniquely
+  identify a connection.  ie. if two packets have the same tuple, they
+  are in the same connection; if not, they are not.
+
+  We divide the structure along "manipulatable" and
+  "non-manipulatable" lines, for the benefit of the NAT code.
+*/
+
+#define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
+
+/* The protocol-specific manipulable parts of the tuple: always in
+   network order! */
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
+/* The manipulable part of the tuple. */
+struct nf_conntrack_man {
+	union nf_inet_addr u3;
+	union nf_conntrack_man_proto u;
+	/* Layer 3 protocol */
+	u_int16_t l3num;
+};
+
+/* This contains the information to distinguish a connection. */
+struct nf_conntrack_tuple {
+	struct nf_conntrack_man src;
+
+	/* These are the parts of the tuple which are fixed. */
+	struct {
+		union nf_inet_addr u3;
+		union {
+			/* Add other protocols here. */
+			__be16 all;
+
+			struct {
+				__be16 port;
+			} tcp;
+			struct {
+				__be16 port;
+			} udp;
+			struct {
+				u_int8_t type, code;
+			} icmp;
+			struct {
+				__be16 port;
+			} dccp;
+			struct {
+				__be16 port;
+			} sctp;
+			struct {
+				__be16 key;
+			} gre;
+		} u;
+
+		/* The protocol. */
+		u_int8_t protonum;
+
+		/* The direction (for tuplehash) */
+		u_int8_t dir;
+	} dst;
+};
+
+struct nf_conntrack_tuple_mask {
+	struct {
+		union nf_inet_addr u3;
+		union nf_conntrack_man_proto u;
+	} src;
+};
+
+#endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
new file mode 100644
index 0000000..73c1946
--- /dev/null
+++ b/include/linux/netfilter/nf_nat.h
@@ -0,0 +1,52 @@
+#ifndef _NF_NAT_H
+#define _NF_NAT_H
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/nf_conntrack_tuple.h>
+
+#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
+
+enum nf_nat_manip_type {
+	IP_NAT_MANIP_SRC,
+	IP_NAT_MANIP_DST
+};
+
+/* SRC manip occurs POST_ROUTING or LOCAL_IN */
+#define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
+			     (hooknum) != NF_INET_LOCAL_IN)
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
+#define IP_NAT_RANGE_PERSISTENT 8
+
+/* NAT sequence number modifications */
+struct nf_nat_seq {
+	/* position of the last TCP sequence number modification (if any) */
+	u_int32_t correction_pos;
+
+	/* sequence number offset before and after last modification */
+	int16_t offset_before, offset_after;
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
+#endif
-- 
1.7.6.1

