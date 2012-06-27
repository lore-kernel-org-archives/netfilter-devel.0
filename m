From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH] netfilter: nfnetlink_queue: Don't set random flag bits
Date: Wed, 27 Jun 2012 16:29:56 +0530
Message-ID: <20120627105956.26473.95573.sendpatchset@localhost.localdomain>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56460 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2F0LAF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:00:05 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Wed, 27 Jun 2012 10:56:51 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q5RAxxJY57212944
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jun 2012 20:59:59 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q5RAxx1c000954
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jun 2012 20:59:59 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow setting of only supported flag bits in queue->flags.

If this is OK, I can send a patch to add this flag to
libnetfilter_queue too.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/linux/netfilter/nfnetlink_queue.h |    2 ++
 net/netfilter/nfnetlink_queue_core.c      |    6 ++++++
 2 files changed, 8 insertions(+)

diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
--- org/include/linux/netfilter/nfnetlink_queue.h	2012-06-18 08:36:53.000000000 +0530
+++ new/include/linux/netfilter/nfnetlink_queue.h	2012-06-27 16:25:54.297619352 +0530
@@ -96,4 +96,6 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
 
+#define NFQA_CFG_F_FLAGS_MAX			(1 << 2)
+
 #endif /* _NFNETLINK_QUEUE_H */
diff -ruNp org/net/netfilter/nfnetlink_queue_core.c new/net/netfilter/nfnetlink_queue_core.c
--- org/net/netfilter/nfnetlink_queue_core.c	2012-06-27 12:34:02.000000000 +0530
+++ new/net/netfilter/nfnetlink_queue_core.c	2012-06-27 14:00:46.153670918 +0530
@@ -910,6 +910,12 @@ nfqnl_recv_config(struct sock *ctnl, str
 		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
 		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
 
+		if (flags >= NFQA_CFG_F_FLAGS_MAX) {
+			/* flags has more bits than what is supported */
+			ret = -EOPNOTSUPP;
+			goto err_out_unlock;
+		}
+
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;

