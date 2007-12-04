From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 35/49]: {nfnetlink,ip,ip6}_queue: kill issue_verdict
Date: Tue,  4 Dec 2007 13:02:45 +0100 (MET)
Message-ID: <20071204120244.2442.97121.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62210 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXLDMCq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:46 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {nfnetlink,ip,ip6}_queue: kill issue_verdict

Now that issue_verdict doesn't need to free the queue entries anymore,
all it does is disable local BHs and call nf_reinject. Move the BH
disabling to the okfn invocation in nf_reinject and kill the
issue_verdict functions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 79f4f2de87033501ea05a8d47634a8cffd51418c
tree 6614f9abb1050f071f8e61e4142accb54b0fd776
parent 9522be669a4499574be6df2228b6bd6e8d77b037
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:31 +0100

 net/ipv4/netfilter/ip_queue.c   |   17 ++---------------
 net/ipv6/netfilter/ip6_queue.c  |   12 ++----------
 net/netfilter/nf_queue.c        |    2 ++
 net/netfilter/nfnetlink_queue.c |   21 ++-------------------
 4 files changed, 8 insertions(+), 44 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index f1affd2..68b12ce 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -49,19 +49,6 @@ static struct sock *ipqnl __read_mostly;
 static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
-static void
-ipq_issue_verdict(struct nf_queue_entry *entry, int verdict)
-{
-	/* TCP input path (and probably other bits) assume to be called
-	 * from softirq context, not from syscall, like ipq_issue_verdict is
-	 * called.  TCP input path deadlocks with locks taken from timer
-	 * softirq, e.g.  We therefore emulate this by local_bh_disable() */
-
-	local_bh_disable();
-	nf_reinject(entry, verdict);
-	local_bh_enable();
-}
-
 static inline void
 __ipq_enqueue_entry(struct nf_queue_entry *entry)
 {
@@ -138,7 +125,7 @@ __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 		if (!cmpfn || cmpfn(entry, data)) {
 			list_del(&entry->list);
 			queue_total--;
-			ipq_issue_verdict(entry, NF_DROP);
+			nf_reinject(entry, NF_DROP);
 		}
 	}
 }
@@ -345,7 +332,7 @@ ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 			if (ipq_mangle_ipv4(vmsg, entry) < 0)
 				verdict = NF_DROP;
 
-		ipq_issue_verdict(entry, verdict);
+		nf_reinject(entry, verdict);
 		return 0;
 	}
 }
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 9014ada..e5b0059 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -53,14 +53,6 @@ static struct sock *ipqnl __read_mostly;
 static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
-static void
-ipq_issue_verdict(struct nf_queue_entry *entry, int verdict)
-{
-	local_bh_disable();
-	nf_reinject(entry, verdict);
-	local_bh_enable();
-}
-
 static inline void
 __ipq_enqueue_entry(struct nf_queue_entry *entry)
 {
@@ -137,7 +129,7 @@ __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 		if (!cmpfn || cmpfn(entry, data)) {
 			list_del(&entry->list);
 			queue_total--;
-			ipq_issue_verdict(entry, NF_DROP);
+			nf_reinject(entry, NF_DROP);
 		}
 	}
 }
@@ -343,7 +335,7 @@ ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 			if (ipq_mangle_ipv6(vmsg, entry) < 0)
 				verdict = NF_DROP;
 
-		ipq_issue_verdict(entry, verdict);
+		nf_reinject(entry, verdict);
 		return 0;
 	}
 }
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d9d3dc4..f0dc727 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -275,7 +275,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
+		local_bh_disable();
 		entry->okfn(skb);
+		local_bh_enable();
 	case NF_STOLEN:
 		break;
 	case NF_QUEUE:
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a493764..d9ce394 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -202,23 +202,6 @@ instance_destroy(struct nfqnl_instance *inst)
 	_instance_destroy2(inst, 1);
 }
 
-
-
-static void
-issue_verdict(struct nf_queue_entry *entry, int verdict)
-{
-	QDEBUG("entering for entry %p, verdict %u\n", entry, verdict);
-
-	/* TCP input path (and probably other bits) assume to be called
-	 * from softirq context, not from syscall, like issue_verdict is
-	 * called.  TCP input path deadlocks with locks taken from timer
-	 * softirq, e.g.  We therefore emulate this by local_bh_disable() */
-
-	local_bh_disable();
-	nf_reinject(entry, verdict);
-	local_bh_enable();
-}
-
 static inline void
 __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
@@ -289,7 +272,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 		if (!cmpfn || cmpfn(entry, data)) {
 			list_del(&entry->list);
 			queue->queue_total--;
-			issue_verdict(entry, NF_DROP);
+			nf_reinject(entry, NF_DROP);
 		}
 	}
 	spin_unlock_bh(&queue->lock);
@@ -761,7 +744,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		entry->skb->mark = ntohl(*(__be32 *)
 					 nla_data(nfqa[NFQA_MARK]));
 
-	issue_verdict(entry, verdict);
+	nf_reinject(entry, verdict);
 	instance_put(queue);
 	return 0;
 
