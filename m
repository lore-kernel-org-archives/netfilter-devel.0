From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/49]: {nf_netlink,ip,ip6}_queue: use list_for_each_entry
Date: Tue,  4 Dec 2007 13:02:36 +0100 (MET)
Message-ID: <20071204120236.2442.79847.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62188 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXLDMCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:37 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {nf_netlink,ip,ip6}_queue: use list_for_each_entry

Use list_add_tail/list_for_each_entry instead of list_add and
list_for_each_prev as a preparation for switching to RCU.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5a6886e29d4d9cd1ac4f91073ae30163446512ef
tree 1d3512786533a3b98553059e137ba228e396d084
parent 39c53418dafbd3d8b9173420294bdd4a2c637b7c
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:35 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:32:16 +0100

 net/ipv4/netfilter/ip_queue.c   |    8 +++-----
 net/ipv6/netfilter/ip6_queue.c  |    8 +++-----
 net/netfilter/nfnetlink_queue.c |    8 +++-----
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 2966fbd..9e72246 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -73,7 +73,7 @@ ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 static inline void
 __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 {
-       list_add(&entry->list, &queue_list);
+       list_add_tail(&entry->list, &queue_list);
        queue_total++;
 }
 
@@ -84,11 +84,9 @@ __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 static inline struct ipq_queue_entry *
 __ipq_find_entry(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct list_head *p;
-
-	list_for_each_prev(p, &queue_list) {
-		struct ipq_queue_entry *entry = (struct ipq_queue_entry *)p;
+	struct ipq_queue_entry *entry;
 
+	list_for_each_entry(entry, &queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data))
 			return entry;
 	}
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 7ff9915..243a00b 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -71,7 +71,7 @@ ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 static inline void
 __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 {
-       list_add(&entry->list, &queue_list);
+       list_add_tail(&entry->list, &queue_list);
        queue_total++;
 }
 
@@ -82,11 +82,9 @@ __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 static inline struct ipq_queue_entry *
 __ipq_find_entry(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct list_head *p;
-
-	list_for_each_prev(p, &queue_list) {
-		struct ipq_queue_entry *entry = (struct ipq_queue_entry *)p;
+	struct ipq_queue_entry *entry;
 
+	list_for_each_entry(entry, &queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data))
 			return entry;
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3a09f02..74d5ed9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -231,7 +231,7 @@ static inline void
 __enqueue_entry(struct nfqnl_instance *queue,
 		      struct nfqnl_queue_entry *entry)
 {
-       list_add(&entry->list, &queue->queue_list);
+       list_add_tail(&entry->list, &queue->queue_list);
        queue->queue_total++;
 }
 
@@ -243,11 +243,9 @@ static inline struct nfqnl_queue_entry *
 __find_entry(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
 		   unsigned long data)
 {
-	struct list_head *p;
-
-	list_for_each_prev(p, &queue->queue_list) {
-		struct nfqnl_queue_entry *entry = (struct nfqnl_queue_entry *)p;
+	struct nfqnl_queue_entry *entry;
 
+	list_for_each_entry(entry, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data))
 			return entry;
 	}
