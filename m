From: dmitry pervushin <dpervushin@gmail.com>
Subject: Android netfilter patches (xt_IDLETIMER) [3/3]
Date: Mon, 25 Mar 2013 23:09:34 +0100
Message-ID: <5150CB1E.7050409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:33913 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484Ab3CYWJf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:09:35 -0400
Received: by mail-we0-f170.google.com with SMTP id z2so4013417wey.15
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2013 15:09:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes to iptables to use updated kernel IDLETIMER structures

Signed-off-by: dmitry pervushin <dpervushin@gmail.com>

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 21004a4..fc7a18c 100644
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
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, send_nl_msg)},
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

@@ -52,30 +56,32 @@ static void idletimer_tg_print(const void *ip,
 			       const struct xt_entry_target *target,
 			       int numeric)
 {
-	struct idletimer_tg_info *info =
-		(struct idletimer_tg_info *) target->data;
+	struct idletimer_tg_info_v1 *info =
+		(struct idletimer_tg_info_v1 *) target->data;

 	printf(" timeout:%u", info->timeout);
 	printf(" label:%s", info->label);
+	printf(" send-nl-msg:%d", info->send_nl_msg ? 1 : 0);
 }

 static void idletimer_tg_save(const void *ip,
 			      const struct xt_entry_target *target)
 {
-	struct idletimer_tg_info *info =
-		(struct idletimer_tg_info *) target->data;
+	struct idletimer_tg_info_v1 *info =
+		(struct idletimer_tg_info_v1 *) target->data;

 	printf(" --timeout %u", info->timeout);
 	printf(" --label %s", info->label);
+	printf(" --send_nl_msg %d", info->send_nl_msg ? 1 : 0);
 }

 static struct xtables_target idletimer_tg_reg = {
 	.family	       = NFPROTO_UNSPEC,
 	.name	       = "IDLETIMER",
 	.version       = XTABLES_VERSION,
-	.revision      = 0,
-	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
-	.userspacesize = offsetof(struct idletimer_tg_info, timer),
+	.revision      = 1,
+	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info_v1)),
+	.userspacesize = offsetof(struct idletimer_tg_info_v1, timer),
 	.help	       = idletimer_tg_help,
 	.x6_parse      = xtables_option_parse,
 	.print	       = idletimer_tg_print,
