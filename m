From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v4 6/7] netfilter: remove route_key_size field in struct nf_afinfo
Date: Wed, 27 Dec 2017 18:15:46 +0100
Message-ID: <20171227171547.4354-7-pablo@netfilter.org>
References: <20171227171547.4354-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbdL0RP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 12:15:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3A505B4979
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A0D253CDE
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 064F7DA3A6
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:56 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CCA9D4265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:55 +0100 (CET)
In-Reply-To: <20171227171547.4354-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only needed by nf_queue, place this code where it belongs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h |  1 -
 net/ipv4/netfilter.c      |  1 -
 net/ipv6/netfilter.c      |  1 -
 net/netfilter/nf_queue.c  | 22 ++++++++++++++++------
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 8358e717eabd..58a169e425f7 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,7 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	int		route_key_size;
 };
 
 extern const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO];
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index ec73be3b2f14..bd8e161c2f95 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -164,7 +164,6 @@ EXPORT_SYMBOL_GPL(nf_ip_route);
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
 static int __init ipv4_netfilter_init(void)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d633b78be06f..18f82a3fb0c0 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -176,7 +176,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.route_key_size		= sizeof(struct ip6_rt_info),
 };
 
 int __init ipv6_netfilter_init(void)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 15382ff83e7a..7f55af5f3d1a 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -15,6 +15,8 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <net/protocol.h>
 #include <net/netfilter/nf_queue.h>
 #include <net/dst.h>
@@ -145,9 +147,9 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
-	const struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
 	struct net *net = state->net;
+	unsigned int route_key_size;
 
 	/* QUEUE == DROP if no one is waiting, to be safe. */
 	qh = rcu_dereference(net->nf.queue_handler);
@@ -156,11 +158,19 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	afinfo = nf_get_afinfo(state->pf);
-	if (!afinfo)
-		goto err;
+	switch (state->pf) {
+	case AF_INET:
+		route_key_size = sizeof(struct ip_rt_info);
+		break;
+	case AF_INET6:
+		route_key_size = sizeof(struct ip6_rt_info);
+		break;
+	default:
+		route_key_size = 0;
+		break;
+	}
 
-	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry) {
 		status = -ENOMEM;
 		goto err;
@@ -170,7 +180,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.skb	= skb,
 		.state	= *state,
 		.hook_index = index,
-		.size	= sizeof(*entry) + afinfo->route_key_size,
+		.size	= sizeof(*entry) + route_key_size,
 	};
 
 	nf_queue_entry_get_refs(entry);
-- 
2.11.0

