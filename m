From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: ipt_CLUSTERIP: Fix potential deadlock when CLUSTERIP target is inserted
Date: Sun,  3 Sep 2017 23:31:04 +0900
Message-ID: <20170903143104.25994-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38263 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbdICObL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 10:31:11 -0400
Received: by mail-pg0-f65.google.com with SMTP id t3so2964287pgt.5
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Sep 2017 07:31:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When ipt_CLUSTERIP target is inserted, lockdep warns about
possible DEADLOCK situation. to avoid deadlock situation
register_netdevice_notifier() should be called by only init routine.

reproduce command is :
   # iptables -A INPUT -p tcp -i enp3s0 -d 192.168.0.5 --dport 80 \
-j CLUSTERIP --new --hashmode sourceip \
--clustermac 01:00:5e:00:00:20 --total-nodes 2 --local-node 1

warning message is :

[  148.751110] WARNING: possible circular locking dependency detected
[  148.758037] 4.13.0-rc1+ #71 Not tainted
[  148.762334] ------------------------------------------------------

[ ... ]

	the existing dependency chain (in reverse order) is:
[  148.816203]
	-> #1 (sk_lock-AF_INET){+.+.+.}:
[  148.822686]        lock_acquire+0x190/0x370
[  148.827401]        lock_sock_nested+0xb8/0x100
[  148.832405]        do_ip_setsockopt.isra.16+0x140/0x24f0
[  148.838380]        ip_setsockopt+0x34/0xb0
[  148.842988]        udp_setsockopt+0x1b/0x30
[  148.847692]        sock_common_setsockopt+0x78/0xf0
[  148.853182]        SyS_setsockopt+0x11c/0x220
[  148.858089]        do_syscall_64+0x187/0x410
[  148.862901]        return_from_SYSCALL_64+0x0/0x7a
[  148.868289]
	-> #0 (rtnl_mutex){+.+.+.}:
[  148.874303]        __lock_acquire+0x4114/0x47c0
[  148.879405]        lock_acquire+0x190/0x370
[  148.884109]        __mutex_lock+0xef/0x1460
[  148.888820]        mutex_lock_nested+0x1b/0x20
[  148.893824]        rtnl_lock+0x17/0x20
[  148.898052]        register_netdevice_notifier+0x6f/0x4f0
[  148.904127]        clusterip_tg_check+0xbf0/0x13e0
[  148.909519]        xt_check_target+0x1f5/0x6c0
[  148.914525]        find_check_entry.isra.7+0x62f/0x960
[  148.920308]        translate_table+0xcf2/0x1830
[  148.925410]        do_ipt_set_ctl+0x1ff/0x3a0
[  148.930320]        nf_setsockopt+0x61/0xc0
[  148.934933]        ip_setsockopt+0x82/0xb0
[  148.939548]        raw_setsockopt+0x73/0xa0
[  148.944260]        sock_common_setsockopt+0x78/0xf0
[  148.949749]        SyS_setsockopt+0x11c/0x220
[  148.954658]        entry_SYSCALL_64_fastpath+0x1c/0xb1
[  148.960435]
	other info that might help us debug this:

[  148.969459]  Possible unsafe locking scenario:

[  148.976124]        CPU0                    CPU1
[  148.981218]        ----                    ----
[  148.986312]   lock(sk_lock-AF_INET);
[  148.990343]                                lock(rtnl_mutex);
[  148.996708]                                lock(sk_lock-AF_INET);
[  149.003559]   lock(rtnl_mutex);
[  149.007103]
*** DEADLOCK ***

[ ... ]

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 70 +++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 6637e8b..c31f188 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -59,7 +59,6 @@ struct clusterip_config {
 	struct rcu_head rcu;
 
 	char ifname[IFNAMSIZ];			/* device ifname */
-	struct notifier_block notifier;		/* refresh c->ifindex in it */
 };
 
 #ifdef CONFIG_PROC_FS
@@ -73,6 +72,7 @@ struct clusterip_net {
 	/* lock protects the configs list */
 	spinlock_t lock;
 
+	struct notifier_block notifier;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 #endif
@@ -111,8 +111,6 @@ clusterip_config_entry_put(struct net *net, struct clusterip_config *c)
 		spin_unlock(&cn->lock);
 		local_bh_enable();
 
-		unregister_netdevice_notifier(&c->notifier);
-
 		/* In case anyone still accesses the file, the open/close
 		 * functions are also incrementing the refcount on their own,
 		 * so it's safe to remove the entry even if it's in use. */
@@ -176,32 +174,37 @@ clusterip_netdev_event(struct notifier_block *this, unsigned long event,
 		       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 	struct clusterip_config *c;
 
-	c = container_of(this, struct clusterip_config, notifier);
-	switch (event) {
-	case NETDEV_REGISTER:
-		if (!strcmp(dev->name, c->ifname)) {
-			c->ifindex = dev->ifindex;
-			dev_mc_add(dev, c->clustermac);
-		}
-		break;
-	case NETDEV_UNREGISTER:
-		if (dev->ifindex == c->ifindex) {
-			dev_mc_del(dev, c->clustermac);
-			c->ifindex = -1;
-		}
-		break;
-	case NETDEV_CHANGENAME:
-		if (!strcmp(dev->name, c->ifname)) {
-			c->ifindex = dev->ifindex;
-			dev_mc_add(dev, c->clustermac);
-		} else if (dev->ifindex == c->ifindex) {
-			dev_mc_del(dev, c->clustermac);
-			c->ifindex = -1;
+	rcu_read_lock();
+	list_for_each_entry_rcu(c, &cn->configs, list) {
+		switch (event) {
+		case NETDEV_REGISTER:
+			if (!strcmp(dev->name, c->ifname)) {
+				c->ifindex = dev->ifindex;
+				dev_mc_add(dev, c->clustermac);
+			}
+			break;
+		case NETDEV_UNREGISTER:
+			if (dev->ifindex == c->ifindex) {
+				dev_mc_del(dev, c->clustermac);
+				c->ifindex = -1;
+			}
+			break;
+		case NETDEV_CHANGENAME:
+			if (!strcmp(dev->name, c->ifname)) {
+				c->ifindex = dev->ifindex;
+				dev_mc_add(dev, c->clustermac);
+			} else if (dev->ifindex == c->ifindex) {
+				dev_mc_del(dev, c->clustermac);
+				c->ifindex = -1;
+			}
+			break;
 		}
-		break;
 	}
+	rcu_read_unlock();
 
 	return NOTIFY_DONE;
 }
@@ -256,11 +259,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	}
 #endif
 
-	c->notifier.notifier_call = clusterip_netdev_event;
-	err = register_netdevice_notifier(&c->notifier);
-	if (!err)
-		return c;
-
+	return c;
 #ifdef CONFIG_PROC_FS
 	proc_remove(c->pde);
 err:
@@ -798,9 +797,17 @@ static int clusterip_net_init(struct net *net)
 	if (ret < 0)
 		return ret;
 
+	cn->notifier.notifier_call = clusterip_netdev_event;
+	ret = register_netdevice_notifier(&cn->notifier);
+	if (ret) {
+		nf_unregister_net_hook(net, &cip_arp_ops);
+		return ret;
+	}
+
 #ifdef CONFIG_PROC_FS
 	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
+		unregister_netdevice_notifier(&cn->notifier);
 		nf_unregister_net_hook(net, &cip_arp_ops);
 		pr_err("Unable to proc dir entry\n");
 		return -ENOMEM;
@@ -812,10 +819,11 @@ static int clusterip_net_init(struct net *net)
 
 static void clusterip_net_exit(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+#ifdef CONFIG_PROC_FS
 	proc_remove(cn->procdir);
 #endif
+	unregister_netdevice_notifier(&cn->notifier);
 	nf_unregister_net_hook(net, &cip_arp_ops);
 }
 
-- 
2.9.3

