From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/3] netfilter: nft_log: check the validity of log level
Date: Mon, 18 Jul 2016 20:44:16 +0800
Message-ID: <1468845857-30291-3-git-send-email-zlpnobody@163.com>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:54344 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbcGRMpH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 08:45:07 -0400
In-Reply-To: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

User can specify the log level larger than 7(debug level) via
nfnetlink, this is invalid. So in this case, we should report
EINVAL to the userspace.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index e1b34ff..5f6f088 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -79,6 +79,11 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		} else {
 			li->u.log.level = LOGLEVEL_WARNING;
 		}
+		if (li->u.log.level > LOGLEVEL_DEBUG) {
+			err = -EINVAL;
+			goto err1;
+		}
+
 		if (tb[NFTA_LOG_FLAGS] != NULL) {
 			li->u.log.logflags =
 				ntohl(nla_get_be32(tb[NFTA_LOG_FLAGS]));
-- 
2.5.5


