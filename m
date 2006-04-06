From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/12]: Introduce infrastructure for address family
	specific operations
Date: Thu,  6 Apr 2006 12:05:07 +0200 (MEST)
Message-ID: <20060406100506.17409.27277.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Introduce infrastructure for address family specific operations

Change the queue rerouter intrastructure to a generic usable infrastructure
for address family specific operations as a base for some cleanups.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6a870bcf3e2ee0394ee23cb1ca32de2195edf86d
tree a5e7a46f323f8b9e24c52d546b9d7fcc69f8273c
parent c9cb4249431b37ed45e69f20a5faa2735933feeb
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:48 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:48 +0200

 include/linux/netfilter.h |   23 +++++++++++++++------
 net/ipv4/netfilter.c      |   17 ++++++++--------
 net/ipv6/netfilter.c      |   17 ++++++++--------
 net/netfilter/core.c      |   23 +++++++++++++++++++++
 net/netfilter/nf_queue.c  |   49 ++++++++++++---------------------------------
 5 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 5aa9316..6ee168c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -283,16 +283,25 @@ extern void nf_invalidate_cache(int pf);
    Returns true or false. */
 extern int skb_make_writable(struct sk_buff **pskb, unsigned int writable_len);
 
-struct nf_queue_rerouter {
-	void (*save)(const struct sk_buff *skb, struct nf_info *info);
-	int (*reroute)(struct sk_buff **skb, const struct nf_info *info);
-	int rer_size;
+struct nf_afinfo {
+	unsigned short	family;
+	void		(*saveroute)(const struct sk_buff *skb,
+				     struct nf_info *info);
+	int		(*reroute)(struct sk_buff **skb,
+				   const struct nf_info *info);
+	int		route_key_size;
 };
 
-#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
+extern struct nf_afinfo *nf_afinfo[];
+static inline struct nf_afinfo *nf_get_afinfo(unsigned short family)
+{
+	return rcu_dereference(nf_afinfo[family]);
+}
 
-extern int nf_register_queue_rerouter(int pf, struct nf_queue_rerouter *rer);
-extern int nf_unregister_queue_rerouter(int pf);
+extern int nf_register_afinfo(struct nf_afinfo *afinfo);
+extern void nf_unregister_afinfo(struct nf_afinfo *afinfo);
+
+#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
 
 #include <net/flow.h>
 extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index b5ad9ac..b25339c 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -133,7 +133,7 @@ struct ip_rt_info {
 	u_int8_t tos;
 };
 
-static void queue_save(const struct sk_buff *skb, struct nf_info *info)
+static void nf_ip_saveroute(const struct sk_buff *skb, struct nf_info *info)
 {
 	struct ip_rt_info *rt_info = nf_info_reroute(info);
 
@@ -146,7 +146,7 @@ static void queue_save(const struct sk_b
 	}
 }
 
-static int queue_reroute(struct sk_buff **pskb, const struct nf_info *info)
+static int nf_ip_reroute(struct sk_buff **pskb, const struct nf_info *info)
 {
 	const struct ip_rt_info *rt_info = nf_info_reroute(info);
 
@@ -161,20 +161,21 @@ static int queue_reroute(struct sk_buff 
 	return 0;
 }
 
-static struct nf_queue_rerouter ip_reroute = {
-	.rer_size	= sizeof(struct ip_rt_info),
-	.save		= queue_save,
-	.reroute	= queue_reroute,
+static struct nf_afinfo nf_ip_afinfo = {
+	.family		= AF_INET,
+	.saveroute	= nf_ip_saveroute,
+	.reroute	= nf_ip_reroute,
+	.route_key_size	= sizeof(struct ip_rt_info),
 };
 
 static int ipv4_netfilter_init(void)
 {
-	return nf_register_queue_rerouter(PF_INET, &ip_reroute);
+	return nf_register_afinfo(&nf_ip_afinfo);
 }
 
 static void ipv4_netfilter_fini(void)
 {
-	nf_unregister_queue_rerouter(PF_INET);
+	nf_unregister_afinfo(&nf_ip_afinfo);
 }
 
 module_init(ipv4_netfilter_init);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d750cfc..f514a01 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -54,7 +54,7 @@ struct ip6_rt_info {
 	struct in6_addr saddr;
 };
 
-static void save(const struct sk_buff *skb, struct nf_info *info)
+static void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_info *info)
 {
 	struct ip6_rt_info *rt_info = nf_info_reroute(info);
 
@@ -66,7 +66,7 @@ static void save(const struct sk_buff *s
 	}
 }
 
-static int reroute(struct sk_buff **pskb, const struct nf_info *info)
+static int nf_ip6_reroute(struct sk_buff **pskb, const struct nf_info *info)
 {
 	struct ip6_rt_info *rt_info = nf_info_reroute(info);
 
@@ -79,15 +79,16 @@ static int reroute(struct sk_buff **pskb
 	return 0;
 }
 
-static struct nf_queue_rerouter ip6_reroute = {
-	.rer_size	= sizeof(struct ip6_rt_info),
-	.save 		= &save,
-	.reroute	= &reroute,
+static struct nf_afinfo nf_ip6_afinfo = {
+	.family		= AF_INET6,
+	.saveroute	= nf_ip6_saveroute,
+	.reroute	= nf_ip6_reroute,
+	.route_key_size	= sizeof(struct ip6_rt_info),
 };
 
 int __init ipv6_netfilter_init(void)
 {
-	return nf_register_queue_rerouter(PF_INET6, &ip6_reroute);
+	return nf_register_afinfo(&nf_ip6_afinfo);
 }
 
 /* This can be called from inet6_init() on errors, so it cannot
@@ -95,5 +96,5 @@ int __init ipv6_netfilter_init(void)
  */
 void ipv6_netfilter_fini(void)
 {
-	nf_unregister_queue_rerouter(PF_INET6);
+	nf_unregister_afinfo(&nf_ip6_afinfo);
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5c7143e..dceed88 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -27,6 +27,29 @@
 
 #include "nf_internals.h"
 
+static DEFINE_SPINLOCK(afinfo_lock);
+
+struct nf_afinfo *nf_afinfo[NPROTO];
+EXPORT_SYMBOL(nf_afinfo);
+
+int nf_register_afinfo(struct nf_afinfo *afinfo)
+{
+	spin_lock(&afinfo_lock);
+	rcu_assign_pointer(nf_afinfo[afinfo->family], afinfo);
+	spin_unlock(&afinfo_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_register_afinfo);
+
+void nf_unregister_afinfo(struct nf_afinfo *afinfo)
+{
+	spin_lock(&afinfo_lock);
+	rcu_assign_pointer(nf_afinfo[afinfo->family], NULL);
+	spin_unlock(&afinfo_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
+
 /* In this code, we can be waiting indefinitely for userspace to
  * service a packet if a hook returns NF_QUEUE.  We could keep a count
  * of skbuffs queued for userspace, and not deregister a hook unless
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d9f0d7e..ee8f708 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -17,7 +17,6 @@
  * for queueing and must reinject all packets it receives, no matter what.
  */
 static struct nf_queue_handler *queue_handler[NPROTO];
-static struct nf_queue_rerouter *queue_rerouter[NPROTO];
 
 static DEFINE_RWLOCK(queue_handler_lock);
 
@@ -59,32 +58,6 @@ int nf_unregister_queue_handler(int pf)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-int nf_register_queue_rerouter(int pf, struct nf_queue_rerouter *rer)
-{
-	if (pf >= NPROTO)
-		return -EINVAL;
-
-	write_lock_bh(&queue_handler_lock);
-	rcu_assign_pointer(queue_rerouter[pf], rer);
-	write_unlock_bh(&queue_handler_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_register_queue_rerouter);
-
-int nf_unregister_queue_rerouter(int pf)
-{
-	if (pf >= NPROTO)
-		return -EINVAL;
-
-	write_lock_bh(&queue_handler_lock);
-	rcu_assign_pointer(queue_rerouter[pf], NULL);
-	write_unlock_bh(&queue_handler_lock);
-	synchronize_rcu();
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_unregister_queue_rerouter);
-
 void nf_unregister_queue_handlers(struct nf_queue_handler *qh)
 {
 	int pf;
@@ -116,7 +89,7 @@ int nf_queue(struct sk_buff **skb, 
 	struct net_device *physindev = NULL;
 	struct net_device *physoutdev = NULL;
 #endif
-	struct nf_queue_rerouter *rerouter;
+	struct nf_afinfo *afinfo;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	read_lock(&queue_handler_lock);
@@ -126,7 +99,14 @@ int nf_queue(struct sk_buff **skb, 
 		return 1;
 	}
 
-	info = kmalloc(sizeof(*info)+queue_rerouter[pf]->rer_size, GFP_ATOMIC);
+	afinfo = nf_get_afinfo(pf);
+	if (!afinfo) {
+		read_unlock(&queue_handler_lock);
+		kfree_skb(*skb);
+		return 1;
+	}
+
+	info = kmalloc(sizeof(*info) + afinfo->route_key_size, GFP_ATOMIC);
 	if (!info) {
 		if (net_ratelimit())
 			printk(KERN_ERR "OOM queueing packet %p\n",
@@ -158,10 +138,7 @@ int nf_queue(struct sk_buff **skb, 
 		if (physoutdev) dev_hold(physoutdev);
 	}
 #endif
-	rerouter = rcu_dereference(queue_rerouter[pf]);
-	if (rerouter)
-		rerouter->save(*skb, info);
-
+	afinfo->saveroute(*skb, info);
 	status = queue_handler[pf]->outfn(*skb, info, queuenum,
 					  queue_handler[pf]->data);
 
@@ -190,7 +167,7 @@ void nf_reinject(struct sk_buff *skb, st
 {
 	struct list_head *elem = &info->elem->list;
 	struct list_head *i;
-	struct nf_queue_rerouter *rerouter;
+	struct nf_afinfo *afinfo;
 
 	rcu_read_lock();
 
@@ -228,8 +205,8 @@ void nf_reinject(struct sk_buff *skb, st
 	}
 
 	if (verdict == NF_ACCEPT) {
-		rerouter = rcu_dereference(queue_rerouter[info->pf]);
-		if (rerouter && rerouter->reroute(&skb, info) < 0)
+		afinfo = nf_get_afinfo(info->pf);
+		if (!afinfo || afinfo->reroute(&skb, info) < 0)
 			verdict = NF_DROP;
 	}
 
