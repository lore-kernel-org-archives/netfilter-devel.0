From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] libxt_NFQUEUE: add new v1 version with queue-balance option
Date: Thu, 20 Aug 2009 16:28:02 +0200
Message-ID: <1250778482-9959-1-git-send-email-fw@strlen.de>
References: <4A8D46AA.8020303@trash.net>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34716 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237AbZHTO2G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:28:06 -0400
In-Reply-To: <4A8D46AA.8020303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New version that adds support for specifying a queue range instead
of a single queue id.
The kernel will distribute flows across the given queue range.

This is useful for multicore systems, simply start multiple instances
of the userspace program on queues x, x+1, .. x+n and use
"--queue-balance x:x+n".
Packets belonging to the same connection are put into the same queue.

With fixes from Jan Engelhardt.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 changes since v1:
  - bail out on --queue-num 1<something> (i.e. do not change behaviour, v1
    did treat "--queue-num 1<something>" as "--queue-num 1")

 extensions/libxt_NFQUEUE.c           |  116 ++++++++++++++++++++++++++++++++-
 extensions/libxt_NFQUEUE.man         |   18 ++++--
 include/linux/netfilter/xt_NFQUEUE.h |    5 ++
 3 files changed, 129 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 53ecf1c..2d9d98a 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -23,21 +23,33 @@ static void NFQUEUE_help(void)
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
+	{ "queue-balance", 1, NULL, 'B' },
 	{ .name = NULL }
 };
 
+static void exit_badqueue(const char *s)
+{
+	xtables_error(PARAMETER_PROBLEM, "Invalid queue number `%s'\n", s);
+}
+
 static void
 parse_num(const char *s, struct xt_NFQ_info *tinfo)
 {
 	unsigned int num;
-       
+
 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid queue number `%s'\n", s);
+		exit_badqueue(s);
 
-    	tinfo->queuenum = num & 0xffff;
+	tinfo->queuenum = num;
 }
 
 static int
@@ -54,6 +66,53 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Only use --queue-num ONCE!");
 		parse_num(optarg, tinfo);
 		break;
+	case 'B':
+		xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
+				   "--queue-balance not supported (kernel too old?)");
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
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
+		if (c == 'F') {
+			if (*colon)
+				exit_badqueue(optarg);
+			break;
+		}
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
 	default:
 		return 0;
 	}
@@ -69,6 +128,20 @@ static void NFQUEUE_print(const void *ip,
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
@@ -77,6 +150,25 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
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
@@ -90,7 +182,23 @@ static struct xtables_target nfqueue_target = {
 	.extra_opts	= NFQUEUE_opts
 };
 
+static struct xtables_target nfqueue_target_v1 = {
+	.family		= NFPROTO_UNSPEC,
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
+	.extra_opts	= NFQUEUE_opts,
+};
+
 void _init(void)
 {
 	xtables_register_target(&nfqueue_target);
+	xtables_register_target(&nfqueue_target_v1);
 }
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index b2c90bb..59eddfc 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -1,12 +1,18 @@
 This target is an extension of the QUEUE target. As opposed to QUEUE, it allows
 you to put a packet into any specific queue, identified by its 16-bit queue
-number.  
-.TP
-\fB\-\-queue\-num\fP \fIvalue\fP
-This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
-.PP
+number.
 It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
 .B
 nfnetlink_queue
-kernel support.
+kernel support. The \fBqueue-balance\fP option was added in Linux 2.6.31.
+.TP
+\fB\-\-queue\-num\fP \fIvalue\fP
+This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
+.PP
+.TP
+\fB\-\-queue\-balance\fP \fIvalue\fP\fB:\fP\fIvalue\fP
+This specifies a range of queues to use. Packets are then balanced across the given queues.
+This is useful for multicore systems: start multiple instances of the userspace program on
+queues x, x+1, .. x+n and use "\-\-queue\-balance \fIx\fP\fB:\fP\fIx+n\fP".
+Packets belonging to the same connection are put into the same nfqueue.
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
1.6.3.3

