From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/49]: nf_queue: make queue_handler const
Date: Tue,  4 Dec 2007 13:02:32 +0100 (MET)
Message-ID: <20071204120232.2442.67173.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62179 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXLDMCd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:33 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: make queue_handler const

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 36e4c3f3efcf0041dd8a5f410dbb7565b97d1382
tree cc9f5b47c0261b11f074d2a03918ce884577c17b
parent 4e99305d42d41620d4009da54be297970da7c0f7
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:30:58 +0100

 include/linux/netfilter.h       |    8 ++++----
 net/ipv4/netfilter/ip_queue.c   |    2 +-
 net/ipv6/netfilter/ip6_queue.c  |    2 +-
 net/netfilter/nf_queue.c        |   12 ++++++------
 net/netfilter/nfnetlink_queue.c |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9bfc7d4..c2c3faf 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -281,11 +281,11 @@ struct nf_queue_handler {
 	void *data;
 	char *name;
 };
-extern int nf_register_queue_handler(int pf, 
-                                     struct nf_queue_handler *qh);
+extern int nf_register_queue_handler(int pf,
+				     const struct nf_queue_handler *qh);
 extern int nf_unregister_queue_handler(int pf,
-				       struct nf_queue_handler *qh);
-extern void nf_unregister_queue_handlers(struct nf_queue_handler *qh);
+				       const struct nf_queue_handler *qh);
+extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
 extern void nf_reinject(struct sk_buff *skb,
 			struct nf_info *info,
 			unsigned int verdict);
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 14d64a3..062ff19 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -645,7 +645,7 @@ static const struct file_operations ip_queue_proc_fops = {
 	.owner		= THIS_MODULE,
 };
 
-static struct nf_queue_handler nfqh = {
+static const struct nf_queue_handler nfqh = {
 	.name	= "ip_queue",
 	.outfn	= &ipq_enqueue_packet,
 };
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index e273605..d6e971b 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -634,7 +634,7 @@ static const struct file_operations ip6_queue_proc_fops = {
 	.owner		= THIS_MODULE,
 };
 
-static struct nf_queue_handler nfqh = {
+static const struct nf_queue_handler nfqh = {
 	.name	= "ip6_queue",
 	.outfn	= &ipq_enqueue_packet,
 };
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 0bea88c..dd18126 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -15,13 +15,13 @@
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static struct nf_queue_handler *queue_handler[NPROTO];
+static const struct nf_queue_handler *queue_handler[NPROTO];
 
 static DEFINE_MUTEX(queue_handler_mutex);
 
 /* return EBUSY when somebody else is registered, return EEXIST if the
  * same handler is registered, return 0 in case of success. */
-int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
+int nf_register_queue_handler(int pf, const struct nf_queue_handler *qh)
 {
 	int ret;
 
@@ -44,7 +44,7 @@ int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
 EXPORT_SYMBOL(nf_register_queue_handler);
 
 /* The caller must flush their queue before this */
-int nf_unregister_queue_handler(int pf, struct nf_queue_handler *qh)
+int nf_unregister_queue_handler(int pf, const struct nf_queue_handler *qh)
 {
 	if (pf >= NPROTO)
 		return -EINVAL;
@@ -64,7 +64,7 @@ int nf_unregister_queue_handler(int pf, struct nf_queue_handler *qh)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-void nf_unregister_queue_handlers(struct nf_queue_handler *qh)
+void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 {
 	int pf;
 
@@ -98,7 +98,7 @@ static int __nf_queue(struct sk_buff *skb,
 	struct net_device *physoutdev = NULL;
 #endif
 	struct nf_afinfo *afinfo;
-	struct nf_queue_handler *qh;
+	const struct nf_queue_handler *qh;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	rcu_read_lock();
@@ -313,7 +313,7 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	int ret;
 	loff_t *pos = v;
-	struct nf_queue_handler *qh;
+	const struct nf_queue_handler *qh;
 
 	rcu_read_lock();
 	qh = rcu_dereference(queue_handler[*pos]);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3ceeffc..b75091c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -849,7 +849,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
 	[NFQA_CFG_PARAMS]	= { .len = sizeof(struct nfqnl_msg_config_params) },
 };
 
-static struct nf_queue_handler nfqh = {
+static const struct nf_queue_handler nfqh = {
 	.name 	= "nf_queue",
 	.outfn	= &nfqnl_enqueue_packet,
 };
