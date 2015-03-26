From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V3 2/2] Add MARK target for arptables
Date: Thu, 26 Mar 2015 05:33:30 -0400
Message-ID: <1427362410-9255-3-git-send-email-zhangcy@cn.fujitsu.com>
References: <1427362410-9255-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>,
	Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23198 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567AbbCZKBH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 06:01:07 -0400
In-Reply-To: <1427362410-9255-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use MARK target to set make value for arp packet.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 arptables.8            |  17 ++++++
 extensions/Makefile    |   2 +-
 extensions/arpt_MARK.c | 151 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 extensions/arpt_MARK.c

diff --git a/arptables.8 b/arptables.8
index 78b2c60..676b884 100644
--- a/arptables.8
+++ b/arptables.8
@@ -315,6 +315,23 @@ sify the packet into a specific CBQ class).
 Set the major and minor  class  value.  The  values  are  always
 interpreted as hexadecimal even if no 0x prefix is given.
 
+.SS MARK
+This  module  allows you to set the skb->mark value (and thus classify
+the packet by the mark in u32)
+
+.TP
+.BR "--set-mark mark"
+Set the mark value. The  values  are  always
+interpreted as hexadecimal even if no 0x prefix is given
+
+.TP
+.BR "--and-mark mark"
+Binary AND the mark with bits.
+
+.TP
+.BR "--or-mark mark"
+Binary OR the mark with bits.
+
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH SEE ALSO
diff --git a/extensions/Makefile b/extensions/Makefile
index 09b244e..0189cc9 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=standard mangle CLASSIFY
+EXT_FUNC+=standard mangle CLASSIFY MARK
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
 
 extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
diff --git a/extensions/arpt_MARK.c b/extensions/arpt_MARK.c
new file mode 100644
index 0000000..698161e
--- /dev/null
+++ b/extensions/arpt_MARK.c
@@ -0,0 +1,151 @@
+/*
+ * (C) 2014 by Gao Feng <gaofeng@cn.fujitsu.com>
+ *
+ * arpt_MARK.c -- arptables extension to set mark for arp packet
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <stdio.h>
+#include <getopt.h>
+#include <arptables.h>
+#include <linux/netfilter/xt_mark.h>
+#include <linux/netfilter/xt_MARK.h>
+#include <linux/netfilter/x_tables.h>
+
+static void help(void)
+{
+	printf(
+"MARK target v%s options:\n"
+"--set-mark mark : set the mark value\n"
+"--and-mark value : binary AND the mark with value\n"
+"--or-mark value : binary OR the mark with value\n",
+	ARPTABLES_VERSION);
+}
+
+#define MARK_OPT 1
+#define AND_MARK_OPT 2
+#define OR_MARK_OPT 3
+
+
+static struct option opts[] = {
+	{ .name = "set-mark", .has_arg = required_argument, .flag = 0, .val = MARK_OPT },
+	{ .name = "and-mark", .has_arg = required_argument, .flag = 0, .val = AND_MARK_OPT },
+	{ .name = "or-mark", .has_arg = required_argument, .flag = 0, .val =  OR_MARK_OPT },
+	{ .name = NULL}
+};
+
+static void init(struct arpt_entry_target *t)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *) t->data;
+
+	info->mark = 0;
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct arpt_entry *e,
+	struct arpt_entry_target **t)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(*t)->data;
+	int i;
+
+	switch (c) {
+	case MARK_OPT:
+		if (sscanf(argv[optind-1], "%x", &i) != 1) {
+			exit_error(PARAMETER_PROBLEM,
+				"Bad mark value `%s'", optarg);
+			return 0;
+		}
+		info->mark = i;
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				"MARK: Can't specify --set-mark twice");
+		*flags = 1;
+		break;
+	case AND_MARK_OPT:
+		if (sscanf(argv[optind-1], "%x", &i) != 1) {
+			exit_error(PARAMETER_PROBLEM,
+				"Bad mark value `%s'", optarg);
+			return 0;
+		}
+		info->mark = 0;
+		info->mask = ~i;
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				"MARK: Can't specify --and-mark twice");
+		*flags = 1;
+		break;
+	case OR_MARK_OPT:
+		if (sscanf(argv[optind-1], "%x", &i) != 1) {
+			exit_error(PARAMETER_PROBLEM,
+				"Bad mark value `%s'", optarg);
+			return 0;
+		}
+		info->mark = info->mask = i;
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				"MARK: Can't specify --or-mark twice");
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "MARK: Parameter --set-mark/--and-mark/--or-mark is required");
+}
+
+static void print(const struct arpt_arp *ip,
+	const struct arpt_entry_target *target, int numeric)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(target->data);
+	
+	if (info->mark == 0)
+		printf("--and-mark %x", (unsigned int)(uint32_t)~info->mask);
+	else if (info->mark == info->mask)
+		printf("--or-mark %x", info->mark);
+	else
+		printf("--set-mark %x", info->mark);
+}
+
+static void save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
+{
+}
+
+static struct arptables_target mark = {
+	.next          = NULL,
+	.name          = "MARK",
+	.version       = ARPTABLES_VERSION,
+	.size          = ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+	.userspacesize = ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+	.revision      = 2,
+	.help          = help,
+	.init          = init,
+	.parse         = parse,
+	.final_check   = final_check,
+	.print         = print,
+	.save          = save,
+	.extra_opts    = opts
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+	register_target(&mark);
+}
-- 
1.7.12.4

