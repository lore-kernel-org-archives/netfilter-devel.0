From: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
Subject: [ebtables PATCH] Add filter for matching on a string
Date: Thu, 21 Dec 2017 13:03:06 +1300
Message-ID: <20171221000306.5873-1-bernie.harris@alliedtelesis.co.nz>
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        Bernie Harris <bernie.harris@alliedtelesis.co.nz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37047 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756202AbdLUAMx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 19:12:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a proposal to add a new filter type that matches on an
arbitrary string within the network-layer packet.

This would allow filtering packets on bridge interfaces based on
certain fields of uncommon protocols (e.g. BACnet).

Two new rule options are added:

--string-offset <offset in decimal>
--string-hex <sequence of octets in hex>

The offset is relative to the start of the network layer packet.

A corresponding kernel patch will also be proposed.

Signed-off-by: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
---
 extensions/Makefile                         |   2 +-
 extensions/ebt_string.c                     | 154 ++++++++++++++++++++++++++++
 include/linux/netfilter_bridge/ebt_string.h |  15 +++
 3 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100644 extensions/ebt_string.c
 create mode 100644 include/linux/netfilter_bridge/ebt_string.h

diff --git a/extensions/Makefile b/extensions/Makefile
index b3548e8..60a70a2 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -1,7 +1,7 @@
 #! /usr/bin/make
 
 EXT_FUNC+=802_3 nat arp arpreply ip ip6 standard log redirect vlan mark_m mark \
-          pkttype stp among limit ulog nflog
+          pkttype stp among limit ulog nflog string
 EXT_TABLES+=filter nat broute
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/ebt_$(T).o)
 EXT_OBJS+=$(foreach T,$(EXT_TABLES), extensions/ebtable_$(T).o)
diff --git a/extensions/ebt_string.c b/extensions/ebt_string.c
new file mode 100644
index 0000000..0596035
--- /dev/null
+++ b/extensions/ebt_string.c
@@ -0,0 +1,154 @@
+/* ebt_string
+ *
+ * Author:
+ * Bernie Harris <bernie.harris@alliedtelesis.co.nz>
+ *
+ * October, 2017
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <ctype.h>
+#include "../include/ebtables_u.h"
+#include <linux/if_packet.h>
+#include <linux/netfilter_bridge/ebt_string.h>
+
+#define STRING_OFFSET '1'
+#define STRING_HEX  '2'
+#define OPT_STRING_OFFSET 0x01
+#define OPT_STRING_HEX    0x02
+
+static const struct option opts[] =
+{
+	{ "string-offset"           , required_argument, 0, STRING_OFFSET },
+	{ "string-hex"              , required_argument, 0, STRING_HEX },
+	{ 0 }
+};
+
+static void print_help()
+{
+	printf(
+"string options:\n"
+"--string-offset offset : offset relative to start of network packet to match from\n"
+"--string-hex string    : string to match, in hex format (e.g. 6578616d706c65)\n"
+"The maximum allowable number of octets to match for are %d\n", MAX_STRING_OCTETS);
+}
+
+static void init(struct ebt_entry_match *match)
+{
+	struct ebt_string_info *info = (struct ebt_string_info *)match->data;
+
+	info->offset = 0;
+	info->length = 0;
+}
+
+static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
+   unsigned int *flags, struct ebt_entry_match **match)
+{
+	struct ebt_string_info *info = (struct ebt_string_info *)(*match)->data;
+	int i;
+	int input_string_length = 0;
+	char buf[3] = { 0 };
+
+	switch (c) {
+	case STRING_OFFSET:
+		ebt_check_option2(flags, OPT_STRING_OFFSET);
+		if (ebt_check_inverse2(optarg))
+			ebt_print_error2("Unexpected `!' after --string-offset");
+		info->offset = (__u16)strtoul(optarg, NULL, 10);
+		break;
+	case STRING_HEX:
+		ebt_check_option2(flags, OPT_STRING_HEX);
+
+		/* Don't support inversion */
+		if (ebt_check_inverse2(optarg))
+			ebt_print_error2("Unexpected `!' after --string-hex");
+
+		/* Check match string length */
+		input_string_length = strlen(optarg);
+		if (input_string_length == 0)
+			ebt_print_error2("Match string must contain at least one character");
+		if (input_string_length > MAX_STRING_OCTETS * 2)
+			ebt_print_error2("Match string exceeds %d octets", MAX_STRING_OCTETS);
+		if (input_string_length % 2 != 0)
+			ebt_print_error2("Invalid match string");
+
+		for (i = 0; i < input_string_length / 2; i++) {
+			strncpy(buf, optarg + 2 * i, 2);
+
+			/* String must be in hex format */
+			if (!isxdigit(buf[0]) || !isxdigit(buf[1]))
+				ebt_print_error2("Invalid match string");
+
+			info->string[i] = (unsigned char)strtoul(buf, NULL, 16);
+		}
+
+		info->length = i;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(const struct ebt_u_entry *entry,
+   const struct ebt_entry_match *match, const char *name,
+   unsigned int hookmask, unsigned int time)
+{
+}
+
+static void print(const struct ebt_u_entry *entry,
+   const struct ebt_entry_match *match)
+{
+	struct ebt_string_info *info = (struct ebt_string_info *)match->data;
+	char print_string[MAX_STRING_OCTETS * 2 + 1] = { 0 };
+	int i;
+
+	for (i = 0; i < info->length; i++)
+		sprintf(print_string + i * 2, "%02x", info->string[i]);
+
+	printf("--string-offset %u --string-hex %s ", info->offset, print_string);
+}
+
+static int compare(const struct ebt_entry_match *m1,
+   const struct ebt_entry_match *m2)
+{
+	struct ebt_string_info *info1 = (struct ebt_string_info *)m1->data;
+	struct ebt_string_info *info2 = (struct ebt_string_info *)m2->data;
+	int i = 0;
+
+	if (info1->offset != info2->offset)
+		return 0;
+
+	if (info1->length != info2->length)
+		return 0;
+
+	for (i = 0; i < info1->length; i++)
+	{
+		if (info1->string[i] != info2->string[i])
+			return 0;
+	}
+
+	return 1;
+}
+
+static struct ebt_u_match string_match =
+{
+	.name		= "string",
+	.size		= sizeof(struct ebt_string_info),
+	.help		= print_help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.compare	= compare,
+	.extra_ops	= opts,
+};
+
+void _init(void)
+{
+	ebt_register_match(&string_match);
+}
diff --git a/include/linux/netfilter_bridge/ebt_string.h b/include/linux/netfilter_bridge/ebt_string.h
new file mode 100644
index 0000000..ce56b30
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_string.h
@@ -0,0 +1,15 @@
+#ifndef __LINUX_BRIDGE_EBT_STRING_H
+#define __LINUX_BRIDGE_EBT_STRING_H
+
+#include <linux/types.h>
+
+#define EBT_STRING_MATCH "string"
+#define MAX_STRING_OCTETS 64
+
+struct ebt_string_info {
+	__u16 offset;
+	__u16 length;
+	unsigned char string[MAX_STRING_OCTETS + 1];
+};
+
+#endif
-- 
2.15.1

