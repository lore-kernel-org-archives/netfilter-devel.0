From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/9] netfilter: nft_log: complete logging support
Date: Mon, 23 Jun 2014 16:41:13 +0200
Message-ID: <1403534473-5178-10-git-send-email-pablo@netfilter.org>
References: <1403534473-5178-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, fw@strlen.de,
	eric.dumazet@gmail.com, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42294 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaFWOlm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:41:42 -0400
In-Reply-To: <1403534473-5178-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the unified nf_log_packet() interface that allows us explicit
logger selection through the nf_loginfo structure.

If you specify the group attribute, this means you want to receive
logging messages through nfnetlink_log. In that case, the snaplen
and qthreshold attributes allows you to tune internal aspects of
the netlink logging infrastructure.

On the other hand, if the level is specified, then the plain text
format through the kernel logging ring is used instead, which is
also used by default if neither group nor level are indicated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    4 ++
 net/netfilter/nft_log.c                  |   81 +++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2a88f64..5ce21e3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -697,6 +697,8 @@ enum nft_counter_attributes {
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
  * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_SYSLOG: syslog level (NLA_U32)
+ * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
 enum nft_log_attributes {
 	NFTA_LOG_UNSPEC,
@@ -704,6 +706,8 @@ enum nft_log_attributes {
 	NFTA_LOG_PREFIX,
 	NFTA_LOG_SNAPLEN,
 	NFTA_LOG_QTHRESHOLD,
+	NFTA_LOG_SYSLOG,
+	NFTA_LOG_FLAGS,
 	__NFTA_LOG_MAX
 };
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 10cfb15..8c07f4c 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2012-2014 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -41,6 +42,8 @@ static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_PREFIX]	= { .type = NLA_STRING },
 	[NFTA_LOG_SNAPLEN]	= { .type = NLA_U32 },
 	[NFTA_LOG_QTHRESHOLD]	= { .type = NLA_U16 },
+	[NFTA_LOG_SYSLOG]	= { .type = NLA_U32 },
+	[NFTA_LOG_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_log_init(const struct nft_ctx *ctx,
@@ -57,30 +60,56 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		if (priv->prefix == NULL)
 			return -ENOMEM;
 		nla_strlcpy(priv->prefix, nla, nla_len(nla) + 1);
-	} else
+	} else {
 		priv->prefix = (char *)nft_log_null_prefix;
+	}
 
-	li->type = NF_LOG_TYPE_ULOG;
+	li->type = NF_LOG_TYPE_LOG;
+	if (tb[NFTA_LOG_SYSLOG] != NULL &&
+	    tb[NFTA_LOG_GROUP] != NULL)
+		return -EINVAL;
 	if (tb[NFTA_LOG_GROUP] != NULL)
+		li->type = NF_LOG_TYPE_ULOG;
+
+	switch (li->type) {
+	case NF_LOG_TYPE_LOG:
+		if (tb[NFTA_LOG_SYSLOG] != NULL) {
+			li->u.log.level =
+				ntohl(nla_get_be32(tb[NFTA_LOG_SYSLOG]));;
+		} else {
+			li->u.log.level = 4;
+		}
+		if (tb[NFTA_LOG_FLAGS] != NULL) {
+			li->u.log.logflags =
+				ntohl(nla_get_be32(tb[NFTA_LOG_FLAGS]));
+		}
+		break;
+	case NF_LOG_TYPE_ULOG:
 		li->u.ulog.group = ntohs(nla_get_be16(tb[NFTA_LOG_GROUP]));
-
-	if (tb[NFTA_LOG_SNAPLEN] != NULL)
-		li->u.ulog.copy_len = ntohl(nla_get_be32(tb[NFTA_LOG_SNAPLEN]));
-	if (tb[NFTA_LOG_QTHRESHOLD] != NULL) {
-		li->u.ulog.qthreshold =
-			ntohs(nla_get_be16(tb[NFTA_LOG_QTHRESHOLD]));
+		if (tb[NFTA_LOG_SNAPLEN] != NULL) {
+			li->u.ulog.copy_len =
+				ntohl(nla_get_be32(tb[NFTA_LOG_SNAPLEN]));
+		}
+		if (tb[NFTA_LOG_QTHRESHOLD] != NULL) {
+			li->u.ulog.qthreshold =
+				ntohs(nla_get_be16(tb[NFTA_LOG_QTHRESHOLD]));
+		}
+		break;
 	}
 
-	return 0;
+	return nf_logger_find_get(ctx->afi->family, li->type);
 }
 
 static void nft_log_destroy(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr)
 {
 	struct nft_log *priv = nft_expr_priv(expr);
+	struct nf_loginfo *li = &priv->loginfo;
 
 	if (priv->prefix != nft_log_null_prefix)
 		kfree(priv->prefix);
+
+	nf_logger_put(ctx->afi->family, li->type);
 }
 
 static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -91,17 +120,33 @@ static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (priv->prefix != nft_log_null_prefix)
 		if (nla_put_string(skb, NFTA_LOG_PREFIX, priv->prefix))
 			goto nla_put_failure;
-	if (li->u.ulog.group)
-		if (nla_put_be16(skb, NFTA_LOG_GROUP, htons(li->u.ulog.group)))
+	switch (li->type) {
+	case NF_LOG_TYPE_LOG:
+		if (nla_put_be32(skb, NFTA_LOG_SYSLOG, htonl(li->u.log.level)))
 			goto nla_put_failure;
-	if (li->u.ulog.copy_len)
-		if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
-				 htonl(li->u.ulog.copy_len)))
-			goto nla_put_failure;
-	if (li->u.ulog.qthreshold)
-		if (nla_put_be16(skb, NFTA_LOG_QTHRESHOLD,
-				 htons(li->u.ulog.qthreshold)))
+
+		if (li->u.log.logflags) {
+			if (nla_put_be32(skb, NFTA_LOG_FLAGS,
+					 htonl(li->u.log.logflags)))
+				goto nla_put_failure;
+		}
+		break;
+	case NF_LOG_TYPE_ULOG:
+		if (nla_put_be16(skb, NFTA_LOG_GROUP, htons(li->u.ulog.group)))
 			goto nla_put_failure;
+
+		if (li->u.ulog.copy_len) {
+			if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
+					 htonl(li->u.ulog.copy_len)))
+				goto nla_put_failure;
+		}
+		if (li->u.ulog.qthreshold) {
+			if (nla_put_be16(skb, NFTA_LOG_QTHRESHOLD,
+					 htons(li->u.ulog.qthreshold)))
+				goto nla_put_failure;
+		}
+		break;
+	}
 	return 0;
 
 nla_put_failure:
-- 
1.7.10.4

