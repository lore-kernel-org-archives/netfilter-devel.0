From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH v2 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Tue, 2 Apr 2013 12:35:39 +0200
Message-ID: <20130402103539.GF8327@imap.eitzenberger.org>
References: <20130323200402.209591997@eitzenberger.org>
 <20130323200608.668651644@eitzenberger.org>
 <20130401232947.GA12381@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762Ab3DBKfm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:35:42 -0400
Content-Disposition: inline
In-Reply-To: <20130401232947.GA12381@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

> I think we have to add O_QUEUE_CPU_FANOUT here to make sure both
> queue-balance and queue-cpu-fanout are not used both incorrectly
> together. That also needs some code a new .x6_fcheck function to
> validate this.

it is currently that --queue-cpu-fanout *requires* --queue-balance, as
the CPU fanout works on top of the balanced queues.

Or possibly I miss your point.

> Could you also send me the corresponding manpage update for this?

Sorry for lacking that.

I've respinned the 3/3 patch to include the man page update as well.
I was unsure about using bold font for referencing the --queue-balance
parameter.  Checking the man pages of other extensions it seems as if
it is done quite differently throughout.

Patch is attached to this email.

 /Holger


--Dxnq1zWXvFF0Q93v
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="iptables-NFQUEUE-cpu-fanout.diff"

NFQUEUE: add --queue-cpu-fanout parameter

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c	2013-04-02 10:00:07.000000000 +0200
+++ iptables/extensions/libxt_NFQUEUE.c	2013-04-02 10:08:32.000000000 +0200
@@ -13,8 +13,10 @@
 	O_QUEUE_NUM = 0,
 	O_QUEUE_BALANCE,
 	O_QUEUE_BYPASS,
+	O_QUEUE_CPU_FANOUT,
 	F_QUEUE_NUM     = 1 << O_QUEUE_NUM,
 	F_QUEUE_BALANCE = 1 << O_QUEUE_BALANCE,
+	F_QUEUE_CPU_FANOUT = 1 << O_QUEUE_CPU_FANOUT,
 };
 
 static void NFQUEUE_help(void)
@@ -37,7 +39,15 @@
 {
 	NFQUEUE_help_v1();
 	printf(
-"  --queue-bypass		Bypass Queueing if no queue instance exists.\n");
+"  --queue-bypass		Bypass Queueing if no queue instance exists.\n"
+"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
+}
+
+static void NFQUEUE_help_v3(void)
+{
+	NFQUEUE_help_v2();
+	printf(
+"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
 }
 
 #define s struct xt_NFQ_info
@@ -48,6 +58,8 @@
 	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
 	 .type = XTTYPE_UINT16RC, .excl = F_QUEUE_NUM},
 	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
+	{.name = "queue-cpu-fanout", .id = O_QUEUE_CPU_FANOUT,
+	 .type = XTTYPE_NONE, .also = F_QUEUE_BALANCE},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -92,6 +104,18 @@
 	}
 }
 
+static void NFQUEUE_parse_v3(struct xt_option_call *cb)
+{
+	struct xt_NFQ_info_v3 *info = cb->data;
+
+	NFQUEUE_parse_v2(cb);
+	switch (cb->entry->id) {
+	case O_QUEUE_CPU_FANOUT:
+		info->flags |= NFQ_FLAG_CPU_FANOUT;
+		break;
+	}
+}
+
 static void NFQUEUE_print(const void *ip,
                           const struct xt_entry_target *target, int numeric)
 {
@@ -120,10 +144,20 @@
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
 
 	NFQUEUE_print_v1(ip, target, numeric);
-	if (info->bypass)
+	if (info->bypass & NFQ_FLAG_BYPASS)
 		printf(" bypass");
 }
 
+static void NFQUEUE_print_v3(const void *ip,
+                             const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+
+	NFQUEUE_print_v2(ip, target, numeric);
+	if (info->flags & NFQ_FLAG_CPU_FANOUT)
+		printf(" cpu-fanout");
+}
+
 static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info *tinfo =
@@ -151,10 +185,20 @@
 
 	NFQUEUE_save_v1(ip, target);
 
-	if (info->bypass)
+	if (info->bypass & NFQ_FLAG_BYPASS)
 		printf(" --queue-bypass");
 }
 
+static void NFQUEUE_save_v3(const void *ip,
+			    const struct xt_entry_target *target)
+{
+	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+
+	NFQUEUE_save_v2(ip, target);
+	if (info->flags & NFQ_FLAG_CPU_FANOUT)
+		printf(" --queue-cpu-fanout");
+}
+
 static void NFQUEUE_init_v1(struct xt_entry_target *t)
 {
 	struct xt_NFQ_info_v1 *tinfo = (void *)t->data;
@@ -199,6 +243,19 @@
 	.save		= NFQUEUE_save_v2,
 	.x6_parse	= NFQUEUE_parse_v2,
 	.x6_options	= NFQUEUE_opts,
+},{
+	.family		= NFPROTO_UNSPEC,
+	.revision	= 3,
+	.name		= "NFQUEUE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v3)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v3)),
+	.help		= NFQUEUE_help_v3,
+	.init		= NFQUEUE_init_v1,
+	.print		= NFQUEUE_print_v3,
+	.save		= NFQUEUE_save_v3,
+	.x6_parse	= NFQUEUE_parse_v3,
+	.x6_options	= NFQUEUE_opts,
 }
 };
 
Index: iptables/include/linux/netfilter/xt_NFQUEUE.h
===================================================================
--- iptables.orig/include/linux/netfilter/xt_NFQUEUE.h	2013-04-02 10:00:07.000000000 +0200
+++ iptables/include/linux/netfilter/xt_NFQUEUE.h	2013-04-02 10:08:32.000000000 +0200
@@ -26,4 +26,13 @@
 	__u16 bypass;
 };
 
+struct xt_NFQ_info_v3 {
+	__u16 queuenum;
+	__u16 queues_total;
+	__u16 flags;
+#define NFQ_FLAG_BYPASS		0x01 /* for compatibility with v2 */
+#define NFQ_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
+#define NFQ_FLAG_MASK		0x03
+};
+
 #endif /* _XT_NFQ_TARGET_H */
Index: iptables/extensions/libxt_NFQUEUE.man
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.man	2013-04-02 12:16:09.000000000 +0200
+++ iptables/extensions/libxt_NFQUEUE.man	2013-04-02 12:19:53.000000000 +0200
@@ -23,3 +23,11 @@
 By default, if no userspace program is listening on an NFQUEUE, then all packets that are to be queued
 are dropped.  When this option is used, the NFQUEUE rule is silently bypassed instead. The packet
 will move on to the next rule.
+.PP
+.TP
+\fB\-\-queue\-cpu-fanout\fP
+When used together with \fB--queue-balance\fP this will use the CPU ID
+as an index into the NFQUEUEs.  This is a performance improvement if
+all packet handling CPUs have a corresponding NFQUEUE.
+
+Requires \fB--queue-balance\fP to be specified.

--Dxnq1zWXvFF0Q93v--
