From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] NFQUEUE: add new v1 version with queue-balance option
Date: Fri,  5 Jun 2009 03:17:59 +0200
Message-ID: <1244164679-11032-3-git-send-email-fw@strlen.de>
References: <1244164679-11032-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
	Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48523 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbZFEBNK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:13:10 -0400
In-Reply-To: <1244164679-11032-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

new version that adds support for specifying a queue range instead
of a single queue id.
The kernel will distribute flows across the given queue range.

This is useful for multicore systems, simply start multiple instances
of the userspace program on queues x, x+1, .. x+n and use
"--queue-balance x:x+n".
Packets belonging to the same connection are put into the same queue.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/libxt_NFQUEUE.c           |  127 +++++++++++++++++++++++++++++++++-
 extensions/libxt_NFQUEUE.man         |   10 +++
 include/linux/netfilter/xt_NFQUEUE.h |    5 ++
 3 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 6939c6f..bf75e63 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -23,19 +23,36 @@ static void NFQUEUE_help(void)
 );
 }
 
+static void NFQUEUE_help_v1(void)
+{
+	NFQUEUE_help();
+	printf(
+"  --queue-balance first:last	Balance flows between queues <value> to <value>.\n");
+}
+
 static const struct option NFQUEUE_opts[] = {
 	{ "queue-num", 1, NULL, 'F' },
 	{ .name = NULL }
 };
 
+static const struct option NFQUEUE_opts_v1[] = {
+	{ "queue-num", 1, NULL, 'F' },
+	{ "queue-balance", 1, NULL, 'B' },
+	{ .name = NULL }
+};
+
+static void exit_badqueue(const char *s)
+{
+	xtables_error(PARAMETER_PROBLEM, "Invalid queue number `%s'\n", s);
+}
+
 static void
 parse_num(const char *s, struct xt_NFQ_info *tinfo)
 {
 	unsigned int num;
 
 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid queue number `%s'\n", s);
+		exit_badqueue(s);
 
 	tinfo->queuenum = num;
 }
@@ -61,6 +78,47 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static int
+NFQUEUE_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+                 const void *entry, struct xt_entry_target **target)
+{
+	struct xt_NFQ_info_v1 *info = (void *)(*target)->data;
+	char *colon;
+	unsigned int firstqueue, lastqueue;
+
+	switch (c) {
+	case 'F': /* fallthrough */
+	case 'B':
+		if (*flags)
+			xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
+				   "Only use --queue-num ONCE!");
+
+		if (!xtables_strtoui(optarg, &colon, &firstqueue, 0, UINT16_MAX))
+			exit_badqueue(optarg);
+
+		info->queuenum = firstqueue;
+
+		if (c == 'F')
+			break;
+
+		if (*colon != ':')
+			xtables_error(PARAMETER_PROBLEM, "Bad range \"%s\"", optarg);
+
+		if (!xtables_strtoui(colon + 1, NULL, &lastqueue, 1, UINT16_MAX))
+			exit_badqueue(optarg);
+
+		if (firstqueue >= lastqueue)
+			xtables_error(PARAMETER_PROBLEM, "%u should be less than %u",
+							firstqueue, lastqueue);
+		info->queues_total = lastqueue - firstqueue + 1;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
 static void NFQUEUE_print(const void *ip,
                           const struct xt_entry_target *target, int numeric)
 {
@@ -69,6 +127,20 @@ static void NFQUEUE_print(const void *ip,
 	printf("NFQUEUE num %u", tinfo->queuenum);
 }
 
+static void NFQUEUE_print_v1(const void *ip,
+                             const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
+	unsigned int last = tinfo->queues_total;
+
+	if (last > 1) {
+		last += tinfo->queuenum - 1;
+		printf("NFQUEUE balance %u:%u", tinfo->queuenum, last);
+	} else {
+		printf("NFQUEUE num %u", tinfo->queuenum);
+	}
+}
+
 static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info *tinfo =
@@ -77,6 +149,25 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 	printf("--queue-num %u ", tinfo->queuenum);
 }
 
+static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
+	unsigned int last = tinfo->queues_total;
+
+	if (last > 1) {
+		last += tinfo->queuenum - 1;
+		printf("--queue-balance %u:%u ", tinfo->queuenum, last);
+	} else {
+		printf("--queue-num %u ", tinfo->queuenum);
+	}
+}
+
+static void NFQUEUE_init_v1(struct xt_entry_target *t)
+{
+	struct xt_NFQ_info_v1 *tinfo = (void *)t->data;
+	tinfo->queues_total = 1;
+}
+
 static struct xtables_target nfqueue_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "NFQUEUE",
@@ -90,7 +181,39 @@ static struct xtables_target nfqueue_target = {
 	.extra_opts	= NFQUEUE_opts
 };
 
+static struct xtables_target nfqueue_target4_v1 = {
+	.family		= NFPROTO_IPV4,
+	.revision	= 1,
+	.name		= "NFQUEUE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
+	.help		= NFQUEUE_help_v1,
+	.init		= NFQUEUE_init_v1,
+	.parse		= NFQUEUE_parse_v1,
+	.print		= NFQUEUE_print_v1,
+	.save		= NFQUEUE_save_v1,
+	.extra_opts	= NFQUEUE_opts_v1,
+};
+
+static struct xtables_target nfqueue_target6_v1 = {
+	.family		= NFPROTO_IPV6,
+	.revision	= 1,
+	.name		= "NFQUEUE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
+	.help		= NFQUEUE_help_v1,
+	.init		= NFQUEUE_init_v1,
+	.parse		= NFQUEUE_parse_v1,
+	.print		= NFQUEUE_print_v1,
+	.save		= NFQUEUE_save_v1,
+	.extra_opts	= NFQUEUE_opts_v1,
+};
+
 void _init(void)
 {
 	xtables_register_target(&nfqueue_target);
+	xtables_register_target(&nfqueue_target4_v1);
+	xtables_register_target(&nfqueue_target6_v1);
 }
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index b2c90bb..db01021 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -5,8 +5,18 @@ number.
 \fB\-\-queue\-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
 .PP
+.TP
+\fB\-\-queue\-balance\fP \fIvalue\fP:\fIvalue\fP
+This specifies a range of queues to use. Packets are then balanced across the given queues.
+This is useful for multicore systems: start multiple instances of the userspace program on
+queues x, x+1, .. x+n and use "--queue-balance x:x+n".
+Packets belonging to the same connection are put into the same nfqueue.
+.PP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
 .B
 nfnetlink_queue
 kernel support.
+.B
+queue-balance
+support was added in Linux 2.6.31.
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 9a9af79..ab6d62b 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -13,4 +13,9 @@ struct xt_NFQ_info {
 	u_int16_t queuenum;
 };
 
+struct xt_NFQ_info_v1 {
+	u_int16_t queuenum;
+	u_int16_t queues_total;
+};
+
 #endif /* _XT_NFQ_TARGET_H */
-- 
1.6.0.6

