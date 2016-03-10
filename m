From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libipt_LOG: Avoid to print the default log level
 in the translation
Date: Thu, 10 Mar 2016 19:15:40 +0100
Message-ID: <20160310181537.GA16699@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35472 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbcCJSPs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:15:48 -0500
Received: by mail-wm0-f42.google.com with SMTP id l68so42319320wml.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 10:15:47 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid to print the log level in the translation when the level is the
default value.

Example:

$ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 10 -j LOG
nft add rule ip filter INPUT icmp type != router-solicitation counter log

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libipt_LOG.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index f3875b6..216b1ca 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -194,7 +194,8 @@ static int LOG_xlate(const struct xt_entry_target *target,
 		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
 
 	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
-		if (loginfo->level == ipt_log_xlate_names[i].level) {
+		if (loginfo->level != LOG_DEFAULT_LEVEL &&
+		    loginfo->level == ipt_log_xlate_names[i].level) {
 			xt_xlate_add(xl, "level %s ",
 				   ipt_log_xlate_names[i].name);
 			break;
-- 
2.7.0

