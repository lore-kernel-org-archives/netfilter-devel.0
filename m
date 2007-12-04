From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/49]: nf_queue: remove unused data pointer
Date: Tue,  4 Dec 2007 13:02:33 +0100 (MET)
Message-ID: <20071204120233.2442.71451.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62182 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXLDMCe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:34 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: remove unused data pointer

Remove the data pointer from struct nf_queue_handler. It has never been used
and is useless for the only handler that really matters, nfnetlink_queue,
since the handler is shared between all instances.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ed35b6d3d2fe607f86dff296349a4c13d0f38720
tree 7409927263da34926ad93b1ead0584cad859ac9d
parent 36e4c3f3efcf0041dd8a5f410dbb7565b97d1382
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:31:05 +0100

 include/linux/netfilter.h       |    3 +--
 net/ipv4/netfilter/ip_queue.c   |    2 +-
 net/ipv6/netfilter/ip6_queue.c  |    2 +-
 net/netfilter/nf_queue.c        |    2 +-
 net/netfilter/nfnetlink_queue.c |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c2c3faf..1ba6011 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -277,8 +277,7 @@ int compat_nf_getsockopt(struct sock *sk, int pf, int optval,
 /* Packet queuing */
 struct nf_queue_handler {
 	int (*outfn)(struct sk_buff *skb, struct nf_info *info,
-		     unsigned int queuenum, void *data);
-	void *data;
+		     unsigned int queuenum);
 	char *name;
 };
 extern int nf_register_queue_handler(int pf,
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 062ff19..08e7f8b 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -272,7 +272,7 @@ nlmsg_failure:
 
 static int
 ipq_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		   unsigned int queuenum, void *data)
+		   unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index d6e971b..5a9ca0d 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -269,7 +269,7 @@ nlmsg_failure:
 
 static int
 ipq_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		   unsigned int queuenum, void *data)
+		   unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index dd18126..c098ccb 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -153,7 +153,7 @@ static int __nf_queue(struct sk_buff *skb,
 	}
 #endif
 	afinfo->saveroute(skb, info);
-	status = qh->outfn(skb, info, queuenum, qh->data);
+	status = qh->outfn(skb, info, queuenum);
 
 	rcu_read_unlock();
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b75091c..94ec1c2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -534,7 +534,7 @@ nla_put_failure:
 
 static int
 nfqnl_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		     unsigned int queuenum, void *data)
+		     unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
