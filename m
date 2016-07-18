From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not truncate packets
Date: Mon, 18 Jul 2016 20:44:17 +0800
Message-ID: <1468845857-30291-4-git-send-email-zlpnobody@163.com>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:55206 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbcGRMpV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 08:45:21 -0400
In-Reply-To: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

There's a similar problem in xt_NFLOG, and was fixed by commit 7643507fe8b5
("netfilter: xt_NFLOG: nflog-range does not truncate packets"). Only set
copy_len here does not work, so we should enable NF_LOG_F_COPY_LEN also.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
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
2.5.5


