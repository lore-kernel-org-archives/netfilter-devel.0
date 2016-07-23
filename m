From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/25] netfilter: nft_log: fix snaplen does not truncate packets
Date: Sat, 23 Jul 2016 13:02:19 +0200
Message-ID: <1469271745-14523-20-git-send-email-pablo@netfilter.org>
References: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35325 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbcGWLDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:03:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BC232E7DAA
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AE0F4FEFD1
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 86291FF2D6
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:20 +0200 (CEST)
In-Reply-To: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

There's a similar problem in xt_NFLOG, and was fixed by commit 7643507fe8b5
("netfilter: xt_NFLOG: nflog-range does not truncate packets"). Only set
copy_len here does not work, so we should enable NF_LOG_F_COPY_LEN also.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 5f6f088..24a73bb 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -92,6 +92,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	case NF_LOG_TYPE_ULOG:
 		li->u.ulog.group = ntohs(nla_get_be16(tb[NFTA_LOG_GROUP]));
 		if (tb[NFTA_LOG_SNAPLEN] != NULL) {
+			li->u.ulog.flags |= NF_LOG_F_COPY_LEN;
 			li->u.ulog.copy_len =
 				ntohl(nla_get_be32(tb[NFTA_LOG_SNAPLEN]));
 		}
@@ -149,7 +150,7 @@ static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		if (nla_put_be16(skb, NFTA_LOG_GROUP, htons(li->u.ulog.group)))
 			goto nla_put_failure;
 
-		if (li->u.ulog.copy_len) {
+		if (li->u.ulog.flags & NF_LOG_F_COPY_LEN) {
 			if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
 					 htonl(li->u.ulog.copy_len)))
 				goto nla_put_failure;
-- 
2.1.4

