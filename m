From: Peter Volkov <peter.volkov@gmail.com>
Subject: Re: xtables-addons: make ipv6 optional for RAWNAT and SYSRQ
Date: Sat, 20 Feb 2010 15:43:32 +0300
Message-ID: <1266669812.2097.21.camel@tablet>
References: <1266580375.26314.6.camel@tablet>
	 <alpine.LSU.2.01.1002191411280.17165@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JzbQQLlgDsuaZnI8Linq"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51207 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420Ab0BXXo4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:44:56 -0500
Received: by fxm19 with SMTP id 19so5711656fxm.21
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2010 15:44:54 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002191411280.17165@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-JzbQQLlgDsuaZnI8Linq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

В Птн, 19/02/2010 в 14:14 +0100, Jan Engelhardt пишет:
> On Friday 2010-02-19 12:52, Peter Volkov wrote:
> For ip6table_rawpost, we could probably do this in the Kbuild file:
> 
> ifneq (${CONFIG_IPV6},)
> obj-${build_RAWNAT} += ip6table_rawpost.o
> endif
> 
> Can you test?

Works.

> For the second patch, I would suggest to move around the structures in 
> rawnat_tg_reg to reduce the number of #ifdefs needed.

Done. Updated patch in attachment. Also added #ifdefs around ip6t
MODULE_ALIAS.

Also I've updated SYSRQ patch a bit. Added ifdefs around another IPV6
related code and around MODULE_ALIAS.

-- 
Peter.

--=-JzbQQLlgDsuaZnI8Linq
Content-Disposition: attachment; filename="0001-RAWNAT-make-ipv6-support-conditional.patch"
Content-Type: text/x-patch; name="0001-RAWNAT-make-ipv6-support-conditional.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 097f838fe1abac456f61774a727861a719ac3df3 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Sat, 20 Feb 2010 14:56:32 +0300
Subject: [PATCH 1/2] RAWNAT: make ipv6 support conditional

In case kernel is built without ipv6 support this module fails as it
assumes ipv6. This patch makes kernel support conditional on kernel
.config.
---
 extensions/Kbuild      |    5 ++++-
 extensions/xt_RAWNAT.c |   24 ++++++++++++++++++------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/extensions/Kbuild b/extensions/Kbuild
index 5588c2c..841332d 100644
--- a/extensions/Kbuild
+++ b/extensions/Kbuild
@@ -12,7 +12,10 @@ obj-${build_DHCPMAC}     += xt_DHCPMAC.o
 obj-${build_ECHO}        += xt_ECHO.o
 obj-${build_IPMARK}      += xt_IPMARK.o
 obj-${build_LOGMARK}     += xt_LOGMARK.o
-obj-${build_RAWNAT}      += xt_RAWNAT.o iptable_rawpost.o ip6table_rawpost.o
+obj-${build_RAWNAT}      += xt_RAWNAT.o iptable_rawpost.o
+ifneq (${CONFIG_IPV6},)
+obj-${build_RAWNAT} += ip6table_rawpost.o
+endif
 obj-${build_SYSRQ}       += xt_SYSRQ.o
 obj-${build_STEAL}       += xt_STEAL.o
 obj-${build_TARPIT}      += xt_TARPIT.o
diff --git a/extensions/xt_RAWNAT.c b/extensions/xt_RAWNAT.c
index 18661a9..e743531 100644
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
@@ -297,19 +305,20 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.me         = THIS_MODULE,
 	},
 	{
-		.name       = "RAWSNAT",
+		.name       = "RAWDNAT",
 		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = rawsnat_tg6,
+		.family     = NFPROTO_IPV4,
+		.target     = rawdnat_tg4,
 		.targetsize = sizeof(struct xt_rawnat_tginfo),
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
-		.name       = "RAWDNAT",
+		.name       = "RAWSNAT",
 		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = rawdnat_tg4,
+		.family     = NFPROTO_IPV6,
+		.target     = rawsnat_tg6,
 		.targetsize = sizeof(struct xt_rawnat_tginfo),
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
@@ -323,6 +332,7 @@ static struct xt_target rawnat_tg_reg[] __read_mostly = {
 		.checkentry = rawnat_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init rawnat_tg_init(void)
@@ -342,5 +352,7 @@ MODULE_DESCRIPTION("Xtables: conntrack-less raw NAT");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_RAWSNAT");
 MODULE_ALIAS("ipt_RAWDNAT");
+#ifdef WITH_IPV6
 MODULE_ALIAS("ip6t_RAWSNAT");
 MODULE_ALIAS("ip6t_RAWDNAT");
+#endif
-- 
1.6.4.4


--=-JzbQQLlgDsuaZnI8Linq
Content-Disposition: attachment; filename="0002-SYSRQ-make-ipv6-support-conditional.patch"
Content-Type: text/x-patch; name="0002-SYSRQ-make-ipv6-support-conditional.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 8dfafcf38940c4529845b28505439fd7f03349f0 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Sat, 20 Feb 2010 14:57:20 +0300
Subject: [PATCH 2/2] SYSRQ: make ipv6 support conditional

In case kernel is built without ipv6 support this module fails as it
assumes ipv6. This patch makes kernel support conditional on kernel
.config.
---
 extensions/xt_SYSRQ.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/extensions/xt_SYSRQ.c b/extensions/xt_SYSRQ.c
index 3cd223b..5557b41 100644
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
@@ -253,6 +259,7 @@ static bool sysrq_tg_check(const struct xt_tgchk_param *par)
 		    entry->ip.proto != IPPROTO_UDPLITE) ||
 		    entry->ip.invflags & XT_INV_PROTO)
 			goto out;
+#ifdef WITH_IPV6
 	} else if (par->target->family == NFPROTO_IPV6) {
 		const struct ip6t_entry *entry = par->entryinfo;
 
@@ -260,6 +267,7 @@ static bool sysrq_tg_check(const struct xt_tgchk_param *par)
 		    entry->ipv6.proto != IPPROTO_UDPLITE) ||
 		    entry->ipv6.invflags & XT_INV_PROTO)
 			goto out;
+#endif
 	}
 
 	return true;
@@ -278,6 +286,7 @@ static struct xt_target sysrq_tg_reg[] __read_mostly = {
 		.checkentry = sysrq_tg_check,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
 		.name       = "SYSRQ",
 		.revision   = 1,
@@ -286,6 +295,7 @@ static struct xt_target sysrq_tg_reg[] __read_mostly = {
 		.checkentry = sysrq_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init sysrq_tg_init(void)
@@ -357,4 +367,6 @@ MODULE_DESCRIPTION("Xtables: triggering SYSRQ remotely");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_SYSRQ");
+#ifdef WITH_IPV6
 MODULE_ALIAS("ip6t_SYSRQ");
+#endif
-- 
1.6.4.4


--=-JzbQQLlgDsuaZnI8Linq--

