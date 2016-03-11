From: =?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
Subject: [PATCH] extensions: libip6t_LOG: Avoid to print the default log level in the translation
Date: Fri, 11 Mar 2016 20:49:32 +0100
Message-ID: <1457725772-10913-1-git-send-email-rodanber@gmail.com>
Cc: =?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38404 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbcCKTt4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Mar 2016 14:49:56 -0500
Received: by mail-wm0-f49.google.com with SMTP id l68so30669335wml.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2016 11:49:55 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the log level when default is used

Before:
	$ sudo iptables-translate -I INPUT -j LOG
	nft add rule filter INPUT log level warning

After:
	$ sudo iptables-translate -I INPUT -j LOG
	nft add rule filter INPUT counter log
---
 extensions/libip6t_LOG.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 7841e57..3c5075e 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -194,7 +194,8 @@ static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
 		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
 
 	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
-		if (loginfo->level == ip6t_log_xlate_names[i].level) {
+		if (loginfo->level == ip6t_log_xlate_names[i].level &&
+		    loginfo->level != LOG_DEFAULT_LEVEL) {
 			xt_xlate_add(xl, "level %s",
 				   ip6t_log_xlate_names[i].name);
 			break;
-- 
2.7.2

