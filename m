Return-Path: <SRS0=V6Sm=6A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6DBC2D0EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Apr 2020 04:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9346720767
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Apr 2020 04:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="j/YmIm2U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392046AbgDPEyF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 00:54:05 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:22850 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404320AbgDPEyC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 00:54:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587012840; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=fILVz8RiWLbP5jviCBsmrA4zzbpInyddAU+6id5PQmM=; b=j/YmIm2Uy8zV1MG9J06IHUJxo5zu60l9zbkTconejaeynEx+xdit+LAtJufjuKiTPKQns6zT
 BhMprV8MJjeoUk88jsKPApqsVdIysCXXyGHGyeMHwjJIRl1P8UdR121OoMOvOCe+T/xqxptj
 P9LHoIbtwjWpAd8P57F3kJpAiTc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e97e4d8.7f397770f1f0-smtp-out-n01;
 Thu, 16 Apr 2020 04:53:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E45CC433CB; Thu, 16 Apr 2020 04:53:43 +0000 (UTC)
Received: from manojbm-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67419C433F2;
        Thu, 16 Apr 2020 04:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 67419C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=manojbm@codeaurora.org
From:   Manoj Basapathi <manojbm@codeaurora.org>
To:     netfilter-devel@vger.kernel.org
Cc:     coreteam@netfilter.org, pablo@netfilter.org,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@codeaurora.org, Manoj Basapathi <manojbm@codeaurora.org>,
        Sauvik Saha <ssaha@codeaurora.org>
Subject: [PATCH] [nf,v3] idletimer extension :  Add alarm timer option
Date:   Thu, 16 Apr 2020 10:23:29 +0530
Message-Id: <20200416045329.9573-1-manojbm@codeaurora.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce "--alarm" option for idletimer rule.
If it is present, hardidle-timer is used, else default timer.
The default idletimer starts a deferrable timer or in other
words the timer will cease to run when cpu is in suspended
state. This change introduces the option to start a
non-deferrable or alarm timer which will continue to run even
when the cpu is in suspended state.

Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
Signed-off-by: Sauvik Saha <ssaha@codeaurora.org>
---
 extensions/libxt_IDLETIMER.c           | 99 ++++++++++++++++++++++----
 extensions/libxt_IDLETIMER.t           |  2 +
 include/linux/netfilter/xt_IDLETIMER.h | 12 ++++
 3 files changed, 100 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 21004a4b..68b223f4 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -27,6 +27,7 @@
 enum {
 	O_TIMEOUT = 0,
 	O_LABEL,
+	O_ALARM,
 };
 
 #define s struct idletimer_tg_info
@@ -39,6 +40,17 @@ static const struct xt_option_entry idletimer_tg_opts[] = {
 };
 #undef s
 
+#define s struct idletimer_tg_info_v1
+static const struct xt_option_entry idletimer_tg_opts_v1[] = {
+	{.name = "timeout", .id = O_TIMEOUT, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, timeout)},
+	{.name = "label", .id = O_LABEL, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, label)},
+	{.name = "alarm", .id = O_ALARM, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+#undef s
+
 static void idletimer_tg_help(void)
 {
 	printf(
@@ -48,6 +60,16 @@ static void idletimer_tg_help(void)
 "\n");
 }
 
+static void idletimer_tg_help_v1(void)
+{
+	printf(
+"IDLETIMER target options:\n"
+" --timeout time	Timeout until the notification is sent (in seconds)\n"
+" --label string	Unique rule identifier\n"
+" --alarm none	    Use alarm instead of default timer\n"
+"\n");
+}
+
 static void idletimer_tg_print(const void *ip,
 			       const struct xt_entry_target *target,
 			       int numeric)
@@ -59,6 +81,20 @@ static void idletimer_tg_print(const void *ip,
 	printf(" label:%s", info->label);
 }
 
+static void idletimer_tg_print_v1(const void *ip,
+			       const struct xt_entry_target *target,
+			       int numeric)
+{
+	struct idletimer_tg_info_v1 *info =
+		(struct idletimer_tg_info_v1 *) target->data;
+
+	printf(" timeout:%u", info->timeout);
+	printf(" label:%s", info->label);
+	if (info->timer_type == XT_IDLETIMER_ALARM)
+		printf(" alarm");
+}
+
+
 static void idletimer_tg_save(const void *ip,
 			      const struct xt_entry_target *target)
 {
@@ -69,21 +105,58 @@ static void idletimer_tg_save(const void *ip,
 	printf(" --label %s", info->label);
 }
 
-static struct xtables_target idletimer_tg_reg = {
-	.family	       = NFPROTO_UNSPEC,
-	.name	       = "IDLETIMER",
-	.version       = XTABLES_VERSION,
-	.revision      = 0,
-	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
-	.userspacesize = offsetof(struct idletimer_tg_info, timer),
-	.help	       = idletimer_tg_help,
-	.x6_parse      = xtables_option_parse,
-	.print	       = idletimer_tg_print,
-	.save	       = idletimer_tg_save,
-	.x6_options    = idletimer_tg_opts,
+static void idletimer_tg_save_v1(const void *ip,
+			      const struct xt_entry_target *target)
+{
+	struct idletimer_tg_info_v1 *info =
+		(struct idletimer_tg_info_v1 *) target->data;
+
+	printf(" --timeout %u", info->timeout);
+	printf(" --label %s", info->label);
+	if (info->timer_type == XT_IDLETIMER_ALARM)
+		printf(" --alarm");
+}
+
+static void idletimer_tg_parse_v1(struct xt_option_call *cb)
+{
+	struct idletimer_tg_info_v1 *info = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->entry->id == O_ALARM)
+		info->timer_type = XT_IDLETIMER_ALARM;
+}
+
+static struct xtables_target idletimer_tg_reg[] = {
+	{
+		.family	       = NFPROTO_UNSPEC,
+		.name	       = "IDLETIMER",
+		.version       = XTABLES_VERSION,
+		.revision      = 0,
+		.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
+		.userspacesize = offsetof(struct idletimer_tg_info, timer),
+		.help	       = idletimer_tg_help,
+		.x6_parse      = xtables_option_parse,
+		.print	       = idletimer_tg_print,
+		.save	       = idletimer_tg_save,
+		.x6_options    = idletimer_tg_opts,
+	},
+	{
+		.family	       = NFPROTO_UNSPEC,
+		.name	       = "IDLETIMER",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info_v1)),
+		.userspacesize = offsetof(struct idletimer_tg_info_v1, timer),
+		.help	       = idletimer_tg_help_v1,
+		.x6_parse      = idletimer_tg_parse_v1,
+		.print	       = idletimer_tg_print_v1,
+		.save	       = idletimer_tg_save_v1,
+		.x6_options    = idletimer_tg_opts_v1,
+	},
+
 };
 
 void _init(void)
 {
-	xtables_register_target(&idletimer_tg_reg);
+	xtables_register_targets(idletimer_tg_reg, ARRAY_SIZE(idletimer_tg_reg));
 }
diff --git a/extensions/libxt_IDLETIMER.t b/extensions/libxt_IDLETIMER.t
index 6afd92c1..d13b119e 100644
--- a/extensions/libxt_IDLETIMER.t
+++ b/extensions/libxt_IDLETIMER.t
@@ -2,3 +2,5 @@
 -j IDLETIMER --timeout;;FAIL
 -j IDLETIMER --timeout 42;;FAIL
 -j IDLETIMER --timeout 42 --label foo;=;OK
+-j IDLETIMER --timeout 42 --label foo --alarm;;OK
+
diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
index 208ae938..49ddcdc6 100644
--- a/include/linux/netfilter/xt_IDLETIMER.h
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -32,6 +32,7 @@
 #include <linux/types.h>
 
 #define MAX_IDLETIMER_LABEL_SIZE 28
+#define XT_IDLETIMER_ALARM 0x01
 
 struct idletimer_tg_info {
 	__u32 timeout;
@@ -42,4 +43,15 @@ struct idletimer_tg_info {
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
 
+struct idletimer_tg_info_v1 {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
+	__u8 timer_type;
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute__((aligned(8)));
+};
 #endif
-- 
2.25.1
