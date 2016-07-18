From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 2/2] extensions: libxt_NFLOG: translate to nft log snaplen if nflog-size is specified
Date: Mon, 18 Jul 2016 22:14:28 +0800
Message-ID: <1468851268-35370-2-git-send-email-zlpnobody@163.com>
References: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:43189 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbcGROPU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 10:15:20 -0400
In-Reply-To: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

The nflog-size was introduced by commit 7070b1f3c88a ("extensions:
libxt_NFLOG: nflog-range does not truncate packets"). Then make
the nflog-range become deprecated, because it has no effect from
the beginning.

So when we do translation, nft log snaplen is translated only if the
nflog-size is specified.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_NFLOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index a747951..dad83f6 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -112,7 +112,7 @@ static void nflog_print_xlate(const struct xt_nflog_info *info,
 	xt_xlate_add(xl, "log ");
 	if (info->prefix[0] != '\0')
 		xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
-	if (info->len)
+	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
 		xt_xlate_add(xl, "queue-threshold %u ", info->threshold);
-- 
2.5.5


