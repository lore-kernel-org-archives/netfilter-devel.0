From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Thu, 25 Apr 2013 12:43:28 +0200
Message-ID: <1366886611-21666-2-git-send-email-fw@strlen.de>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45144 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594Ab3DYKl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:41:27 -0400
In-Reply-To: <1366886611-21666-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a partial revert of a0c885ae5a79457aa592cb70c27a7dee619762a4

Specifically, it removes the header linux/netfilter/nfnetlink_queue.h
added in that commit.

1), there is already a /usr/include/linux/netfilter/nfnetlink_queue.h,
    which is part of the linux kernel API

2), we already have
    include/libnetfilter_queue/linux_nfnetlink_queue.h

which contains the same definitions/structures/macros, so it makes
little sense to have two headers in libnetfilter_queue that share
almost their entire content.

[ worse, the nfnetlink_queue.h header reverted here actually is
incompatible with mainline kernels, since a few defines have the
wrong value ... ]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Makefile.am                               |    2 +-
 configure.ac                              |    3 +-
 include/Makefile.am                       |    2 +-
 include/linux/Makefile.am                 |    1 -
 include/linux/netfilter/Makefile.am       |    1 -
 include/linux/netfilter/nfnetlink_queue.h |   98 -----------------------------
 src/nlmsg.c                               |    2 -
 7 files changed, 3 insertions(+), 106 deletions(-)
 delete mode 100644 include/linux/Makefile.am
 delete mode 100644 include/linux/netfilter/Makefile.am
 delete mode 100644 include/linux/netfilter/nfnetlink_queue.h

diff --git a/Makefile.am b/Makefile.am
index 6b4ef77..1230dc1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,6 @@
 ACLOCAL_AMFLAGS = -I m4
 
-EXTRA_DIST = $(man_MANS) include/linux
+EXTRA_DIST = $(man_MANS)
 
 SUBDIRS = src utils include examples
 
diff --git a/configure.ac b/configure.ac
index 07747a6..649060d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,6 +32,5 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 dnl Output the makefiles
 AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
         libnetfilter_queue.pc doxygen.cfg
-	include/Makefile include/libnetfilter_queue/Makefile
-	include/linux/Makefile include/linux/netfilter/Makefile])
+	include/Makefile include/libnetfilter_queue/Makefile])
 AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
index 54ea0b4..1e766d5 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1 +1 @@
-SUBDIRS= libnetfilter_queue linux
+SUBDIRS= libnetfilter_queue
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
deleted file mode 100644
index 38eb109..0000000
--- a/include/linux/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-SUBDIRS = netfilter
diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
deleted file mode 100644
index d0937cb..0000000
--- a/include/linux/netfilter/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS = nfnetlink_queue.h
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
deleted file mode 100644
index da44b33..0000000
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ /dev/null
@@ -1,98 +0,0 @@
-#ifndef _NFNETLINK_QUEUE_H
-#define _NFNETLINK_QUEUE_H
-
-#include <linux/types.h>
-#include <linux/netfilter/nfnetlink.h>
-
-enum nfqnl_msg_types {
-	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
-	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
-	NFQNL_MSG_CONFIG,		/* connect to a particular queue */
-	NFQNL_MSG_VERDICT_BATCH,	/* batchv from userspace to kernel */
-
-	NFQNL_MSG_MAX
-};
-
-struct nfqnl_msg_packet_hdr {
-	__be32		packet_id;	/* unique ID of packet in queue */
-	__be16		hw_protocol;	/* hw protocol (network order) */
-	__u8	hook;		/* netfilter hook */
-} __attribute__ ((packed));
-
-struct nfqnl_msg_packet_hw {
-	__be16		hw_addrlen;
-	__u16	_pad;
-	__u8	hw_addr[8];
-};
-
-struct nfqnl_msg_packet_timestamp {
-	__aligned_be64	sec;
-	__aligned_be64	usec;
-};
-
-enum nfqnl_attr_type {
-	NFQA_UNSPEC,
-	NFQA_PACKET_HDR,
-	NFQA_VERDICT_HDR,		/* nfqnl_msg_verdict_hrd */
-	NFQA_MARK,			/* __u32 nfmark */
-	NFQA_TIMESTAMP,			/* nfqnl_msg_packet_timestamp */
-	NFQA_IFINDEX_INDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_OUTDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_PHYSINDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
-	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
-	NFQA_PAYLOAD,			/* opaque data payload */
-	NFQA_CT,			/* nf_conntrack_netlink.h */
-	NFQA_CT_INFO,			/* enum ip_conntrack_info */
-
-	__NFQA_MAX
-};
-#define NFQA_MAX (__NFQA_MAX - 1)
-
-struct nfqnl_msg_verdict_hdr {
-	__be32 verdict;
-	__be32 id;
-};
-
-
-enum nfqnl_msg_config_cmds {
-	NFQNL_CFG_CMD_NONE,
-	NFQNL_CFG_CMD_BIND,
-	NFQNL_CFG_CMD_UNBIND,
-	NFQNL_CFG_CMD_PF_BIND,
-	NFQNL_CFG_CMD_PF_UNBIND,
-};
-
-struct nfqnl_msg_config_cmd {
-	__u8	command;	/* nfqnl_msg_config_cmds */
-	__u8	_pad;
-	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
-};
-
-enum nfqnl_config_mode {
-	NFQNL_COPY_NONE,
-	NFQNL_COPY_META,
-	NFQNL_COPY_PACKET,
-};
-
-struct nfqnl_msg_config_params {
-	__be32		copy_range;
-	__u8	copy_mode;	/* enum nfqnl_config_mode */
-} __attribute__ ((packed));
-
-enum nfqnl_flags {
-	NFQNL_F_NONE		= 0,
-	NFQNL_F_CONNTRACK	= (1 << 0),
-};
-
-enum nfqnl_attr_config {
-	NFQA_CFG_UNSPEC,
-	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
-	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
-	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
-	NFQA_CFG_FLAGS,			/* __u32 */
-	__NFQA_CFG_MAX
-};
-#define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
-
-#endif /* _NFNETLINK_QUEUE_H */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 6c4a139..e592ebd 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -19,8 +19,6 @@
 #define __aligned_le64 __le64 __attribute__((aligned(8)))
 #endif
 
-#include <linux/netfilter/nfnetlink_queue.h>
-
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
 #include "internal.h"
-- 
1.7.8.6

