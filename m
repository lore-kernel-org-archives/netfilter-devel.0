From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 2/2] netfilter: nft_log: group and qthreshold are 2^16
Date: Thu,  8 Aug 2013 19:54:31 +0200
Message-ID: <1375984471-21035-2-git-send-email-pablo@netfilter.org>
References: <1375984471-21035-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35325 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829Ab3HHRzV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:55:21 -0400
In-Reply-To: <1375984471-21035-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As defined by struct nf_loginfo.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_log.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 35a4182..65cc62f 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -39,8 +39,8 @@ static void nft_log_eval(const struct nft_expr *expr,
 static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_GROUP]	= { .type = NLA_U32 },
 	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
-	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
-	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U32 },
+	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U16 },
+	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
 };
 
 static int nft_log_init(const struct nft_ctx *ctx,
@@ -64,11 +64,14 @@ static int nft_log_init(const struct nft_ctx *ctx,
 
 	li->type = NF_LOG_TYPE_ULOG;
 	if (tb[NFTA_LOG_GROUP] != NULL)
-		li->u.ulog.group = ntohl(nla_get_be32(tb[NFTA_LOG_GROUP]));
+		li->u.ulog.group = ntohs(nla_get_be16(tb[NFTA_LOG_GROUP]));
+
 	if (tb[NFTA_LOG_SNAPLEN] != NULL)
 		li->u.ulog.copy_len = ntohl(nla_get_be32(tb[NFTA_LOG_SNAPLEN]));
-	if (tb[NFTA_LOG_QTHRESHOLD] != NULL)
-		li->u.ulog.qthreshold = ntohl(nla_get_be32(tb[NFTA_LOG_QTHRESHOLD]));
+	if (tb[NFTA_LOG_QTHRESHOLD] != NULL) {
+		li->u.ulog.qthreshold =
+			ntohs(nla_get_be16(tb[NFTA_LOG_QTHRESHOLD]));
+	}
 
 	return 0;
 }
@@ -90,15 +93,15 @@ static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		if (nla_put_string(skb, NFTA_LOG_PREFIX, priv->prefix))
 			goto nla_put_failure;
 	if (li->u.ulog.group)
-		if (nla_put_be32(skb, NFTA_LOG_GROUP, htonl(li->u.ulog.group)))
+		if (nla_put_be16(skb, NFTA_LOG_GROUP, htons(li->u.ulog.group)))
 			goto nla_put_failure;
 	if (li->u.ulog.copy_len)
 		if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
 				 htonl(li->u.ulog.copy_len)))
 			goto nla_put_failure;
 	if (li->u.ulog.qthreshold)
-		if (nla_put_be32(skb, NFTA_LOG_QTHRESHOLD,
-				 htonl(li->u.ulog.qthreshold)))
+		if (nla_put_be16(skb, NFTA_LOG_QTHRESHOLD,
+				 htons(li->u.ulog.qthreshold)))
 			goto nla_put_failure;
 	return 0;
 
-- 
1.7.10.4

