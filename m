From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/13: cleanup netfilter_ipv6.h userspace header
Date: Mon,  7 Jul 2008 14:05:21 +0200 (MEST)
Message-ID: <20080707120520.4975.96847.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYGGMFW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:22 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: cleanup netfilter_ipv6.h userspace header

Kernel functions are not for userspace.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fa30a357f95a548526ffe578a57ff55fb2646674
tree 61ec88d0f6bf116a21131a796d6283a504c33bbe
parent 92b669eedbfbca32d05723764afb243b6d8faeed
author Adrian Bunk <bunk@kernel.org> Mon, 07 Jul 2008 13:00:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:16 +0200

 include/linux/netfilter_ipv6.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index fd50988..d654873 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -70,6 +70,8 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_LAST = INT_MAX,
 };
 
+#ifdef  __KERNEL__
+
 #ifdef CONFIG_NETFILTER
 extern int ip6_route_me_harder(struct sk_buff *skb);
 extern __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
@@ -82,4 +84,6 @@ static inline int ipv6_netfilter_init(void) { return 0; }
 static inline void ipv6_netfilter_fini(void) { return; }
 #endif /* CONFIG_NETFILTER */
 
+#endif /* __KERNEL__ */
+
 #endif /*__LINUX_IP6_NETFILTER_H*/
