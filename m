Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A549C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E672075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfDORAp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:45 -0400
Received: from mail.us.es ([193.147.175.20]:50452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfDORAo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 95BE11C442E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 786D1DA712
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7681EDA705; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11EB6DA71A;
        Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D3B6B4265A31;
        Mon, 15 Apr 2019 19:00:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/22] netfilter: nft_osf: Add version option support
Date:   Mon, 15 Apr 2019 19:00:19 +0200
Message-Id: <20190415170028.3470-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add version option support to the nftables "osf" expression.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_osf.h  | 11 ++++++++---
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nfnetlink_osf.c            | 14 +++++++-------
 net/netfilter/nft_osf.c                  | 30 +++++++++++++++++++++++++-----
 4 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
index c6000046c966..788613f36935 100644
--- a/include/linux/netfilter/nfnetlink_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -21,13 +21,18 @@ struct nf_osf_finger {
 	struct nf_osf_user_finger	finger;
 };
 
+struct nf_osf_data {
+	const char *genre;
+	const char *version;
+};
+
 bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 		  int hooknum, struct net_device *in, struct net_device *out,
 		  const struct nf_osf_info *info, struct net *net,
 		  const struct list_head *nf_osf_fingers);
 
-const char *nf_osf_find(const struct sk_buff *skb,
-			const struct list_head *nf_osf_fingers,
-			const int ttl_check);
+bool nf_osf_find(const struct sk_buff *skb,
+		 const struct list_head *nf_osf_fingers,
+		 const int ttl_check, struct nf_osf_data *data);
 
 #endif /* _NFOSF_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a66c8de006cc..061bb3eb20c3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1522,15 +1522,21 @@ enum nft_flowtable_hook_attributes {
  *
  * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
  */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
 	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
 	__NFTA_OSF_MAX,
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
 
+enum nft_osf_flags {
+	NFT_OSF_F_VERSION = (1 << 0),
+};
+
 /**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 1f1d90c1716b..7b827bcb412c 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -255,9 +255,9 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 }
 EXPORT_SYMBOL_GPL(nf_osf_match);
 
-const char *nf_osf_find(const struct sk_buff *skb,
-			const struct list_head *nf_osf_fingers,
-			const int ttl_check)
+bool nf_osf_find(const struct sk_buff *skb,
+		 const struct list_head *nf_osf_fingers,
+		 const int ttl_check, struct nf_osf_data *data)
 {
 	const struct iphdr *ip = ip_hdr(skb);
 	const struct nf_osf_user_finger *f;
@@ -265,24 +265,24 @@ const char *nf_osf_find(const struct sk_buff *skb,
 	const struct nf_osf_finger *kf;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
-	const char *genre = NULL;
 
 	memset(&ctx, 0, sizeof(ctx));
 
 	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
 	if (!tcp)
-		return NULL;
+		return false;
 
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 		f = &kf->finger;
 		if (!nf_osf_match_one(skb, f, ttl_check, &ctx))
 			continue;
 
-		genre = f->genre;
+		data->genre = f->genre;
+		data->version = f->version;
 		break;
 	}
 
-	return genre;
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index b13618c764ec..87b60d6617ef 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -7,11 +7,13 @@
 struct nft_osf {
 	enum nft_registers	dreg:8;
 	u8			ttl;
+	u32			flags;
 };
 
 static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
 	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
 	[NFTA_OSF_TTL]		= { .type = NLA_U8 },
+	[NFTA_OSF_FLAGS]	= { .type = NLA_U32 },
 };
 
 static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
@@ -20,9 +22,10 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nft_osf *priv = nft_expr_priv(expr);
 	u32 *dest = &regs->data[priv->dreg];
 	struct sk_buff *skb = pkt->skb;
+	char os_match[NFT_OSF_MAXGENRELEN + 1];
 	const struct tcphdr *tcp;
+	struct nf_osf_data data;
 	struct tcphdr _tcph;
-	const char *os_name;
 
 	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
 				 sizeof(struct tcphdr), &_tcph);
@@ -35,11 +38,17 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	os_name = nf_osf_find(skb, nf_osf_fingers, priv->ttl);
-	if (!os_name)
+	if (!nf_osf_find(skb, nf_osf_fingers, priv->ttl, &data)) {
 		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
-	else
-		strncpy((char *)dest, os_name, NFT_OSF_MAXGENRELEN);
+	} else {
+		if (priv->flags & NFT_OSF_F_VERSION)
+			snprintf(os_match, NFT_OSF_MAXGENRELEN, "%s:%s",
+				 data.genre, data.version);
+		else
+			strlcpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
+
+		strncpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
+	}
 }
 
 static int nft_osf_init(const struct nft_ctx *ctx,
@@ -47,6 +56,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 			const struct nlattr * const tb[])
 {
 	struct nft_osf *priv = nft_expr_priv(expr);
+	u32 flags;
 	int err;
 	u8 ttl;
 
@@ -57,6 +67,13 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 		priv->ttl = ttl;
 	}
 
+	if (tb[NFTA_OSF_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_OSF_FLAGS]));
+		if (flags != NFT_OSF_F_VERSION)
+			return -EINVAL;
+		priv->flags = flags;
+	}
+
 	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
 	err = nft_validate_register_store(ctx, priv->dreg, NULL,
 					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);
@@ -73,6 +90,9 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
 		goto nla_put_failure;
 
+	if (nla_put_be32(skb, NFTA_OSF_FLAGS, ntohl(priv->flags)))
+		goto nla_put_failure;
+
 	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
 		goto nla_put_failure;
 
-- 
2.11.0

