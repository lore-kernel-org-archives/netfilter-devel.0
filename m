From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/7] libxt_NOTRACK: replace as an alias to CT --notrack
Date: Fri, 28 Sep 2012 00:48:27 +0200
Message-ID: <1348786109-20894-6-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56164 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab2I0Wsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:33 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Note that we do not need any print/save functions for the alias entries,
since the real CT entry will handle this.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in  |    5 ++++-
 extensions/libxt_CT.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_NOTRACK.c |   15 ---------------
 3 files changed, 44 insertions(+), 16 deletions(-)
 delete mode 100644 extensions/libxt_NOTRACK.c

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 218dc3a..b5c355a 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,6 +39,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
+pfx_build_mod += NOTRACK
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -96,11 +97,13 @@ lib%.so: lib%.oo
 lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
+libxt_NOTRACK.so: libxt_CT.so
+	ln -fs $< $@
+
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
-
 #
 #	Static bits
 #
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 27a20e2..a576a95 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -248,6 +248,20 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 		printf(" --zone %u", info->zone);
 }
 
+static void notrack_ct0_tg_init(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info *info = (void *)target->data;
+
+	info->flags = XT_CT_NOTRACK;
+}
+
+static void notrack_ct1_tg_init(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info_v1 *info = (void *)target->data;
+
+	info->flags = XT_CT_NOTRACK;
+}
+
 static struct xtables_target ct_target_reg[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -274,6 +288,32 @@ static struct xtables_target ct_target_reg[] = {
 		.x6_parse	= ct_parse_v1,
 		.x6_options	= ct_opts_v1,
 	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "NOTRACK",
+		.real_name     = "CT",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_ct_target_info)),
+		.userspacesize = offsetof(struct xt_ct_target_info, ct),
+		.init          = notrack_ct0_tg_init,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "NOTRACK",
+		.real_name     = "CT",
+		.revision      = 1,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
+		.userspacesize = offsetof(struct xt_ct_target_info_v1, ct),
+		.init          = notrack_ct1_tg_init,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "NOTRACK",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+	},
 };
 
 void _init(void)
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
deleted file mode 100644
index ca58700..0000000
--- a/extensions/libxt_NOTRACK.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/* Shared library add-on to iptables to add NOTRACK target support. */
-#include <xtables.h>
-
-static struct xtables_target notrack_target = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "NOTRACK",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
-};
-
-void _init(void)
-{
-	xtables_register_target(&notrack_target);
-}
-- 
1.7.10.4

