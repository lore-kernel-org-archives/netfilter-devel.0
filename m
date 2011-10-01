From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: [PATCH] netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH
Date: Sat,  1 Oct 2011 13:51:29 -0400
Message-ID: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu>
Cc: kaber@trash.net, basile@opensource.dyc.edu, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.ddl.dyc.edu ([67.151.215.230]:54599 "EHLO ddl.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1JARsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:48:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Anthony G. Basile" <basile@opensource.dyc.edu>

This exports the sanitized version of nf_nat.h for userland
applications, like iptables and miniupnpd, which make use of
binary representations of NAT provided by netfilter.

This patch makes the API header public by installing it in
INSTALL_HDR_PATH.

See: https://bugs.gentoo.org/376873

Signed-off-by: Anthony G. Basile <blueness@gentoo.org>
---
 include/linux/netfilter/Kbuild   |    1 +
 include/linux/netfilter/nf_nat.h |   39 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/nf_nat.h

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index a1b410c..d81f771 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -5,6 +5,7 @@ header-y += nf_conntrack_ftp.h
 header-y += nf_conntrack_sctp.h
 header-y += nf_conntrack_tcp.h
 header-y += nf_conntrack_tuple_common.h
+header-y += nf_nat.h
 header-y += nfnetlink.h
 header-y += nfnetlink_compat.h
 header-y += nfnetlink_conntrack.h
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
new file mode 100644
index 0000000..3360f39
--- /dev/null
+++ b/include/linux/netfilter/nf_nat.h
@@ -0,0 +1,39 @@
+#ifndef _NF_NAT_H
+#define _NF_NAT_H
+#include <linux/types.h>
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
+#define IP_NAT_RANGE_PERSISTENT 8
+
+/* The protocol-specific manipulable parts of the tuple */
+union nf_conntrack_man_proto {
+	__be16 all;
+	__be16 port;
+	__be16 icmp_idnt;
+	__be16 gre_key;
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

