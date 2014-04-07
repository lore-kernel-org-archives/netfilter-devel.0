From: Kirill Tkhai <ktkhai@parallels.com>
Subject: [PATCH --smtp-server=mail.sw.ru] ipt_CLUSTERIP: Add network device
 notifier
Date: Mon, 07 Apr 2014 15:37:11 +0400
Message-ID: <20140407113644.22540.42391.stgit@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tkhai@yandex.ru, kaber@trash.net, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from swsoft-msk-nat.sw.ru ([195.214.232.10]:63069 "EHLO tkhai"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753510AbaDGLv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:51:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Clusterip target does dev_hold() in .checkentry, while dev_put() in .destroy.
So, unregister_netdevice catches the leak:

# modprobe dummy
# iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashmode sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 --local-node 1
# rmmod dummy

   Message from syslogd@localhost ...
     kernel: unregister_netdevice: waiting for dummy0 to become free. Usage count = 1

To fix that we add netdevice notifier, which masks target is inactive
(i.e., it sets target.dev to NULL) when device is going away,
and executes dev_put().

If the device comes back, the target is being masked as active and does
dev_hold().

Initially I found this on OpenVZ kernel 2.6.32, when I was investigating
a leak on container stopping.

The call:

unregister_netdevice()  --->  waiting for device refcnt is 1  ---> fail

was before:

ipt_unregister_table()  --->  remove_target.destroy() ---> dev_put();

It looks like, containers on vanila kernel have the same problem
with stopping.

***

The another solution for this is to implement generic deletion of
any rule from ip table, but it requires a lot of userspace iptable
parsing functionality to be moved into kernel. ipt_CLUSTERIP is
the only module which needs this, so it looks like the local fix
of this patch is enough.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Patrick McHardy <kaber@trash.net>
CC: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |  146 +++++++++++++++++++++++++++++++++---
 1 file changed, 134 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2510c02..f878946 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -46,7 +46,10 @@ struct clusterip_config {
 
 	__be32 clusterip;			/* the IP address */
 	u_int8_t clustermac[ETH_ALEN];		/* the MAC address */
-	struct net_device *dev;			/* device */
+	struct net_device *dev;			/* device. Access to dev->...
+						 * fields requires
+						 * &cn->lock is held */
+	char dev_name[IFNAMSIZ];
 	u_int16_t num_total_nodes;		/* total number of nodes */
 	unsigned long local_nodes;		/* node number array */
 
@@ -97,9 +100,8 @@ clusterip_config_put(struct clusterip_config *c)
  * entry(rule) is removed, remove the config from lists, but don't free it
  * yet, since proc-files could still be holding references */
 static inline void
-clusterip_config_entry_put(struct clusterip_config *c)
+clusterip_config_entry_put(struct net *net, struct clusterip_config *c)
 {
-	struct net *net = dev_net(c->dev);
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
 	local_bh_disable();
@@ -108,8 +110,10 @@ clusterip_config_entry_put(struct clusterip_config *c)
 		spin_unlock(&cn->lock);
 		local_bh_enable();
 
-		dev_mc_del(c->dev, c->clustermac);
-		dev_put(c->dev);
+		if (c->dev) {
+			dev_mc_del(c->dev, c->clustermac);
+			dev_put(c->dev);
+		}
 
 		/* In case anyone still accesses the file, the open/close
 		 * functions are also incrementing the refcount on their own,
@@ -176,6 +180,7 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 		return NULL;
 
 	c->dev = dev;
+	memcpy(c->dev_name, dev->name, IFNAMSIZ);
 	c->clusterip = ip;
 	memcpy(&c->clustermac, &i->clustermac, ETH_ALEN);
 	c->num_total_nodes = i->num_total_nodes;
@@ -295,6 +300,91 @@ clusterip_responsible(const struct clusterip_config *config, u_int32_t hash)
 }
 
 /***********************************************************************
+ * NETDEVICE NOTIFIER
+ ***********************************************************************/
+static int cip_unregister_device(struct net_device *dev)
+{
+	struct net *net = dev_net(dev);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	struct clusterip_config *c;
+
+	spin_lock_bh(&cn->lock);
+
+	list_for_each_entry_rcu(c, &cn->configs, list)
+		if (c->dev == dev) {
+			c->dev = NULL;
+			dev_mc_del(dev, c->clustermac);
+			dev_put(dev);
+		}
+
+	spin_unlock_bh(&cn->lock);
+
+	synchronize_net();
+
+	return NOTIFY_DONE;
+}
+
+static int cip_register_device(struct net_device *dev)
+{
+	struct net *net = dev_net(dev);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	struct clusterip_config *c;
+
+	spin_lock_bh(&cn->lock);
+
+	list_for_each_entry_rcu(c, &cn->configs, list)
+		if (!c->dev && strcmp(c->dev_name, dev->name) == 0) {
+			dev_hold(dev);
+			dev_mc_add(dev, c->clustermac);
+			c->dev = dev;
+		}
+
+	spin_unlock_bh(&cn->lock);
+
+	synchronize_net();
+
+	return NOTIFY_DONE;
+}
+
+static int cip_rename_device(struct net_device *dev)
+{
+	struct net *net = dev_net(dev);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	struct clusterip_config *c;
+
+	spin_lock_bh(&cn->lock);
+
+	list_for_each_entry_rcu(c, &cn->configs, list)
+		if (c->dev == dev)
+			memcpy(c->dev_name, dev->name, IFNAMSIZ);
+
+	spin_unlock_bh(&cn->lock);
+
+	return NOTIFY_DONE;
+}
+
+static int cip_dev_notify(struct notifier_block *this, unsigned long event,
+			  void *data)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(data);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		return cip_unregister_device(dev);
+	case NETDEV_REGISTER:
+		return cip_register_device(dev);
+	case NETDEV_CHANGENAME:
+		return cip_rename_device(dev);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cip_dev_notifier = {
+	.notifier_call = cip_dev_notify,
+	.priority = 0
+};
+
+/***********************************************************************
  * IPTABLES TARGET
  ***********************************************************************/
 
@@ -365,6 +455,9 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 	struct clusterip_config *config;
+	struct net *net = par->net;
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	struct net_device *dev;
 	int ret;
 
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
@@ -382,15 +475,13 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(par->net, e->ip.dst.s_addr, 1);
+	config = clusterip_config_find_get(net, e->ip.dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			pr_info("no config found for %pI4, need 'new'\n",
 				&e->ip.dst.s_addr);
 			return -EINVAL;
 		} else {
-			struct net_device *dev;
-
 			if (e->ip.iniface[0] == '\0') {
 				pr_info("Please specify an interface name\n");
 				return -EINVAL;
@@ -411,6 +502,30 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			}
 			dev_mc_add(config->dev, config->clustermac);
 		}
+	} else if (!config->dev) {
+		int fail = 0;
+		/* Device were removed, so we need insert it back */
+		dev = dev_get_by_name(net, e->ip.iniface);
+		if (!dev) {
+			clusterip_config_entry_put(net, config);
+			printk(KERN_WARNING "CLUSTERIP: no such interface %s\n", e->ip.iniface);
+			return false;
+		}
+		spin_lock_bh(&cn->lock);
+		/* Check again under lock */
+		if (config->dev == NULL) {
+			config->dev = dev;
+			memcpy(config->dev_name, dev->name, IFNAMSIZ);
+			dev_mc_add(config->dev, config->clustermac);
+		} else
+			fail = 1;
+		spin_unlock_bh(&cn->lock);
+
+		if (fail) {
+			dev_put(dev);
+			clusterip_config_entry_put(net, config);
+			return false;
+		}
 	}
 	cipinfo->config = config;
 
@@ -428,7 +543,7 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
-	clusterip_config_entry_put(cipinfo->config);
+	clusterip_config_entry_put(par->net, cipinfo->config);
 
 	clusterip_config_put(cipinfo->config);
 
@@ -522,7 +637,7 @@ arp_mangle(const struct nf_hook_ops *ops,
 	/* if there is no clusterip configuration for the arp reply's
 	 * source ip, we don't want to mangle it */
 	c = clusterip_config_find_get(net, payload->src_ip, 0);
-	if (!c)
+	if (!c || !c->dev)
 		return NF_ACCEPT;
 
 	/* normally the linux kernel always replies to arp queries of
@@ -532,7 +647,7 @@ arp_mangle(const struct nf_hook_ops *ops,
 	if (c->dev != out) {
 		pr_debug("not mangling arp reply on different "
 			 "interface: cip'%s'-skb'%s'\n",
-			 c->dev->name, out->name);
+			 c->dev_name, out->name);
 		clusterip_config_put(c);
 		return NF_ACCEPT;
 	}
@@ -753,10 +868,14 @@ static int __init clusterip_tg_init(void)
 	if (ret < 0)
 		return ret;
 
-	ret = xt_register_target(&clusterip_tg_reg);
+	ret = register_netdevice_notifier(&cip_dev_notifier);
 	if (ret < 0)
 		goto cleanup_subsys;
 
+	ret = xt_register_target(&clusterip_tg_reg);
+	if (ret < 0)
+		goto cleanup_notifier;
+
 	ret = nf_register_hook(&cip_arp_ops);
 	if (ret < 0)
 		goto cleanup_target;
@@ -768,6 +887,8 @@ static int __init clusterip_tg_init(void)
 
 cleanup_target:
 	xt_unregister_target(&clusterip_tg_reg);
+cleanup_notifier:
+	unregister_netdevice_notifier(&cip_dev_notifier);
 cleanup_subsys:
 	unregister_pernet_subsys(&clusterip_net_ops);
 	return ret;
@@ -779,6 +900,7 @@ static void __exit clusterip_tg_exit(void)
 
 	nf_unregister_hook(&cip_arp_ops);
 	xt_unregister_target(&clusterip_tg_reg);
+	unregister_netdevice_notifier(&cip_dev_notifier);
 	unregister_pernet_subsys(&clusterip_net_ops);
 
 	/* Wait for completion of call_rcu_bh()'s (clusterip_config_rcu_free) */

