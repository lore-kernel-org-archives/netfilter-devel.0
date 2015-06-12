From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/4] netfilter: xt_TEE: always allocate private area
Date: Fri, 12 Jun 2015 13:59:36 +0200
Message-ID: <1434110378-6284-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbbFLLyZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 07:54:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This simplifies the integration with nf_tables at the cost of consuming little
extra memory per rule, and I don't expect many rules using TEE in a ruleset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index a747eb4..189ad13 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -53,6 +53,11 @@ static struct net *pick_net(struct sk_buff *skb)
 	return &init_net;
 }
 
+static inline bool tee_has_notifier(const struct xt_tee_tginfo *info)
+{
+	return info->priv->notifier.notifier_call != NULL;
+}
+
 static bool
 tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 {
@@ -62,7 +67,7 @@ tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	struct flowi4 fl4;
 
 	memset(&fl4, 0, sizeof(fl4));
-	if (info->priv) {
+	if (tee_has_notifier(info)) {
 		if (info->priv->oif == -1)
 			return false;
 		fl4.flowi4_oif = info->priv->oif;
@@ -144,7 +149,7 @@ tee_tg_route6(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	struct flowi6 fl6;
 
 	memset(&fl6, 0, sizeof(fl6));
-	if (info->priv) {
+	if (tee_has_notifier(info)) {
 		if (info->priv->oif == -1)
 			return false;
 		fl6.flowi6_oif = info->priv->oif;
@@ -235,34 +240,37 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		   sizeof(tee_zero_address)) == 0)
 		return -EINVAL;
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	priv->tginfo	= info;
+	priv->oif	= -1;
+
 	if (info->oif[0]) {
 		if (info->oif[sizeof(info->oif)-1] != '\0')
-			return -EINVAL;
-
-		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (priv == NULL)
-			return -ENOMEM;
+			goto err1;
 
-		priv->tginfo  = info;
-		priv->oif     = -1;
 		priv->notifier.notifier_call = tee_netdev_event;
-		info->priv    = priv;
-
 		register_netdevice_notifier(&priv->notifier);
-	} else
-		info->priv = NULL;
+	}
+
+	info->priv	= priv;
 
 	return 0;
+err1:
+	kfree(priv);
+	return -EINVAL;
 }
 
 static void tee_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	struct xt_tee_tginfo *info = par->targinfo;
 
-	if (info->priv) {
+	if (tee_has_notifier(info))
 		unregister_netdevice_notifier(&info->priv->notifier);
-		kfree(info->priv);
-	}
+
+	kfree(info->priv);
 }
 
 static struct xt_target tee_tg_reg[] __read_mostly = {
-- 
1.7.10.4

