From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: Fix/improve deadlock condition on module removal
	netfilter
Date: Mon, 10 Sep 2007 00:20:41 +0200 (MEST)
Message-ID: <20070909221739.25157.4141.sendpatchset@localhost.localdomain>
References: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix/improve deadlock condition on module removal netfilter

So I've had a deadlock reported to me.  I've found that the sequence of
events goes like this:

1) process A (modprobe) runs to remove ip_tables.ko

2) process B (iptables-restore) runs and calls setsockopt on a netfilter socket,
increasing the ip_tables socket_ops use count

3) process A acquires a file lock on the file ip_tables.ko, calls remove_module
in the kernel, which in turn executes the ip_tables module cleanup routine,
which calls nf_unregister_sockopt

4) nf_unregister_sockopt, seeing that the use count is non-zero, puts the
calling process into uninterruptible sleep, expecting the process using the
socket option code to wake it up when it exits the kernel

4) the user of the socket option code (process B) in do_ipt_get_ctl, calls
ipt_find_table_lock, which in this case calls request_module to load
ip_tables_nat.ko

5) request_module forks a copy of modprobe (process C) to load the module and
blocks until modprobe exits.

6) Process C. forked by request_module process the dependencies of
ip_tables_nat.ko, of which ip_tables.ko is one.

7) Process C attempts to lock the request module and all its dependencies, it
blocks when it attempts to lock ip_tables.ko (which was previously locked in
step 3)

Theres not really any great permanent solution to this that I can see, but I've
developed a two part solution that corrects the problem

Part 1) Modifies the nf_sockopt registration code so that, instead of using a
use counter internal to the nf_sockopt_ops structure, we instead use a pointer
to the registering modules owner to do module reference counting when nf_sockopt
calls a modules set/get routine.  This prevents the deadlock by preventing set 4
from happening.

Part 2) Enhances the modprobe utilty so that by default it preforms non-blocking
remove operations (the same way rmmod does), and add an option to explicity
request blocking operation.  So if you select blocking operation in modprobe you
can still cause the above deadlock, but only if you explicity try (and since
root can do any old stupid thing it would like....  :)  ).

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5bb6d2d373f47c4215a073ec0f53080b57a399f5
tree 1377a5178becc2e20eb97187f6a632d3d23aa7ee
parent 0fb0ffa355d0db63cf6f9dda9958c91e4bc7c859
author Neil Horman <nhorman@tuxdriver.com> Mon, 10 Sep 2007 00:13:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 10 Sep 2007 00:13:16 +0200

 include/linux/netfilter.h                      |    5 +--
 net/bridge/netfilter/ebtables.c                |    1 +
 net/ipv4/ipvs/ip_vs_ctl.c                      |    1 +
 net/ipv4/netfilter/arp_tables.c                |    1 +
 net/ipv4/netfilter/ip_tables.c                 |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 net/ipv6/netfilter/ip6_tables.c                |    1 +
 net/netfilter/nf_sockopt.c                     |   36 +++++++-----------------
 8 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0eed0b7..1dd075e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -88,9 +88,8 @@ struct nf_sockopt_ops
 	int (*compat_get)(struct sock *sk, int optval,
 			void __user *user, int *len);
 
-	/* Number of users inside set() or get(). */
-	unsigned int use;
-	struct task_struct *cleanup_task;
+	/* Use the module struct to lock set/get code in place */
+	struct module *owner;
 };
 
 /* Each queued (to userspace) skbuff has one of these. */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 4169a2a..6018d0e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1513,6 +1513,7 @@ static struct nf_sockopt_ops ebt_sockopts =
 	.get_optmin	= EBT_BASE_CTL,
 	.get_optmax	= EBT_SO_GET_MAX + 1,
 	.get		= do_ebt_get_ctl,
+	.owner		= THIS_MODULE,
 };
 
 static int __init ebtables_init(void)
diff --git a/net/ipv4/ipvs/ip_vs_ctl.c b/net/ipv4/ipvs/ip_vs_ctl.c
index 902fd57..f656d41 100644
--- a/net/ipv4/ipvs/ip_vs_ctl.c
+++ b/net/ipv4/ipvs/ip_vs_ctl.c
@@ -2339,6 +2339,7 @@ static struct nf_sockopt_ops ip_vs_sockopts = {
 	.get_optmin	= IP_VS_BASE_CTL,
 	.get_optmax	= IP_VS_SO_GET_MAX+1,
 	.get		= do_ip_vs_get_ctl,
+	.owner		= THIS_MODULE,
 };
 
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d1149ab..29114a9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1161,6 +1161,7 @@ static struct nf_sockopt_ops arpt_sockopts = {
 	.get_optmin	= ARPT_BASE_CTL,
 	.get_optmax	= ARPT_SO_GET_MAX+1,
 	.get		= do_arpt_get_ctl,
+	.owner		= THIS_MODULE,
 };
 
 static int __init arp_tables_init(void)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e1b402c..6486894 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2296,6 +2296,7 @@ static struct nf_sockopt_ops ipt_sockopts = {
 #ifdef CONFIG_COMPAT
 	.compat_get	= compat_do_ipt_get_ctl,
 #endif
+	.owner		= THIS_MODULE,
 };
 
 static struct xt_match icmp_matchstruct __read_mostly = {
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 53cb177..f813e02 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -399,6 +399,7 @@ static struct nf_sockopt_ops so_getorigdst = {
 	.get_optmin	= SO_ORIGINAL_DST,
 	.get_optmax	= SO_ORIGINAL_DST+1,
 	.get		= &getorigdst,
+	.owner		= THIS_MODULE,
 };
 
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index aeda617..cd9df02 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1462,6 +1462,7 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.get_optmin	= IP6T_BASE_CTL,
 	.get_optmax	= IP6T_SO_GET_MAX+1,
 	.get		= do_ip6t_get_ctl,
+	.owner		= THIS_MODULE,
 };
 
 static struct xt_match icmp6_matchstruct __read_mostly = {
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 8b8ece7..e32761c 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -55,18 +55,7 @@ EXPORT_SYMBOL(nf_register_sockopt);
 
 void nf_unregister_sockopt(struct nf_sockopt_ops *reg)
 {
-	/* No point being interruptible: we're probably in cleanup_module() */
- restart:
 	mutex_lock(&nf_sockopt_mutex);
-	if (reg->use != 0) {
-		/* To be woken by nf_sockopt call... */
-		/* FIXME: Stuart Young's name appears gratuitously. */
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		reg->cleanup_task = current;
-		mutex_unlock(&nf_sockopt_mutex);
-		schedule();
-		goto restart;
-	}
 	list_del(&reg->list);
 	mutex_unlock(&nf_sockopt_mutex);
 }
@@ -86,10 +75,11 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 	list_for_each(i, &nf_sockopts) {
 		ops = (struct nf_sockopt_ops *)i;
 		if (ops->pf == pf) {
+			if (!try_module_get(ops->owner))
+				goto out_nosup;
 			if (get) {
 				if (val >= ops->get_optmin
 				    && val < ops->get_optmax) {
-					ops->use++;
 					mutex_unlock(&nf_sockopt_mutex);
 					ret = ops->get(sk, val, opt, len);
 					goto out;
@@ -97,23 +87,20 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 			} else {
 				if (val >= ops->set_optmin
 				    && val < ops->set_optmax) {
-					ops->use++;
 					mutex_unlock(&nf_sockopt_mutex);
 					ret = ops->set(sk, val, opt, *len);
 					goto out;
 				}
 			}
+			module_put(ops->owner);
 		}
 	}
+ out_nosup:
 	mutex_unlock(&nf_sockopt_mutex);
 	return -ENOPROTOOPT;
 
  out:
-	mutex_lock(&nf_sockopt_mutex);
-	ops->use--;
-	if (ops->cleanup_task)
-		wake_up_process(ops->cleanup_task);
-	mutex_unlock(&nf_sockopt_mutex);
+	module_put(ops->owner);
 	return ret;
 }
 
@@ -144,10 +131,12 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 	list_for_each(i, &nf_sockopts) {
 		ops = (struct nf_sockopt_ops *)i;
 		if (ops->pf == pf) {
+			if (!try_module_get(ops->owner))
+				goto out_nosup;
+
 			if (get) {
 				if (val >= ops->get_optmin
 				    && val < ops->get_optmax) {
-					ops->use++;
 					mutex_unlock(&nf_sockopt_mutex);
 					if (ops->compat_get)
 						ret = ops->compat_get(sk,
@@ -160,7 +149,6 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 			} else {
 				if (val >= ops->set_optmin
 				    && val < ops->set_optmax) {
-					ops->use++;
 					mutex_unlock(&nf_sockopt_mutex);
 					if (ops->compat_set)
 						ret = ops->compat_set(sk,
@@ -171,17 +159,15 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 					goto out;
 				}
 			}
+			module_put(ops->owner);
 		}
 	}
+ out_nosup:
 	mutex_unlock(&nf_sockopt_mutex);
 	return -ENOPROTOOPT;
 
  out:
-	mutex_lock(&nf_sockopt_mutex);
-	ops->use--;
-	if (ops->cleanup_task)
-		wake_up_process(ops->cleanup_task);
-	mutex_unlock(&nf_sockopt_mutex);
+	module_put(ops->owner);
 	return ret;
 }
 
