From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] iptables: extensions: add IPv6 capable ECN match extension
Date: Thu, 09 Jun 2011 14:18:56 +0200
Message-ID: <4DF0BA30.8070109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060603010907010200060301"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>,
	Dave Taht <dave.taht@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37910 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1FIMS6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:18:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060603010907010200060301
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


--------------060603010907010200060301
Content-Type: text/x-patch;
 name="libxt_ecn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libxt_ecn.diff"

commit 9c6ed522dbf12adb213f288b8e2bb0952e216ee3
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jun 9 11:31:21 2011 +0200

    extensions: add IPv6 capable ECN match extension
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
deleted file mode 100644
index 56a0347..0000000
--- a/extensions/libipt_ecn.c
+++ /dev/null
@@ -1,137 +0,0 @@
-/* Shared library add-on to iptables for ECN matching
- *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *
- * This program is distributed under the terms of GNU GPL v2, 1991
- *
- * libipt_ecn.c borrowed heavily from libipt_dscp.c
- *
- */
-#include <stdio.h>
-#include <xtables.h>
-#include <linux/netfilter_ipv4/ipt_ecn.h>
-
-enum {
-	O_ECN_TCP_CWR = 0,
-	O_ECN_TCP_ECE,
-	O_ECN_IP_ECT,
-};
-
-static void ecn_help(void)
-{
-	printf(
-"ECN match options\n"
-"[!] --ecn-tcp-cwr 		Match CWR bit of TCP header\n"
-"[!] --ecn-tcp-ece		Match ECE bit of TCP header\n"
-"[!] --ecn-ip-ect [0..3]	Match ECN codepoint in IPv4 header\n");
-}
-
-static const struct xt_option_entry ecn_opts[] = {
-	{.name = "ecn-tcp-cwr", .id = O_ECN_TCP_CWR, .type = XTTYPE_NONE,
-	 .flags = XTOPT_INVERT},
-	{.name = "ecn-tcp-ece", .id = O_ECN_TCP_ECE, .type = XTTYPE_NONE,
-	 .flags = XTOPT_INVERT},
-	{.name = "ecn-ip-ect", .id = O_ECN_IP_ECT, .type = XTTYPE_UINT8,
-	 .min = 0, .max = 3, .flags = XTOPT_INVERT},
-	XTOPT_TABLEEND,
-};
-
-static void ecn_parse(struct xt_option_call *cb)
-{
-	struct ipt_ecn_info *einfo = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_ECN_TCP_CWR:
-		einfo->operation |= IPT_ECN_OP_MATCH_CWR;
-		if (cb->invert)
-			einfo->invert |= IPT_ECN_OP_MATCH_CWR;
-		break;
-	case O_ECN_TCP_ECE:
-		einfo->operation |= IPT_ECN_OP_MATCH_ECE;
-		if (cb->invert)
-			einfo->invert |= IPT_ECN_OP_MATCH_ECE;
-		break;
-	case O_ECN_IP_ECT:
-		if (cb->invert)
-			einfo->invert |= IPT_ECN_OP_MATCH_IP;
-		einfo->operation |= IPT_ECN_OP_MATCH_IP;
-		einfo->ip_ect = cb->val.u8;
-		break;
-	}
-}
-
-static void ecn_check(struct xt_fcheck_call *cb)
-{
-	if (cb->xflags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-		           "ECN match: some option required");
-}
-
-static void ecn_print(const void *ip, const struct xt_entry_match *match,
-                      int numeric)
-{
-	const struct ipt_ecn_info *einfo =
-		(const struct ipt_ecn_info *)match->data;
-
-	printf(" ECN match");
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
-		printf(" %sECE",
-		       (einfo->invert & IPT_ECN_OP_MATCH_ECE) ? "!" : "");
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
-		printf(" %sCWR",
-		       (einfo->invert & IPT_ECN_OP_MATCH_CWR) ? "!" : "");
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_IP) {
-		printf(" %sECT=%d",
-		       (einfo->invert & IPT_ECN_OP_MATCH_IP) ? "!" : "",
-		       einfo->ip_ect);
-	}
-}
-
-static void ecn_save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_ecn_info *einfo =
-		(const struct ipt_ecn_info *)match->data;
-	
-	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_ECE)
-			printf(" !");
-		printf(" --ecn-tcp-ece");
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_CWR)
-			printf(" !");
-		printf(" --ecn-tcp-cwr");
-	}
-
-	if (einfo->operation & IPT_ECN_OP_MATCH_IP) {
-		if (einfo->invert & IPT_ECN_OP_MATCH_IP)
-			printf(" !");
-		printf(" --ecn-ip-ect %d", einfo->ip_ect);
-	}
-}
-
-static struct xtables_match ecn_mt_reg = {
-	.name          = "ecn",
-	.version       = XTABLES_VERSION,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct ipt_ecn_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ipt_ecn_info)),
-	.help          = ecn_help,
-	.print         = ecn_print,
-	.save          = ecn_save,
-	.x6_parse      = ecn_parse,
-	.x6_fcheck     = ecn_check,
-	.x6_options    = ecn_opts,
-};
-
-void _init(void)
-{
-	xtables_register_match(&ecn_mt_reg);
-}
diff --git a/extensions/libipt_ecn.man b/extensions/libipt_ecn.man
deleted file mode 100644
index 7f80647..0000000
--- a/extensions/libipt_ecn.man
+++ /dev/null
@@ -1,11 +0,0 @@
-This allows you to match the ECN bits of the IPv4 and TCP header.  ECN is the Explicit Congestion Notification mechanism as specified in RFC3168
-.TP
-[\fB!\fP] \fB\-\-ecn\-tcp\-cwr\fP
-This matches if the TCP ECN CWR (Congestion Window Received) bit is set.
-.TP
-[\fB!\fP] \fB\-\-ecn\-tcp\-ece\fP
-This matches if the TCP ECN ECE (ECN Echo) bit is set.
-.TP
-[\fB!\fP] \fB\-\-ecn\-ip\-ect\fP \fInum\fP
-This matches a particular IPv4 ECT (ECN-Capable Transport). You have to specify
-a number between `0' and `3'.
diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
new file mode 100644
index 0000000..0ae72dd
--- /dev/null
+++ b/extensions/libxt_ecn.c
@@ -0,0 +1,137 @@
+/* Shared library add-on to iptables for ECN matching
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This program is distributed under the terms of GNU GPL v2, 1991
+ *
+ * libipt_ecn.c borrowed heavily from libipt_dscp.c
+ *
+ */
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_ecn.h>
+
+enum {
+	O_ECN_TCP_CWR = 0,
+	O_ECN_TCP_ECE,
+	O_ECN_IP_ECT,
+};
+
+static void ecn_help(void)
+{
+	printf(
+"ECN match options\n"
+"[!] --ecn-tcp-cwr 		Match CWR bit of TCP header\n"
+"[!] --ecn-tcp-ece		Match ECE bit of TCP header\n"
+"[!] --ecn-ip-ect [0..3]	Match ECN codepoint in IPv4/IPv6 header\n");
+}
+
+static const struct xt_option_entry ecn_opts[] = {
+	{.name = "ecn-tcp-cwr", .id = O_ECN_TCP_CWR, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "ecn-tcp-ece", .id = O_ECN_TCP_ECE, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "ecn-ip-ect", .id = O_ECN_IP_ECT, .type = XTTYPE_UINT8,
+	 .min = 0, .max = 3, .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
+};
+
+static void ecn_parse(struct xt_option_call *cb)
+{
+	struct xt_ecn_info *einfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_ECN_TCP_CWR:
+		einfo->operation |= XT_ECN_OP_MATCH_CWR;
+		if (cb->invert)
+			einfo->invert |= XT_ECN_OP_MATCH_CWR;
+		break;
+	case O_ECN_TCP_ECE:
+		einfo->operation |= XT_ECN_OP_MATCH_ECE;
+		if (cb->invert)
+			einfo->invert |= XT_ECN_OP_MATCH_ECE;
+		break;
+	case O_ECN_IP_ECT:
+		if (cb->invert)
+			einfo->invert |= XT_ECN_OP_MATCH_IP;
+		einfo->operation |= XT_ECN_OP_MATCH_IP;
+		einfo->ip_ect = cb->val.u8;
+		break;
+	}
+}
+
+static void ecn_check(struct xt_fcheck_call *cb)
+{
+	if (cb->xflags == 0)
+		xtables_error(PARAMETER_PROBLEM,
+		           "ECN match: some option required");
+}
+
+static void ecn_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
+{
+	const struct xt_ecn_info *einfo =
+		(const struct xt_ecn_info *)match->data;
+
+	printf(" ECN match");
+
+	if (einfo->operation & XT_ECN_OP_MATCH_ECE) {
+		printf(" %sECE",
+		       (einfo->invert & XT_ECN_OP_MATCH_ECE) ? "!" : "");
+	}
+
+	if (einfo->operation & XT_ECN_OP_MATCH_CWR) {
+		printf(" %sCWR",
+		       (einfo->invert & XT_ECN_OP_MATCH_CWR) ? "!" : "");
+	}
+
+	if (einfo->operation & XT_ECN_OP_MATCH_IP) {
+		printf(" %sECT=%d",
+		       (einfo->invert & XT_ECN_OP_MATCH_IP) ? "!" : "",
+		       einfo->ip_ect);
+	}
+}
+
+static void ecn_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_ecn_info *einfo =
+		(const struct xt_ecn_info *)match->data;
+
+	if (einfo->operation & XT_ECN_OP_MATCH_ECE) {
+		if (einfo->invert & XT_ECN_OP_MATCH_ECE)
+			printf(" !");
+		printf(" --ecn-tcp-ece");
+	}
+
+	if (einfo->operation & XT_ECN_OP_MATCH_CWR) {
+		if (einfo->invert & XT_ECN_OP_MATCH_CWR)
+			printf(" !");
+		printf(" --ecn-tcp-cwr");
+	}
+
+	if (einfo->operation & XT_ECN_OP_MATCH_IP) {
+		if (einfo->invert & XT_ECN_OP_MATCH_IP)
+			printf(" !");
+		printf(" --ecn-ip-ect %d", einfo->ip_ect);
+	}
+}
+
+static struct xtables_match ecn_mt_reg = {
+	.name          = "ecn",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_UNSPEC,
+	.size          = XT_ALIGN(sizeof(struct xt_ecn_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_ecn_info)),
+	.help          = ecn_help,
+	.print         = ecn_print,
+	.save          = ecn_save,
+	.x6_parse      = ecn_parse,
+	.x6_fcheck     = ecn_check,
+	.x6_options    = ecn_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&ecn_mt_reg);
+}
diff --git a/extensions/libxt_ecn.man b/extensions/libxt_ecn.man
new file mode 100644
index 0000000..31c0a3e
--- /dev/null
+++ b/extensions/libxt_ecn.man
@@ -0,0 +1,11 @@
+This allows you to match the ECN bits of the IPv4/IPv6 and TCP header.  ECN is the Explicit Congestion Notification mechanism as specified in RFC3168
+.TP
+[\fB!\fP] \fB\-\-ecn\-tcp\-cwr\fP
+This matches if the TCP ECN CWR (Congestion Window Received) bit is set.
+.TP
+[\fB!\fP] \fB\-\-ecn\-tcp\-ece\fP
+This matches if the TCP ECN ECE (ECN Echo) bit is set.
+.TP
+[\fB!\fP] \fB\-\-ecn\-ip\-ect\fP \fInum\fP
+This matches a particular IPv4/IPv6 ECT (ECN-Capable Transport). You have to specify
+a number between `0' and `3'.
diff --git a/include/linux/netfilter/xt_ecn.h b/include/linux/netfilter/xt_ecn.h
new file mode 100644
index 0000000..5a38dd3
--- /dev/null
+++ b/include/linux/netfilter/xt_ecn.h
@@ -0,0 +1,33 @@
+/* iptables module for matching the ECN header in IPv4 and TCP header
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+*/
+#ifndef _XT_ECN_H
+#define _XT_ECN_H
+
+#include <linux/types.h>
+#include <linux/netfilter/xt_dscp.h>
+
+#define XT_ECN_IP_MASK	(~XT_DSCP_MASK)
+
+#define XT_ECN_OP_MATCH_IP	0x01
+#define XT_ECN_OP_MATCH_ECE	0x10
+#define XT_ECN_OP_MATCH_CWR	0x20
+
+#define XT_ECN_OP_MATCH_MASK	0xce
+
+/* match info */
+struct xt_ecn_info {
+	__u8 operation;
+	__u8 invert;
+	__u8 ip_ect;
+	union {
+		struct {
+			__u8 ect;
+		} tcp;
+	} proto;
+};
+
+#endif /* _XT_ECN_H */
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
deleted file mode 100644
index 9945baa..0000000
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* iptables module for matching the ECN header in IPv4 and TCP header
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
-*/
-#ifndef _IPT_ECN_H
-#define _IPT_ECN_H
-#include <linux/netfilter/xt_dscp.h>
-
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_MATCH_IP	0x01
-#define IPT_ECN_OP_MATCH_ECE	0x10
-#define IPT_ECN_OP_MATCH_CWR	0x20
-
-#define IPT_ECN_OP_MATCH_MASK	0xce
-
-/* match info */
-struct ipt_ecn_info {
-	u_int8_t operation;
-	u_int8_t invert;
-	u_int8_t ip_ect;
-	union {
-		struct {
-			u_int8_t ect;
-		} tcp;
-	} proto;
-};
-
-#endif /* _IPT_ECN_H */

--------------060603010907010200060301--
