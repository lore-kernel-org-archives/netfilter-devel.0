From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/11] netfilter: queue: use NFPROTO_ for queue callsites
Date: Fri,  8 May 2009 11:26:32 +0200
Message-ID: <1241774801-2315-3-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53346 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZEHJ0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:42 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

af is an nfproto.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_queue.c  |    2 +-
 net/ipv6/netfilter/ip6_queue.c |    2 +-
 net/netfilter/nf_queue.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 5f22c91..c156db2 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -596,7 +596,7 @@ static int __init ip_queue_init(void)
 #ifdef CONFIG_SYSCTL
 	ipq_sysctl_header = register_sysctl_paths(net_ipv4_ctl_path, ipq_table);
 #endif
-	status = nf_register_queue_handler(PF_INET, &nfqh);
+	status = nf_register_queue_handler(NFPROTO_IPV4, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip_queue: failed to register queue handler\n");
 		goto cleanup_sysctl;
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index b693f84..1cf3f0c 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -598,7 +598,7 @@ static int __init ip6_queue_init(void)
 #ifdef CONFIG_SYSCTL
 	ipq_sysctl_header = register_sysctl_paths(net_ipv6_ctl_path, ipq_table);
 #endif
-	status = nf_register_queue_handler(PF_INET6, &nfqh);
+	status = nf_register_queue_handler(NFPROTO_IPV6, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip6_queue: failed to register queue handler\n");
 		goto cleanup_sysctl;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 4f2310c..3a6fd77 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -204,10 +204,10 @@ int nf_queue(struct sk_buff *skb,
 				  queuenum);
 
 	switch (pf) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		skb->protocol = htons(ETH_P_IP);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	}
-- 
1.6.2.2

