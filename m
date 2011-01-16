From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] NFQUEUE: add v2 revision with --queue-bypass option
Date: Sun, 16 Jan 2011 14:29:21 +0100
Message-ID: <1295184561-13320-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33476 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab1APNea (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:34:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--queue-bypass: if no userpace program is listening on the queue, then
allow packets to continue through the ruleset instead of dropping them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_NFQUEUE.c           |   64 ++++++++++++++++++++++++++++++---
 extensions/libxt_NFQUEUE.man         |    9 ++++-
 include/linux/netfilter/xt_NFQUEUE.h |    6 +++
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 995134e..6c44842 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -31,9 +31,17 @@ static void NFQUEUE_help_v1(void)
 "  --queue-balance first:last	Balance flows between queues <value> to <value>.\n");
 }
 
+static void NFQUEUE_help_v2(void)
+{
+	NFQUEUE_help_v1();
+	printf(
+"  --queue-bypass		Bypass Queueing if no queue instance exists.\n");
+}
+
 static const struct option NFQUEUE_opts[] = {
 	{.name = "queue-num",     .has_arg = true, .val = 'F'},
 	{.name = "queue-balance", .has_arg = true, .val = 'B'},
+	{.name = "queue-bypass",  .has_arg = false,.val = 'P'},
 	XT_GETOPT_TABLEEND,
 };
 
@@ -117,6 +125,18 @@ NFQUEUE_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static int
+NFQUEUE_parse_v2(int c, char **argv, int invert, unsigned int *flags,
+                 const void *entry, struct xt_entry_target **target)
+{
+	if (c == 'P') {
+		struct xt_NFQ_info_v2 *info = (void *)(*target)->data;
+		info->bypass = 1;
+		return 1;
+	}
+	return NFQUEUE_parse_v1(c, argv, invert, flags, entry, target);
+}
+
 static void NFQUEUE_print(const void *ip,
                           const struct xt_entry_target *target, int numeric)
 {
@@ -139,6 +159,16 @@ static void NFQUEUE_print_v1(const void *ip,
 	}
 }
 
+static void NFQUEUE_print_v2(const void *ip,
+                             const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+
+	NFQUEUE_print_v1(ip, target, numeric);
+	if (info->bypass)
+		printf(" bypass");
+}
+
 static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info *tinfo =
@@ -160,13 +190,24 @@ static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target
 	}
 }
 
+static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+
+	NFQUEUE_save_v1(ip, target);
+
+	if (info->bypass)
+		printf("--queue-bypass ");
+}
+
 static void NFQUEUE_init_v1(struct xt_entry_target *t)
 {
 	struct xt_NFQ_info_v1 *tinfo = (void *)t->data;
 	tinfo->queues_total = 1;
 }
 
-static struct xtables_target nfqueue_target = {
+static struct xtables_target nfqueue_targets[] = {
+{
 	.family		= NFPROTO_UNSPEC,
 	.name		= "NFQUEUE",
 	.version	= XTABLES_VERSION,
@@ -177,9 +218,7 @@ static struct xtables_target nfqueue_target = {
 	.print		= NFQUEUE_print,
 	.save		= NFQUEUE_save,
 	.extra_opts	= NFQUEUE_opts
-};
-
-static struct xtables_target nfqueue_target_v1 = {
+},{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 1,
 	.name		= "NFQUEUE",
@@ -192,10 +231,23 @@ static struct xtables_target nfqueue_target_v1 = {
 	.print		= NFQUEUE_print_v1,
 	.save		= NFQUEUE_save_v1,
 	.extra_opts	= NFQUEUE_opts,
+},{
+	.family		= NFPROTO_UNSPEC,
+	.revision	= 2,
+	.name		= "NFQUEUE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v2)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v2)),
+	.help		= NFQUEUE_help_v2,
+	.init		= NFQUEUE_init_v1,
+	.parse		= NFQUEUE_parse_v2,
+	.print		= NFQUEUE_print_v2,
+	.save		= NFQUEUE_save_v2,
+	.extra_opts	= NFQUEUE_opts,
+}
 };
 
 void _init(void)
 {
-	xtables_register_target(&nfqueue_target);
-	xtables_register_target(&nfqueue_target_v1);
+	xtables_register_targets(nfqueue_targets, ARRAY_SIZE(nfqueue_targets));
 }
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 59eddfc..910e386 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -5,7 +5,8 @@ It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
 .B
 nfnetlink_queue
-kernel support. The \fBqueue-balance\fP option was added in Linux 2.6.31.
+kernel support. The \fBqueue-balance\fP option was added in Linux 2.6.31,
+\fBqueue-bypass\fP in 2.6.39.
 .TP
 \fB\-\-queue\-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
@@ -16,3 +17,9 @@ This specifies a range of queues to use. Packets are then balanced across the gi
 This is useful for multicore systems: start multiple instances of the userspace program on
 queues x, x+1, .. x+n and use "\-\-queue\-balance \fIx\fP\fB:\fP\fIx+n\fP".
 Packets belonging to the same connection are put into the same nfqueue.
+.PP
+.TP
+\fB\-\-queue\-bypass\fP
+By default, if no userspace program is listening on an NFQUEUE, then all packets that are to be queued
+are dropped.  When this option is used, the NFQUEUE rule is silently bypassed instead. The packet
+will move on to the next rule.
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 2584f4a..9eafdbb 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -20,4 +20,10 @@ struct xt_NFQ_info_v1 {
 	__u16 queues_total;
 };
 
+struct xt_NFQ_info_v2 {
+	__u16 queuenum;
+	__u16 queues_total;
+	__u16 bypass;
+};
+
 #endif /* _XT_NFQ_TARGET_H */
-- 
1.7.2.2

