Return-Path: <SRS0=jxct=TK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35AAC04A6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 16:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A560E20881
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 16:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBzKgXHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfEJQCM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 May 2019 12:02:12 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:41169 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfEJQCM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 May 2019 12:02:12 -0400
Received: by mail-ed1-f43.google.com with SMTP id m4so5780874edd.8
        for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2019 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VLRw62zi8TNiZwBjU6FNb40MCvwtYmsCICLVhC+uQJY=;
        b=OBzKgXHdeZ+eRGzdYUy0JVfoaM36c6xc75HPpvMu11RYe6O+DILFmXTFVgI3cjnuFx
         tq1r9cr8thuBPVCIFCpq94f4Y3SzeWxRfhLF5Hp6qTofkWcI6evbaR126LT8pNs/vOjn
         JZ2o6HLaUDuMs6ETCdMBldbMg0OoTBrwnydeZB38wmpwPopg78RK1O1ufLI9J77snkiR
         88aw4vrQYYj0fHHNJQSDORN2PrYrhInyDrBlGO0Ynqx6ijy0iu7jpLeRPaUCaTKV10oa
         it8NhBh3OlxoORPTL6yTCvHVC/Bn5Nzm2vyLxmC641pCJzRUpQR541JJXAcgh0n/k7sw
         d0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLRw62zi8TNiZwBjU6FNb40MCvwtYmsCICLVhC+uQJY=;
        b=TTUwO1OkkLVZdXLpP8985T4yvbZenres6V8SLws/ckh+g1w5/8nFHs1Qyvv9OgvkvJ
         hDHu75CSYjY1M4kczaWgXs4Z02K5MBvvkn47IkPw5QCaJio6ojPe3aj0QbxbyEl8pN1z
         3OrdrcqojFCiXg28QdUK7jRFgBN1IcKO09iWN22GmFbfo/KFqdXwzjj9OCRtuJ/FYseb
         GSBCQHqxSpD+cDT589jeHCaZSQhv5P0qwfi5Q3hYZec17IcFDvjbYTwWIi1TpGa0ikWa
         Yx8559xiVwItYyjneww1tIGmtrGisV1o+mTZSqBuRknc9aQUXtlcIlIEMjGRi12ZlNF/
         7GFw==
X-Gm-Message-State: APjAAAUyhOk2ziSYcstIS7yKMRsKlxJPQLjX+TZzuefdi2vkfWH/J9CV
        AwCHg8HfvjzAxcQQAcIiUHPvsuxw
X-Google-Smtp-Source: APXvYqxJonJFy7Wwu9ihhKcgvRG7BwNkY0E0X9KtnfiuXhvhENxyivu1PkzvIB03YP70LRkuaKDeoA==
X-Received: by 2002:a50:e70b:: with SMTP id a11mr11802607edn.294.1557504129253;
        Fri, 10 May 2019 09:02:09 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id l3sm1492449edl.63.2019.05.10.09.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 09:02:07 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nf-next,v2] netfilter: nft_ct: add ct expectations support
Date:   Fri, 10 May 2019 18:00:03 +0200
Message-Id: <20190510160003.9373-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190505225114.pwpwckz2oauskkrf@salvia>
References: <20190505225114.pwpwckz2oauskkrf@salvia>
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
 include/uapi/linux/netfilter/nf_tables.h |  13 ++-
 net/netfilter/nft_ct.c                   | 124 ++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index f0cf7b0f4f35..767ecfe9ac60 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1447,6 +1447,16 @@ enum nft_ct_timeout_timeout_attributes {
 };
 #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
 
+enum nft_ct_expectation_attributes {
+	NFTA_CT_EXPECT_UNSPEC,
+	NFTA_CT_EXPECT_L3PROTO,
+	NFTA_CT_EXPECT_L4PROTO,
+	NFTA_CT_EXPECT_DPORT,
+	NFTA_CT_EXPECT_TIMEOUT,
+	__NFTA_CT_EXPECT_MAX,
+};
+#define NFTA_CT_EXPECT_MAX	(__NFTA_CT_EXPECT_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
@@ -1456,7 +1466,8 @@ enum nft_ct_timeout_timeout_attributes {
 #define NFT_OBJECT_TUNNEL	6
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
-#define __NFT_OBJECT_MAX	9
+#define NFT_OBJECT_CT_EXPECT	9
+#define __NFT_OBJECT_MAX	10
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index f043936763f3..164847c4dafe 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -790,6 +791,117 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+struct nft_ct_expect_obj {
+	int			l3num;
+	u8			l4proto;
+	__be16		dport;
+	u32			timeout;
+};
+
+static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
+				   const struct nlattr * const tb[],
+				   struct nft_object *obj)
+{
+	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	int ret;
+
+	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
+	    !tb[NFTA_CT_EXPECT_DPORT])
+		return -EINVAL;
+
+	priv->l3num = ctx->family;
+	if (tb[NFTA_CT_EXPECT_L3PROTO])
+		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
+	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+
+	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
+
+	priv->timeout = 0;
+	if (tb[NFTA_CT_EXPECT_TIMEOUT])
+		priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
+
+	ret = nf_ct_netns_get(ctx->net, ctx->family);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_ct_expect_obj_dump(struct sk_buff *skb,
+				   struct nft_object *obj, bool reset)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
+		nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
+		nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
+		nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout))
+	return -1;
+
+	return 0;
+}
+
+static void nft_ct_expect_obj_eval(struct nft_object *obj,
+				    struct nft_regs *regs,
+				    const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
+	int dir = CTINFO2DIR(ctinfo);
+	struct nf_conntrack_expect *exp;
+
+	nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	exp = nf_ct_expect_alloc(ct);
+	if (exp == NULL) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
+		&ct->tuplehash[!dir].tuple.src.u3,
+		&ct->tuplehash[!dir].tuple.dst.u3,
+		priv->l4proto, NULL, &priv->dport);
+	if (priv->timeout)
+		exp->timeout.expires = jiffies + priv->timeout * HZ;
+
+	if (nf_ct_expect_related(exp) != 0) {
+		regs->verdict.code = NF_DROP;
+	}
+}
+
+static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
+	[NFTA_CT_EXPECT_L3PROTO]	= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_L4PROTO]	= { .type = NLA_U8 },
+	[NFTA_CT_EXPECT_DPORT]		= { .type = NLA_U16 },
+	[NFTA_CT_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
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
@@ -1173,17 +1285,23 @@ static int __init nft_ct_module_init(void)
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
@@ -1196,6 +1314,7 @@ static void __exit nft_ct_module_exit(void)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	nft_unregister_obj(&nft_ct_timeout_obj_type);
 #endif
+	nft_unregister_obj(&nft_ct_expect_obj_type);
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
@@ -1210,3 +1329,4 @@ MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
-- 
2.21.0

