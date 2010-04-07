From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: use idr instead of list to speed up packet lookup
 by id
Date: Wed, 07 Apr 2010 11:38:09 +0800
Message-ID: <4BBBFE21.9070507@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63709 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0DGDiK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:38:10 -0400
Received: by gyg13 with SMTP id 13so366750gyg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2010 20:38:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use idr instead of list to speed up packet lookup by id.

The current implementations of nfnetlink_queue, ip_queue and ip6_queue
are all use list to save the packets queued. If the verdicts aren't
received in order, the lookup for the corresponding packets isn't
efficient. As the ids is generated and maintained in kernel, we can use
idr to speed up the lookup. The side effect of this patch is fixing the
potential id overlap in nfnetlink_queue.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
include/net/netfilter/nf_queue.h | 1
net/ipv4/netfilter/ip_queue.c | 64 +++++++++++++++++++++------------------
net/ipv6/netfilter/ip6_queue.c | 64 +++++++++++++++++++++------------------
net/netfilter/nfnetlink_queue.c | 59 +++++++++++++++++------------------
4 files changed, 99 insertions(+), 89 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 252fd10..c90db4a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -3,7 +3,6 @@
 
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
-	struct list_head	list;
 	struct sk_buff		*skb;
 	unsigned int		id;
 
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index e278704..24890dc 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -49,16 +49,9 @@ static unsigned int queue_total;
 static unsigned int queue_dropped = 0;
 static unsigned int queue_user_dropped = 0;
 static struct sock *ipqnl __read_mostly;
-static LIST_HEAD(queue_list);
+static struct idr idr;
 static DEFINE_MUTEX(ipqnl_mutex);
 
-static inline void
-__ipq_enqueue_entry(struct nf_queue_entry *entry)
-{
-       list_add_tail(&entry->list, &queue_list);
-       queue_total++;
-}
-
 static inline int
 __ipq_set_mode(unsigned char mode, unsigned int range)
 {
@@ -99,19 +92,13 @@ __ipq_reset(void)
 static struct nf_queue_entry *
 ipq_find_dequeue_entry(unsigned long id)
 {
-	struct nf_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry;
 
 	write_lock_bh(&queue_lock);
 
-	list_for_each_entry(i, &queue_list, list) {
-		if ((unsigned long)i == id) {
-			entry = i;
-			break;
-		}
-	}
-
-	if (entry) {
-		list_del(&entry->list);
+	entry = idr_find(&idr, id);
+	if (entry != NULL) {
+		idr_remove(&idr, id);
 		queue_total--;
 	}
 
@@ -122,14 +109,16 @@ ipq_find_dequeue_entry(unsigned long id)
 static void
 __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct nf_queue_entry *entry, *next;
+	struct nf_queue_entry *entry;
+	int id = 0;
 
-	list_for_each_entry_safe(entry, next, &queue_list, list) {
+	while ((entry = idr_get_next(&idr, &id)) != NULL) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
+			idr_remove(&idr, id);
 			queue_total--;
 			nf_reinject(entry, NF_DROP);
 		}
+		++id;
 	}
 }
 
@@ -142,7 +131,7 @@ ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 }
 
 static struct sk_buff *
-ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
+ipq_build_packet_message(struct nf_queue_entry *entry, int *errp, int *pid)
 {
 	sk_buff_data_t old_tail;
 	size_t size = 0;
@@ -151,8 +140,9 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	struct ipq_packet_msg *pmsg;
 	struct nlmsghdr *nlh;
 	struct timeval tv;
+	int id;
 
-	read_lock_bh(&queue_lock);
+	write_lock_bh(&queue_lock);
 
 	switch (copy_mode) {
 	case IPQ_COPY_META:
@@ -164,7 +154,7 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 		if ((entry->skb->ip_summed == CHECKSUM_PARTIAL ||
 		     entry->skb->ip_summed == CHECKSUM_COMPLETE) &&
 		    (*errp = skb_checksum_help(entry->skb))) {
-			read_unlock_bh(&queue_lock);
+			write_unlock_bh(&queue_lock);
 			return NULL;
 		}
 		if (copy_range == 0 || copy_range > entry->skb->len)
@@ -177,11 +167,18 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 
 	default:
 		*errp = -EINVAL;
-		read_unlock_bh(&queue_lock);
+		write_unlock_bh(&queue_lock);
 		return NULL;
 	}
 
-	read_unlock_bh(&queue_lock);
+	if (!idr_pre_get(&idr, GFP_ATOMIC) ||
+	    idr_get_new(&idr, entry, &id) != 0) {
+		*errp = -ENOMEM;
+		write_unlock_bh(&queue_lock);
+		return NULL;
+	}
+
+	write_unlock_bh(&queue_lock);
 
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb)
@@ -192,7 +189,7 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	pmsg = NLMSG_DATA(nlh);
 	memset(pmsg, 0, sizeof(*pmsg));
 
-	pmsg->packet_id       = (unsigned long )entry;
+	pmsg->packet_id       = (unsigned long )id;
 	pmsg->data_len        = data_len;
 	tv = ktime_to_timeval(entry->skb->tstamp);
 	pmsg->timestamp_sec   = tv.tv_sec;
@@ -222,11 +219,15 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 			BUG();
 
 	nlh->nlmsg_len = skb->tail - old_tail;
+	*pid = id;
 	return skb;
 
 nlmsg_failure:
 	*errp = -EINVAL;
 	printk(KERN_ERR "ip_queue: error creating packet message\n");
+	write_lock_bh(&queue_lock);
+	idr_remove(&idr, id);
+	write_unlock_bh(&queue_lock);
 	return NULL;
 }
 
@@ -234,12 +235,13 @@ static int
 ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	int status = -EINVAL;
+	int id;
 	struct sk_buff *nskb;
 
 	if (copy_mode == IPQ_COPY_NONE)
 		return -EAGAIN;
 
-	nskb = ipq_build_packet_message(entry, &status);
+	nskb = ipq_build_packet_message(entry, &status, &id);
 	if (nskb == NULL)
 		return status;
 
@@ -265,7 +267,7 @@ ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_unlock;
 	}
 
-	__ipq_enqueue_entry(entry);
+	queue_total++;
 
 	write_unlock_bh(&queue_lock);
 	return status;
@@ -274,6 +276,7 @@ err_out_free_nskb:
 	kfree_skb(nskb);
 
 err_out_unlock:
+	idr_remove(&idr, id);
 	write_unlock_bh(&queue_lock);
 	return status;
 }
@@ -575,6 +578,8 @@ static int __init ip_queue_init(void)
 	int status = -ENOMEM;
 	struct proc_dir_entry *proc __maybe_unused;
 
+	idr_init(&idr);
+
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(&init_net, NETLINK_FIREWALL, 0,
 				      ipq_rcv_skb, NULL, THIS_MODULE);
@@ -623,6 +628,7 @@ static void __exit ip_queue_fini(void)
 	nf_unregister_queue_handlers(&nfqh);
 
 	ipq_flush(NULL, 0);
+	idr_destroy(&idr);
 
 #ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 6a68a74..645eed2 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -50,16 +50,9 @@ static unsigned int queue_total;
 static unsigned int queue_dropped = 0;
 static unsigned int queue_user_dropped = 0;
 static struct sock *ipqnl __read_mostly;
-static LIST_HEAD(queue_list);
+static struct idr idr;
 static DEFINE_MUTEX(ipqnl_mutex);
 
-static inline void
-__ipq_enqueue_entry(struct nf_queue_entry *entry)
-{
-       list_add_tail(&entry->list, &queue_list);
-       queue_total++;
-}
-
 static inline int
 __ipq_set_mode(unsigned char mode, unsigned int range)
 {
@@ -100,19 +93,13 @@ __ipq_reset(void)
 static struct nf_queue_entry *
 ipq_find_dequeue_entry(unsigned long id)
 {
-	struct nf_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry;
 
 	write_lock_bh(&queue_lock);
 
-	list_for_each_entry(i, &queue_list, list) {
-		if ((unsigned long)i == id) {
-			entry = i;
-			break;
-		}
-	}
-
-	if (entry) {
-		list_del(&entry->list);
+	entry = idr_find(&idr, id);
+	if (entry != NULL) {
+		idr_remove(&idr, id);
 		queue_total--;
 	}
 
@@ -123,14 +110,16 @@ ipq_find_dequeue_entry(unsigned long id)
 static void
 __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct nf_queue_entry *entry, *next;
+	struct nf_queue_entry *entry;
+	int id = 0;
 
-	list_for_each_entry_safe(entry, next, &queue_list, list) {
+	while ((entry = idr_get_next(&idr, &id)) != NULL) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
+			idr_remove(&idr, id);
 			queue_total--;
 			nf_reinject(entry, NF_DROP);
 		}
+		++id;
 	}
 }
 
@@ -143,7 +132,7 @@ ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 }
 
 static struct sk_buff *
-ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
+ipq_build_packet_message(struct nf_queue_entry *entry, int *errp, int *pid)
 {
 	sk_buff_data_t old_tail;
 	size_t size = 0;
@@ -152,8 +141,9 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	struct ipq_packet_msg *pmsg;
 	struct nlmsghdr *nlh;
 	struct timeval tv;
+	int id;
 
-	read_lock_bh(&queue_lock);
+	write_lock_bh(&queue_lock);
 
 	switch (copy_mode) {
 	case IPQ_COPY_META:
@@ -165,7 +155,7 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 		if ((entry->skb->ip_summed == CHECKSUM_PARTIAL ||
 		     entry->skb->ip_summed == CHECKSUM_COMPLETE) &&
 		    (*errp = skb_checksum_help(entry->skb))) {
-			read_unlock_bh(&queue_lock);
+			write_unlock_bh(&queue_lock);
 			return NULL;
 		}
 		if (copy_range == 0 || copy_range > entry->skb->len)
@@ -178,11 +168,18 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 
 	default:
 		*errp = -EINVAL;
-		read_unlock_bh(&queue_lock);
+		write_unlock_bh(&queue_lock);
 		return NULL;
 	}
 
-	read_unlock_bh(&queue_lock);
+	if (!idr_pre_get(&idr, GFP_ATOMIC) ||
+	    idr_get_new(&idr, entry, &id) != 0) {
+		*errp = -ENOMEM;
+		write_unlock_bh(&queue_lock);
+		return NULL;
+	}
+
+	write_unlock_bh(&queue_lock);
 
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb)
@@ -193,7 +190,7 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 	pmsg = NLMSG_DATA(nlh);
 	memset(pmsg, 0, sizeof(*pmsg));
 
-	pmsg->packet_id       = (unsigned long )entry;
+	pmsg->packet_id       = (unsigned long )id;
 	pmsg->data_len        = data_len;
 	tv = ktime_to_timeval(entry->skb->tstamp);
 	pmsg->timestamp_sec   = tv.tv_sec;
@@ -222,11 +219,15 @@ ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 			BUG();
 
 	nlh->nlmsg_len = skb->tail - old_tail;
+	*pid = id;
 	return skb;
 
 nlmsg_failure:
 	*errp = -EINVAL;
 	printk(KERN_ERR "ip6_queue: error creating packet message\n");
+	write_lock_bh(&queue_lock);
+	idr_remove(&idr, id);
+	write_unlock_bh(&queue_lock);
 	return NULL;
 }
 
@@ -234,12 +235,13 @@ static int
 ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	int status = -EINVAL;
+	int id;
 	struct sk_buff *nskb;
 
 	if (copy_mode == IPQ_COPY_NONE)
 		return -EAGAIN;
 
-	nskb = ipq_build_packet_message(entry, &status);
+	nskb = ipq_build_packet_message(entry, &status, &id);
 	if (nskb == NULL)
 		return status;
 
@@ -265,7 +267,7 @@ ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_unlock;
 	}
 
-	__ipq_enqueue_entry(entry);
+	queue_total++;
 
 	write_unlock_bh(&queue_lock);
 	return status;
@@ -274,6 +276,7 @@ err_out_free_nskb:
 	kfree_skb(nskb);
 
 err_out_unlock:
+	idr_remove(&idr, id);
 	write_unlock_bh(&queue_lock);
 	return status;
 }
@@ -576,6 +579,8 @@ static int __init ip6_queue_init(void)
 	int status = -ENOMEM;
 	struct proc_dir_entry *proc __maybe_unused;
 
+	idr_init(&idr);
+
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(&init_net, NETLINK_IP6_FW, 0,
 			              ipq_rcv_skb, NULL, THIS_MODULE);
@@ -625,6 +630,7 @@ static void __exit ip6_queue_fini(void)
 	nf_unregister_queue_handlers(&nfqh);
 
 	ipq_flush(NULL, 0);
+	idr_destroy(&idr);
 
 #ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e70a6ef..6a6fd07 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -50,14 +50,12 @@ struct nfqnl_instance {
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
 
-	unsigned int id_sequence;		/* 'sequence' of pkt ids */
-
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
 
 	spinlock_t lock;
 
-	struct list_head queue_list;		/* packets in queue */
+	struct idr	idr;
 };
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
@@ -112,7 +110,7 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
-	INIT_LIST_HEAD(&inst->queue_list);
+	idr_init(&inst->idr);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
@@ -143,6 +141,7 @@ instance_destroy_rcu(struct rcu_head *head)
 						   rcu);
 
 	nfqnl_flush(inst, NULL, 0);
+	idr_destroy(&inst->idr);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -162,29 +161,16 @@ instance_destroy(struct nfqnl_instance *inst)
 	spin_unlock(&instances_lock);
 }
 
-static inline void
-__enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
-{
-       list_add_tail(&entry->list, &queue->queue_list);
-       queue->queue_total++;
-}
-
 static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-	struct nf_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry;
 
 	spin_lock_bh(&queue->lock);
 
-	list_for_each_entry(i, &queue->queue_list, list) {
-		if (i->id == id) {
-			entry = i;
-			break;
-		}
-	}
-
-	if (entry) {
-		list_del(&entry->list);
+	entry = idr_find(&queue->idr, id);
+	if (entry != NULL) {
+		idr_remove(&queue->idr, id);
 		queue->queue_total--;
 	}
 
@@ -196,22 +182,24 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
-	struct nf_queue_entry *entry, *next;
+	struct nf_queue_entry *entry;
+	int id = 0;
 
 	spin_lock_bh(&queue->lock);
-	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
+	while ((entry = idr_get_next(&queue->idr, &id)) != NULL) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
+			idr_remove(&queue->idr, id);
 			queue->queue_total--;
 			nf_reinject(entry, NF_DROP);
 		}
+		++id;
 	}
 	spin_unlock_bh(&queue->lock);
 }
 
 static struct sk_buff *
 nfqnl_build_packet_message(struct nfqnl_instance *queue,
-			   struct nf_queue_entry *entry)
+			   struct nf_queue_entry *entry, u32 *pid)
 {
 	sk_buff_data_t old_tail;
 	size_t size;
@@ -223,6 +211,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct sk_buff *entskb = entry->skb;
 	struct net_device *indev;
 	struct net_device *outdev;
+	u32 id;
 
 	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -262,7 +251,11 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		break;
 	}
 
-	entry->id = queue->id_sequence++;
+	if (!idr_pre_get(&queue->idr, GFP_ATOMIC) ||
+	    idr_get_new(&queue->idr, entry, &id) != 0) {
+	    	spin_unlock_bh(&queue->lock);
+		return NULL;
+	}
 
 	spin_unlock_bh(&queue->lock);
 
@@ -279,7 +272,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	nfmsg->version = NFNETLINK_V0;
 	nfmsg->res_id = htons(queue->queue_num);
 
-	pmsg.packet_id 		= htonl(entry->id);
+	pmsg.packet_id 		= htonl(id);
 	pmsg.hw_protocol	= entskb->protocol;
 	pmsg.hook		= entry->hook;
 
@@ -375,6 +368,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->tail - old_tail;
+	*pid = id;
 	return skb;
 
 nlmsg_failure:
@@ -383,6 +377,9 @@ nla_put_failure:
 		kfree_skb(skb);
 	if (net_ratelimit())
 		printk(KERN_ERR "nf_queue: error creating packet message\n");
+	spin_lock_bh(&queue->lock);
+	idr_remove(&queue->idr, id);
+	spin_unlock_bh(&queue->lock);
 	return NULL;
 }
 
@@ -392,6 +389,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
 	int err;
+	u32 id;
 
 	/* rcu_read_lock()ed by nf_hook_slow() */
 	queue = instance_lookup(queuenum);
@@ -401,7 +399,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	if (queue->copy_mode == NFQNL_COPY_NONE)
 		goto err_out;
 
-	nskb = nfqnl_build_packet_message(queue, entry);
+	nskb = nfqnl_build_packet_message(queue, entry, &id);
 	if (nskb == NULL)
 		goto err_out;
 
@@ -426,7 +424,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_unlock;
 	}
 
-	__enqueue_entry(queue, entry);
+	queue->queue_total++;
 
 	spin_unlock_bh(&queue->lock);
 	return 0;
@@ -434,6 +432,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
+	idr_remove(&queue->idr, id);
 	spin_unlock_bh(&queue->lock);
 err_out:
 	return -1;
@@ -867,7 +866,7 @@ static int seq_show(struct seq_file *s, void *v)
 			  inst->peer_pid, inst->queue_total,
 			  inst->copy_mode, inst->copy_range,
 			  inst->queue_dropped, inst->queue_user_dropped,
-			  inst->id_sequence, 1);
+			  0, 1);
 }
 
 static const struct seq_operations nfqnl_seq_ops = {

