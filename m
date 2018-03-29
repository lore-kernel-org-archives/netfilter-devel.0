From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 2/3] netfilter: Rework xt_TEE netdevice notifier
Date: Thu, 29 Mar 2018 17:03:35 +0300
Message-ID: <152233221526.1654.14062155454284081692.stgit@localhost.localdomain>
References: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        daniel@iogearbox.net, jakub.kicinski@netronome.com, ast@kernel.org,
        brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Register netdevice notifier for every iptable entry
is not good, since this breaks modularity, and
the hidden synchronization is based on rtnl_lock().

This patch reworks the synchronization via new lock,
while the rest of logic remains as it was before.
This is required for the next patch.

Tested via:

while :; do
	unshare -n iptables -t mangle -A OUTPUT -j TEE --gateway 1.1.1.2 --oif lo;
done

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 net/netfilter/xt_TEE.c |   73 ++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 86b0580b2216..475957cfcf50 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -20,7 +20,7 @@
 #include <linux/netfilter/xt_TEE.h>
 
 struct xt_tee_priv {
-	struct notifier_block	notifier;
+	struct list_head	list;
 	struct xt_tee_tginfo	*tginfo;
 	int			oif;
 };
@@ -51,29 +51,35 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 }
 #endif
 
+static DEFINE_MUTEX(priv_list_mutex);
+static LIST_HEAD(priv_list);
+
 static int tee_netdev_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
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
+	mutex_lock(&priv_list_mutex);
+	list_for_each_entry(priv, &priv_list, list) {
+		switch (event) {
+		case NETDEV_REGISTER:
+			if (!strcmp(dev->name, priv->tginfo->oif))
+				priv->oif = dev->ifindex;
+			break;
+		case NETDEV_UNREGISTER:
+			if (dev->ifindex == priv->oif)
+				priv->oif = -1;
+			break;
+		case NETDEV_CHANGENAME:
+			if (!strcmp(dev->name, priv->tginfo->oif))
+				priv->oif = dev->ifindex;
+			else if (dev->ifindex == priv->oif)
+				priv->oif = -1;
+			break;
+		}
 	}
+	mutex_unlock(&priv_list_mutex);
 
 	return NOTIFY_DONE;
 }
@@ -89,8 +95,6 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (info->oif[0]) {
-		int ret;
-
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
@@ -100,14 +104,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 
 		priv->tginfo  = info;
 		priv->oif     = -1;
-		priv->notifier.notifier_call = tee_netdev_event;
 		info->priv    = priv;
 
-		ret = register_netdevice_notifier(&priv->notifier);
-		if (ret) {
-			kfree(priv);
-			return ret;
-		}
+		mutex_lock(&priv_list_mutex);
+		list_add(&priv->list, &priv_list);
+		mutex_unlock(&priv_list_mutex);
 	} else
 		info->priv = NULL;
 
@@ -120,7 +121,9 @@ static void tee_tg_destroy(const struct xt_tgdtor_param *par)
 	struct xt_tee_tginfo *info = par->targinfo;
 
 	if (info->priv) {
-		unregister_netdevice_notifier(&info->priv->notifier);
+		mutex_lock(&priv_list_mutex);
+		list_del(&info->priv->list);
+		mutex_unlock(&priv_list_mutex);
 		kfree(info->priv);
 	}
 	static_key_slow_dec(&xt_tee_enabled);
@@ -153,13 +156,29 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 #endif
 };
 
+static struct notifier_block tee_netdev_notifier = {
+	.notifier_call = tee_netdev_event,
+};
+
 static int __init tee_tg_init(void)
 {
-	return xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	int ret;
+
+	ret = xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	if (ret)
+		return ret;
+	ret = register_netdevice_notifier(&tee_netdev_notifier);
+	if (ret) {
+		xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit tee_tg_exit(void)
 {
+	unregister_netdevice_notifier(&tee_netdev_notifier);
 	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
 }
 
