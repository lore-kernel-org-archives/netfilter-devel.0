From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: add mark_m match extension
Date: Wed, 21 Jan 2015 19:35:57 +0100
Message-ID: <20150121183557.9396.11050.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50600 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751758AbbAUSgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:36:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translate mark_m match extension to the xtables-compat environment.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_mark_m.c                  |  135 +++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_mark_m.h |   16 +++
 iptables/xtables-eb.c                       |    1 
 3 files changed, 152 insertions(+)
 create mode 100644 extensions/libebt_mark_m.c
 create mode 100644 include/linux/netfilter_bridge/ebt_mark_m.h

diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
new file mode 100644
index 0000000..d5df6bc
--- /dev/null
+++ b/extensions/libebt_mark_m.c
@@ -0,0 +1,135 @@
+/* ebt_mark_m
+ *
+ * Authors:
+ * Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * July, 2002
+ *
+ * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * to use libxtables for ebtables-compat in 2015.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter_bridge/ebt_mark_m.h>
+
+#define MARK '1'
+
+static struct option brmark_m_opts[] = {
+	{ .name = "mark",	.has_arg = true, .val = MARK },
+	XT_GETOPT_TABLEEND,
+};
+
+static void brmark_m_print_help(void)
+{
+	printf(
+"mark option:\n"
+"--mark    [!] [value][/mask]: Match nfmask value (see man page)\n");
+}
+
+static void brmark_m_init(struct xt_entry_match *match)
+{
+	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)match->data;
+
+	info->mark = 0;
+	info->mask = 0;
+	info->invert = 0;
+	info->bitmask = 0;
+}
+
+#define OPT_MARK 0x01
+static int
+brmark_m_parse(int c, char **argv, int invert, unsigned int *flags,
+	       const void *entry, struct xt_entry_match **match)
+{
+	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)
+				       (*match)->data;
+	char *end;
+
+	switch (c) {
+	case MARK:
+		if (invert)
+			info->invert = 1;
+		info->mark = strtoul(optarg, &end, 0);
+		info->bitmask = EBT_MARK_AND;
+		if (*end == '/') {
+			if (end == optarg)
+				info->bitmask = EBT_MARK_OR;
+			info->mask = strtoul(end+1, &end, 0);
+		} else {
+			info->mask = 0xffffffff;
+		}
+		if (*end != '\0' || end == optarg)
+			xtables_error(PARAMETER_PROBLEM, "Bad mark value '%s'",
+				      optarg);
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void brmark_m_final_check(unsigned int flags)
+{
+	if (!flags)
+		xtables_error(PARAMETER_PROBLEM,
+			      "You must specify proper arguments");
+}
+
+static void brmark_m_print(const void *ip, const struct xt_entry_match *match,
+			   int numeric)
+{
+	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)match->data;
+
+	printf("--mark ");
+	if (info->invert)
+		printf("! ");
+	if (info->bitmask == EBT_MARK_OR)
+		printf("/0x%lx ", info->mask);
+	else if (info->mask != 0xffffffff)
+		printf("0x%lx/0x%lx ", info->mark, info->mask);
+	else
+		printf("0x%lx ", info->mark);
+}
+
+/*
+static int compare(const struct ebt_entry_match *m1,
+   const struct ebt_entry_match *m2)
+{
+	struct ebt_mark_m_info *info1 = (struct ebt_mark_m_info *)m1->data;
+	struct ebt_mark_m_info *info2 = (struct ebt_mark_m_info *)m2->data;
+
+	if (info1->invert != info2->invert)
+		return 0;
+	if (info1->mark != info2->mark)
+		return 0;
+	if (info1->mask != info2->mask)
+		return 0;
+	if (info1->bitmask != info2->bitmask)
+		return 0;
+	return 1;
+}
+*/
+
+static struct xtables_match brmark_m_match = {
+	.name		= "mark_m",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
+	.init		= brmark_m_init,
+	.help		= brmark_m_print_help,
+	.parse		= brmark_m_parse,
+	.final_check	= brmark_m_final_check,
+	.print		= brmark_m_print,
+	.extra_opts	= brmark_m_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&brmark_m_match);
+}
diff --git a/include/linux/netfilter_bridge/ebt_mark_m.h b/include/linux/netfilter_bridge/ebt_mark_m.h
new file mode 100644
index 0000000..410f9e5
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_mark_m.h
@@ -0,0 +1,16 @@
+#ifndef __LINUX_BRIDGE_EBT_MARK_M_H
+#define __LINUX_BRIDGE_EBT_MARK_M_H
+
+#include <linux/types.h>
+
+#define EBT_MARK_AND 0x01
+#define EBT_MARK_OR 0x02
+#define EBT_MARK_MASK (EBT_MARK_AND | EBT_MARK_OR)
+struct ebt_mark_m_info {
+	unsigned long mark, mask;
+	__u8 invert;
+	__u8 bitmask;
+};
+#define EBT_MARK_MATCH "mark_m"
+
+#endif
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 27a1c16..0ac39d0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -640,6 +640,7 @@ static void ebt_load_matches(void)
 	opts = ebt_original_options;
 	ebt_load_match("802_3");
 	ebt_load_match("ip");
+	ebt_load_match("mark_m");
 }
 
 static void ebt_add_match(struct xtables_match *m,

