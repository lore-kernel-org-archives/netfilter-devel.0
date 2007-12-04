From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/49]: nf_queue: move list_head/skb/id to struct nf_info
Date: Tue,  4 Dec 2007 13:02:43 +0100 (MET)
Message-ID: <20071204120243.2442.28616.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62206 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbXLDMCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:45 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: move list_head/skb/id to struct nf_info

Move common fields for queue management to struct nf_info and rename it
to struct nf_queue_entry. The avoids one allocation/free per packet and
simplifies the code a bit.

Alternatively we could add some private room at the tail, but since
all current users use identical structs this seems easier.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9522be669a4499574be6df2228b6bd6e8d77b037
tree 970b62e1799f15fae7077fe8d756f89901ed8b5f
parent e7a1b1cd873707620365c477874645736b9388a6
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:51 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:27 +0100

 include/linux/netfilter.h        |    6 ++-
 include/net/netfilter/nf_queue.h |   14 ++++---
 net/ipv4/netfilter.c             |   14 ++++---
 net/ipv4/netfilter/ip_queue.c    |   68 ++++++++++++-----------------------
 net/ipv6/netfilter.c             |   14 ++++---
 net/ipv6/netfilter/ip6_queue.c   |   67 ++++++++++++----------------------
 net/netfilter/nf_queue.c         |   65 ++++++++++++++++++---------------
 net/netfilter/nfnetlink_queue.c  |   74 ++++++++++++--------------------------
 8 files changed, 132 insertions(+), 190 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 5fe4ef4..f25eec5 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -270,7 +270,7 @@ extern void nf_invalidate_cache(int pf);
 extern int skb_make_writable(struct sk_buff *skb, unsigned int writable_len);
 
 struct flowi;
-struct nf_info;
+struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
@@ -278,9 +278,9 @@ struct nf_afinfo {
 				    unsigned int dataoff, u_int8_t protocol);
 	int		(*route)(struct dst_entry **dst, struct flowi *fl);
 	void		(*saveroute)(const struct sk_buff *skb,
-				     struct nf_info *info);
+				     struct nf_queue_entry *entry);
 	int		(*reroute)(struct sk_buff *skb,
-				   const struct nf_info *info);
+				   const struct nf_queue_entry *entry);
 	int		route_key_size;
 };
 
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 8c6b382..d030044 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -2,7 +2,11 @@
 #define _NF_QUEUE_H
 
 /* Each queued (to userspace) skbuff has one of these. */
-struct nf_info {
+struct nf_queue_entry {
+	struct list_head	list;
+	struct sk_buff		*skb;
+	unsigned int		id;
+
 	struct nf_hook_ops	*elem;
 	int			pf;
 	unsigned int		hook;
@@ -11,12 +15,11 @@ struct nf_info {
 	int			(*okfn)(struct sk_buff *);
 };
 
-#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
+#define nf_queue_entry_reroute(x) ((void *)x + sizeof(struct nf_queue_entry))
 
 /* Packet queuing */
 struct nf_queue_handler {
-	int			(*outfn)(struct sk_buff *skb,
-					 struct nf_info *info,
+	int			(*outfn)(struct nf_queue_entry *entry,
 					 unsigned int queuenum);
 	char			*name;
 };
@@ -26,7 +29,6 @@ extern int nf_register_queue_handler(int pf,
 extern int nf_unregister_queue_handler(int pf,
 				       const struct nf_queue_handler *qh);
 extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
-extern void nf_reinject(struct sk_buff *skb, struct nf_info *info,
-			unsigned int verdict);
+extern void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
 #endif /* _NF_QUEUE_H */
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index f716608..7bf5e4a 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -123,11 +123,12 @@ struct ip_rt_info {
 	u_int8_t tos;
 };
 
-static void nf_ip_saveroute(const struct sk_buff *skb, struct nf_info *info)
+static void nf_ip_saveroute(const struct sk_buff *skb,
+			    struct nf_queue_entry *entry)
 {
-	struct ip_rt_info *rt_info = nf_info_reroute(info);
+	struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
-	if (info->hook == NF_INET_LOCAL_OUT) {
+	if (entry->hook == NF_INET_LOCAL_OUT) {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		rt_info->tos = iph->tos;
@@ -136,11 +137,12 @@ static void nf_ip_saveroute(const struct sk_buff *skb, struct nf_info *info)
 	}
 }
 
-static int nf_ip_reroute(struct sk_buff *skb, const struct nf_info *info)
+static int nf_ip_reroute(struct sk_buff *skb,
+			 const struct nf_queue_entry *entry)
 {
-	const struct ip_rt_info *rt_info = nf_info_reroute(info);
+	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
-	if (info->hook == NF_INET_LOCAL_OUT) {
+	if (entry->hook == NF_INET_LOCAL_OUT) {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (!(iph->tos == rt_info->tos
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index df2957c..f1affd2 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -35,13 +35,7 @@
 #define NET_IPQ_QMAX 2088
 #define NET_IPQ_QMAX_NAME "ip_queue_maxlen"
 
-struct ipq_queue_entry {
-	struct list_head list;
-	struct nf_info *info;
-	struct sk_buff *skb;
-};
-
-typedef int (*ipq_cmpfn)(struct ipq_queue_entry *, unsigned long);
+typedef int (*ipq_cmpfn)(struct nf_queue_entry *, unsigned long);
 
 static unsigned char copy_mode __read_mostly = IPQ_COPY_NONE;
 static unsigned int queue_maxlen __read_mostly = IPQ_QMAX_DEFAULT;
@@ -56,7 +50,7 @@ static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
 static void
-ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
+ipq_issue_verdict(struct nf_queue_entry *entry, int verdict)
 {
 	/* TCP input path (and probably other bits) assume to be called
 	 * from softirq context, not from syscall, like ipq_issue_verdict is
@@ -64,14 +58,12 @@ ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 	 * softirq, e.g.  We therefore emulate this by local_bh_disable() */
 
 	local_bh_disable();
-	nf_reinject(entry->skb, entry->info, verdict);
+	nf_reinject(entry, verdict);
 	local_bh_enable();
-
-	kfree(entry);
 }
 
 static inline void
-__ipq_enqueue_entry(struct ipq_queue_entry *entry)
+__ipq_enqueue_entry(struct nf_queue_entry *entry)
 {
        list_add_tail(&entry->list, &queue_list);
        queue_total++;
@@ -114,10 +106,10 @@ __ipq_reset(void)
 	__ipq_flush(NULL, 0);
 }
 
-static struct ipq_queue_entry *
+static struct nf_queue_entry *
 ipq_find_dequeue_entry(unsigned long id)
 {
-	struct ipq_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry = NULL, *i;
 
 	write_lock_bh(&queue_lock);
 
@@ -140,7 +132,7 @@ ipq_find_dequeue_entry(unsigned long id)
 static void
 __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct ipq_queue_entry *entry, *next;
+	struct nf_queue_entry *entry, *next;
 
 	list_for_each_entry_safe(entry, next, &queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
@@ -160,7 +152,7 @@ ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 }
 
 static struct sk_buff *
-ipq_build_packet_message(struct ipq_queue_entry *entry, int *errp)
+ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 {
 	sk_buff_data_t old_tail;
 	size_t size = 0;
@@ -217,20 +209,20 @@ ipq_build_packet_message(struct ipq_queue_entry *entry, int *errp)
 	pmsg->timestamp_sec   = tv.tv_sec;
 	pmsg->timestamp_usec  = tv.tv_usec;
 	pmsg->mark            = entry->skb->mark;
-	pmsg->hook            = entry->info->hook;
+	pmsg->hook            = entry->hook;
 	pmsg->hw_protocol     = entry->skb->protocol;
 
-	if (entry->info->indev)
-		strcpy(pmsg->indev_name, entry->info->indev->name);
+	if (entry->indev)
+		strcpy(pmsg->indev_name, entry->indev->name);
 	else
 		pmsg->indev_name[0] = '\0';
 
-	if (entry->info->outdev)
-		strcpy(pmsg->outdev_name, entry->info->outdev->name);
+	if (entry->outdev)
+		strcpy(pmsg->outdev_name, entry->outdev->name);
 	else
 		pmsg->outdev_name[0] = '\0';
 
-	if (entry->info->indev && entry->skb->dev) {
+	if (entry->indev && entry->skb->dev) {
 		pmsg->hw_type = entry->skb->dev->type;
 		pmsg->hw_addrlen = dev_parse_header(entry->skb,
 						    pmsg->hw_addr);
@@ -252,28 +244,17 @@ nlmsg_failure:
 }
 
 static int
-ipq_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		   unsigned int queuenum)
+ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
-	struct ipq_queue_entry *entry;
 
 	if (copy_mode == IPQ_COPY_NONE)
 		return -EAGAIN;
 
-	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
-	if (entry == NULL) {
-		printk(KERN_ERR "ip_queue: OOM in ipq_enqueue_packet()\n");
-		return -ENOMEM;
-	}
-
-	entry->info = info;
-	entry->skb = skb;
-
 	nskb = ipq_build_packet_message(entry, &status);
 	if (nskb == NULL)
-		goto err_out_free;
+		return status;
 
 	write_lock_bh(&queue_lock);
 
@@ -307,14 +288,11 @@ err_out_free_nskb:
 
 err_out_unlock:
 	write_unlock_bh(&queue_lock);
-
-err_out_free:
-	kfree(entry);
 	return status;
 }
 
 static int
-ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
+ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
 	int err;
@@ -352,7 +330,7 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 static int
 ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 {
-	struct ipq_queue_entry *entry;
+	struct nf_queue_entry *entry;
 
 	if (vmsg->value > NF_MAX_VERDICT)
 		return -EINVAL;
@@ -412,13 +390,13 @@ ipq_receive_peer(struct ipq_peer_msg *pmsg,
 }
 
 static int
-dev_cmp(struct ipq_queue_entry *entry, unsigned long ifindex)
+dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 {
-	if (entry->info->indev)
-		if (entry->info->indev->ifindex == ifindex)
+	if (entry->indev)
+		if (entry->indev->ifindex == ifindex)
 			return 1;
-	if (entry->info->outdev)
-		if (entry->info->outdev->ifindex == ifindex)
+	if (entry->outdev)
+		if (entry->outdev->ifindex == ifindex)
 			return 1;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (entry->skb->nf_bridge) {
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 55ea9c6..945e6ae 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -57,11 +57,12 @@ struct ip6_rt_info {
 	struct in6_addr saddr;
 };
 
-static void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_info *info)
+static void nf_ip6_saveroute(const struct sk_buff *skb,
+			     struct nf_queue_entry *entry)
 {
-	struct ip6_rt_info *rt_info = nf_info_reroute(info);
+	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
-	if (info->hook == NF_INET_LOCAL_OUT) {
+	if (entry->hook == NF_INET_LOCAL_OUT) {
 		struct ipv6hdr *iph = ipv6_hdr(skb);
 
 		rt_info->daddr = iph->daddr;
@@ -69,11 +70,12 @@ static void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_info *info)
 	}
 }
 
-static int nf_ip6_reroute(struct sk_buff *skb, const struct nf_info *info)
+static int nf_ip6_reroute(struct sk_buff *skb,
+			  const struct nf_queue_entry *entry)
 {
-	struct ip6_rt_info *rt_info = nf_info_reroute(info);
+	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
-	if (info->hook == NF_INET_LOCAL_OUT) {
+	if (entry->hook == NF_INET_LOCAL_OUT) {
 		struct ipv6hdr *iph = ipv6_hdr(skb);
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr))
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 9c50cb1..9014ada 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -39,13 +39,7 @@
 #define NET_IPQ_QMAX 2088
 #define NET_IPQ_QMAX_NAME "ip6_queue_maxlen"
 
-struct ipq_queue_entry {
-	struct list_head list;
-	struct nf_info *info;
-	struct sk_buff *skb;
-};
-
-typedef int (*ipq_cmpfn)(struct ipq_queue_entry *, unsigned long);
+typedef int (*ipq_cmpfn)(struct nf_queue_entry *, unsigned long);
 
 static unsigned char copy_mode __read_mostly = IPQ_COPY_NONE;
 static unsigned int queue_maxlen __read_mostly = IPQ_QMAX_DEFAULT;
@@ -60,16 +54,15 @@ static LIST_HEAD(queue_list);
 static DEFINE_MUTEX(ipqnl_mutex);
 
 static void
-ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
+ipq_issue_verdict(struct nf_queue_entry *entry, int verdict)
 {
 	local_bh_disable();
-	nf_reinject(entry->skb, entry->info, verdict);
+	nf_reinject(entry, verdict);
 	local_bh_enable();
-	kfree(entry);
 }
 
 static inline void
-__ipq_enqueue_entry(struct ipq_queue_entry *entry)
+__ipq_enqueue_entry(struct nf_queue_entry *entry)
 {
        list_add_tail(&entry->list, &queue_list);
        queue_total++;
@@ -112,10 +105,10 @@ __ipq_reset(void)
 	__ipq_flush(NULL, 0);
 }
 
-static struct ipq_queue_entry *
+static struct nf_queue_entry *
 ipq_find_dequeue_entry(unsigned long id)
 {
-	struct ipq_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry = NULL, *i;
 
 	write_lock_bh(&queue_lock);
 
@@ -138,7 +131,7 @@ ipq_find_dequeue_entry(unsigned long id)
 static void
 __ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 {
-	struct ipq_queue_entry *entry, *next;
+	struct nf_queue_entry *entry, *next;
 
 	list_for_each_entry_safe(entry, next, &queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
@@ -158,7 +151,7 @@ ipq_flush(ipq_cmpfn cmpfn, unsigned long data)
 }
 
 static struct sk_buff *
-ipq_build_packet_message(struct ipq_queue_entry *entry, int *errp)
+ipq_build_packet_message(struct nf_queue_entry *entry, int *errp)
 {
 	sk_buff_data_t old_tail;
 	size_t size = 0;
@@ -215,20 +208,20 @@ ipq_build_packet_message(struct ipq_queue_entry *entry, int *errp)
 	pmsg->timestamp_sec   = tv.tv_sec;
 	pmsg->timestamp_usec  = tv.tv_usec;
 	pmsg->mark            = entry->skb->mark;
-	pmsg->hook            = entry->info->hook;
+	pmsg->hook            = entry->hook;
 	pmsg->hw_protocol     = entry->skb->protocol;
 
-	if (entry->info->indev)
-		strcpy(pmsg->indev_name, entry->info->indev->name);
+	if (entry->indev)
+		strcpy(pmsg->indev_name, entry->indev->name);
 	else
 		pmsg->indev_name[0] = '\0';
 
-	if (entry->info->outdev)
-		strcpy(pmsg->outdev_name, entry->info->outdev->name);
+	if (entry->outdev)
+		strcpy(pmsg->outdev_name, entry->outdev->name);
 	else
 		pmsg->outdev_name[0] = '\0';
 
-	if (entry->info->indev && entry->skb->dev) {
+	if (entry->indev && entry->skb->dev) {
 		pmsg->hw_type = entry->skb->dev->type;
 		pmsg->hw_addrlen = dev_parse_header(entry->skb, pmsg->hw_addr);
 	}
@@ -249,28 +242,17 @@ nlmsg_failure:
 }
 
 static int
-ipq_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		   unsigned int queuenum)
+ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
-	struct ipq_queue_entry *entry;
 
 	if (copy_mode == IPQ_COPY_NONE)
 		return -EAGAIN;
 
-	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
-	if (entry == NULL) {
-		printk(KERN_ERR "ip6_queue: OOM in ipq_enqueue_packet()\n");
-		return -ENOMEM;
-	}
-
-	entry->info = info;
-	entry->skb = skb;
-
 	nskb = ipq_build_packet_message(entry, &status);
 	if (nskb == NULL)
-		goto err_out_free;
+		return status;
 
 	write_lock_bh(&queue_lock);
 
@@ -304,14 +286,11 @@ err_out_free_nskb:
 
 err_out_unlock:
 	write_unlock_bh(&queue_lock);
-
-err_out_free:
-	kfree(entry);
 	return status;
 }
 
 static int
-ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
+ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
 	int err;
@@ -349,7 +328,7 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 static int
 ipq_set_verdict(struct ipq_verdict_msg *vmsg, unsigned int len)
 {
-	struct ipq_queue_entry *entry;
+	struct nf_queue_entry *entry;
 
 	if (vmsg->value > NF_MAX_VERDICT)
 		return -EINVAL;
@@ -409,14 +388,14 @@ ipq_receive_peer(struct ipq_peer_msg *pmsg,
 }
 
 static int
-dev_cmp(struct ipq_queue_entry *entry, unsigned long ifindex)
+dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 {
-	if (entry->info->indev)
-		if (entry->info->indev->ifindex == ifindex)
+	if (entry->indev)
+		if (entry->indev->ifindex == ifindex)
 			return 1;
 
-	if (entry->info->outdev)
-		if (entry->info->outdev->ifindex == ifindex)
+	if (entry->outdev)
+		if (entry->outdev->ifindex == ifindex)
 			return 1;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (entry->skb->nf_bridge) {
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bd71f43..d9d3dc4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -93,7 +93,7 @@ static int __nf_queue(struct sk_buff *skb,
 		      unsigned int queuenum)
 {
 	int status;
-	struct nf_info *info;
+	struct nf_queue_entry *entry;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct net_device *physindev = NULL;
 	struct net_device *physoutdev = NULL;
@@ -118,8 +118,8 @@ static int __nf_queue(struct sk_buff *skb,
 		return 1;
 	}
 
-	info = kmalloc(sizeof(*info) + afinfo->route_key_size, GFP_ATOMIC);
-	if (!info) {
+	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
+	if (!entry) {
 		if (net_ratelimit())
 			printk(KERN_ERR "OOM queueing packet %p\n",
 			       skb);
@@ -128,13 +128,20 @@ static int __nf_queue(struct sk_buff *skb,
 		return 1;
 	}
 
-	*info = (struct nf_info) {
-		(struct nf_hook_ops *)elem, pf, hook, indev, outdev, okfn };
+	*entry = (struct nf_queue_entry) {
+		.skb	= skb,
+		.elem	= list_entry(elem, struct nf_hook_ops, list),
+		.pf	= pf,
+		.hook	= hook,
+		.indev	= indev,
+		.outdev	= outdev,
+		.okfn	= okfn,
+	};
 
 	/* If it's going away, ignore hook. */
-	if (!try_module_get(info->elem->owner)) {
+	if (!try_module_get(entry->elem->owner)) {
 		rcu_read_unlock();
-		kfree(info);
+		kfree(entry);
 		return 0;
 	}
 
@@ -153,8 +160,8 @@ static int __nf_queue(struct sk_buff *skb,
 			dev_hold(physoutdev);
 	}
 #endif
-	afinfo->saveroute(skb, info);
-	status = qh->outfn(skb, info, queuenum);
+	afinfo->saveroute(skb, entry);
+	status = qh->outfn(entry, queuenum);
 
 	rcu_read_unlock();
 
@@ -170,8 +177,8 @@ static int __nf_queue(struct sk_buff *skb,
 		if (physoutdev)
 			dev_put(physoutdev);
 #endif
-		module_put(info->elem->owner);
-		kfree(info);
+		module_put(entry->elem->owner);
+		kfree(entry);
 		kfree_skb(skb);
 
 		return 1;
@@ -220,19 +227,19 @@ int nf_queue(struct sk_buff *skb,
 	return 1;
 }
 
-void nf_reinject(struct sk_buff *skb, struct nf_info *info,
-		 unsigned int verdict)
+void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
-	struct list_head *elem = &info->elem->list;
+	struct sk_buff *skb = entry->skb;
+	struct list_head *elem = &entry->elem->list;
 	struct nf_afinfo *afinfo;
 
 	rcu_read_lock();
 
 	/* Release those devices we held, or Alexey will kill me. */
-	if (info->indev)
-		dev_put(info->indev);
-	if (info->outdev)
-		dev_put(info->outdev);
+	if (entry->indev)
+		dev_put(entry->indev);
+	if (entry->outdev)
+		dev_put(entry->outdev);
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge) {
 		if (skb->nf_bridge->physindev)
@@ -243,7 +250,7 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 #endif
 
 	/* Drop reference to owner of hook which queued us. */
-	module_put(info->elem->owner);
+	module_put(entry->elem->owner);
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
@@ -252,28 +259,28 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 	}
 
 	if (verdict == NF_ACCEPT) {
-		afinfo = nf_get_afinfo(info->pf);
-		if (!afinfo || afinfo->reroute(skb, info) < 0)
+		afinfo = nf_get_afinfo(entry->pf);
+		if (!afinfo || afinfo->reroute(skb, entry) < 0)
 			verdict = NF_DROP;
 	}
 
 	if (verdict == NF_ACCEPT) {
 	next_hook:
-		verdict = nf_iterate(&nf_hooks[info->pf][info->hook],
-				     skb, info->hook,
-				     info->indev, info->outdev, &elem,
-				     info->okfn, INT_MIN);
+		verdict = nf_iterate(&nf_hooks[entry->pf][entry->hook],
+				     skb, entry->hook,
+				     entry->indev, entry->outdev, &elem,
+				     entry->okfn, INT_MIN);
 	}
 
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		info->okfn(skb);
+		entry->okfn(skb);
 	case NF_STOLEN:
 		break;
 	case NF_QUEUE:
-		if (!__nf_queue(skb, elem, info->pf, info->hook,
-				info->indev, info->outdev, info->okfn,
+		if (!__nf_queue(skb, elem, entry->pf, entry->hook,
+				entry->indev, entry->outdev, entry->okfn,
 				verdict >> NF_VERDICT_BITS))
 			goto next_hook;
 		break;
@@ -281,7 +288,7 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 		kfree_skb(skb);
 	}
 	rcu_read_unlock();
-	kfree(info);
+	kfree(entry);
 	return;
 }
 EXPORT_SYMBOL(nf_reinject);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index cb901cf..a493764 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -45,13 +45,6 @@
 #define QDEBUG(x, ...)
 #endif
 
-struct nfqnl_queue_entry {
-	struct list_head list;
-	struct nf_info *info;
-	struct sk_buff *skb;
-	unsigned int id;
-};
-
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	atomic_t use;
@@ -73,7 +66,7 @@ struct nfqnl_instance {
 	struct list_head queue_list;		/* packets in queue */
 };
 
-typedef int (*nfqnl_cmpfn)(struct nfqnl_queue_entry *, unsigned long);
+typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
 
 static DEFINE_RWLOCK(instances_lock);
 
@@ -212,7 +205,7 @@ instance_destroy(struct nfqnl_instance *inst)
 
 
 static void
-issue_verdict(struct nfqnl_queue_entry *entry, int verdict)
+issue_verdict(struct nf_queue_entry *entry, int verdict)
 {
 	QDEBUG("entering for entry %p, verdict %u\n", entry, verdict);
 
@@ -222,15 +215,12 @@ issue_verdict(struct nfqnl_queue_entry *entry, int verdict)
 	 * softirq, e.g.  We therefore emulate this by local_bh_disable() */
 
 	local_bh_disable();
-	nf_reinject(entry->skb, entry->info, verdict);
+	nf_reinject(entry, verdict);
 	local_bh_enable();
-
-	kfree(entry);
 }
 
 static inline void
-__enqueue_entry(struct nfqnl_instance *queue,
-		      struct nfqnl_queue_entry *entry)
+__enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
        list_add_tail(&entry->list, &queue->queue_list);
        queue->queue_total++;
@@ -265,10 +255,10 @@ __nfqnl_set_mode(struct nfqnl_instance *queue,
 	return status;
 }
 
-static struct nfqnl_queue_entry *
+static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-	struct nfqnl_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry = NULL, *i;
 
 	spin_lock_bh(&queue->lock);
 
@@ -292,7 +282,7 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
-	struct nfqnl_queue_entry *entry, *next;
+	struct nf_queue_entry *entry, *next;
 
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
@@ -307,7 +297,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 
 static struct sk_buff *
 nfqnl_build_packet_message(struct nfqnl_instance *queue,
-			   struct nfqnl_queue_entry *entry, int *errp)
+			   struct nf_queue_entry *entry, int *errp)
 {
 	sk_buff_data_t old_tail;
 	size_t size;
@@ -316,7 +306,6 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct nfqnl_msg_packet_hdr pmsg;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct nf_info *entinf = entry->info;
 	struct sk_buff *entskb = entry->skb;
 	struct net_device *indev;
 	struct net_device *outdev;
@@ -336,7 +325,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));
 
-	outdev = entinf->outdev;
+	outdev = entry->outdev;
 
 	spin_lock_bh(&queue->lock);
 
@@ -379,23 +368,23 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
-	nfmsg->nfgen_family = entinf->pf;
+	nfmsg->nfgen_family = entry->pf;
 	nfmsg->version = NFNETLINK_V0;
 	nfmsg->res_id = htons(queue->queue_num);
 
 	pmsg.packet_id 		= htonl(entry->id);
 	pmsg.hw_protocol	= entskb->protocol;
-	pmsg.hook		= entinf->hook;
+	pmsg.hook		= entry->hook;
 
 	NLA_PUT(skb, NFQA_PACKET_HDR, sizeof(pmsg), &pmsg);
 
-	indev = entinf->indev;
+	indev = entry->indev;
 	if (indev) {
 		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
 		NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint), &tmp_uint);
 #else
-		if (entinf->pf == PF_BRIDGE) {
+		if (entry->pf == PF_BRIDGE) {
 			/* Case 1: indev is physical input device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
@@ -425,7 +414,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 #ifndef CONFIG_BRIDGE_NETFILTER
 		NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint), &tmp_uint);
 #else
-		if (entinf->pf == PF_BRIDGE) {
+		if (entry->pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
@@ -504,13 +493,11 @@ nla_put_failure:
 }
 
 static int
-nfqnl_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
-		     unsigned int queuenum)
+nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
-	struct nfqnl_queue_entry *entry;
 
 	QDEBUG("entered\n");
 
@@ -526,22 +513,11 @@ nfqnl_enqueue_packet(struct sk_buff *skb, struct nf_info *info,
 		goto err_out_put;
 	}
 
-	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
-	if (entry == NULL) {
-		if (net_ratelimit())
-			printk(KERN_ERR
-				"nf_queue: OOM in nfqnl_enqueue_packet()\n");
-		status = -ENOMEM;
-		goto err_out_put;
-	}
-
-	entry->info = info;
-	entry->skb = skb;
 	entry->id = atomic_inc_return(&queue->id_sequence);
 
 	nskb = nfqnl_build_packet_message(queue, entry, &status);
 	if (nskb == NULL)
-		goto err_out_free;
+		goto err_out_put;
 
 	spin_lock_bh(&queue->lock);
 
@@ -577,15 +553,13 @@ err_out_free_nskb:
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
 
-err_out_free:
-	kfree(entry);
 err_out_put:
 	instance_put(queue);
 	return status;
 }
 
 static int
-nfqnl_mangle(void *data, int data_len, struct nfqnl_queue_entry *e)
+nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e)
 {
 	int diff;
 	int err;
@@ -630,15 +604,13 @@ nfqnl_set_mode(struct nfqnl_instance *queue,
 }
 
 static int
-dev_cmp(struct nfqnl_queue_entry *entry, unsigned long ifindex)
+dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 {
-	struct nf_info *entinf = entry->info;
-
-	if (entinf->indev)
-		if (entinf->indev->ifindex == ifindex)
+	if (entry->indev)
+		if (entry->indev->ifindex == ifindex)
 			return 1;
-	if (entinf->outdev)
-		if (entinf->outdev->ifindex == ifindex)
+	if (entry->outdev)
+		if (entry->outdev->ifindex == ifindex)
 			return 1;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (entry->skb->nf_bridge) {
@@ -748,7 +720,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	struct nfqnl_instance *queue;
 	unsigned int verdict;
-	struct nfqnl_queue_entry *entry;
+	struct nf_queue_entry *entry;
 	int err;
 
 	queue = instance_lookup_get(queue_num);
