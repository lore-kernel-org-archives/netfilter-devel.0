From: basile@opensource.dyc.edu
Subject: [PATCH] xtables-addons: match packets based on status of grsecurity RBAC
Date: Sun, 17 Oct 2010 09:52:02 -0400 (EDT)
Message-ID: <20101017135202.8AFEE148E1BC@opensource.dyc.edu>
To: netfilter-devel@vger.kernel.org, pva@gentoo.org,
	hardened@gentoo.org, zbyniu@destrukcja.pl, spender@grsecurity.net,
	pageexec@freemail.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.ddl.dyc.edu ([67.151.215.230]:38815 "EHLO ddl.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab0JQOTf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:19:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a module which is useful to users of
grsecurity's RBAC system.  It matches packets based
on whether RBAC is enabled or disabled.

See: http://grsecurity.net/

Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
---
 extensions/Mbuild                  |    1 +
 extensions/libxt_gradm.c           |   96 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_gradm.man         |    7 +++
 include/linux/netfilter/xt_gradm.h |    9 +++
 mconfig                            |    1 +
 5 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/extensions/Mbuild b/extensions/Mbuild
index f5aa137..3e5557c 100644
--- a/extensions/Mbuild
+++ b/extensions/Mbuild
@@ -25,3 +25,4 @@ obj-${build_lscan}       += libxt_lscan.so
 obj-${build_pknock}      += pknock/
 obj-${build_psd}         += libxt_psd.so
 obj-${build_quota2}      += libxt_quota2.so
+obj-${build_gradm}       += libxt_gradm.so
diff --git a/extensions/libxt_gradm.c b/extensions/libxt_gradm.c
new file mode 100644
index 0000000..cecf192
--- /dev/null
+++ b/extensions/libxt_gradm.c
@@ -0,0 +1,96 @@
+/*
+ *	"gradm" match extension for iptables
+ *	Zbigniew Krzystolik <zbyniu@destrukcja.pl>, 2010
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License;
+ *	either version 2 of the License, or any later version, as
+ *	published by the Free Software Foundation.
+ */
+#include <getopt.h>
+#include <netdb.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_gradm.h>
+
+static void gradm_mt_help(void)
+{
+	printf(
+"gradm match options:\n"
+" [!] --enabled    is Grsecurity RBAC enabled\n"
+" [!] --disabled   is Grsecurity RBAC disabled\n");
+};
+
+static const struct option gradm_mt_opts[] = {
+	{.name = "enabled", .has_arg = false, .val = '1'},
+	{.name = "disabled", .has_arg = false, .val = '2'},
+	{NULL},
+};
+
+static void gradm_mt_init(struct xt_entry_match *m)
+{
+}
+
+static int gradm_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+                          const void *entry, struct xt_entry_match **match)
+{
+	struct xt_gradm_mtinfo *info = (void *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (invert)
+			info->invflags |= 1;
+		return true;
+	case '2':
+		if (!invert)
+			info->invflags |= 1;
+		return true;
+	}
+	return false;
+}
+
+static void gradm_mt_check(unsigned int flags)
+{
+}
+
+static void gradm_mt_print(const void *ip, const struct xt_entry_match *match,
+                           int numeric)
+{
+	const struct xt_gradm_mtinfo *info = (const void *)match->data;
+	if (info->invflags)
+		printf("gradm:  disabled");
+	else
+		printf("gradm:  enabled");
+}
+
+static void gradm_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_gradm_mtinfo *info = (const void *)match->data;
+	if (info->invflags)
+		printf("--disabled ");
+	else
+		printf("--enabled ");
+}
+
+static struct xtables_match gradm_mt_reg = { 
+	.family		= NFPROTO_UNSPEC,
+	.name		= "gradm",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_gradm_mtinfo)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_gradm_mtinfo)),
+	.help		= gradm_mt_help,
+	.init		= gradm_mt_init,
+	.parse		= gradm_mt_parse,
+	.final_check	= gradm_mt_check,
+	.print		= gradm_mt_print,
+	.save		= gradm_mt_save,
+	.extra_opts	= gradm_mt_opts,
+};
+
+static __attribute__((constructor)) void gradm_mt_ldr(void)
+{
+	xtables_register_match(&gradm_mt_reg);
+}
diff --git a/extensions/libxt_gradm.man b/extensions/libxt_gradm.man
new file mode 100644
index 0000000..154a4c4
--- /dev/null
+++ b/extensions/libxt_gradm.man
@@ -0,0 +1,7 @@
+This module matches packets based on grsecurity RBAC status.
+.TP
+[\fB!\fP] \fB\-\-enabled\fP
+Matches packets if grsecurity RBAC is enabled.
+.TP
+[\fB!\fP] \fB\-\-disabled\fP
+Matches packets if grsecurity RBAC is disabled.
diff --git a/include/linux/netfilter/xt_gradm.h b/include/linux/netfilter/xt_gradm.h
new file mode 100644
index 0000000..96aa447
--- /dev/null
+++ b/include/linux/netfilter/xt_gradm.h
@@ -0,0 +1,9 @@
+#ifndef _XT_GRADM_H
+#define _XT_GRADM_H
+
+struct xt_gradm_mtinfo {
+	__u16 flags;
+	__u16 invflags;
+};
+
+#endif
diff --git a/mconfig b/mconfig
index 6bfeb71..d22cd20 100644
--- a/mconfig
+++ b/mconfig
@@ -25,3 +25,4 @@ build_lscan=m
 build_pknock=m
 build_psd=m
 build_quota2=m
+build_gradm=m
