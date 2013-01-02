From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH v2] iptables: merge libip6t SNPT and DNPT to NPT
Date: Wed, 2 Jan 2013 17:58:42 +0100
Message-ID: <50E46742.1050507@sophos.com>
References: <20130102160349.GB3760@uweber-WS>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------000502060609080601070907"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx4.sophos.com ([216.47.234.213]:48180 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3ABRG7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:06:59 -0500
Received: from mx4.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 67AA74E051D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 16:58:44 +0000 (GMT)
Received: from abn-exch1b.green.sophos (abn-exch1b.green.sophos [10.100.70.62])
	by mx4.sophos.com (Postfix) with ESMTPS id C4AD74E051B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 16:58:43 +0000 (GMT)
In-Reply-To: <20130102160349.GB3760@uweber-WS>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--------------000502060609080601070907
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Was to quick ;) Please find proper fix attached,
merging DNPT and SNPT into new NPT file.

Cheers
  Ulrich

--------------000502060609080601070907
Content-Type: text/x-patch;
	name="0001-iptables-merge-libip6t-SNPT-and-DNPT-to-NPT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-iptables-merge-libip6t-SNPT-and-DNPT-to-NPT.patch"

>From fcc5be86597dc9d66b13e42d756a3b2747d0fb2e Mon Sep 17 00:00:00 2001
From: Ulrich Weber <ulrich.weber@sophos.com>
Date: Wed, 2 Jan 2013 17:37:50 +0100
Subject: [PATCH] iptables: merge libip6t SNPT and DNPT to NPT

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 extensions/GNUmakefile.in |    6 ++-
 extensions/libip6t_DNPT.c |   71 ----------------------------------
 extensions/libip6t_NPT.c  |   94 +++++++++++++++++++++++++++++++++++++++++++++
 extensions/libip6t_SNPT.c |   71 ----------------------------------
 4 files changed, 99 insertions(+), 143 deletions(-)
 delete mode 100644 extensions/libip6t_DNPT.c
 create mode 100644 extensions/libip6t_NPT.c
 delete mode 100644 extensions/libip6t_SNPT.c

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e71e3ff..afb7e3c 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -41,7 +41,7 @@ endif
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
 pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
-@ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
+@ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c))) SNPT DNPT
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
 pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
 pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
@@ -99,6 +99,10 @@ libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
 libxt_state.so: libxt_conntrack.so
 	ln -fs $< $@
+libip6t_SNPT.so: libip6t_NPT.so
+	ln -fs $< $@
+libip6t_DNPT.so: libip6t_NPT.so
+	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 ip6t_NETMAP_LIBADD  = -lip6tc
diff --git a/extensions/libip6t_DNPT.c b/extensions/libip6t_DNPT.c
deleted file mode 100644
index 9e4dc5c..0000000
--- a/extensions/libip6t_DNPT.c
+++ /dev/null
@@ -1,71 +0,0 @@
-#include <stdio.h>
-#include <xtables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_NPT.h>
-
-enum {
-	O_SRC_PFX	= 1 << 0,
-	O_DST_PFX	= 1 << 1,
-};
-
-static const struct xt_option_entry SNPT_options[] = {
-	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
-	  .flags = XTOPT_MAND },
-	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
-	  .flags = XTOPT_MAND },
-	{ }
-};
-
-static void SNPT_help(void)
-{
-	printf("SNPT target options:"
-	       "\n"
-	       " --src-pfx prefix/length\n"
-	       " --dst-pfx prefix/length\n"
-	       "\n");
-}
-
-static void SNPT_parse(struct xt_option_call *cb)
-{
-	struct ip6t_npt_tginfo *npt = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_SRC_PFX:
-		npt->src_pfx = cb->val.haddr;
-		npt->src_pfx_len = cb->val.hlen;
-		break;
-	case O_DST_PFX:
-		npt->dst_pfx = cb->val.haddr;
-		npt->dst_pfx_len = cb->val.hlen;
-		break;
-	}
-}
-
-static void SNPT_print(const void *ip, const struct xt_entry_target *target,
-		       int numeric)
-{
-	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
-
-	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
-				 npt->src_pfx_len);
-	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
-				 npt->dst_pfx_len);
-}
-
-static struct xtables_target snpt_tg_reg = {
-	.name		= "DNPT",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV6,
-	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
-	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
-	.help		= SNPT_help,
-	.x6_parse	= SNPT_parse,
-	.print		= SNPT_print,
-	.x6_options	= SNPT_options,
-};
-
-void _init(void)
-{
-	xtables_register_target(&snpt_tg_reg);
-}
diff --git a/extensions/libip6t_NPT.c b/extensions/libip6t_NPT.c
new file mode 100644
index 0000000..56e6f43
--- /dev/null
+++ b/extensions/libip6t_NPT.c
@@ -0,0 +1,94 @@
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_NPT.h>
+
+enum {
+	O_SRC_PFX	= 1 << 0,
+	O_DST_PFX	= 1 << 1,
+};
+
+static const struct xt_option_entry NPT_options[] = {
+	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_MAND },
+	{ }
+};
+
+static void SNPT_help(void)
+{
+	printf("SNPT target options:"
+	       "\n"
+	       " --src-pfx prefix/length\n"
+	       " --dst-pfx prefix/length\n"
+	       "\n");
+}
+
+static void DNPT_help(void)
+{
+	printf("DNPT target options:"
+	       "\n"
+	       " --src-pfx prefix/length\n"
+	       " --dst-pfx prefix/length\n"
+	       "\n");
+}
+
+static void NPT_parse(struct xt_option_call *cb)
+{
+	struct ip6t_npt_tginfo *npt = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_PFX:
+		npt->src_pfx = cb->val.haddr;
+		npt->src_pfx_len = cb->val.hlen;
+		break;
+	case O_DST_PFX:
+		npt->dst_pfx = cb->val.haddr;
+		npt->dst_pfx_len = cb->val.hlen;
+		break;
+	}
+}
+
+static void NPT_print(const void *ip, const struct xt_entry_target *target,
+		       int numeric)
+{
+	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
+
+	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
+				 npt->src_pfx_len);
+	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
+				 npt->dst_pfx_len);
+}
+
+static struct xtables_target snpt_tg_reg = {
+	.name		= "SNPT",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
+	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
+	.help		= SNPT_help,
+	.x6_parse	= NPT_parse,
+	.print		= NPT_print,
+	.x6_options	= NPT_options,
+};
+
+static struct xtables_target dnpt_tg_reg = {
+	.name		= "DNPT",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
+	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
+	.help		= DNPT_help,
+	.x6_parse	= NPT_parse,
+	.print		= NPT_print,
+	.x6_options	= NPT_options,
+};
+
+
+void _init(void)
+{
+	xtables_register_target(&snpt_tg_reg);
+	xtables_register_target(&dnpt_tg_reg);
+}
diff --git a/extensions/libip6t_SNPT.c b/extensions/libip6t_SNPT.c
deleted file mode 100644
index 26a86c5..0000000
--- a/extensions/libip6t_SNPT.c
+++ /dev/null
@@ -1,71 +0,0 @@
-#include <stdio.h>
-#include <xtables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_NPT.h>
-
-enum {
-	O_SRC_PFX	= 1 << 0,
-	O_DST_PFX	= 1 << 1,
-};
-
-static const struct xt_option_entry SNPT_options[] = {
-	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
-	  .flags = XTOPT_MAND },
-	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
-	  .flags = XTOPT_MAND },
-	{ }
-};
-
-static void SNPT_help(void)
-{
-	printf("SNPT target options:"
-	       "\n"
-	       " --src-pfx prefix/length\n"
-	       " --dst-pfx prefix/length\n"
-	       "\n");
-}
-
-static void SNPT_parse(struct xt_option_call *cb)
-{
-	struct ip6t_npt_tginfo *npt = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_SRC_PFX:
-		npt->src_pfx = cb->val.haddr;
-		npt->src_pfx_len = cb->val.hlen;
-		break;
-	case O_DST_PFX:
-		npt->dst_pfx = cb->val.haddr;
-		npt->dst_pfx_len = cb->val.hlen;
-		break;
-	}
-}
-
-static void SNPT_print(const void *ip, const struct xt_entry_target *target,
-		       int numeric)
-{
-	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
-
-	printf("src-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->src_pfx.in6),
-				 npt->src_pfx_len);
-	printf("dst-pfx %s/%u ", xtables_ip6addr_to_numeric(&npt->dst_pfx.in6),
-				 npt->dst_pfx_len);
-}
-
-static struct xtables_target snpt_tg_reg = {
-	.name		= "SNPT",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV6,
-	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
-	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
-	.help		= SNPT_help,
-	.x6_parse	= SNPT_parse,
-	.print		= SNPT_print,
-	.x6_options	= SNPT_options,
-};
-
-void _init(void)
-{
-	xtables_register_target(&snpt_tg_reg);
-}
-- 
1.7.9.5


--------------000502060609080601070907--
