Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8958FC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A09F206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQ18FqeC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390954AbfEWTYk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 15:24:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55034 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390944AbfEWTYk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 15:24:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id i3so6983218wml.4
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 12:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zILOnL8E6hd66vhLhxP7ZztcwdqtbYZ3rWViBhCtWac=;
        b=aQ18FqeCZzQlD3aLujtnncODNXRNLOlCWTrJQ9bj/Gh1lCORbJAw7Oa7DDt6lcz+iq
         7Z1x1fAkuzy7UXqiWCWp88ebkN/su4P3u3oY5RS3Tmwa06w9eTrn9e38sDCyD3O4wZNr
         k3Muh5eJ2l8qvXB6LJuuGNBL/HSelgFS2I/eE81ubz81mnmeX/yojI+/mJWE+87LRweb
         DMkdDOeragrePGrIIjRUpiI1loRGZPvWtzi/vUg/7WVQqBb9D/aAJm9dyGor+wkrHx9g
         3qrBbhcgZt6NrT9GxqYbF4iGB8ggXebpxsKUxLEQ/43KkVXXKEZHinuoFx/5ztyO0lKJ
         rEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zILOnL8E6hd66vhLhxP7ZztcwdqtbYZ3rWViBhCtWac=;
        b=msZtWUXWkZwxsa58xjjaBWY58/E18PsRG/yCNqs91NAeh5A04Okzl/iq/ooEDtIdHR
         IWZUHMTCmdQkTmEB1yqSSt1K6blh/+Sj65annw0PLm5YFNuhkMzZQf0Y296zQxuRhHVT
         FFbcEWx+aTxHx4BcceFgfDoOsqBWfaQDO8N0gvWvZO5m2D7Ra/YYC9/B7U6+u7UmFHk2
         4Uwxhvnbr6IGHuQdDaPvCef+MlKK8wyK9SAF5t/DsJaDLOsnXLA79o8TjImQ7phb1zCM
         dLs2CKlAobr68QxBNu53mvWxn41MO7/C9NBsdAd8WkTEzC4VWTRBKyQMhWc7TsFd17U9
         fM/w==
X-Gm-Message-State: APjAAAWoGBaIriRF0O1jGvhQQMXYVYt9Oxz7NLS1fY/d1IaJdtCtd10N
        Dfb1c3mjWPzfsFU8lBfC7EZNY3IZ
X-Google-Smtp-Source: APXvYqzqNFGXvcKuVmxw2kxY3oz0mtzW9DHyLj7Uz42F6hIir25ZJP4QI98bMqOXQjjjxYHoz5pHdQ==
X-Received: by 2002:a1c:a695:: with SMTP id p143mr13569113wme.128.1558639478022;
        Thu, 23 May 2019 12:24:38 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id j28sm245649wrd.64.2019.05.23.12.24.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 12:24:37 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nf-next v4 1/1] netfilter: nft_ct: add ct expectations support
Date:   Thu, 23 May 2019 21:22:11 +0200
Message-Id: <20190523192211.25402-2-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523192211.25402-1-sveyret@gmail.com>
References: <20190523192211.25402-1-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows to add, list and delete expectations via nft objref
infrastructure and assigning these expectations via nft rule.

This allows manual port triggering when no helper is defined to manage a
specific protocol. For example, if I have an online game which protocol
is based on initial connection to TCP port 9753 of the server, and where
the server opens a connection to port 9876, I can set rules as follow:

table ip filter {
    ct expectation mygame {
        protocol udp;
        dport 9876;
        timeout 2m;
        size 1;
    }

    chain input {
        type filter hook input priority 0; policy drop;
        tcp dport 9753 ct expectation set "mygame";
    }

    chain output {
        type filter hook output priority 0; policy drop;
        udp dport 9876 ct status expected accept;
    }
}

Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  14 ++-
 net/netfilter/nft_ct.c                   | 145 ++++++++++++++++++++++-
 2 files changed, 156 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 505393c6e959..31a6b8f7ff73 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1445,6 +1445,17 @@ enum nft_ct_timeout_timeout_attributes {
 };
 #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
 
+enum nft_ct_expectation_attributes {
+	NFTA_CT_EXPECT_UNSPEC,
+	NFTA_CT_EXPECT_L3PROTO,
+	NFTA_CT_EXPECT_L4PROTO,
+	NFTA_CT_EXPECT_DPORT,
+	NFTA_CT_EXPECT_TIMEOUT,
+	NFTA_CT_EXPECT_SIZE,
+	__NFTA_CT_EXPECT_MAX,
+};
+#define NFTA_CT_EXPECT_MAX	(__NFTA_CT_EXPECT_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
@@ -1454,7 +1465,8 @@ enum nft_ct_timeout_timeout_attributes {
 #define NFT_OBJECT_TUNNEL	6
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
-#define __NFT_OBJECT_MAX	9
+#define NFT_OBJECT_CT_EXPECT	9
+#define __NFT_OBJECT_MAX	10
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index f043936763f3..d072d3c8e6bc 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -790,6 +791,138 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+struct nft_ct_expect_obj {
+	int		l3num;
+	u8		l4proto;
+	__be16		dport;
+	u32		timeout;
+	u8		size;
+};
+
+static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
+				  const struct nlattr * const tb[],
+				  struct nft_object *obj)
+{
+	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
+	    !tb[NFTA_CT_EXPECT_DPORT] ||
+	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
+	    !tb[NFTA_CT_EXPECT_SIZE])
+		return -EINVAL;
+
+	priv->l3num = ctx->family;
+	if (tb[NFTA_CT_EXPECT_L3PROTO])
+		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
+
+	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
+	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
+	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
+
+	return nf_ct_netns_get(ctx->net, ctx->family);
+}
+
+static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_ct_expect_obj_dump(struct sk_buff *skb,
+				  struct nft_object *obj, bool reset)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
+	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
+	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
+	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
+	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
+		return -1;
+
+	return 0;
+}
+
+static void nft_ct_expect_obj_eval(struct nft_object *obj,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	struct nf_conntrack_expect *exp;
+	enum ip_conntrack_info ctinfo;
+	int dir;
+	struct nf_conn *ct;
+	struct nf_conn_help *ct_help;
+	int l3num = priv->l3num;
+
+	/* Check ct exists and is tracked */
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_UNTRACKED) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	dir = CTINFO2DIR(ctinfo);
+
+	/* ct extention is required */
+	ct_help = nfct_help(ct);
+	if (!ct_help) {
+		ct_help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	}
+
+	/* Did we reach the limit? */
+	if (ct_help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	/* If l3num is set to INET, use the current ct proto */
+	if (l3num == NFPROTO_INET) {
+		l3num = nf_ct_l3num(ct);
+	}
+
+	/* Create expectation */
+	exp = nf_ct_expect_alloc(ct);
+	if (exp == NULL) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
+		          &ct->tuplehash[!dir].tuple.src.u3,
+		          &ct->tuplehash[!dir].tuple.dst.u3,
+		          priv->l4proto, NULL, &priv->dport);
+	exp->timeout.expires = jiffies + priv->timeout * HZ;
+	if (nf_ct_expect_related(exp) != 0)
+		regs->verdict.code = NF_DROP;
+}
+
+static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
+	[NFTA_CT_EXPECT_L3PROTO]	= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_L4PROTO]	= { .type = NLA_U8 },
+	[NFTA_CT_EXPECT_DPORT]		= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
+	[NFTA_CT_EXPECT_SIZE]		= { .type = NLA_U8 },
+};
+
+static struct nft_object_type nft_ct_expect_obj_type;
+
+static const struct nft_object_ops nft_ct_expect_obj_ops = {
+	.type		= &nft_ct_expect_obj_type,
+	.size		= sizeof(struct nft_ct_expect_obj),
+	.eval		= nft_ct_expect_obj_eval,
+	.init		= nft_ct_expect_obj_init,
+	.destroy	= nft_ct_expect_obj_destroy,
+	.dump		= nft_ct_expect_obj_dump,
+};
+
+static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
+	.type		= NFT_OBJECT_CT_EXPECT,
+	.ops		= &nft_ct_expect_obj_ops,
+	.maxattr	= NFTA_CT_EXPECT_MAX,
+	.policy		= nft_ct_expect_policy,
+	.owner		= THIS_MODULE,
+};
+
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 static int
 nft_ct_timeout_parse_policy(void *timeouts,
@@ -1173,17 +1306,23 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_helper_obj_type);
 	if (err < 0)
 		goto err2;
+
+	err = nft_register_obj(&nft_ct_expect_obj_type);
+	if (err < 0)
+		goto err3;
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	err = nft_register_obj(&nft_ct_timeout_obj_type);
 	if (err < 0)
-		goto err3;
+		goto err4;
 #endif
 	return 0;
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+err4:
+	nft_unregister_obj(&nft_ct_expect_obj_type);
+#endif
 err3:
 	nft_unregister_obj(&nft_ct_helper_obj_type);
-#endif
 err2:
 	nft_unregister_expr(&nft_notrack_type);
 err1:
@@ -1196,6 +1335,7 @@ static void __exit nft_ct_module_exit(void)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	nft_unregister_obj(&nft_ct_timeout_obj_type);
 #endif
+	nft_unregister_obj(&nft_ct_expect_obj_type);
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
@@ -1210,3 +1350,4 @@ MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
-- 
2.21.0

