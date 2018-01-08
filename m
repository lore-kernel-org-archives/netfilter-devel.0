From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/52] netfilter: add defines for arp/decnet max hooks
Date: Mon,  8 Jan 2018 21:19:22 +0100
Message-ID: <20180108202000.12989-15-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756947AbeAHUUU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3676E7B8D
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B559253CDE
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:19 +0100 (CET)
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

The kernel already has defines for this, but they are in uapi exposed
headers.

Including these from netns.h causes build errors and also adds unneeded
dependencies on heads that we don't need.

So move these defines to netfilter_defs.h and place the uapi ones
in ifndef __KERNEL__ to keep them for userspace.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_defs.h        | 6 ++++++
 include/uapi/linux/netfilter_arp.h    | 3 +++
 include/uapi/linux/netfilter_decnet.h | 4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_defs.h b/include/linux/netfilter_defs.h
index dc6111adea06..fdcdf2bf34df 100644
--- a/include/linux/netfilter_defs.h
+++ b/include/linux/netfilter_defs.h
@@ -7,4 +7,10 @@
 /* Largest hook number + 1, see uapi/linux/netfilter_decnet.h */
 #define NF_MAX_HOOKS 8
 
+/* in/out/forward only */
+#define NF_ARP_NUMHOOKS 3
+
+/* max hook is NF_DN_ROUTE (6), also see uapi/linux/netfilter_decnet.h */
+#define NF_DN_NUMHOOKS 7
+
 #endif
diff --git a/include/uapi/linux/netfilter_arp.h b/include/uapi/linux/netfilter_arp.h
index 81b6a4cbcb72..791dfc5ae907 100644
--- a/include/uapi/linux/netfilter_arp.h
+++ b/include/uapi/linux/netfilter_arp.h
@@ -15,6 +15,9 @@
 #define NF_ARP_IN	0
 #define NF_ARP_OUT	1
 #define NF_ARP_FORWARD	2
+
+#ifndef __KERNEL__
 #define NF_ARP_NUMHOOKS	3
+#endif
 
 #endif /* __LINUX_ARP_NETFILTER_H */
diff --git a/include/uapi/linux/netfilter_decnet.h b/include/uapi/linux/netfilter_decnet.h
index 9089c38f6abe..61f1c7dfd033 100644
--- a/include/uapi/linux/netfilter_decnet.h
+++ b/include/uapi/linux/netfilter_decnet.h
@@ -24,6 +24,9 @@
 #define NFC_DN_IF_IN		0x0004
 /* Output device. */
 #define NFC_DN_IF_OUT		0x0008
+
+/* kernel define is in netfilter_defs.h */
+#define NF_DN_NUMHOOKS		7
 #endif /* ! __KERNEL__ */
 
 /* DECnet Hooks */
@@ -41,7 +44,6 @@
 #define NF_DN_HELLO		5
 /* Input Routing Packets */
 #define NF_DN_ROUTE		6
-#define NF_DN_NUMHOOKS		7
 
 enum nf_dn_hook_priorities {
 	NF_DN_PRI_FIRST = INT_MIN,
-- 
2.11.0

