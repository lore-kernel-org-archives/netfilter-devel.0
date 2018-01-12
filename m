From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables 1/2] extensions: add support for 'SEG6' target
Date: Fri, 12 Jan 2018 05:39:58 +0100
Message-ID: <1515731999-6381-1-git-send-email-amsalam20@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds a new exetension to iptables to supprt IPv6
segment routing 'SEG6' target.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_SEG6.c                | 122 +++++++++++++++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_SEG6.h |  17 +++++
 2 files changed, 139 insertions(+)
 create mode 100644 extensions/libip6t_SEG6.c
 create mode 100644 include/linux/netfilter_ipv6/ip6t_SEG6.h

diff --git a/extensions/libip6t_SEG6.c b/extensions/libip6t_SEG6.c
new file mode 100644
index 0000000..1a47160
--- /dev/null
+++ b/extensions/libip6t_SEG6.c
@@ -0,0 +1,122 @@
+/*
+ * Shared library add-on to iptables to add SEG6 target support
+ *
+ * Author:
+ *       Ahmed Abdelsalam <amsalam20@gmail.com>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv6/ip6t_SEG6.h>
+
+struct seg6_names {
+	const char *name;
+	enum ip6t_seg6_action action;
+	const char *desc;
+};
+
+enum {
+	O_SEG6_ACTION = 0,
+};
+
+static const struct seg6_names seg6_table[] = {
+	{"go-next", IP6T_SEG6_GO_NEXT, "SEG6 go next"},
+	{"skip-next", IP6T_SEG6_SKIP_NEXT, "SEG6 skip next"},
+	{"go-last",   IP6T_SEG6_GO_LAST, "SEG6 go last"}
+};
+
+static void
+print_seg6_action(void)
+{
+	unsigned int i;
+
+	printf("Valid SEG6 action:\n");
+	for (i = 0; i < ARRAY_SIZE(seg6_table); ++i) {
+		printf("    %-25s\t%s\n", seg6_table[i].name,
+			seg6_table[i].desc);
+	}
+	printf("\n");
+}
+
+static void SEG6_help(void)
+{
+	printf(
+"SEG6 target options:\n"
+"--seg6-action action	perform statless action on SRv6 packets\n");
+
+	print_seg6_action();
+}
+
+static const struct xt_option_entry SEG6_opts[] = {
+	{.name = "seg6-action", .id = O_SEG6_ACTION, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
+};
+
+static void SEG6_init(struct xt_entry_target *t)
+{
+	struct ip6t_seg6_info *seg6 = (struct ip6t_seg6_info *)t->data;
+
+	/* default */
+	seg6->action = IP6T_SEG6_GO_NEXT;
+}
+
+static void SEG6_parse(struct xt_option_call *cb)
+{
+	struct ip6t_seg6_info *seg6 = cb->data;
+	unsigned int i;
+
+	xtables_option_parse(cb);
+	for (i = 0; i < ARRAY_SIZE(seg6_table); ++i)
+		if (strncasecmp(seg6_table[i].name, cb->arg,
+		strlen(cb->arg)) == 0) {
+			seg6->action = seg6_table[i].action;
+			return;
+		}
+	xtables_error(PARAMETER_PROBLEM, "unknown seg6 action \"%s\"", cb->arg);
+}
+
+static void SEG6_print(const void *ip, const struct xt_entry_target *target,
+			int numeric)
+{
+	const struct ip6t_seg6_info *seg6
+		= (const struct ip6t_seg6_info *)target->data;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(seg6_table); ++i)
+		if (seg6_table[i].action == seg6->action)
+			break;
+	printf(" seg6-action %s", seg6_table[i].name);
+}
+
+static void SEG6_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct ip6t_seg6_info *seg6
+		= (const struct ip6t_seg6_info *)target->data;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(seg6_table); ++i)
+		if (seg6_table[i].action == seg6->action)
+			break;
+
+	printf(" --seg6-action %s", seg6_table[i].name);
+}
+
+static struct xtables_target seg6_tg6_reg = {
+	.name		= "SEG6",
+	.version        = XTABLES_VERSION,
+	.family         = NFPROTO_IPV6,
+	.size           = XT_ALIGN(sizeof(struct ip6t_seg6_info)),
+	.userspacesize  = XT_ALIGN(sizeof(struct ip6t_seg6_info)),
+	.help           = SEG6_help,
+	.init           = SEG6_init,
+	.print          = SEG6_print,
+	.save           = SEG6_save,
+	.x6_parse       = SEG6_parse,
+	.x6_options     = SEG6_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&seg6_tg6_reg);
+}
diff --git a/include/linux/netfilter_ipv6/ip6t_SEG6.h b/include/linux/netfilter_ipv6/ip6t_SEG6.h
new file mode 100644
index 0000000..cdfdf4e
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_SEG6.h
@@ -0,0 +1,17 @@
+#ifndef _IP6T_SEG6_H
+#define _IP6T_SEG6_H
+
+#include <linux/types.h>
+
+/* seg6 action options */
+enum ip6t_seg6_action {
+	IP6T_SEG6_GO_NEXT,
+	IP6T_SEG6_SKIP_NEXT,
+	IP6T_SEG6_GO_LAST,
+};
+
+struct ip6t_seg6_info {
+	__u32	action;	/* SEG6 action */
+};
+
+#endif /*_IP6T_SEG6_H*/
-- 
2.1.4
