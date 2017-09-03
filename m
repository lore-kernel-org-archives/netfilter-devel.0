From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V2] netfilter: xt_TEE: Fix potential deadlock when TEE target is inserted
Date: Mon,  4 Sep 2017 01:11:19 +0900
Message-ID: <20170903161119.15031-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, jengelh@inai.de,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33098 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdICQL0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 12:11:26 -0400
Received: by mail-pg0-f65.google.com with SMTP id m15so3083004pgc.0
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Sep 2017 09:11:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When xt_TEE target is inserted, lockdep warns about possible
DEADLOCK situation. to avoid deadlock situation
the register_netdevice_notifier() should be called by only init routine.

reproduce command is :
   # iptables -I INPUT -j TEE --oif enp3s0 --gateway 192.168.0.1

warning message is :

[  115.182917] WARNING: possible circular locking dependency detected
[  115.189846] 4.13.0-rc1+ #68 Not tainted
[  115.194141] ------------------------------------------------------
[  115.201065] iptables/1283 is trying to acquire lock:
[  115.206627]  (rtnl_mutex){+.+.+.}, at: [<ffffffff8236f0d7>] rtnl_lock+0x17/0x20
[  115.214842]
[  115.214842] but task is already holding lock:
[  115.221378]  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff8273ab0d>] ip_setsockopt+0x6d/0xb0
[  115.230462]
[  115.230462] which lock already depends on the new lock.
[  115.230462]
[  115.239627]
[  115.239627] the existing dependency chain (in reverse order) is:
[  115.248012]
[  115.248012] -> #1 (sk_lock-AF_INET){+.+.+.}:
[  115.254472]        lock_acquire+0x190/0x370
[  115.259165]        lock_sock_nested+0xb8/0x100
[  115.264148]        do_ip_setsockopt.isra.16+0x140/0x24f0
[  115.270125]        ip_setsockopt+0x34/0xb0
[  115.274742]        udp_setsockopt+0x1b/0x30
[  115.279455]        sock_common_setsockopt+0x78/0xf0
[  115.284937]        SyS_setsockopt+0x11c/0x220
[  115.289835]        do_syscall_64+0x187/0x410
[  115.294638]        return_from_SYSCALL_64+0x0/0x7a
[  115.300025]
[  115.300025] -> #0 (rtnl_mutex){+.+.+.}:
[  115.306030]        __lock_acquire+0x4114/0x47c0
[  115.311132]        lock_acquire+0x190/0x370
[  115.315844]        __mutex_lock+0xef/0x1460
[  115.320555]        mutex_lock_nested+0x1b/0x20
[  115.325558]        rtnl_lock+0x17/0x20
[  115.329785]        register_netdevice_notifier+0x6f/0x4f0
[  115.335851]        tee_tg_check+0x19b/0x260
[  115.340562]        xt_check_target+0x1f5/0x6c0
[  115.345569]        find_check_entry.isra.7+0x62f/0x960
[  115.351353]        translate_table+0xcf2/0x1830
[  115.356454]        do_ipt_set_ctl+0x1ff/0x3a0
[  115.361362]        nf_setsockopt+0x61/0xc0
[  115.365977]        ip_setsockopt+0x82/0xb0
[  115.370592]        raw_setsockopt+0x73/0xa0
[  115.375304]        sock_common_setsockopt+0x78/0xf0
[  115.380793]        SyS_setsockopt+0x11c/0x220
[  115.385701]        entry_SYSCALL_64_fastpath+0x1c/0xb1
[  115.391478]
[  115.391478] other info that might help us debug this:
[  115.391478]
[  115.400511]  Possible unsafe locking scenario:
[  115.400511]
[  115.407176]        CPU0                    CPU1
[  115.412270]        ----                    ----
[  115.417364]   lock(sk_lock-AF_INET);
[  115.421394]                                lock(rtnl_mutex);
[  115.427760]                                lock(sk_lock-AF_INET);
[  115.434723]   lock(rtnl_mutex);
[  115.438267]
[  115.438267]  *** DEADLOCK ***

[ ... ]

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

V2:
 - Do not modify the xt_TEE.h

V1:
 - Initial version


 net/netfilter/xt_TEE.c | 89 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 86b0580..2aebbc0 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -12,19 +12,20 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/route.h>
 #include <linux/netfilter/x_tables.h>
-#include <net/route.h>
 #include <net/netfilter/ipv4/nf_dup_ipv4.h>
 #include <net/netfilter/ipv6/nf_dup_ipv6.h>
 #include <linux/netfilter/xt_TEE.h>
 
 struct xt_tee_priv {
-	struct notifier_block	notifier;
 	struct xt_tee_tginfo	*tginfo;
+	struct net		*net;
+	struct list_head	list;
 	int			oif;
 };
 
+static LIST_HEAD(tee_tg_list);
+static DEFINE_MUTEX(list_mutex);
 static const union nf_inet_addr tee_zero_address;
 
 static unsigned int
@@ -55,59 +56,68 @@ static int tee_netdev_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
 	struct xt_tee_priv *priv;
 
-	priv = container_of(this, struct xt_tee_priv, notifier);
-	switch (event) {
-	case NETDEV_REGISTER:
-		if (!strcmp(dev->name, priv->tginfo->oif))
-			priv->oif = dev->ifindex;
-		break;
-	case NETDEV_UNREGISTER:
-		if (dev->ifindex == priv->oif)
-			priv->oif = -1;
-		break;
-	case NETDEV_CHANGENAME:
-		if (!strcmp(dev->name, priv->tginfo->oif))
-			priv->oif = dev->ifindex;
-		else if (dev->ifindex == priv->oif)
-			priv->oif = -1;
-		break;
+	mutex_lock(&list_mutex);
+	list_for_each_entry(priv, &tee_tg_list, list) {
+		switch (event) {
+		case NETDEV_REGISTER:
+			if (!strcmp(dev->name, priv->tginfo->oif) &&
+			    net_eq(net, priv->net))
+				priv->oif = dev->ifindex;
+			break;
+		case NETDEV_UNREGISTER:
+			if (dev->ifindex == priv->oif && net_eq(net, priv->net))
+				priv->oif = -1;
+			break;
+		case NETDEV_CHANGENAME:
+			if (!strcmp(dev->name, priv->tginfo->oif) &&
+			    net_eq(net, priv->net))
+				priv->oif = dev->ifindex;
+			else if (dev->ifindex == priv->oif &&
+				 net_eq(net, priv->net))
+				priv->oif = -1;
+			break;
+		}
 	}
+	mutex_unlock(&list_mutex);
 
 	return NOTIFY_DONE;
 }
 
+static struct notifier_block tee_dev_notifier = {
+	.notifier_call	= tee_netdev_event,
+};
+
 static int tee_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_tee_tginfo *info = par->targinfo;
 	struct xt_tee_priv *priv;
 
 	/* 0.0.0.0 and :: not allowed */
-	if (memcmp(&info->gw, &tee_zero_address,
-		   sizeof(tee_zero_address)) == 0)
+	if (nf_inet_addr_cmp(&info->gw, &tee_zero_address)) {
+		pr_info("TEE: Invalid gateway address\n");
 		return -EINVAL;
+	}
 
 	if (info->oif[0]) {
-		int ret;
-
-		if (info->oif[sizeof(info->oif)-1] != '\0')
+		if (info->oif[sizeof(info->oif) - 1] != '\0') {
+			pr_info("TEE: Invalid oif name\n");
 			return -EINVAL;
+		}
 
 		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 		if (priv == NULL)
 			return -ENOMEM;
 
 		priv->tginfo  = info;
+		priv->net     = par->net;
 		priv->oif     = -1;
-		priv->notifier.notifier_call = tee_netdev_event;
 		info->priv    = priv;
-
-		ret = register_netdevice_notifier(&priv->notifier);
-		if (ret) {
-			kfree(priv);
-			return ret;
-		}
+		mutex_lock(&list_mutex);
+		list_add(&priv->list, &tee_tg_list);
+		mutex_unlock(&list_mutex);
 	} else
 		info->priv = NULL;
 
@@ -120,8 +130,10 @@ static void tee_tg_destroy(const struct xt_tgdtor_param *par)
 	struct xt_tee_tginfo *info = par->targinfo;
 
 	if (info->priv) {
-		unregister_netdevice_notifier(&info->priv->notifier);
+		mutex_lock(&list_mutex);
+		list_del(&info->priv->list);
 		kfree(info->priv);
+		mutex_unlock(&list_mutex);
 	}
 	static_key_slow_dec(&xt_tee_enabled);
 }
@@ -155,11 +167,22 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 
 static int __init tee_tg_init(void)
 {
-	return xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	int ret;
+
+	ret = xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	if (ret)
+		return ret;
+
+	ret = register_netdevice_notifier(&tee_dev_notifier);
+	if (ret)
+		xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+
+	return ret;
 }
 
 static void __exit tee_tg_exit(void)
 {
+	unregister_netdevice_notifier(&tee_dev_notifier);
 	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
 }
 
-- 
2.9.3

