From: aft <aftnix@gmail.com>
Subject: [PATCH 1/2] 1) Changed to "one" ds 2) Added some consistancy checks
Date: Tue, 18 Sep 2012 20:22:41 +0600
Message-ID: <1347978161.11478.2.camel@kernel-host-rh6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58302 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2IROXB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:23:01 -0400
Received: by pbbrr13 with SMTP id rr13so78021pbb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Sep 2012 07:23:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Arif Hossain <aftnix@gmail.com>
---
 extensions/xt_OBSF.c |   69 ++++++++++++++++++++++++++++++-------------------
 extensions/xt_OBSF.h |    8 +-----
 2 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/extensions/xt_OBSF.c b/extensions/xt_OBSF.c
index a1060a9..b997133 100644
--- a/extensions/xt_OBSF.c
+++ b/extensions/xt_OBSF.c
@@ -63,12 +63,28 @@ static unsigned int obsf_tg(struct sk_buff *skb, const struct xt_action_param *p
 		if (info->flags & XT_OBSF_ENC_DEC)
 			crypto_blkcipher_decrypt(&desc, &sg, &sg, data_len);
 	}	
-	return NF_ACCEPT;
-}
 
-static unsigned int obsf_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	printk("inside obsf_tg_v1");
+	if (info->flags & XT_OBSF_PAD_STATIC) {
+		if (info->flags & XT_OBSF_PAD_ADD) {
+			/* Add flase bytes */
+		}
+
+		if (info->flags & XT_OBSF_PAD_REM) {
+			/* Remove false bytes */
+		}
+	}
+
+	if (info->flags & XT_OBSF_PAD_RANDOM) {
+		if (info->flags & XT_OBSF_PAD_ADD) {
+					/* Add flase bytes */
+		}
+
+		if (info->flags & XT_OBSF_PAD_REM) {
+					/* Remove false bytes */
+		}
+	}
+
+
 	return NF_ACCEPT;
 }
 
@@ -90,12 +106,26 @@ static int obsf_tg_check(const struct xt_tgchk_param *par)
 			get_random_bytes(&priv->iv, 4);
 
 			info->priv = priv;
-			/* flag consistency check */
-
-			return 0;
 	}
 
+	/* flags consistency */
+
+	if ((info->flags & XT_OBSF_ENC_ARC4) && (info->flags & XT_OBSF_ENC_AES))
+		return -EINVAL;
+
+	if ((info->flags & XT_OBSF_ENC_ENC) && (info->flags & XT_OBSF_ENC_DEC))
+		return -EINVAL;
+
+	if ((info->flags & XT_OBSF_PAD_STATIC) && (info->flags & XT_OBSF_PAD_RANDOM))
+		return -EINVAL;
+
+	if ((info->flags & XT_OBSF_PAD_ADD) & (info->flags & XT_OBSF_PAD_REM))
+		return -EINVAL;
+
+	return 0;
+
 	/* failover */
+
 	fail:
 	if (priv) {
 		if (priv->tfm)
@@ -107,40 +137,25 @@ static int obsf_tg_check(const struct xt_tgchk_param *par)
 
 }
 
-static int obsf_tg_check_v1(const struct xt_tgchk_param *par)
-{
-	printk("inside obsf_tg_check_v1");
-	return 0;
-}
 
-static struct xt_target obsf_tg_reg[] __read_mostly = {
-	{
+static struct xt_target obsf_tg_reg __read_mostly = {
+
 		.name = "OBSF",
 		.family = NFPROTO_UNSPEC,
 		.target = obsf_tg,
 		.checkentry = obsf_tg_check,
 		.targetsize = sizeof(struct xt_OBSF_tginfo),
 		.me = THIS_MODULE,
-	},
-	{
-		.name = "OBSF",
-		.revision = 1,
-		.family = NFPROTO_UNSPEC,
-		.target = obsf_tg_v1,
-		.targetsize = sizeof(struct xt_OBSF_tginfo_v1),
-		.checkentry = obsf_tg_check_v1,
-		.me = THIS_MODULE,
-	},
 };
 
 static int __init obsf_tg_init(void)
 {
-	return xt_register_targets(obsf_tg_reg, ARRAY_SIZE(obsf_tg_reg));
+	return xt_register_target(&obsf_tg_reg);
 }
 
 static void __exit obsf_tg_exit(void)
 {
-	xt_unregister_targets(obsf_tg_reg, ARRAY_SIZE(obsf_tg_reg));
+	xt_unregister_target(&obsf_tg_reg);
 }
 
 module_init(obsf_tg_init);
diff --git a/extensions/xt_OBSF.h b/extensions/xt_OBSF.h
index cef781f..9d68c72 100644
--- a/extensions/xt_OBSF.h
+++ b/extensions/xt_OBSF.h
@@ -13,14 +13,8 @@ enum {
 	XT_OBSF_PAD_REM = 1 << 7
 };
 
-struct xt_OBSF_tginfo {
-	__u8 flags;
-	__u8 key[XT_OBSF_MAX_KEY_LEN];
-	__u8 key_len;
-	struct xt_obsf_priv *priv;
-};
 
-struct xt_OBSF_tginfo_v1 {
+struct xt_OBSF_tginfo{
 	__u8 flags;
 	__u8 key[XT_OBSF_MAX_KEY_LEN];
 	__u8 key_len;
-- 
1.7.1


