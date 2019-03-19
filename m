Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D85C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2DFE20651
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfCSTJv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:09:51 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35362 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfCSTJv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:09:51 -0400
Received: from localhost ([::1]:48452 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h6K7S-0007MQ-FK; Tue, 19 Mar 2019 20:09:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH 3/3] extensions: Add AUDIT target
Date:   Tue, 19 Mar 2019 20:09:38 +0100
Message-Id: <20190319190938.20751-4-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190319190938.20751-1-phil@nwl.cc>
References: <20190319190938.20751-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a barn find from Fedora package, actually spooking around in
various places in the internet. No idea who wrote it, but it seems to be
used. So add it for the time being.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am                        |   2 +-
 extensions/ebt_AUDIT.c             | 110 +++++++++++++++++++++++++++++
 include/linux/netfilter/xt_AUDIT.h |  30 ++++++++
 3 files changed, 141 insertions(+), 1 deletion(-)
 create mode 100644 extensions/ebt_AUDIT.c
 create mode 100644 include/linux/netfilter/xt_AUDIT.h

diff --git a/Makefile.am b/Makefile.am
index 53fcbadbca7b4..904de12773a84 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,7 +40,7 @@ libebtc_la_SOURCES = \
 	extensions/ebt_mark_m.c extensions/ebt_nat.c extensions/ebt_nflog.c \
 	extensions/ebt_pkttype.c extensions/ebt_redirect.c \
 	extensions/ebt_standard.c extensions/ebt_stp.c extensions/ebt_string.c \
-	extensions/ebt_ulog.c extensions/ebt_vlan.c \
+	extensions/ebt_ulog.c extensions/ebt_vlan.c extensions/ebt_AUDIT.c \
 	extensions/ebtable_broute.c extensions/ebtable_filter.c \
 	extensions/ebtable_nat.c
 # Make sure ebtables.c can be built twice
diff --git a/extensions/ebt_AUDIT.c b/extensions/ebt_AUDIT.c
new file mode 100644
index 0000000000000..c9befccca94db
--- /dev/null
+++ b/extensions/ebt_AUDIT.c
@@ -0,0 +1,110 @@
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include "../include/ebtables_u.h"
+#include <linux/netfilter/xt_AUDIT.h>
+
+#define AUDIT_TYPE  '1'
+static struct option opts[] =
+{
+	{ "audit-type" , required_argument, 0, AUDIT_TYPE },
+	{ 0 }
+};
+
+static void print_help()
+{
+	printf(
+	"AUDIT target options:\n"
+	" --audit-type TYPE          : Set action type to record.\n");
+}
+
+static void init(struct ebt_entry_target *target)
+{
+	struct xt_AUDIT_info *info = (struct xt_AUDIT_info *) target->data;
+
+	info->type = 0;
+}
+
+static int parse(int c, char **argv, int argc,
+   const struct ebt_u_entry *entry, unsigned int *flags,
+   struct ebt_entry_target **target)
+{
+	struct xt_AUDIT_info *info = (struct xt_AUDIT_info *) (*target)->data;
+
+	switch (c) {
+	case AUDIT_TYPE:
+		ebt_check_option2(flags, AUDIT_TYPE);
+
+		if (!strcasecmp(optarg, "accept"))
+			info->type = XT_AUDIT_TYPE_ACCEPT;
+		else if (!strcasecmp(optarg, "drop"))
+			info->type = XT_AUDIT_TYPE_DROP;
+		else if (!strcasecmp(optarg, "reject"))
+			info->type = XT_AUDIT_TYPE_REJECT;
+		else
+			ebt_print_error2("Bad action type value `%s'", optarg);
+
+		break;
+	 default:
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(const struct ebt_u_entry *entry,
+   const struct ebt_entry_target *target, const char *name,
+   unsigned int hookmask, unsigned int time)
+{
+}
+
+static void print(const struct ebt_u_entry *entry,
+   const struct ebt_entry_target *target)
+{
+	const struct xt_AUDIT_info *info =
+		(const struct xt_AUDIT_info *) target->data;
+
+	printf("--audit-type ");
+
+	switch(info->type) {
+	case XT_AUDIT_TYPE_ACCEPT:
+		printf("accept");
+		break;
+	case XT_AUDIT_TYPE_DROP:
+		printf("drop");
+		break;
+	case XT_AUDIT_TYPE_REJECT:
+		printf("reject");
+		break;
+	}
+}
+
+static int compare(const struct ebt_entry_target *t1,
+   const struct ebt_entry_target *t2)
+{
+	const struct xt_AUDIT_info *info1 =
+		(const struct xt_AUDIT_info *) t1->data;
+	const struct xt_AUDIT_info *info2 =
+		(const struct xt_AUDIT_info *) t2->data;
+
+	return info1->type == info2->type;
+}
+
+static struct ebt_u_target AUDIT_target =
+{
+	.name		= "AUDIT",
+	.size		= sizeof(struct xt_AUDIT_info),
+	.help		= print_help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.compare	= compare,
+	.extra_ops	= opts,
+};
+
+static void _INIT(void)
+{
+	ebt_register_target(&AUDIT_target);
+}
diff --git a/include/linux/netfilter/xt_AUDIT.h b/include/linux/netfilter/xt_AUDIT.h
new file mode 100644
index 0000000000000..44111b242b531
--- /dev/null
+++ b/include/linux/netfilter/xt_AUDIT.h
@@ -0,0 +1,30 @@
+/*
+ * Header file for iptables xt_AUDIT target
+ *
+ * (C) 2010-2011 Thomas Graf <tgraf@redhat.com>
+ * (C) 2010-2011 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _XT_AUDIT_TARGET_H
+#define _XT_AUDIT_TARGET_H
+
+#include <linux/types.h>
+
+enum {
+	XT_AUDIT_TYPE_ACCEPT = 0,
+	XT_AUDIT_TYPE_DROP,
+	XT_AUDIT_TYPE_REJECT,
+	__XT_AUDIT_TYPE_MAX,
+};
+
+#define XT_AUDIT_TYPE_MAX (__XT_AUDIT_TYPE_MAX - 1)
+
+struct xt_AUDIT_info {
+	__u8 type; /* XT_AUDIT_TYPE_* */
+};
+
+#endif /* _XT_AUDIT_TARGET_H */
-- 
2.21.0

