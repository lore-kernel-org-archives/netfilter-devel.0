From: Konstantin Khorenko <khorenko@sw.ru>
Subject: [PATCH] [NETFILTER] ipt_SAME: add compat conversion functions
Date: Tue, 13 Nov 2007 15:40:16 +0300
Message-ID: <47399B30.7080308@sw.ru>
Reply-To: devel@openvz.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050608000001020101020305"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	devel@openvz.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:21511 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbXKMMk2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:40:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050608000001020101020305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[NETFILTER]: ipt_SAME: add compat conversion functions

ipt_SAME should have the compat function cause its entry structure (ipt_same_info)
contains a pointer between data filled/checked in both kernel and userspace.

Signed-off-by: Konstantin Khorenko <khorenko@sw.ru>

---
Thank you,
	Konstantin Khorenko

SWsoft Virtuozzo/OpenVZ Linux kernel team


--------------050608000001020101020305
Content-Type: text/plain;
 name="diff-ms-nf-ipt-SAME-compat-20071110"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-ms-nf-ipt-SAME-compat-20071110"

--- ./net/ipv4/netfilter/ipt_SAME.c.SAME	2007-11-06 13:55:16.000000000 +0300
+++ ./net/ipv4/netfilter/ipt_SAME.c	2007-11-09 16:50:38.000000000 +0300
@@ -152,6 +152,47 @@ same_target(struct sk_buff *skb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ipt_same_info
+{
+	unsigned char info;
+	u_int32_t rangesize;
+	u_int32_t ipnum;
+	compat_uptr_t iparray;
+
+	/* hangs off end. */
+	struct nf_nat_range range[IPT_SAME_MAX_RANGE];
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	const struct compat_ipt_same_info *cl = src;
+	struct ipt_same_info l = {
+		.info		= cl->info,
+		.rangesize	= cl->rangesize,
+		.ipnum		= 0,
+		.iparray	= NULL,
+	};
+
+	memcpy(l.range, cl->range, sizeof(l.range));
+	memcpy(dst, &l, sizeof(l));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	const struct ipt_same_info *l = src;
+	struct compat_ipt_same_info cl = {
+		.info		= l->info,
+		.rangesize	= l->rangesize,
+		.ipnum		= 0,
+		.iparray	= (compat_uptr_t)NULL,
+	};
+
+	memcpy(cl.range, l->range, sizeof(cl.range));
+	return copy_to_user(dst, &cl, sizeof(cl)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_target same_reg __read_mostly = {
 	.name		= "SAME",
 	.family		= AF_INET,
@@ -161,6 +202,11 @@ static struct xt_target same_reg __read_
 	.hooks		= (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING),
 	.checkentry	= same_check,
 	.destroy	= same_destroy,
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ipt_same_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
 	.me		= THIS_MODULE,
 };
 


--------------050608000001020101020305--
