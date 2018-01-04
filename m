From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [xtables-addons][PATCH 2/2] build: support for Linux 4.15
Date: Thu,  4 Jan 2018 15:50:50 -0200
Message-ID: <1515088250-32295-3-git-send-email-marcelo.cerri@canonical.com>
References: <1515088250-32295-1-git-send-email-marcelo.cerri@canonical.com>
Cc: jengelh@inai.de,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58328 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbeADRvN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 12:51:13 -0500
Received: from mail-qt0-f200.google.com ([209.85.216.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1eX9fc-0005wC-RY
        for netfilter-devel@vger.kernel.org; Thu, 04 Jan 2018 17:51:12 +0000
Received: by mail-qt0-f200.google.com with SMTP id z37so1533817qtz.16
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jan 2018 09:51:12 -0800 (PST)
In-Reply-To: <1515088250-32295-1-git-send-email-marcelo.cerri@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 extensions/pknock/xt_pknock.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index 6fbdea43321c..31d4bc8c9584 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -358,10 +358,20 @@ has_logged_during_this_minute(const struct peer *peer)
  * @r: rule
  */
 static void
-peer_gc(unsigned long r)
+peer_gc(
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 15, 0)
+	struct timer_list *tl
+#else
+	unsigned long r
+#endif
+)
 {
 	unsigned int i;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 15, 0)
+	struct xt_pknock_rule *rule = from_timer(rule, tl, timer);
+#else
 	struct xt_pknock_rule *rule = (struct xt_pknock_rule *)r;
+#endif
 	struct peer *peer;
 	struct list_head *pos, *n;
 
@@ -469,9 +479,13 @@ add_rule(struct xt_pknock_mtinfo *info)
 	if (rule->peer_head == NULL)
 		goto out;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 15, 0)
+	timer_setup(&rule->timer, peer_gc, 0);
+#else
 	init_timer(&rule->timer);
 	rule->timer.function	= peer_gc;
 	rule->timer.data	= (unsigned long)rule;
+#endif
 
 	rule->status_proc = proc_create_data(info->rule_name, 0, pde,
 	                    &pknock_proc_ops, rule);
-- 
2.7.4

