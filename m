From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: remove old comments about reentrancy
Date: Tue, 20 Apr 2010 14:24:11 +0200
Message-ID: <4BCD9CEB.3040801@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-5-git-send-email-jengelh@medozas.de> <4BCC63E1.6080808@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060104090501020001030104"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47288 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0DTMYX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:24:23 -0400
In-Reply-To: <4BCC63E1.6080808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060104090501020001030104
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Also applied, thanks Jan. I'll push everything out after
> some more intensive testing.

Not using oif was broken due to an incorrect check for a device
name, there also was a device reference leak. I took the
opportunity to convert it to notifier based device resolving.

If a oif is given, we register a netdevice notifier to resolve
the name on NETDEV_REGISTER or NETDEV_CHANGE and unresolve it
again on NETDEV_UNREGISTER or NETDEV_CHANGE (to a different name).
The behaviour should be equivalent to the runtime resolving.

Please review, if things are fine I'll commit the patch and
push everything out.

--------------060104090501020001030104
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
index 55d4a50..5c21d5c 100644
--- a/include/linux/netfilter/xt_TEE.h
+++ b/include/linux/netfilter/xt_TEE.h
@@ -4,6 +4,9 @@
 struct xt_tee_tginfo {
 	union nf_inet_addr gw;
 	char oif[16];
+
+	/* used internally by the kernel */
+	struct xt_tee_priv *priv __attribute__((aligned(8)));
 };
 
 #endif /* _XT_TEE_TARGET_H */
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 842e701..1dbef1d 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/route.h>
 #include <linux/skbuff.h>
+#include <linux/notifier.h>
 #include <net/checksum.h>
 #include <net/icmp.h>
 #include <net/ip.h>
@@ -32,6 +33,12 @@
 #	define WITH_IPV6 1
 #endif
 
+struct xt_tee_priv {
+	struct notifier_block	notifier;
+	struct xt_tee_tginfo	*tginfo;
+	int			oif;
+};
+
 static const union nf_inet_addr tee_zero_address;
 static DEFINE_PER_CPU(bool, tee_active);
 
@@ -49,20 +56,6 @@ static struct net *pick_net(struct sk_buff *skb)
 	return &init_net;
 }
 
-static bool tee_tg_route_oif(struct flowi *f, struct net *net,
-			     const struct xt_tee_tginfo *info)
-{
-	const struct net_device *dev;
-
-	if (*info->oif != '\0')
-		return true;
-	dev = dev_get_by_name(net, info->oif);
-	if (dev == NULL)
-		return false;
-	f->oif = dev->ifindex;
-	return true;
-}
-
 static bool
 tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 {
@@ -72,8 +65,11 @@ tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	struct flowi fl;
 
 	memset(&fl, 0, sizeof(fl));
-	if (!tee_tg_route_oif(&fl, net, info))
-		return false;
+	if (info->priv) {
+		if (info->priv->oif == -1)
+			return false;
+		fl.oif = info->priv->oif;
+	}
 	fl.nl_u.ip4_u.daddr = info->gw.ip;
 	fl.nl_u.ip4_u.tos   = RT_TOS(iph->tos);
 	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
@@ -149,8 +145,11 @@ tee_tg_route6(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	struct flowi fl;
 
 	memset(&fl, 0, sizeof(fl));
-	if (!tee_tg_route_oif(&fl, net, info))
-		return false;
+	if (info->priv) {
+		if (info->priv->oif == -1)
+			return false;
+		fl.oif = info->priv->oif;
+	}
 	fl.nl_u.ip6_u.daddr = info->gw.in6;
 	fl.nl_u.ip6_u.flowlabel = ((iph->flow_lbl[0] & 0xF) << 16) |
 				  (iph->flow_lbl[1] << 8) | iph->flow_lbl[2];
@@ -198,15 +197,70 @@ tee_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 #endif /* WITH_IPV6 */
 
+static int tee_netdev_event(struct notifier_block *this, unsigned long event,
+			    void *ptr)
+{
+	struct net_device *dev = ptr;
+	struct xt_tee_priv *priv;
+
+	priv = container_of(this, struct xt_tee_priv, notifier);
+	switch (event) {
+	case NETDEV_REGISTER:
+		if (!strcmp(dev->name, priv->tginfo->oif))
+			priv->oif = dev->ifindex;
+		break;
+	case NETDEV_UNREGISTER:
+		if (dev->ifindex == priv->oif)
+			priv->oif = -1;
+		break;
+	case NETDEV_CHANGENAME:
+		if (!strcmp(dev->name, priv->tginfo->oif))
+			priv->oif = dev->ifindex;
+		else if (dev->ifindex == priv->oif)
+			priv->oif = -1;
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int tee_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_tee_tginfo *info = par->targinfo;
+	struct xt_tee_tginfo *info = par->targinfo;
+	struct xt_tee_priv *priv;
 
-	if (info->oif[sizeof(info->oif)-1] != '\0')
-		return -EINVAL;
 	/* 0.0.0.0 and :: not allowed */
-	return (memcmp(&info->gw, &tee_zero_address,
-	       sizeof(tee_zero_address)) == 0) ? -EINVAL : 0;
+	if (memcmp(&info->gw, &tee_zero_address,
+		   sizeof(tee_zero_address)) == 0)
+		return -EINVAL;
+
+	if (info->oif[0]) {
+		if (info->oif[sizeof(info->oif)-1] != '\0')
+			return -EINVAL;
+
+		priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+		if (priv == NULL)
+			return -ENOMEM;
+
+		priv->tginfo  = info;
+		priv->oif     = -1;
+		priv->notifier.notifier_call = tee_netdev_event;
+
+		register_netdevice_notifier(&priv->notifier);
+	} else
+		info->priv = NULL;
+
+	return 0;
+}
+
+static void tee_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	struct xt_tee_tginfo *info = par->targinfo;
+
+	if (info->priv) {
+		unregister_netdevice_notifier(&info->priv->notifier);
+		kfree(info->priv);
+	}
 }
 
 static struct xt_target tee_tg_reg[] __read_mostly = {
@@ -217,6 +271,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.target     = tee_tg4,
 		.targetsize = sizeof(struct xt_tee_tginfo),
 		.checkentry = tee_tg_check,
+		.destroy    = tee_tg_destroy,
 		.me         = THIS_MODULE,
 	},
 #ifdef WITH_IPV6
@@ -227,6 +282,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.target     = tee_tg6,
 		.targetsize = sizeof(struct xt_tee_tginfo),
 		.checkentry = tee_tg_check,
+		.destroy    = tee_tg_destroy,
 		.me         = THIS_MODULE,
 	},
 #endif

--------------060104090501020001030104--
