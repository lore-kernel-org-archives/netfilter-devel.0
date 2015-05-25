From: Eddie Linder <eddi@guardicore.com>
Subject: [PATCH 1/1] Added a vlan id and pcp matching extension
Date: Mon, 25 May 2015 13:40:27 -0700
Message-ID: <1432586427-42288-1-git-send-email-eddi@guardicore.com>
Cc: Eddie Linder <eddi@guardicore.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32990 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbEYUke (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 16:40:34 -0400
Received: by wgez8 with SMTP id z8so80623023wge.0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2015 13:40:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eddie Linder <eddi@guardicore.com>
---
 extensions/libxt_vlan.c           | 107 ++++++++++++++++++++++++++++++++++++++
 extensions/libxt_vlan.man         |   6 +++
 extensions/libxt_vlan.t           |   9 ++++
 include/linux/netfilter/xt_vlan.h |  10 ++++
 include/xtables.h                 |   8 ++-
 iptables-test.py                  |   8 +--
 iptables/.gitignore               |   4 ++
 libxtables/xtoptions.c            |  31 +++++++++++
 8 files changed, 178 insertions(+), 5 deletions(-)
 create mode 100644 extensions/libxt_vlan.c
 create mode 100644 extensions/libxt_vlan.man
 create mode 100644 extensions/libxt_vlan.t
 create mode 100644 include/linux/netfilter/xt_vlan.h

diff --git a/extensions/libxt_vlan.c b/extensions/libxt_vlan.c
new file mode 100644
index 0000000..5d036cf
--- /dev/null
+++ b/extensions/libxt_vlan.c
@@ -0,0 +1,107 @@
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_vlan.h>
+
+enum {
+	O_VLAN_ID = 0,
+	O_VLAN_PCP,
+};
+
+static void vlan_mt_help(void)
+{
+	printf(
+"vlan match options:\n"
+"[!] --vlan-id vlan_id\n"
+" --vlan-pcp vlan_pcp\n"
+"				Match vlan fields\n");
+}
+
+#define s struct xt_vlan_info
+static const struct xt_option_entry vlan_mt_opts[] = {
+	{.name = "vlan-id", .id = O_VLAN_ID, .type = XTTYPE_VLAN_ID,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	{.name = "vlan-pcp", .id = O_VLAN_PCP, .type = XTTYPE_VLAN_PCP},
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static void vlan_mt_parse(struct xt_option_call *cb)
+{
+	struct xt_vlan_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_VLAN_ID:
+		if (cb->invert)
+			info->invert = 1;
+		info->vlan_id = cb->val.vlan_id;
+		break;
+	case O_VLAN_PCP:
+		info->vlan_pcp = cb->val.vlan_pcp;
+		break;
+	}
+}
+
+static void print_vlan_id(const struct xt_vlan_info *info)
+{
+	printf("%hu", info->vlan_id);
+}
+
+static void print_vlan_pcp(const struct xt_vlan_info *info)
+{
+	printf("%u", info->vlan_pcp);
+}
+
+
+static void
+vlan_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_vlan_info *info = (void *)match->data;
+
+	printf(" VLAN --id ");
+
+	if (info->invert)
+		printf("!");
+
+	print_vlan_id(info);
+
+	if (info->vlan_pcp) {
+		printf(" --pcp ");
+		print_vlan_pcp(info);
+	}
+}
+
+static void vlan_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_vlan_info *info = (void *)match->data;
+
+	if (info->invert)
+		printf(" !");
+
+	printf(" --vlan-id ");
+	print_vlan_id(info);
+
+	if (info->vlan_pcp) {
+		printf(" --vlan-pcp ");
+		print_vlan_pcp(info);
+	}
+}
+
+static struct xtables_match mark_mt_reg = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "vlan",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_vlan_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_vlan_info)),
+	.help		= vlan_mt_help,
+	.x6_parse	= vlan_mt_parse,
+	.print		= vlan_mt_print,
+	.save		= vlan_mt_save,
+	.x6_options	= vlan_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&mark_mt_reg);
+}
+
diff --git a/extensions/libxt_vlan.man b/extensions/libxt_vlan.man
new file mode 100644
index 0000000..998cb82
--- /dev/null
+++ b/extensions/libxt_vlan.man
@@ -0,0 +1,6 @@
+This module matches the netfilter vlan tci field associated with a packet.
+.TP
+[\fB!\fP] \fB\-\-vlan-id\fP \fIvalue\f
+Matches packets with the given unsigned vlan id (0-4095) value.
+\fB\-\-vlan-pcp\fP \fIvalue\f
+Matches packets with the given unsigned vlan pcp (1-7) value.
diff --git a/extensions/libxt_vlan.t b/extensions/libxt_vlan.t
new file mode 100644
index 0000000..00c50d0
--- /dev/null
+++ b/extensions/libxt_vlan.t
@@ -0,0 +1,9 @@
+:INPUT,FORWARD,OUTPUT
+-m vlan --vlan-id 1000;=;OK
+-m vlan --vlan-id 0;=;OK
+-m vlan --vlan-id 4095;OK
+-m vlan --vlan-id 4095 --vlan-pcp 2;OK
+-m vlan --vlan-id 4095 --vlan-pcp 8;FAIL
+-m vlan --vlan-id 4096;;FAIL
+-m vlan --vlan-id -1;;FAIL
+-m vlan;;FAIL
diff --git a/include/linux/netfilter/xt_vlan.h b/include/linux/netfilter/xt_vlan.h
new file mode 100644
index 0000000..bd0acb3
--- /dev/null
+++ b/include/linux/netfilter/xt_vlan.h
@@ -0,0 +1,10 @@
+#ifndef _XT_VLAN_H
+#define _XT_VLAN_H
+
+
+struct xt_vlan_info {
+	unsigned short vlan_id;
+	unsigned char vlan_pcp;
+	unsigned char invert;
+};
+#endif /*_XT_VLAN_H */
diff --git a/include/xtables.h b/include/xtables.h
index bad11a8..2cf42c6 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -69,6 +69,8 @@ struct in_addr;
  * %XTTYPE_PLEN:	prefix length
  * %XTTYPE_PLENMASK:	prefix length (ptr: union nf_inet_addr)
  * %XTTYPE_ETHERMAC:	Ethernet MAC address in hex form
+ * %XTTYPE_VLAN_ID:	VLAN ID in decimal form
+ * %XTTYPE_VLAN_PCP:	VLAN PCP in decimal form (0-7)
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -93,6 +95,8 @@ enum xt_option_type {
 	XTTYPE_PLEN,
 	XTTYPE_PLENMASK,
 	XTTYPE_ETHERMAC,
+	XTTYPE_VLAN_ID,
+	XTTYPE_VLAN_PCP,
 };
 
 /**
@@ -152,8 +156,8 @@ struct xt_option_call {
 	bool invert;
 	uint8_t nvals;
 	union {
-		uint8_t u8, u8_range[2], syslog_level, protocol;
-		uint16_t u16, u16_range[2], port, port_range[2];
+		uint8_t u8, u8_range[2], syslog_level, protocol, vlan_pcp;
+		uint16_t u16, u16_range[2], port, port_range[2], vlan_id;
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		double dbl;
diff --git a/iptables-test.py b/iptables-test.py
index 9e137f8..ea6afaa 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -220,9 +220,11 @@ def run_test_file(filename):
                 rule_save = chain + " " + item[0]
             else:
                 rule_save = chain + " " + item[1]
-
-            res = item[2].rstrip()
-
+            try:
+                res = item[2].rstrip()
+            except:
+                print "Failed running tests on file %s" % filename
+                raise
             ret = run_test(iptables, rule, rule_save,
                            res, filename, lineno + 1)
             if ret < 0:
diff --git a/iptables/.gitignore b/iptables/.gitignore
index 6c0ade1..18d744e 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -7,9 +7,13 @@
 /iptables-extensions.8
 /iptables-extensions.8.tmpl
 /iptables-save
+/iptables-save.8
 /iptables-restore
+/iptables-restore.8
 /iptables-static
+/iptables-apply.8
 /iptables-xml
+/iptables-xml.1
 /xtables-multi
 /xtables-config-parser.c
 /xtables-config-parser.h
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index d26d2f8..528b6b6 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -64,6 +64,8 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
 	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
 	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
+	[XTTYPE_VLAN_ID]     = sizeof(uint16_t),
+	[XTTYPE_VLAN_PCP]    = sizeof(uint8_t),
 };
 
 /**
@@ -805,6 +807,33 @@ static void xtopt_parse_ethermac(struct xt_option_call *cb)
 	xt_params->exit_err(PARAMETER_PROBLEM, "Invalid MAC address specified.");
 }
 
+/**
+ * Validate and parse a vlan id and put the result into
+ * @cb->val.vlan_id.
+ */
+static void xtopt_parse_vlan_id(struct xt_option_call *cb)
+{
+	unsigned int vlan_id = 0;
+
+	if (!xtables_strtoui(cb->arg, NULL, &vlan_id, 0, 4096))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+				    "Invalid Vlan ID specified: %s.",
+				    cb->arg);
+	cb->val.vlan_id = vlan_id;
+}
+
+static void xtopt_parse_vlan_pcp(struct xt_option_call *cb)
+{
+	unsigned int vlan_pcp = 0;
+
+	if (!xtables_strtoui(cb->arg, NULL, &vlan_pcp, 1, 7))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+				    "Invalid Vlan PCP specified: %s.",
+				    cb->arg);
+	cb->val.vlan_pcp = vlan_pcp;
+}
+
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -827,6 +856,8 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_PLEN]        = xtopt_parse_plen,
 	[XTTYPE_PLENMASK]    = xtopt_parse_plenmask,
 	[XTTYPE_ETHERMAC]    = xtopt_parse_ethermac,
+	[XTTYPE_VLAN_ID]     = xtopt_parse_vlan_id,
+	[XTTYPE_VLAN_PCP]    = xtopt_parse_vlan_pcp,
 };
 
 /**
-- 
1.9.1

