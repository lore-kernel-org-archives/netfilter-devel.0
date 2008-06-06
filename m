From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 11/11: {ip,ip6,nfnetlink}_queue: misc cleanups
Date: Fri,  6 Jun 2008 17:18:02 +0200 (MEST)
Message-ID: <20080606151800.25286.74595.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48166 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbYFFPSD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:18:03 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: {ip,ip6,nfnetlink}_queue: misc cleanups

- No need to perform data_len = 0 in the switch command, since data_len
  is initialized to 0 in the beginning of the ipq_build_packet_message()
  method.

- {ip,ip6}_queue: We can reach nlmsg_failure only from one place; skb is
  sure to be NULL when getting there; since skb is NULL, there is no need
  to check this fact and call kfree_skb().

Signed-off-by: Rami Rosen <ramirose@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fd84cffdd4024f74affc3ae7ee4026d754713c36
tree ffd5c770634c694435c555408d3a14c929a7614d
parent e0f7130611c678e99a237ecdfb065daae1e677bf
author Rami Rosen <ramirose@gmail.com> Fri, 06 Jun 2008 17:11:05 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200

 net/ipv4/netfilter/ip_queue.c   |    3 ---
 net/ipv6/netfilter/ip6_queue.c  |    3 ---
 net/netfilter/nfnetlink_queue.c |    1 -
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 26a37ce..aa33a4a 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -156,7 +156,6 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	case IPQ_COPY_META:
 	case IPQ_COPY_NONE:
 		size = NLMSG_SPACE(sizeof(*pmsg));
-		data_len = 0;
 		break;
 
 	case IPQ_COPY_PACKET:
@@ -224,8 +223,6 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	return skb;
 
 nlmsg_failure:
-	if (skb)
-		kfree_skb(skb);
 	*errp = -EINVAL;
 	printk(KERN_ERR "ip_queue: error creating packet message\n");
 	return NULL;
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 2eff3ae..1b8815f 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -159,7 +159,6 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	case IPQ_COPY_META:
 	case IPQ_COPY_NONE:
 		size = NLMSG_SPACE(sizeof(*pmsg));
-		data_len = 0;
 		break;
 
 	case IPQ_COPY_PACKET:
@@ -226,8 +225,6 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	return skb;
 
 nlmsg_failure:
-	if (skb)
-		kfree_skb(skb);
 	*errp = -EINVAL;
 	printk(KERN_ERR "ip6_queue: error creating packet message\n");
 	return NULL;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3447025..04e9c96 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -243,7 +243,6 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	switch ((enum nfqnl_config_mode)queue->copy_mode) {
 	case NFQNL_COPY_META:
 	case NFQNL_COPY_NONE:
-		data_len = 0;
 		break;
 
 	case NFQNL_COPY_PACKET:
