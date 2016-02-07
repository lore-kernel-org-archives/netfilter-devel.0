From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_NFQUEUE: Add translation to nft
Date: Sun, 7 Feb 2016 11:37:21 +0530
Message-ID: <20160207060721.GA11310@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35004 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcBGGHc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2016 01:07:32 -0500
Received: by mail-pa0-f68.google.com with SMTP id y7so774543paa.2
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Feb 2016 22:07:32 -0800 (PST)
Received: from gmail.com ([171.50.30.158])
        by smtp.gmail.com with ESMTPSA id 17sm7846365pfp.96.2016.02.06.22.07.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 06 Feb 2016 22:07:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for NF queue to nftables.

Examples:

$ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30

$ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass

$ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Fix the code for queue-balance

 extensions/libxt_NFQUEUE.c | 62 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 0c86918..ea38f86 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -205,6 +205,62 @@ static void NFQUEUE_init_v1(struct xt_entry_target *t)
 	tinfo->queues_total = 1;
 }
 
+static int NFQUEUE_xlate(const struct xt_entry_target *target,
+			 struct xt_xlate *xl, int numeric)
+{
+	const struct xt_NFQ_info *tinfo =
+		(const struct xt_NFQ_info *)target->data;
+
+	xt_xlate_add(xl, "queue num %u ", tinfo->queuenum);
+
+	return 1;
+}
+
+static int NFQUEUE_xlate_v1(const struct xt_entry_target *target,
+			    struct xt_xlate *xl, int numeric)
+{
+	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
+	unsigned int last = tinfo->queues_total;
+
+	if (last > 1) {
+		last += tinfo->queuenum - 1;
+		xt_xlate_add(xl, "queue num %u-%u ", tinfo->queuenum, last);
+	} else {
+		xt_xlate_add(xl, "queue num %u ", tinfo->queuenum);
+	}
+
+	return 1;
+}
+
+bool sep_need = false;
+
+static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
+			    struct xt_xlate *xl, int numeric)
+{
+	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+
+	NFQUEUE_xlate_v1(target, xl, numeric);
+
+	if (info->bypass & NFQ_FLAG_BYPASS) {
+		xt_xlate_add(xl, "bypass");
+		sep_need = true;
+	}
+
+	return 1;
+}
+
+static int NFQUEUE_xlate_v3(const struct xt_entry_target *target,
+			    struct xt_xlate *xl, int numeric)
+{
+	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+
+	NFQUEUE_xlate_v2(target, xl, numeric);
+	if (info->flags & NFQ_FLAG_CPU_FANOUT)
+		xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
+
+	return 1;
+}
+
 static struct xtables_target nfqueue_targets[] = {
 {
 	.family		= NFPROTO_UNSPEC,
@@ -216,7 +272,8 @@ static struct xtables_target nfqueue_targets[] = {
 	.print		= NFQUEUE_print,
 	.save		= NFQUEUE_save,
 	.x6_parse	= NFQUEUE_parse,
-	.x6_options	= NFQUEUE_opts
+	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate,
 },{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 1,
@@ -230,6 +287,7 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v1,
 	.x6_parse	= NFQUEUE_parse_v1,
 	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate_v1,
 },{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 2,
@@ -243,6 +301,7 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v2,
 	.x6_parse	= NFQUEUE_parse_v2,
 	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate_v2,
 },{
 	.family		= NFPROTO_UNSPEC,
 	.revision	= 3,
@@ -256,6 +315,7 @@ static struct xtables_target nfqueue_targets[] = {
 	.save		= NFQUEUE_save_v3,
 	.x6_parse	= NFQUEUE_parse_v3,
 	.x6_options	= NFQUEUE_opts,
+	.xlate		= NFQUEUE_xlate_v3,
 }
 };
 
-- 
1.9.1

