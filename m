From: Nicolas Bareil <nico@chdir.org>
Subject: Re: scrubbing support in Netfilter
Date: Tue, 27 May 2008 17:12:51 +0200
Message-ID: <87hccjdbm4.fsf@chdir.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicolas Bareil <nicolas.bareil@eads.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moog.chdir.org ([88.191.42.160]:45327 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbYE0PMz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 11:12:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Here is the iptables patch.

commit c23a3f536b11396c2a11df39fe0ae8386d5a12b1
Author: Nicolas Bareil <nico@chdir.org>
Date:   Tue May 27 17:01:00 2008 +0200

    scrubbing support

diff --git a/extensions/libip6t_SCRUB.c b/extensions/libip6t_SCRUB.c
new file mode 100644
index 0000000..7d21083
--- /dev/null
+++ b/extensions/libip6t_SCRUB.c
@@ -0,0 +1,218 @@
+/* Shared library add-on to iptables for the SCRUB target
+ * (C) 2008 by Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is distributed under the terms of GNU GPL
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+#include <linux/netfilter/ipt_scrub.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+#define SCRUB_ALL (SCRUB_IP_TOS_ADJUST|SCRUB_IP_RAND_ID_ADJUST|SCRUB_IP_TTL_ADJUST|SCRUB_TCP_SEQ_ADJUST|SCRUB_TCP_OPT_TIMESTAMP_ADJUST|SCRUB_TCP_OPT_MSS_ADJUST)
+
+static void init(struct xt_entry_target *t)
+{
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *) t->data;
+
+	info->flags = 0;
+	info->ttl.scrubbing_default = SCRUB_NORMALIZE_TTL;
+	info->ttl.modifying_threshold = SCRUB_TTL_LOW_THRESHOLD;
+	info->ttl.dropping_threshold = SCRUB_TTL_DROP_IF_LOWER;
+}
+
+static void help(void) 
+{
+	printf(
+"SCRUB target v%s options\n"
+"  --rand-ipid value		Set a random IP ID\n"
+, XTABLES_VERSION);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const void *entry,
+		struct xt_entry_target **target)
+{
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *) (*target)->data;
+
+        *flags=1;
+
+	switch (c) {
+	case '!':
+		/* do not overwrite "--no-something" */
+		info->flags= (SCRUB_ALL & ~info->flags) ;
+
+	case 'a':
+		info->flags = (info->flags & ~SCRUB_IP_TOS_ADJUST);
+		break;
+	case '0':
+		info->flags |= SCRUB_IP_TOS_ADJUST;
+		break;
+
+	case 'b':
+		info->flags = (info->flags & ~SCRUB_IP_RAND_ID_ADJUST);
+		break;
+	case '1':
+		info->flags |= SCRUB_IP_RAND_ID_ADJUST;
+		break;
+
+	case 'j':
+		info->flags = (info->flags & ~SCRUB_IP_TTL_ADJUST);
+		break;
+	case '9':
+		info->flags |= SCRUB_IP_TTL_ADJUST;
+		break;
+
+	case '2':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.scrubbing_default)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case '3':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.modifying_threshold)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case '4':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.dropping_threshold)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case 'd':
+		info->flags = (info->flags & ~SCRUB_IP_TTL_ADJUST);
+		break;
+	case '5':
+		info->flags |= SCRUB_IP_TTL_ADJUST;
+		break;
+
+	case 'e':
+		info->flags = (info->flags & ~SCRUB_TCP_SEQ_ADJUST);
+		break;
+	case '6':
+		info->flags |= SCRUB_TCP_SEQ_ADJUST;
+		break;
+
+	case 'f':
+		info->flags = (info->flags & ~SCRUB_TCP_OPT_TIMESTAMP_ADJUST);
+		break;
+	case '7':
+		info->flags |= SCRUB_TCP_OPT_TIMESTAMP_ADJUST;
+		break;
+
+	case 'g':
+		info->flags = (info->flags & ~SCRUB_TCP_OPT_MSS_ADJUST);
+		break;
+	case '8':
+		info->flags |= SCRUB_TCP_OPT_MSS_ADJUST;
+		break;
+
+	default:
+		return 0;
+
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+
+}
+
+static void save(const void *ip, const struct xt_entry_target *target)
+{
+}
+
+static void print(const void *ip,
+		const struct xt_entry_target *target, int numeric)
+{
+	const struct ipt_scrub_info *info =
+		(struct ipt_scrub_info *) target->data;
+
+	printf("SCRUB ");
+
+	if (info->flags == SCRUB_ALL) {
+		printf("everything");
+		return;
+	}
+
+	if (info->flags & SCRUB_TCP_SEQ_ADJUST)
+		printf("random-tcp-isn ");
+
+	if (info->flags & SCRUB_IP_RAND_ID_ADJUST)
+		printf("random-ip-id ");
+
+	if (info->flags & SCRUB_IP_TOS_ADJUST)
+		printf("zeroify-ip-tos ");
+
+	if (info->flags & SCRUB_IP_TTL_ADJUST)
+		printf("default-ttl=%u low-threshold=%u dropping-threschold=%u "
+		       , info->ttl.scrubbing_default
+		       , info->ttl.modifying_threshold
+		       , info->ttl.dropping_threshold);
+
+	if (info->flags & SCRUB_TCP_OPT_MSS_ADJUST)
+		printf("check-tcp-mss ");
+
+	if (info->flags & SCRUB_TCP_OPT_TIMESTAMP_ADJUST)
+		printf("random-tcp-timestamp ");
+
+	if (info->flags & SCRUB_IP_SEALED_TTL_ADJUST)
+		printf("ip-ttl-sealed ");
+}
+
+static struct option opts[] = {
+	{ "scrub-everything", 0, 0, '!'},
+	{ "ip-zero-tos", 0, 0, '0'},
+	{ "ip-rand-id", 0, 0, '1' },
+
+	{ "ip-ttl-scrub", 0, 0, '9'},
+	{ "ip-ttl-default", 1, 0, '2'},
+	{ "ip-ttl-low-threshold", 1, 0, '3'},
+	{ "ip-ttl-dropping-threshold", 1, 0, '4'},
+	{ "ip-ttl-sealed", 0, 0, '5'},
+
+	{ "tcp-rand-seq", 0, 0, '6'},
+	{ "tcp-opt-rand-timestamp", 0, 0, '7'},
+	{ "tcp-opt-check-mss", 0, 0, '8'},
+
+	/* inverse parameter, is there another way */
+
+	{ "no-ip-zero-tos", 0, 0, 'a'},
+	{ "no-ip-rand-id", 0, 0, 'b' },
+	
+	{ "no-ip-ttl-scrub", 0, 0, 'c'},
+	{ "no-ip-ttl-sealed", 0, 0, 'd'},
+
+	{ "no-tcp-rand-seq", 0, 0, 'e'},
+	{ "no-tcp-opt-rand-timestamp", 0, 0, 'f'},
+	{ "no-tcp-opt-check-mss", 0, 0, 'g'},
+
+	{ 0 }
+};
+
+static struct xtables_target SCRUB = {
+	.next		= NULL, 
+	.name		= "SCRUB",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct ipt_scrub_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ipt_scrub_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts 
+};
+
+void _init(void)
+{
+	xtables_register_target(&SCRUB);
+}
diff --git a/extensions/libipt_SCRUB.c b/extensions/libipt_SCRUB.c
new file mode 100644
index 0000000..7d21083
--- /dev/null
+++ b/extensions/libipt_SCRUB.c
@@ -0,0 +1,218 @@
+/* Shared library add-on to iptables for the SCRUB target
+ * (C) 2008 by Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is distributed under the terms of GNU GPL
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+#include <linux/netfilter/ipt_scrub.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+#define SCRUB_ALL (SCRUB_IP_TOS_ADJUST|SCRUB_IP_RAND_ID_ADJUST|SCRUB_IP_TTL_ADJUST|SCRUB_TCP_SEQ_ADJUST|SCRUB_TCP_OPT_TIMESTAMP_ADJUST|SCRUB_TCP_OPT_MSS_ADJUST)
+
+static void init(struct xt_entry_target *t)
+{
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *) t->data;
+
+	info->flags = 0;
+	info->ttl.scrubbing_default = SCRUB_NORMALIZE_TTL;
+	info->ttl.modifying_threshold = SCRUB_TTL_LOW_THRESHOLD;
+	info->ttl.dropping_threshold = SCRUB_TTL_DROP_IF_LOWER;
+}
+
+static void help(void) 
+{
+	printf(
+"SCRUB target v%s options\n"
+"  --rand-ipid value		Set a random IP ID\n"
+, XTABLES_VERSION);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const void *entry,
+		struct xt_entry_target **target)
+{
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *) (*target)->data;
+
+        *flags=1;
+
+	switch (c) {
+	case '!':
+		/* do not overwrite "--no-something" */
+		info->flags= (SCRUB_ALL & ~info->flags) ;
+
+	case 'a':
+		info->flags = (info->flags & ~SCRUB_IP_TOS_ADJUST);
+		break;
+	case '0':
+		info->flags |= SCRUB_IP_TOS_ADJUST;
+		break;
+
+	case 'b':
+		info->flags = (info->flags & ~SCRUB_IP_RAND_ID_ADJUST);
+		break;
+	case '1':
+		info->flags |= SCRUB_IP_RAND_ID_ADJUST;
+		break;
+
+	case 'j':
+		info->flags = (info->flags & ~SCRUB_IP_TTL_ADJUST);
+		break;
+	case '9':
+		info->flags |= SCRUB_IP_TTL_ADJUST;
+		break;
+
+	case '2':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.scrubbing_default)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case '3':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.modifying_threshold)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case '4':
+		if (string_to_number(optarg, 0, 255, (unsigned int *) &(info->ttl.dropping_threshold)) == -1)
+			exit_error(PARAMETER_PROBLEM, "Invalid threshold");
+		break;
+
+	case 'd':
+		info->flags = (info->flags & ~SCRUB_IP_TTL_ADJUST);
+		break;
+	case '5':
+		info->flags |= SCRUB_IP_TTL_ADJUST;
+		break;
+
+	case 'e':
+		info->flags = (info->flags & ~SCRUB_TCP_SEQ_ADJUST);
+		break;
+	case '6':
+		info->flags |= SCRUB_TCP_SEQ_ADJUST;
+		break;
+
+	case 'f':
+		info->flags = (info->flags & ~SCRUB_TCP_OPT_TIMESTAMP_ADJUST);
+		break;
+	case '7':
+		info->flags |= SCRUB_TCP_OPT_TIMESTAMP_ADJUST;
+		break;
+
+	case 'g':
+		info->flags = (info->flags & ~SCRUB_TCP_OPT_MSS_ADJUST);
+		break;
+	case '8':
+		info->flags |= SCRUB_TCP_OPT_MSS_ADJUST;
+		break;
+
+	default:
+		return 0;
+
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+
+}
+
+static void save(const void *ip, const struct xt_entry_target *target)
+{
+}
+
+static void print(const void *ip,
+		const struct xt_entry_target *target, int numeric)
+{
+	const struct ipt_scrub_info *info =
+		(struct ipt_scrub_info *) target->data;
+
+	printf("SCRUB ");
+
+	if (info->flags == SCRUB_ALL) {
+		printf("everything");
+		return;
+	}
+
+	if (info->flags & SCRUB_TCP_SEQ_ADJUST)
+		printf("random-tcp-isn ");
+
+	if (info->flags & SCRUB_IP_RAND_ID_ADJUST)
+		printf("random-ip-id ");
+
+	if (info->flags & SCRUB_IP_TOS_ADJUST)
+		printf("zeroify-ip-tos ");
+
+	if (info->flags & SCRUB_IP_TTL_ADJUST)
+		printf("default-ttl=%u low-threshold=%u dropping-threschold=%u "
+		       , info->ttl.scrubbing_default
+		       , info->ttl.modifying_threshold
+		       , info->ttl.dropping_threshold);
+
+	if (info->flags & SCRUB_TCP_OPT_MSS_ADJUST)
+		printf("check-tcp-mss ");
+
+	if (info->flags & SCRUB_TCP_OPT_TIMESTAMP_ADJUST)
+		printf("random-tcp-timestamp ");
+
+	if (info->flags & SCRUB_IP_SEALED_TTL_ADJUST)
+		printf("ip-ttl-sealed ");
+}
+
+static struct option opts[] = {
+	{ "scrub-everything", 0, 0, '!'},
+	{ "ip-zero-tos", 0, 0, '0'},
+	{ "ip-rand-id", 0, 0, '1' },
+
+	{ "ip-ttl-scrub", 0, 0, '9'},
+	{ "ip-ttl-default", 1, 0, '2'},
+	{ "ip-ttl-low-threshold", 1, 0, '3'},
+	{ "ip-ttl-dropping-threshold", 1, 0, '4'},
+	{ "ip-ttl-sealed", 0, 0, '5'},
+
+	{ "tcp-rand-seq", 0, 0, '6'},
+	{ "tcp-opt-rand-timestamp", 0, 0, '7'},
+	{ "tcp-opt-check-mss", 0, 0, '8'},
+
+	/* inverse parameter, is there another way */
+
+	{ "no-ip-zero-tos", 0, 0, 'a'},
+	{ "no-ip-rand-id", 0, 0, 'b' },
+	
+	{ "no-ip-ttl-scrub", 0, 0, 'c'},
+	{ "no-ip-ttl-sealed", 0, 0, 'd'},
+
+	{ "no-tcp-rand-seq", 0, 0, 'e'},
+	{ "no-tcp-opt-rand-timestamp", 0, 0, 'f'},
+	{ "no-tcp-opt-check-mss", 0, 0, 'g'},
+
+	{ 0 }
+};
+
+static struct xtables_target SCRUB = {
+	.next		= NULL, 
+	.name		= "SCRUB",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct ipt_scrub_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ipt_scrub_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts 
+};
+
+void _init(void)
+{
+	xtables_register_target(&SCRUB);
+}
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3b452a6..720fabb 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -132,4 +132,29 @@ enum ip_conntrack_expect_events {
 	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
 };
 
+enum nf_scrub_transformations {
+    /* scrub tcp sequence adjusting */
+    SCRUB_TCP_SEQ_ADJUST_BIT = 1,
+    SCRUB_TCP_SEQ_ADJUST = (1 << SCRUB_TCP_SEQ_ADJUST_BIT),
+
+    SCRUB_IP_RAND_ID_ADJUST_BIT = 2,
+    SCRUB_IP_RAND_ID_ADJUST = (1 << SCRUB_IP_RAND_ID_ADJUST_BIT),
+
+    SCRUB_IP_TTL_ADJUST_BIT = 3,
+    SCRUB_IP_TTL_ADJUST = (1 << SCRUB_IP_TTL_ADJUST_BIT),
+
+    SCRUB_IP_TOS_ADJUST_BIT = 4,
+    SCRUB_IP_TOS_ADJUST = (1 << SCRUB_IP_TOS_ADJUST_BIT),
+
+    SCRUB_TCP_OPT_MSS_ADJUST_BIT = 5,
+    SCRUB_TCP_OPT_MSS_ADJUST = (1 << SCRUB_TCP_OPT_MSS_ADJUST_BIT),
+
+    SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT = 6,
+    SCRUB_TCP_OPT_TIMESTAMP_ADJUST = (1 << SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT),
+
+    SCRUB_IP_SEALED_TTL_ADJUST_BIT = 7,
+    SCRUB_IP_SEALED_TTL_ADJUST = (1 << SCRUB_IP_SEALED_TTL_ADJUST_BIT),
+};
+
+
 #endif /* _NF_CONNTRACK_COMMON_H */
