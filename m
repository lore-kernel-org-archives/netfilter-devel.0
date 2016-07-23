From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/25] netfilter: nft_log: check the validity of log level
Date: Sat, 23 Jul 2016 13:02:18 +0200
Message-ID: <1469271745-14523-19-git-send-email-pablo@netfilter.org>
References: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35333 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbcGWLDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:03:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 98E37E7DB1
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 813AA9EBA5
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82AC0FB467
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:19 +0200 (CEST)
In-Reply-To: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

User can specify the log level larger than 7(debug level) via
nfnetlink, this is invalid. So in this case, we should report
EINVAL to the userspace.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

