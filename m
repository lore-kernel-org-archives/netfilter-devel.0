From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/33]: nf_conntrack: split out protocol handling
Date: Wed, 29 Nov 2006 03:08:50 +0100 (MET)
Message-ID: <20061129020849.21082.68576.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: split out protocol handling

This patch splits out L3/L4 protocol handling into its own file
nf_conntrack_proto.c

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d27a49059250fc2676533e533fcbe77de3b8b112
tree d01bb6048cd687fe9351cb09da75ea007b2fbd76
parent 7ac05737ce5e38dc88375e149281efa0afbcadb6
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:12:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:12:54 +0100

 net/netfilter/Makefile                  |    2 
 net/netfilter/nf_conntrack_core.c       |   81 -----------
 net/netfilter/nf_conntrack_proto.c      |  225 +++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c |  116 ----------------
 4 files changed, 226 insertions(+), 198 deletions(-)

diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index fd0641d..627105d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 029acc4..09c0e63 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,8 +73,6 @@ DEFINE_RWLOCK(nf_conntrack_lock);
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
-struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
-struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
 unsigned int nf_conntrack_htable_size __read_mostly = 0;
 int nf_conntrack_max __read_mostly;
 struct list_head *nf_conntrack_hash __read_mostly;
@@ -115,85 +113,6 @@ DEFINE_RWLOCK(nf_ct_cache_lock);
 /* This avoids calling kmem_cache_create() with same name simultaneously */
 static DEFINE_MUTEX(nf_ct_cache_mutex);
 
-extern struct nf_conntrack_protocol nf_conntrack_generic_protocol;
-struct nf_conntrack_protocol *
-__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
-{
-	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
-		return &nf_conntrack_generic_protocol;
-
-	return nf_ct_protos[l3proto][protocol];
-}
-
-/* this is guaranteed to always return a valid protocol helper, since
- * it falls back to generic_protocol */
-struct nf_conntrack_protocol *
-nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol)
-{
-	struct nf_conntrack_protocol *p;
-
-	preempt_disable();
-	p = __nf_ct_proto_find(l3proto, protocol);
-	if (!try_module_get(p->me))
-		p = &nf_conntrack_generic_protocol;
-	preempt_enable();
-	
-	return p;
-}
-
-void nf_ct_proto_put(struct nf_conntrack_protocol *p)
-{
-	module_put(p->me);
-}
-
-struct nf_conntrack_l3proto *
-nf_ct_l3proto_find_get(u_int16_t l3proto)
-{
-	struct nf_conntrack_l3proto *p;
-
-	preempt_disable();
-	p = __nf_ct_l3proto_find(l3proto);
-	if (!try_module_get(p->me))
-		p = &nf_conntrack_generic_l3proto;
-	preempt_enable();
-
-	return p;
-}
-
-void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p)
-{
-	module_put(p->me);
-}
-
-int
-nf_ct_l3proto_try_module_get(unsigned short l3proto)
-{
-	int ret;
-	struct nf_conntrack_l3proto *p;
-
-retry:	p = nf_ct_l3proto_find_get(l3proto);
-	if (p == &nf_conntrack_generic_l3proto) {
-		ret = request_module("nf_conntrack-%d", l3proto);
-		if (!ret)
-			goto retry;
-
-		return -EPROTOTYPE;
-	}
-
-	return 0;
-}
-
-void nf_ct_l3proto_module_put(unsigned short l3proto)
-{
-	struct nf_conntrack_l3proto *p;
-
-	preempt_disable();
-	p = __nf_ct_l3proto_find(l3proto);
-	preempt_enable();
-
-	module_put(p->me);
-}
-
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
new file mode 100644
index 0000000..24c61a3
--- /dev/null
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -0,0 +1,225 @@
+/* L3/L4 protocol support for nf_conntrack. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/stddef.h>
+#include <linux/err.h>
+#include <linux/percpu.h>
+#include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_core.h>
+
+struct nf_conntrack_protocol **nf_ct_protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
+
+struct nf_conntrack_protocol *
+__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
+{
+	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
+		return &nf_conntrack_generic_protocol;
+
+	return nf_ct_protos[l3proto][protocol];
+}
+
+/* this is guaranteed to always return a valid protocol helper, since
+ * it falls back to generic_protocol */
+struct nf_conntrack_protocol *
+nf_ct_proto_find_get(u_int16_t l3proto, u_int8_t protocol)
+{
+	struct nf_conntrack_protocol *p;
+
+	preempt_disable();
+	p = __nf_ct_proto_find(l3proto, protocol);
+	if (!try_module_get(p->me))
+		p = &nf_conntrack_generic_protocol;
+	preempt_enable();
+
+	return p;
+}
+
+void nf_ct_proto_put(struct nf_conntrack_protocol *p)
+{
+	module_put(p->me);
+}
+
+struct nf_conntrack_l3proto *
+nf_ct_l3proto_find_get(u_int16_t l3proto)
+{
+	struct nf_conntrack_l3proto *p;
+
+	preempt_disable();
+	p = __nf_ct_l3proto_find(l3proto);
+	if (!try_module_get(p->me))
+		p = &nf_conntrack_generic_l3proto;
+	preempt_enable();
+
+	return p;
+}
+
+void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p)
+{
+	module_put(p->me);
+}
+
+int
+nf_ct_l3proto_try_module_get(unsigned short l3proto)
+{
+	int ret;
+	struct nf_conntrack_l3proto *p;
+
+retry:	p = nf_ct_l3proto_find_get(l3proto);
+	if (p == &nf_conntrack_generic_l3proto) {
+		ret = request_module("nf_conntrack-%d", l3proto);
+		if (!ret)
+			goto retry;
+
+		return -EPROTOTYPE;
+	}
+
+	return 0;
+}
+
+void nf_ct_l3proto_module_put(unsigned short l3proto)
+{
+	struct nf_conntrack_l3proto *p;
+
+	preempt_disable();
+	p = __nf_ct_l3proto_find(l3proto);
+	preempt_enable();
+
+	module_put(p->me);
+}
+
+static int kill_l3proto(struct nf_conn *i, void *data)
+{
+	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
+			((struct nf_conntrack_l3proto *)data)->l3proto);
+}
+
+static int kill_proto(struct nf_conn *i, void *data)
+{
+	struct nf_conntrack_protocol *proto;
+	proto = (struct nf_conntrack_protocol *)data;
+	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum ==
+			proto->proto) &&
+	       (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
+			proto->l3proto);
+}
+
+int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
+{
+	int ret = 0;
+
+	write_lock_bh(&nf_conntrack_lock);
+	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_generic_l3proto) {
+		ret = -EBUSY;
+		goto out;
+	}
+	nf_ct_l3protos[proto->l3proto] = proto;
+out:
+	write_unlock_bh(&nf_conntrack_lock);
+
+	return ret;
+}
+
+void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
+{
+	write_lock_bh(&nf_conntrack_lock);
+	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_generic_l3proto;
+	write_unlock_bh(&nf_conntrack_lock);
+
+	/* Somebody could be still looking at the proto in bh. */
+	synchronize_net();
+
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_cleanup(kill_l3proto, proto);
+}
+
+/* FIXME: Allow NULL functions and sub in pointers to generic for
+   them. --RR */
+int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto)
+{
+	int ret = 0;
+
+retry:
+	write_lock_bh(&nf_conntrack_lock);
+	if (nf_ct_protos[proto->l3proto]) {
+		if (nf_ct_protos[proto->l3proto][proto->proto]
+				!= &nf_conntrack_generic_protocol) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	} else {
+		/* l3proto may be loaded latter. */
+		struct nf_conntrack_protocol **proto_array;
+		int i;
+
+		write_unlock_bh(&nf_conntrack_lock);
+
+		proto_array = (struct nf_conntrack_protocol **)
+				kmalloc(MAX_NF_CT_PROTO *
+					 sizeof(struct nf_conntrack_protocol *),
+					GFP_KERNEL);
+		if (proto_array == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		for (i = 0; i < MAX_NF_CT_PROTO; i++)
+			proto_array[i] = &nf_conntrack_generic_protocol;
+
+		write_lock_bh(&nf_conntrack_lock);
+		if (nf_ct_protos[proto->l3proto]) {
+			/* bad timing, but no problem */
+			write_unlock_bh(&nf_conntrack_lock);
+			kfree(proto_array);
+		} else {
+			nf_ct_protos[proto->l3proto] = proto_array;
+			write_unlock_bh(&nf_conntrack_lock);
+		}
+
+		/*
+		 * Just once because array is never freed until unloading
+		 * nf_conntrack.ko
+		 */
+		goto retry;
+	}
+
+	nf_ct_protos[proto->l3proto][proto->proto] = proto;
+
+out_unlock:
+	write_unlock_bh(&nf_conntrack_lock);
+out:
+	return ret;
+}
+
+void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto)
+{
+	write_lock_bh(&nf_conntrack_lock);
+	nf_ct_protos[proto->l3proto][proto->proto]
+		= &nf_conntrack_generic_protocol;
+	write_unlock_bh(&nf_conntrack_lock);
+
+	/* Somebody could be still looking at the proto in bh. */
+	synchronize_net();
+
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_cleanup(kill_proto, proto);
+}
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 73ca156..eb031d2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -50,22 +50,6 @@ MODULE_LICENSE("GPL");
 extern atomic_t nf_conntrack_count;
 DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 
-static int kill_l3proto(struct nf_conn *i, void *data)
-{
-	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num == 
-			((struct nf_conntrack_l3proto *)data)->l3proto);
-}
-
-static int kill_proto(struct nf_conn *i, void *data)
-{
-	struct nf_conntrack_protocol *proto;
-	proto = (struct nf_conntrack_protocol *)data;
-	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == 
-			proto->proto) &&
-	       (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
-			proto->l3proto);
-}
-
 #ifdef CONFIG_PROC_FS
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
@@ -585,106 +569,6 @@ static ctl_table nf_ct_net_table[] = {
 EXPORT_SYMBOL(nf_ct_log_invalid);
 #endif /* CONFIG_SYSCTL */
 
-int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
-{
-	int ret = 0;
-
-	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_generic_l3proto) {
-		ret = -EBUSY;
-		goto out;
-	}
-	nf_ct_l3protos[proto->l3proto] = proto;
-out:
-	write_unlock_bh(&nf_conntrack_lock);
-
-	return ret;
-}
-
-void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
-{
-	write_lock_bh(&nf_conntrack_lock);
-	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_generic_l3proto;
-	write_unlock_bh(&nf_conntrack_lock);
-	
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
-
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(kill_l3proto, proto);
-}
-
-/* FIXME: Allow NULL functions and sub in pointers to generic for
-   them. --RR */
-int nf_conntrack_protocol_register(struct nf_conntrack_protocol *proto)
-{
-	int ret = 0;
-
-retry:
-	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_protos[proto->l3proto]) {
-		if (nf_ct_protos[proto->l3proto][proto->proto]
-				!= &nf_conntrack_generic_protocol) {
-			ret = -EBUSY;
-			goto out_unlock;
-		}
-	} else {
-		/* l3proto may be loaded latter. */
-		struct nf_conntrack_protocol **proto_array;
-		int i;
-
-		write_unlock_bh(&nf_conntrack_lock);
-
-		proto_array = (struct nf_conntrack_protocol **)
-				kmalloc(MAX_NF_CT_PROTO *
-					 sizeof(struct nf_conntrack_protocol *),
-					GFP_KERNEL);
-		if (proto_array == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		for (i = 0; i < MAX_NF_CT_PROTO; i++)
-			proto_array[i] = &nf_conntrack_generic_protocol;
-
-		write_lock_bh(&nf_conntrack_lock);
-		if (nf_ct_protos[proto->l3proto]) {
-			/* bad timing, but no problem */
-			write_unlock_bh(&nf_conntrack_lock);
-			kfree(proto_array);
-		} else {
-			nf_ct_protos[proto->l3proto] = proto_array;
-			write_unlock_bh(&nf_conntrack_lock);
-		}
-
-		/*
-		 * Just once because array is never freed until unloading
-		 * nf_conntrack.ko
-		 */
-		goto retry;
-	}
-
-	nf_ct_protos[proto->l3proto][proto->proto] = proto;
-
-out_unlock:
-	write_unlock_bh(&nf_conntrack_lock);
-out:
-	return ret;
-}
-
-void nf_conntrack_protocol_unregister(struct nf_conntrack_protocol *proto)
-{
-	write_lock_bh(&nf_conntrack_lock);
-	nf_ct_protos[proto->l3proto][proto->proto]
-		= &nf_conntrack_generic_protocol;
-	write_unlock_bh(&nf_conntrack_lock);
-	
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
-
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(kill_proto, proto);
-}
-
 static int __init nf_conntrack_standalone_init(void)
 {
 #ifdef CONFIG_PROC_FS
