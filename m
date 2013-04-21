From: dmitry pervushin <dmitry.pervushin@linaro.org>
Subject: [PATCH 2/2] netfilter: idletimers, add v1 structures
Date: Sun, 21 Apr 2013 11:55:48 +0200
Message-ID: <1366538148-19759-3-git-send-email-dmitry.pervushin@linaro.org>
References: <1366538148-19759-1-git-send-email-dmitry.pervushin@linaro.org>
Cc: patches@linaro.org, dmitry pervushin <dmitry.pervushin@linaro.org>,
	Ashish Sharma <ashishsharma@google.com>,
	JP Abgrall <jpa@google.com>,
	John Stultz <john.stultz@linaro.org>,
	dmitry pervushin <dpervushin@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33146 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3DUJ4O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:56:14 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq17so2826489wib.5
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Apr 2013 02:56:13 -0700 (PDT)
In-Reply-To: <1366538148-19759-1-git-send-email-dmitry.pervushin@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add command-line options to handle --send-nl-msg

Cc: Ashish Sharma <ashishsharma@google.com>
Cc: JP Abgrall <jpa@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: dmitry pervushin <dpervushin@gmail.com>
---
 extensions/libxt_IDLETIMER.c |   44 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 21004a4..4ef7f36 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -27,14 +27,17 @@
 enum {
 	O_TIMEOUT = 0,
 	O_LABEL,
+	O_SEND_NLMSG,
 };
 
-#define s struct idletimer_tg_info
+#define s struct idletimer_tg_info_v1
 static const struct xt_option_entry idletimer_tg_opts[] = {
 	{.name = "timeout", .id = O_TIMEOUT, .type = XTTYPE_UINT32,
 	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, timeout)},
 	{.name = "label", .id = O_LABEL, .type = XTTYPE_STRING,
 	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, label)},
+	{.name = "send_nl_msg", .id = O_SEND_NLMSG, .type = XTTYPE_UINT8,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, send_nl_msg), .min = 0, .max = 1, },
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -45,6 +48,7 @@ static void idletimer_tg_help(void)
 "IDLETIMER target options:\n"
 " --timeout time	Timeout until the notification is sent (in seconds)\n"
 " --label string	Unique rule identifier\n"
+" --send_nl_msg 0|1	Send netlink message when timer expires\n"
 "\n");
 }
 
@@ -57,6 +61,11 @@ static void idletimer_tg_print(const void *ip,
 
 	printf(" timeout:%u", info->timeout);
 	printf(" label:%s", info->label);
+	if (target->u.user.revision > 0) {
+		struct idletimer_tg_info_v1 *info_v1 =
+			(struct idletimer_tg_info_v1 *) target->data;
+		printf(" send_nl_msg:%d", info_v1->send_nl_msg ? 1 : 0);
+	}
 }
 
 static void idletimer_tg_save(const void *ip,
@@ -67,9 +76,23 @@ static void idletimer_tg_save(const void *ip,
 
 	printf(" --timeout %u", info->timeout);
 	printf(" --label %s", info->label);
+	if (target->u.user.revision > 0) {
+		struct idletimer_tg_info_v1 *info_v1 =
+			(struct idletimer_tg_info_v1 *) target->data;
+		printf(" --send_nl_msg %d", info_v1->send_nl_msg ? 1 : 0);
+	}
 }
 
-static struct xtables_target idletimer_tg_reg = {
+static void idletimer_tg_init_v1(struct xt_entry_target *target)
+{
+	struct idletimer_tg_info_v1 *info =
+		(struct idletimer_tg_info_v1 *)target->data;
+
+	info->send_nl_msg = 0;
+}
+
+static struct xtables_target idletimer_tg_reg[] = { 
+{
 	.family	       = NFPROTO_UNSPEC,
 	.name	       = "IDLETIMER",
 	.version       = XTABLES_VERSION,
@@ -81,9 +104,24 @@ static struct xtables_target idletimer_tg_reg = {
 	.print	       = idletimer_tg_print,
 	.save	       = idletimer_tg_save,
 	.x6_options    = idletimer_tg_opts,
+},
+{
+	.family	       = NFPROTO_UNSPEC,
+	.name	       = "IDLETIMER",
+	.version       = XTABLES_VERSION,
+	.revision      = 1,
+	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info_v1)),
+	.userspacesize = offsetof(struct idletimer_tg_info_v1, timer),
+	.help	       = idletimer_tg_help,
+	.x6_parse      = xtables_option_parse,
+	.print	       = idletimer_tg_print,
+	.save	       = idletimer_tg_save,
+	.x6_options    = idletimer_tg_opts,
+	.init	       = idletimer_tg_init_v1,
+}
 };
 
 void _init(void)
 {
-	xtables_register_target(&idletimer_tg_reg);
+	xtables_register_targets(idletimer_tg_reg, ARRAY_SIZE(idletimer_tg_reg));
 }
-- 
1.7.10.4

