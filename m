From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/3] Add MARK target for arptables
Date: Fri, 6 Feb 2015 15:26:29 +0800
Message-ID: <1423207590-13423-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21570 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbbBFH0y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2015 02:26:54 -0500
In-Reply-To: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use MARK target to set make value for
arp packet.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 extensions/Makefile    |   2 +-
 extensions/arpt_MARK.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 extensions/arpt_MARK.c

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
index 0000000..ce24bdb
--- /dev/null
+++ b/extensions/arpt_MARK.c
@@ -0,0 +1,119 @@
+/*
+ * (C) 2015 by Gao feng <gaofeng@cn.fujitsu.com>
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
+#include <linux/netfilter/x_tables.h>
+
+static void
+help(void)
+{
+	printf(
+"MARK target v%s options:\n"
+"--set-mark mark : set the mark value\n",
+	ARPTABLES_VERSION);
+}
+
+#define MARK_OPT 1
+
+static struct option opts[] = {
+	{ "set-mark"   , required_argument, 0, MARK_OPT },
+	{0}
+};
+
+static void
+init(struct arpt_entry_target *t)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *) t->data;
+
+	info->mark = 0;
+	info->mask = 0xffffffff;
+	t->u.user.revision = 2;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct arpt_entry *e,
+	struct arpt_entry_target **t)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(*t)->data;
+	int i;
+
+	switch (c) {
+		case MARK_OPT:
+			if (sscanf(argv[optind-1], "%x", &i) != 1) {
+				exit_error(PARAMETER_PROBLEM,
+						"Bad mark value `%s'", optarg);
+				return 0;
+			}
+			info->mark = i;
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM,
+						"CLASSIFY: Can't specify --set-mark twice");
+			*flags = 1;
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "MARK: Parameter --set-mark is required");
+}
+
+static void print(const struct arpt_arp *ip,
+	const struct arpt_entry_target *target, int numeric)
+{
+	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(target->data);
+
+	printf("--set-mark %x", info->mark);
+}
+
+static void
+save(const struct arpt_arp *ip, const struct arpt_entry_target *target)
+{
+}
+
+static
+struct arptables_target mark
+= { NULL,
+	"MARK",
+	ARPTABLES_VERSION,
+	ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+	ARPT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+static void _init(void) __attribute__ ((constructor));
+static void _init(void)
+{
+	register_target(&mark);
+}
-- 
2.1.0

