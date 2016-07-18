From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 1/2] extensions: libxt_NFLOG: display nflog-size even if it is zero
Date: Mon, 18 Jul 2016 22:14:27 +0800
Message-ID: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:43200 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbcGROPR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 10:15:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

The following iptables rules have the different semantics:
  # iptables -A INPUT -j NFLOG
  # iptables -A INPUT -j NFLOG --nflog-size 0

But they are all displayed as "-A INPUT -j NFLOG", so if
the user input the following commands, the original semantics
will be broken.
  # iptables-save | iptables-restore

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_NFLOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 8c67066..a747951 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -83,7 +83,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 	}
 	if (info->group)
 		printf(" %snflog-group %u", prefix, info->group);
-	if (info->len && info->flags & XT_NFLOG_F_COPY_LEN)
+	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		printf(" %snflog-size %u", prefix, info->len);
 	else if (info->len)
 		printf(" %snflog-range %u", prefix, info->len);
-- 
2.5.5


