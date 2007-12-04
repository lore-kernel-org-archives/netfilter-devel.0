From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/49]: ip_queue: deobfuscate entry lookups
Date: Tue,  4 Dec 2007 13:02:39 +0100 (MET)
Message-ID: <20071204120239.2442.54439.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbXLDMCk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:40 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_queue: deobfuscate entry lookups

A queue entry lookup currently looks like this:

ipq_find_dequeue_entry -> __ipq_find_dequeue_entry ->
	__ipq_find_entry -> cmpfn -> id_cmp

Use simple open-coded list walking and kill the cmpfn for
ipq_find_dequeue_entry. Instead add it to ipq_flush (after
similar cleanups) and use ipq_flush for both complete flushes
and flushing entries related to a device.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7238d8233fc8d2eadc92d5b8920e65645b5ee235
tree e463990b0c5faba3dce9507f9beab8d7d8abc088
parent 554157a1a42a25819b2e64e59f19515828991435
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:42 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:32:29 +0100

 net/ipv4/netfilter/ip_queue.c |  101 +++++++++++++++--------------------------
 1 files changed, 37 insertions(+), 64 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 9e72246..df2957c 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -77,52 +77,6 @@ __ipq_enqueue_entry(struct ipq_queue_entry *entry)
        queue_total++;
 }
 
-/*
- * Find and return a queued entry matched by cmpfn, or return the last
- * entry if cmpfn is NULL.
- */
-static inline struct ipq_queue_entry *
-__ipq_find_entry(ipq_cmpfn cmpfn, unsigned long data)
-{
-	struct ipq_queue_entry *entry;
-
-	list_for_each_entry(entry, &queue_list, list) {
-		if (!cmpfn || cmpfn(entry, data))
-			return entry;
-	}
-	return NULL;
-}
-
-static inline void
-__ipq_dequeue_entry(struct ipq_queue_entry *entry)
-{
-	list_del(&entry->list);
-	queue_total--;
-}
-
-static inline struct ipq_queue_entry *
-__ipq_find_dequeue_entry(ipq_cmpfn cmpfn, unsigned long data)
-{
-	struct ipq_queue_entry *entry;
-
-	entry = __ipq_find_entry(cmpfn, data);
-	if (entry == NULL)
-		return NULL;
-
-	__ipq_dequeue_entry(entry);
-	return entry;
-}
-
-
-static inline void
-__ipq_flush(int verdict)
-{
-	struct ipq_queue_entry *entry;
-
-	while ((entry = __ipq_find_dequeue_entry(NULL, 0)))
-		ipq_issue_verdict(entry, verdict);
-}
-
 static inline int
 __ipq_set_mode(unsigned char mode, unsigned int range)
 {
@@ -149,31 +103,59 @@ __ipq_set_mode(unsigned char mode, unsigned int range)
 	return status;
 }
 
+static void __ipq_flush(ipq_cmpfn cmpfn, unsigned long data);
+
 static inline void
 __ipq_reset(void)
 {
 	peer_pid = 0;
 	net_disable_timestamp();
 	__ipq_set_mode(IPQ_COPY_NONE, 0);
-	__ipq_flush(NF_DROP);
+	__ipq_flush(NULL, 0);
 }
 
 static struct ipq_queue_entry *
-ipq_find_dequeue_entry(ipq_cmpfn cmpfn, unsigned long data)
+ipq_find_dequeue_entry(unsigned long id)
 {
-	struct ipq_queue_entry *entry;
+	struct ipq_queue_entry *entry = NULL, *i;
 
 	write_lock_bh(&queue_lock);
-	entry = __ipq_find_dequeue_entry(cmpfn, data);
+
+	list_for_each_entry(i, &queue_list, list) {
+		if ((unsigned long)i == id) {
+			entry = i;
+			break;
+		}
+	}
+
+	if (entry) {
+		list_del(&entry->list);
+		queue_total--;
+	}
+
 	write_unlock_bh(&queue_lock);
 	return entry;
 }
 
 static void
-ipq_flush(int verdict)
+__ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
+{
+	struct ipq_queue_entry *entry, *next;
+
+	list_for_each_entry_safe(entry, next, &queue_list, list) {
+		if (!cmpfn || cmpfn(entry, data)) {
+			list_del(&entry->list);
+			queue_total--;
+			ipq_issue_verdict(entry, NF_DROP);
+		}
+	}
+}
+
+static void
+ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 {
 	write_lock_bh(&queue_lock);
-	__ipq_flush(verdict);
+	__ipq_flush(cmpfn, data);
 	write_unlock_bh(&queue_lock);
 }
 
@@ -367,12 +349,6 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 	return 0;
 }
 
-static inline int
-id_cmp(struct ipq_queue_entry *e, unsigned long id)
-{
-	return (id == (unsigned long )e);
-}
-
 static int
 ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 {
@@ -381,7 +357,7 @@ ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 	if (vmsg->value > NF_MAX_VERDICT)
 		return -EINVAL;
 
-	entry = ipq_find_dequeue_entry(id_cmp, vmsg->id);
+	entry = ipq_find_dequeue_entry(vmsg->id);
 	if (entry == NULL)
 		return -ENOENT;
 	else {
@@ -460,10 +436,7 @@ dev_cmp(struct ipq_queue_entry *entry, unsigned long ifindex)
 static void
 ipq_dev_drop(int ifindex)
 {
-	struct ipq_queue_entry *entry;
-
-	while ((entry = ipq_find_dequeue_entry(dev_cmp, ifindex)) != NULL)
-		ipq_issue_verdict(entry, NF_DROP);
+	ipq_flush(dev_cmp, ifindex);
 }
 
 #define RCV_SKB_FAIL(err) do { netlink_ack(skb, nlh, (err)); return; } while (0)
@@ -699,7 +672,7 @@ static void __exit ip_queue_fini(void)
 {
 	nf_unregister_queue_handlers(&nfqh);
 	synchronize_net();
-	ipq_flush(NF_DROP);
+	ipq_flush(NULL, 0);
 
 	unregister_sysctl_table(ipq_sysctl_header);
 	unregister_netdevice_notifier(&ipq_dev_notifier);
