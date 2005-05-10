From: Patrick McHardy <kaber@trash.net>
Subject: [netfilter socket hooks 1/5]: Add socket hook infrastructure
Date: Tue, 10 May 2005 18:00:08 +0200
Message-ID: <4280DA88.2000007@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4280DA51.8090201@trash.net>
Content-Disposition: inline;
 filename="01.diff"
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

[NETFILTER]: Add socket hook infrastructure

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4ca9ffc0b58dd44e91cbaaa2de3c27faa220e047
tree e97143c76936d02bb1817a1e109e36707202a6bb
parent e8108c98dd6d65613fa0ec9d2300f89c48d554bf
author Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 16:47:43 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 16:47:43 +0200

 include/linux/netfilter.h |   44 +++++++++++++++++++++
 net/core/netfilter.c      |   96 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 1 deletion(-)

Index: include/linux/netfilter.h
===================================================================
--- 3608de2fc88b062070a9d197eda9cac1fb9635d3/include/linux/netfilter.h  (mode:100644)
+++ e97143c76936d02bb1817a1e109e36707202a6bb/include/linux/netfilter.h  (mode:100644)
@@ -57,6 +57,25 @@
 	int priority;
 };
 
+typedef unsigned int nf_sk_hookfn(unsigned int hooknum,
+                                  struct sock *sk, struct sk_buff **skb,
+                                  const struct net_device *in,
+                                  const struct net_device *out,
+                                  int (*okfn)(struct sock *sk, struct sk_buff *));
+
+struct nf_sk_hook_ops
+{
+	struct list_head list;
+
+	/* User fills in from here down. */
+	nf_sk_hookfn *hook;
+	struct module *owner;
+	unsigned int pf;
+	unsigned int hooknum;
+	/* Hooks are ordered in ascending priority. */
+	int priority;
+};
+
 struct nf_sockopt_ops
 {
 	struct list_head list;
@@ -94,12 +113,16 @@
 int nf_register_hook(struct nf_hook_ops *reg);
 void nf_unregister_hook(struct nf_hook_ops *reg);
 
+int nf_register_sk_hook(struct nf_sk_hook_ops *reg);
+void nf_unregister_sk_hook(struct nf_sk_hook_ops *reg);
+
 /* Functions to register get/setsockopt ranges (non-inclusive).  You
    need to check permissions yourself! */
 int nf_register_sockopt(struct nf_sockopt_ops *reg);
 void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+extern struct list_head nf_sk_hooks[NPROTO][NF_MAX_HOOKS];
 
 typedef void nf_logfn(unsigned int hooknum,
 		      const struct sk_buff *skb,
@@ -149,6 +172,13 @@
 if ((__ret=nf_hook_slow(pf, hook, &(skb), indev, outdev, okfn, thresh)) == 1)  \
 	__ret = (okfn)(skb);						       \
 __ret;})
+#define NF_SK_HOOK(pf, hook, sk, skb, indev, outdev, okfn, skputfn)	       \
+({int __ret;								       \
+if ((__ret=nf_sk_hook_slow(pf, hook, sk, &(skb), indev, outdev, okfn)) == 0)   \
+	__ret = (okfn)(sk, skb);					       \
+else if (sk && skputfn)							       \
+	((void (*)(struct sock *))skputfn)(sk);				       \
+__ret;})
 #else
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			       \
 ({int __ret;								       \
@@ -162,12 +192,25 @@
     (__ret=nf_hook_slow(pf, hook, &(skb), indev, outdev, okfn, thresh)) == 1)  \
 	__ret = (okfn)(skb);						       \
 __ret;})
+#define NF_SK_HOOK(pf, hook, sk, skb, indev, outdev, okfn, skputfn)	       \
+({int __ret;								       \
+if (list_empty(&nf_sk_hooks[pf][hook]) ||				       \
+    (__ret=nf_sk_hook_slow(pf, hook, sk, &(skb), indev, outdev, okfn)) == 0)   \
+	__ret = (okfn)(sk, skb);					       \
+else if (sk && skputfn)							       \
+	((void (*)(struct sock *))skputfn)(sk);				       \
+__ret;})
 #endif
 
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff **pskb,
 		 struct net_device *indev, struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *), int thresh);
 
+int nf_sk_hook_slow(int pf, unsigned int hook,
+                    struct sock *sk, struct sk_buff **pskb,
+                    struct net_device *indev, struct net_device *outdev,
+                    int (*okfn)(struct sock *, struct sk_buff *));
+
 /* Call setsockopt() */
 int nf_setsockopt(struct sock *sk, int pf, int optval, char __user *opt, 
 		  int len);
@@ -192,6 +235,7 @@
 
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
+#define NF_SK_HOOK(pf, hook, sk, skb, indev, outdev, okfn, skputfn) (okfn)(sk, skb)
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif /*CONFIG_NETFILTER*/
 
Index: net/core/netfilter.c
===================================================================
--- 3608de2fc88b062070a9d197eda9cac1fb9635d3/net/core/netfilter.c  (mode:100644)
+++ e97143c76936d02bb1817a1e109e36707202a6bb/net/core/netfilter.c  (mode:100644)
@@ -46,6 +46,7 @@
 static DECLARE_MUTEX(nf_sockopt_mutex);
 
 struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+struct list_head nf_sk_hooks[NPROTO][NF_MAX_HOOKS];
 static LIST_HEAD(nf_sockopts);
 static DEFINE_SPINLOCK(nf_hook_lock);
 
@@ -598,6 +599,97 @@
 	return;
 }
 
+static unsigned int
+nf_sk_iterate(unsigned int hook, struct list_head *head,
+              struct sock *sk, struct sk_buff **skb,
+              const struct net_device *indev,
+              const struct net_device *outdev, struct list_head **i,
+              int (*okfn)(struct sock *sk, struct sk_buff *))
+{
+	unsigned int verdict;
+
+	/*
+	 * The caller must not block between calls to this
+	 * function because of risk of continuing from deleted element.
+	 */
+	list_for_each_continue_rcu(*i, head) {
+		struct nf_sk_hook_ops *elem = (struct nf_sk_hook_ops *)*i;
+		/* Optimization: we don't need to hold module
+                   reference here, since function can't sleep. --RR */
+		verdict = elem->hook(hook, sk, skb, indev, outdev, okfn);
+		if (verdict != NF_ACCEPT) {
+#ifdef CONFIG_NETFILTER_DEBUG
+			if (unlikely(verdict > NF_MAX_VERDICT)) {
+				NFDEBUG("Evil return from %p(%u).\n",
+				        elem->hook, hook);
+				continue;
+			}
+#endif
+			if (verdict != NF_REPEAT)
+				return verdict;
+			*i = (*i)->prev;
+		}
+	}
+	return NF_ACCEPT;
+}
+
+int nf_sk_hook_slow(int pf, unsigned int hook,
+                    struct sock *sk, struct sk_buff **pskb,
+                    struct net_device *indev, struct net_device *outdev,
+                    int (*okfn)(struct sock *sk, struct sk_buff *))
+{
+	struct list_head *elem;
+	unsigned int verdict;
+	int ret = 1;
+
+	/* We may already have this, but read-locks nest anyway */
+	rcu_read_lock();
+
+	elem = &nf_sk_hooks[pf][hook];
+	verdict = nf_sk_iterate(hook, &nf_sk_hooks[pf][hook], sk, pskb,
+	                        indev, outdev, &elem, okfn);
+	if (verdict == NF_ACCEPT || verdict == NF_STOP) {
+		ret = 0;
+		goto unlock;
+	} else if (verdict == NF_DROP) {
+		kfree_skb(*pskb);
+		/* Don't trigger retransmit in ip_local_deliver_finish() */
+		if (indev == NULL)
+			ret = -EPERM;
+	}
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(nf_sk_hook_slow);
+
+int nf_register_sk_hook(struct nf_sk_hook_ops *reg)
+{
+	struct list_head *i;
+
+	spin_lock_bh(&nf_hook_lock);
+	list_for_each(i, &nf_sk_hooks[reg->pf][reg->hooknum]) {
+		if (reg->priority < ((struct nf_sk_hook_ops *)i)->priority)
+			break;
+	}
+	list_add_rcu(&reg->list, i->prev);
+	spin_unlock_bh(&nf_hook_lock);
+
+	synchronize_net();
+	return 0;
+}
+EXPORT_SYMBOL(nf_register_sk_hook);
+
+void nf_unregister_sk_hook(struct nf_sk_hook_ops *reg)
+{
+	spin_lock_bh(&nf_hook_lock);
+	list_del_rcu(&reg->list);
+	spin_unlock_bh(&nf_hook_lock);
+
+	synchronize_net();
+}
+EXPORT_SYMBOL(nf_unregister_sk_hook);
+
 #ifdef CONFIG_INET
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
 int ip_route_me_harder(struct sk_buff **pskb)
@@ -779,8 +871,10 @@
 	int i, h;
 
 	for (i = 0; i < NPROTO; i++) {
-		for (h = 0; h < NF_MAX_HOOKS; h++)
+		for (h = 0; h < NF_MAX_HOOKS; h++) {
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
+			INIT_LIST_HEAD(&nf_sk_hooks[i][h]);
+		}
 	}
 }
 
