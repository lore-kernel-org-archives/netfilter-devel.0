From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 2/2] extensions: libxt_NFQUEUE: Unstack different versions
Date: Thu, 14 Apr 2016 20:56:49 +0530
Message-ID: <20160414152649.GA5365@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33980 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcDNP11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 11:27:27 -0400
Received: by mail-pf0-f196.google.com with SMTP id d184so7412323pfc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 08:27:26 -0700 (PDT)
Received: from shivani ([116.202.32.122])
        by smtp.gmail.com with ESMTPSA id i9sm58657608pfi.95.2016.04.14.08.27.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 14 Apr 2016 08:27:25 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the stacking of older version into the newer one by adding the
appropriate code corresponding to each version.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFQUEUE.c | 104 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 92 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 0b5becc..e8b81b6 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -30,23 +30,32 @@ static void NFQUEUE_help(void)
 
 static void NFQUEUE_help_v1(void)
 {
-	NFQUEUE_help();
 	printf(
+"NFQUEUE target options\n"
+"  --queue-num value            Send packet to QUEUE number <value>.\n"
+"                               Valid queue numbers are 0-65535\n"
 "  --queue-balance first:last	Balance flows between queues <value> to <value>.\n");
 }
 
 static void NFQUEUE_help_v2(void)
 {
-	NFQUEUE_help_v1();
 	printf(
+"NFQUEUE target options\n"
+"  --queue-num value            Send packet to QUEUE number <value>.\n"
+"                               Valid queue numbers are 0-65535\n"
+"  --queue-balance first:last   Balance flows between queues <value> to <value>.\n"
 "  --queue-bypass		Bypass Queueing if no queue instance exists.\n"
 "  --queue-cpu-fanout	Use current CPU (no hashing)\n");
 }
 
 static void NFQUEUE_help_v3(void)
 {
-	NFQUEUE_help_v2();
 	printf(
+"NFQUEUE target options\n"
+"  --queue-num value            Send packet to QUEUE number <value>.\n"
+"                               Valid queue numbers are 0-65535\n"
+"  --queue-balance first:last   Balance flows between queues <value> to <value>.\n"
+"  --queue-bypass               Bypass Queueing if no queue instance exists.\n"
 "  --queue-cpu-fanout	Use current CPU (no hashing)\n");
 }
 
@@ -95,9 +104,21 @@ static void NFQUEUE_parse_v1(struct xt_option_call *cb)
 static void NFQUEUE_parse_v2(struct xt_option_call *cb)
 {
 	struct xt_NFQ_info_v2 *info = cb->data;
+	const uint16_t *r = cb->val.u16_range;
 
-	NFQUEUE_parse_v1(cb);
+	xtables_option_parse(cb);
 	switch (cb->entry->id) {
+	case O_QUEUE_BALANCE:
+		if (cb->nvals != 2)
+			xtables_error(PARAMETER_PROBLEM,
+				"Bad range \"%s\"", cb->arg);
+		if (r[0] >= r[1])
+			xtables_error(PARAMETER_PROBLEM,
+				      "%u should be less than %u",
+				      r[0], r[1]);
+		info->queuenum = r[0];
+		info->queues_total = r[1] - r[0] + 1;
+		break;
 	case O_QUEUE_BYPASS:
 		info->bypass |= NFQ_FLAG_BYPASS;
 		break;
@@ -107,9 +128,24 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
 static void NFQUEUE_parse_v3(struct xt_option_call *cb)
 {
 	struct xt_NFQ_info_v3 *info = cb->data;
+	const uint16_t *r = cb->val.u16_range;
 
-	NFQUEUE_parse_v2(cb);
+	xtables_option_parse(cb);
 	switch (cb->entry->id) {
+	case O_QUEUE_BALANCE:
+		if (cb->nvals != 2)
+			xtables_error(PARAMETER_PROBLEM,
+				"Bad range \"%s\"", cb->arg);
+		if (r[0] >= r[1])
+			xtables_error(PARAMETER_PROBLEM,
+				      "%u should be less than %u",
+				      r[0], r[1]);
+		info->queuenum = r[0];
+		info->queues_total = r[1] - r[0] + 1;
+		break;
+	case O_QUEUE_BYPASS:
+		info->flags |= NFQ_FLAG_BYPASS;
+		break;
 	case O_QUEUE_CPU_FANOUT:
 		info->flags |= NFQ_FLAG_CPU_FANOUT;
 		break;
@@ -142,8 +178,14 @@ static void NFQUEUE_print_v2(const void *ip,
                              const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+	unsigned int last = info->queues_total;
+
+	if (last > 1) {
+		last += info->queuenum - 1;
+		printf(" NFQUEUE balance %u:%u", info->queuenum, last);
+	} else
+		printf(" NFQUEUE num %u", info->queuenum);
 
-	NFQUEUE_print_v1(ip, target, numeric);
 	if (info->bypass & NFQ_FLAG_BYPASS)
 		printf(" bypass");
 }
@@ -152,8 +194,17 @@ static void NFQUEUE_print_v3(const void *ip,
                              const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+	unsigned int last = info->queues_total;
+
+	if (last > 1) {
+		last += info->queuenum - 1;
+		printf(" NFQUEUE balance %u:%u", info->queuenum, last);
+	} else
+		printf(" NFQUEUE num %u", info->queuenum);
+
+	if (info->flags & NFQ_FLAG_BYPASS)
+		printf(" bypass");
 
-	NFQUEUE_print_v2(ip, target, numeric);
 	if (info->flags & NFQ_FLAG_CPU_FANOUT)
 		printf(" cpu-fanout");
 }
@@ -182,8 +233,13 @@ static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target
 static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+	unsigned int last = info->queues_total;
 
-	NFQUEUE_save_v1(ip, target);
+	if (last > 1) {
+		last += info->queuenum - 1;
+		printf(" --queue-balance %u:%u", info->queuenum, last);
+	} else
+		printf(" --queue-num %u", info->queuenum);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
 		printf(" --queue-bypass");
@@ -193,8 +249,17 @@ static void NFQUEUE_save_v3(const void *ip,
 			    const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+	unsigned int last = info->queues_total;
+
+	if (last > 1) {
+		last += info->queuenum - 1;
+		printf(" --queue-balance %u:%u", info->queuenum, last);
+	} else
+		printf(" --queue-num %u", info->queuenum);
+
+	if (info->flags & NFQ_FLAG_BYPASS)
+		printf(" --queue-bypass");
 
-	NFQUEUE_save_v2(ip, target);
 	if (info->flags & NFQ_FLAG_CPU_FANOUT)
 		printf(" --queue-cpu-fanout");
 }
@@ -238,8 +303,13 @@ static int NFQUEUE_xlate_v2(const void *ip,
 			    struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+	unsigned int last = info->queues_total;
 
-	NFQUEUE_xlate_v1(ip, target, xl, numeric);
+	if (last > 1) {
+		last += info->queuenum - 1;
+		xt_xlate_add(xl, "queue num %u-%u ", info->queuenum, last);
+	} else
+		xt_xlate_add(xl, "queue num %u ", info->queuenum);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
 		xt_xlate_add(xl, "bypass");
@@ -252,10 +322,20 @@ static int NFQUEUE_xlate_v3(const void *ip,
 			    struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+	unsigned int last = info->queues_total;
+
+	if (last > 1) {
+		last += info->queuenum - 1;
+		xt_xlate_add(xl, "queue num %u-%u ", info->queuenum, last);
+	} else
+		xt_xlate_add(xl, "queue num %u ", info->queuenum);
+
+	if (info->flags & NFQ_FLAG_BYPASS)
+		xt_xlate_add(xl, "bypass");
 
-	NFQUEUE_xlate_v2(ip, target, xl, numeric);
 	if (info->flags & NFQ_FLAG_CPU_FANOUT)
-		xt_xlate_add(xl, "%sfanout ", info->flags & NFQ_FLAG_BYPASS ? "," : "");
+		xt_xlate_add(xl, "%sfanout ",
+			     info->flags & NFQ_FLAG_BYPASS ? "," : "");
 
 	return 1;
 }
-- 
1.9.1

