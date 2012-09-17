From: aft <aftnix@gmail.com>
Subject: [PATCH] New Target Extension OBSF
Date: Mon, 17 Sep 2012 21:21:11 +0600
Message-ID: <1347895271.27332.1.camel@kernel-host-rh6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50816 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2IQPV3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:21:29 -0400
Received: by dady13 with SMTP id y13so956147dad.19
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Sep 2012 08:21:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This modules does two things:

1) it encrypts UDP traffic.
2) it adds false bytes(padding).

Its purpose is to escape smarter DPIs which blocks certain kinds of
packets by several heuristic methods.

Its purpose is not providing security or prevent man in a middle attack.

Still to do:

1) Add AES support.
2) False bytes addition or removal.
3) Write userspace plugin.

Signed-off-by: Arif Hossain <aftnix@gmail.com>
diff --git a/extensions/Kbuild b/extensions/Kbuild
index 81a8b30..4c2b91d 100644
--- a/extensions/Kbuild
+++ b/extensions/Kbuild
@@ -35,6 +35,7 @@
 obj-${build_pknock}      += pknock/
 obj-${build_psd}         += xt_psd.o
 obj-${build_quota2}      += xt_quota2.o
+obj-${build_OBSF} += xt_OBSF.o
 
 -include ${M}/*.Kbuild
 -include ${M}/Kbuild.*
diff --git a/extensions/xt_OBSF.c b/extensions/xt_OBSF.c
new file mode 100644
index 0000000..a1060a9
--- /dev/null
+++ b/extensions/xt_OBSF.c
@@ -0,0 +1,148 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_OBSF.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
+MODULE_AUTHOR("Arif Hossain <aftnix@gmail.com>");
+MODULE_DESCRIPTION("Xtables: obsfuscation of UDP traffic");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_OBSF");
+MODULE_ALIAS("ip6t_OBSF");
+
+struct xt_obsf_priv {
+	__u8 iv;
+	struct crypto_blkcipher *tfm;
+};
+
+static unsigned int obsf_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct udphdr *udh, *udh_buf;
+	unsigned int data_len;
+	void *payload;
+
+ 	struct scatterlist sg;
+	struct blkcipher_desc desc;
+
+	const struct xt_OBSF_tginfo *info = (const void *)par->targinfo;
+
+	if (skb_linearize (skb) < 0)
+		return NF_DROP;
+	
+	udh = skb_header_pointer(skb, par->thoff, sizeof(struct udphdr), &udh_buf);
+	if (udh == NULL)
+		return NF_DROP;
+	if (ntohs(udh->len) <= sizeof(struct udphdr)) /* malformed packet */
+		return NF_DROP;
+	
+	/* data len of udp payload */
+	data_len = htons(udh->len) - sizeof(*udh);
+	payload = skb_header_pointer(skb, par->thoff + sizeof(*udh), data_len, NULL); 
+
+	if (info->flags & XT_OBSF_ENC_ARC4) {
+		/* crypto */
+
+		desc.tfm = info->priv->tfm;
+		desc.flags = 0;
+
+		crypto_blkcipher_set_iv(info->priv->tfm, &info->priv->iv, 4);
+		crypto_blkcipher_setkey(info->priv->tfm, info->key, info->key_len);
+
+		sg_init_one(&sg, payload, data_len);
+
+		if (info->flags & XT_OBSF_ENC_ENC)
+			crypto_blkcipher_encrypt(&desc, &sg, &sg, data_len);
+
+		if (info->flags & XT_OBSF_ENC_DEC)
+			crypto_blkcipher_decrypt(&desc, &sg, &sg, data_len);
+	}	
+	return NF_ACCEPT;
+}
+
+static unsigned int obsf_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	printk("inside obsf_tg_v1");
+	return NF_ACCEPT;
+}
+
+static int obsf_tg_check(const struct xt_tgchk_param *par)
+{
+	struct xt_OBSF_tginfo *info = par->targinfo;
+	/* Allocate and initialize private data structure */
+	struct xt_obsf_priv *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		goto fail;
+
+	if (info->flags & XT_OBSF_ENC_ARC4) {
+		priv->tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+			if (IS_ERR(priv->tfm)) {
+				priv->tfm = NULL;
+				goto fail;
+			}
+
+			get_random_bytes(&priv->iv, 4);
+
+			info->priv = priv;
+			/* flag consistency check */
+
+			return 0;
+	}
+
+	/* failover */
+	fail:
+	if (priv) {
+		if (priv->tfm)
+			crypto_free_blkcipher(priv->tfm);
+		kfree(priv);
+	}
+	info->priv = NULL;
+	return -ENOMEM;
+
+}
+
+static int obsf_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	printk("inside obsf_tg_check_v1");
+	return 0;
+}
+
+static struct xt_target obsf_tg_reg[] __read_mostly = {
+	{
+		.name = "OBSF",
+		.family = NFPROTO_UNSPEC,
+		.target = obsf_tg,
+		.checkentry = obsf_tg_check,
+		.targetsize = sizeof(struct xt_OBSF_tginfo),
+		.me = THIS_MODULE,
+	},
+	{
+		.name = "OBSF",
+		.revision = 1,
+		.family = NFPROTO_UNSPEC,
+		.target = obsf_tg_v1,
+		.targetsize = sizeof(struct xt_OBSF_tginfo_v1),
+		.checkentry = obsf_tg_check_v1,
+		.me = THIS_MODULE,
+	},
+};
+
+static int __init obsf_tg_init(void)
+{
+	return xt_register_targets(obsf_tg_reg, ARRAY_SIZE(obsf_tg_reg));
+}
+
+static void __exit obsf_tg_exit(void)
+{
+	xt_unregister_targets(obsf_tg_reg, ARRAY_SIZE(obsf_tg_reg));
+}
+
+module_init(obsf_tg_init);
+module_exit(obsf_tg_exit);
+
diff --git a/extensions/xt_OBSF.h b/extensions/xt_OBSF.h
new file mode 100644
index 0000000..cef781f
--- /dev/null
+++ b/extensions/xt_OBSF.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_NETFILTER_XT_OBSF_H
+#define _LINUX_NETFILTER_XT_OBSF_H 1
+
+#define XT_OBSF_MAX_KEY_LEN 32
+enum {
+	XT_OBSF_ENC_ARC4 = 1 << 0,
+	XT_OBSF_ENC_AES = 1 << 1,
+	XT_OBSF_PAD_STATIC = 1 << 2,
+	XT_OBSF_PAD_RANDOM = 1 << 3,
+	XT_OBSF_ENC_ENC = 1 << 4,
+	XT_OBSF_ENC_DEC = 1 << 5,
+	XT_OBSF_PAD_ADD = 1 << 6,
+	XT_OBSF_PAD_REM = 1 << 7
+};
+
+struct xt_OBSF_tginfo {
+	__u8 flags;
+	__u8 key[XT_OBSF_MAX_KEY_LEN];
+	__u8 key_len;
+	struct xt_obsf_priv *priv;
+};
+
+struct xt_OBSF_tginfo_v1 {
+	__u8 flags;
+	__u8 key[XT_OBSF_MAX_KEY_LEN];
+	__u8 key_len;
+	__u8 start;
+	__u8 end;
+	struct xt_obsf_priv *priv;
+};
+
+#endif /* _LINUX_NETFILTER_XT_OBSF_H */
diff --git a/mconfig b/mconfig
index 4fc664a..6c66d43 100644
--- a/mconfig
+++ b/mconfig
@@ -26,3 +26,4 @@
 build_pknock=m
 build_psd=m
 build_quota2=m
+build_OBSF=m
\ No newline at end of fil


