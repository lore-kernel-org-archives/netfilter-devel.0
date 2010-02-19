From: Peter Volkov <peter.volkov@gmail.com>
Subject: xtables-addons: make ipv6 optional for RAWNAT and SYSRQ
Date: Fri, 19 Feb 2010 14:52:55 +0300
Message-ID: <1266580375.26314.6.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-aKtfd5CSOBh/wBZbtSgU"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61805 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0BSLxh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:53:37 -0500
Received: by bwz1 with SMTP id 1so1231868bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2010 03:53:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-aKtfd5CSOBh/wBZbtSgU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, in case kernel was built without ipv6 support xt_RAWNAT and xt_SYSRQ
fail to load with unknown symbols. Patches in attachment fix this issue.
Please, apply.

-- 
Peter.

--=-aKtfd5CSOBh/wBZbtSgU
Content-Disposition: attachment; filename="0001-RAWNAT-make-ipv6-support-conditional.patch"
Content-Type: text/x-patch; name="0001-RAWNAT-make-ipv6-support-conditional.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 646fd4275f91a6e10823b1d6ad2df1581aec7bb5 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Fri, 19 Feb 2010 14:06:00 +0300
Subject: [PATCH 1/2] RAWNAT: make ipv6 support conditional

In case kernel is built without ipv6 support this module fails as it
assumes ipv6. This patch makes kernel support conditional on kernel
.config.
---
 extensions/ip6table_rawpost.c |    4 ++++
 extensions/xt_RAWNAT.c        |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/extensions/ip6table_rawpost.c b/extensions/ip6table_rawpost.c
index 1cd9b26..c1e6102 100644
--- a/extensions/ip6table_rawpost.c
+++ b/extensions/ip6table_rawpost.c
@@ -9,6 +9,8 @@
 #include "compat_xtables.h"
 #include "compat_rawpost.h"
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 enum {
 	RAWPOST_VALID_HOOKS = 1 << NF_INET_POST_ROUTING,
 };
@@ -105,3 +107,5 @@ module_init(rawpost6_table_init);
 module_exit(rawpost6_table_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_LICENSE("GPL");
+
+#endif
diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index 18661a9..b8c7bc7 100644
--- a/extensions/xt_RAWNAT.c
+++ b/extensions/xt_RAWNAT.c
@@ -22,6 +22,10 @@
 #include "compat_xtables.h"
 #include "xt_RAWNAT.h"
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#	define WITH_IPV6 1
+#endif
+
 static inline __be32
 remask(__be32 addr, __be32 repl, unsigned int shift)
 {
@@ -29,6 +33,7 @@ remask(__be32 addr, __be32 repl, unsigned int shift)
 	return htonl((ntohl(addr) & mask) | (ntohl(repl) & ~mask));
 }
 
+#ifdef WITH_IPV6
 static void
 rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
 {
@@ -72,6 +77,7 @@ rawnat_ipv6_mask(__be32 *addr, const __be32 *repl, unsigned int mask)
 		break;
 	}
 }
+#endif
 
 static void rawnat4_update_l4(struct sk_buff *skb, __be32 oldip, __be32 newip)
 {
@@ -162,6 +168,7 @@ rawdnat_tg4(struct sk_buff **pskb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+#ifdef WITH_IPV6
 static bool rawnat6_prepare_l4(struct sk_buff **pskb, unsigned int *l4offset,
     unsigned int *l4proto)
 {
@@ -274,6 +281,7 @@ rawdnat_tg6(struct sk_buff **pskb, const struct xt_target_param *par)
 	memcpy(&iph->daddr, &new_addr, sizeof(new_addr));
 	return XT_CONTINUE;
 }
+#endif
 
 static bool rawnat_tg_check(const struct xt_tgchk_param *par)
 {
@@ -296,6 +304,7 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
 		.name       = "RAWSNAT",
 		.revision   = 0,
@@ -305,6 +314,7 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 	{
 		.name       = "RAWDNAT",
 		.revision   = 0,
@@ -314,6 +324,7 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
 		.name       = "RAWDNAT",
 		.revision   = 0,
@@ -323,6 +334,7 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init rawnat_tg_init(void)
-- 
1.6.4.4


--=-aKtfd5CSOBh/wBZbtSgU
Content-Disposition: attachment; filename="0002-SYSRQ-make-ipv6-support-conditional.patch"
Content-Type: text/x-patch; name="0002-SYSRQ-make-ipv6-support-conditional.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From fdbae5d62bea5775eaf412bbcb2c3d98d26f4c02 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Fri, 19 Feb 2010 14:46:17 +0300
Subject: [PATCH 2/2] SYSRQ: make ipv6 support conditional

In case kernel is built without ipv6 support this module fails as it
assumes ipv6. This patch makes kernel support conditional on kernel
.config.
---
 extensions/xt_SYSRQ.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index 3cd223b..95c1184 100644
--- a/extensions/xt_SYSRQ.c
+++ b/extensions/xt_SYSRQ.c
@@ -23,6 +23,10 @@
 #include <net/ip.h>
 #include "compat_xtables.h"
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#	define WITH_IPV6 1
+#endif
+
 static bool sysrq_once;
 static char sysrq_password[64];
 static char sysrq_hash[16] = "sha1";
@@ -214,6 +218,7 @@ sysrq_tg4(struct sk_buff **pskb, const struct xt_target_param *par)
 	return sysrq_tg((void *)udph + sizeof(struct udphdr), len);
 }
 
+#ifdef WITH_IPV6
 static unsigned int
 sysrq_tg6(struct sk_buff **pskb, const struct xt_target_param *par)
 {
@@ -242,6 +247,7 @@ sysrq_tg6(struct sk_buff **pskb, const struct xt_target_param *par)
 		       ntohs(udph->dest), len);
 	return sysrq_tg(udph + sizeof(struct udphdr), len);
 }
+#endif
 
 static bool sysrq_tg_check(const struct xt_tgchk_param *par)
 {
@@ -278,6 +284,7 @@ static struct xt_target sysrq_tg_reg[] __read_mostly = {
 		.checkentry = sysrq_tg_check,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
 		.name       = "SYSRQ",
 		.revision   = 1,
@@ -286,6 +293,7 @@ static struct xt_target sysrq_tg_reg[] __read_mostly = {
 		.checkentry = sysrq_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init sysrq_tg_init(void)
-- 
1.6.4.4


--=-aKtfd5CSOBh/wBZbtSgU--

