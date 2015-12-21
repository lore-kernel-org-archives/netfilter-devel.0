From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_NFQUEUE: Add translation to nft
Date: Mon, 21 Dec 2015 18:53:43 +0530
Message-ID: <20151221132342.GA2582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33222 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbLUNXt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2015 08:23:49 -0500
Received: by mail-pf0-f174.google.com with SMTP id n128so72183736pfn.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2015 05:23:49 -0800 (PST)
Received: from gmail.com ([223.176.146.232])
        by smtp.gmail.com with ESMTPSA id ah10sm39423036pad.23.2015.12.21.05.23.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 21 Dec 2015 05:23:48 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation of NF queue to nftables.

Examples:

$ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
nft add rule ip nat PREROUTING tcp dport 80 counter  queue num 30

$ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0 bypass

$ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-balance 0:3
nft add rule ip filter FORWARD counter  queue num 0-3 fanout

$ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3
nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0-3 fanout bypass

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFQUEUE.c | 90 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 15 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 0c86918..dd9056d 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -21,10 +21,9 @@ enum {
 
 static void NFQUEUE_help(void)
 {
-	printf(
-"NFQUEUE target options\n"
+	printf("NFQUEUE target options\n"
 "  --queue-num value		Send packet to QUEUE number <value>.\n"
-"  		                Valid queue numbers are 0-65535\n"
+"				Valid queue numbers are 0-65535\n"
 );
 }
 
@@ -84,8 +83,8 @@ static void NFQUEUE_parse_v1(struct xt_option_call *cb)
 			xtables_error(PARAMETER_PROBLEM,
 				"Bad range \"%s\"", cb->arg);
 		if (r[0] >= r[1])
-			xtables_error(PARAMETER_PROBLEM, "%u should be less than %u",
-				r[0], r[1]);
+			xtables_error(PARAMETER_PROBLEM,
+				      "%u should be less than %u", r[0], r[1]);
 		info->queuenum = r[0];
 		info->queues_total = r[1] - r[0] + 1;
 		break;
@@ -117,7 +116,7 @@ static void NFQUEUE_parse_v3(struct xt_option_call *cb)
 }
 
 static void NFQUEUE_print(const void *ip,
-                          const struct xt_entry_target *target, int numeric)
+			  const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)target->data;
@@ -125,7 +124,7 @@ static void NFQUEUE_print(const void *ip,
 }
 
 static void NFQUEUE_print_v1(const void *ip,
-                             const struct xt_entry_target *target, int numeric)
+			     const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
 	unsigned int last = tinfo->queues_total;
@@ -139,7 +138,7 @@ static void NFQUEUE_print_v1(const void *ip,
 }
 
 static void NFQUEUE_print_v2(const void *ip,
-                             const struct xt_entry_target *target, int numeric)
+			     const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
 
@@ -149,7 +148,7 @@ static void NFQUEUE_print_v2(const void *ip,
 }
 
 static void NFQUEUE_print_v3(const void *ip,
-                             const struct xt_entry_target *target, int numeric)
+			     const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info_v3 *info = (void *)target->data;
 
@@ -166,7 +165,8 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --queue-num %u", tinfo->queuenum);
 }
 
-static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target)
+static void
+NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
 	unsigned int last = tinfo->queues_total;
@@ -179,7 +179,8 @@ static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target
 	}
 }
 
-static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target)
+static void
+NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
 
@@ -202,9 +203,64 @@ static void NFQUEUE_save_v3(const void *ip,
 static void NFQUEUE_init_v1(struct xt_entry_target *t)
 {
 	struct xt_NFQ_info_v1 *tinfo = (void *)t->data;
+
 	tinfo->queues_total = 1;
 }
 
+static int NFQUEUE_xlate(const struct xt_entry_target *target,
+			 struct xt_buf *buf, int numeric)
+{
+	const struct xt_NFQ_info *tinfo =
+		(const struct xt_NFQ_info *)target->data;
+
+	xt_buf_add(buf, " queue num %u", tinfo->queuenum);
+
+	return 1;
+}
+
+static int NFQUEUE_xlate_v1(const struct xt_entry_target *target,
+			    struct xt_buf *buf, int numeric)
+{
+	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
+	unsigned int last = tinfo->queues_total;
+
+	if (last > 1) {
+		last += tinfo->queuenum - 1;
+		xt_buf_add(buf, " queue num %u-%u fanout",
+			   tinfo->queuenum, last);
+	} else {
+		xt_buf_add(buf, " queue num %u", tinfo->queuenum);
+	}
+
+	return 1;
+}
+
+static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
+			    struct xt_buf *buf, int numeric)
+{
+	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+
+	NFQUEUE_xlate_v1(target, buf, numeric);
+
+	if (info->bypass & NFQ_FLAG_BYPASS)
+		xt_buf_add(buf, " bypass");
+
+	return 1;
+}
+
+static int NFQUEUE_xlate_v3(const struct xt_entry_target *target,
+			    struct xt_buf *buf, int numeric)
+{
+	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+
+	NFQUEUE_xlate_v2(target, buf, numeric);
+
+	if (info->flags & NFQ_FLAG_CPU_FANOUT)
+		xt_buf_add(buf, " fanout");
+
+	return 1;
+}
+
 static struct xtables_target nfqueue_targets[] = {
 {
 	.family		= NFPROTO_UNSPEC,
@@ -216,8 +272,9 @@ static struct xtables_target nfqueue_targets[] = {
 	.print		= NFQUEUE_print,
 	.save		= NFQUEUE_save,
 	.x6_parse	= NFQUEUE_parse,
-	.x6_options	= NFQUEUE_opts
-},{
+	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate,
+}, {
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 1,
 	.name		= "NFQUEUE",
@@ -230,7 +287,8 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v1,
 	.x6_parse	= NFQUEUE_parse_v1,
 	.x6_options	= NFQUEUE_opts,
-},{
+	.xlate		= NFQUEUE_xlate_v1,
+}, {
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 2,
 	.name		= "NFQUEUE",
@@ -243,7 +301,8 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v2,
 	.x6_parse	= NFQUEUE_parse_v2,
 	.x6_options	= NFQUEUE_opts,
-},{
+	.xlate		= NFQUEUE_xlate_v2,
+}, {
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 3,
 	.name		= "NFQUEUE",
@@ -256,6 +315,7 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v3,
 	.x6_parse	= NFQUEUE_parse_v3,
 	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate_v3,
 }
 };
 
-- 
1.9.1

