Return-Path: <SRS0=W6An=TR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA53C04E87
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60FA32087B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEpyXjgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfEQQnD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 May 2019 12:43:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41445 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfEQQnC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 May 2019 12:43:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id g12so7542795wro.8
        for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2019 09:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K15erYzb/BZuezt9wyQJYLMx+NywtZKNwq0uk7eTfls=;
        b=MEpyXjgAFsy+EK7ldZuHE+Ao8UeyXI8vpZNDewANELRuCLqFVvbC2XnHi9QOZRPlQ0
         vdMlN7En93obVW3dswO4aQyJj3+K8j5zQK34GJoLCrw5BYoectVD8W5X8zpTHK2P+9Ot
         42CgLNA0IZVU7zERu+h72FRB5atGPSN4RWOV5/Kpym3O1QCPYAWbVlkJDUyTDqFfci/j
         XP8y2jnZ6gpnqRSPQofqlBaox4Wwb/A3Tvp1mpeVrM1OUaPzoDZa2pb72kSoS+IUz/6R
         BGMGGKQTPyBjv0r+NMWwRh+JCzuqmO9MSowHJGJapK2Ij63KkJRHq2q0PxRyRjC+h4+E
         oyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K15erYzb/BZuezt9wyQJYLMx+NywtZKNwq0uk7eTfls=;
        b=ZHHcd+78Y3wU94Pth9trrkc4W7FX72M31zxiYAw3EcZLYiGh12FW0vZgjBaN2gW209
         pAwDguSsa3t7K/6ANpZlBKxi+LVeQ57uqY/M2wYQGQgslpvPKtEdy2pzR/b+ge2UX0Xs
         0qWXKky1rao5cZCpo+TIwj08lsyvbml/U6DArf/J5h+TKHMfBb614vP4qA+wLxfsIvtQ
         dvSWyFiz+gT/H0YitLBFHXFNm19xSAElSrUxqwPwB5SLxem6q2C+gXfh+JKSpaQxVQ7V
         vZ6PyrZP+k3g07jOyEzAFDgoCbVkGmtKOAZ7ickHgQ/7GAi6BHm6i3HOnTot/XKsAODW
         nWMQ==
X-Gm-Message-State: APjAAAWmN5fsCV0GTFARuBEPhjtgx8TtSlmBN2KYvDWF0XHwYmqNjTpx
        6CsoIom9UT23y9R04+HBtgQm4ier
X-Google-Smtp-Source: APXvYqzWz1Ux6Mvxom6LlOXXzlSjalc+kPEn/4CuWGNZimQkZYYNopppkozbNlKsQzzAv1M+T/foYg==
X-Received: by 2002:adf:8189:: with SMTP id 9mr32663233wra.71.1558111379752;
        Fri, 17 May 2019 09:42:59 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id s13sm6808708wrw.17.2019.05.17.09.42.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 09:42:58 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nf-next,v3] netfilter: nft_ct: add ct expectations support
Date:   Fri, 17 May 2019 18:40:29 +0200
Message-Id: <20190517164031.8536-2-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190517164031.8536-1-sveyret@gmail.com>
References: <20190517164031.8536-1-sveyret@gmail.com>
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
 net/netfilter/nft_ct.c                   | 121 ++++++++++++++++++++++-
 2 files changed, 131 insertions(+), 3 deletions(-)

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
index f043936763f3..d01cb175ab30 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -790,6 +791,114 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
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
+		!tb[NFTA_CT_EXPECT_DPORT] ||
+		!tb[NFTA_CT_EXPECT_TIMEOUT])
+		return -EINVAL;
+
+	priv->l3num = ctx->family;
+	if (tb[NFTA_CT_EXPECT_L3PROTO])
+		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
+
+	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
+	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
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
+	exp->timeout.expires = jiffies + priv->timeout * HZ;
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
@@ -1173,17 +1282,23 @@ static int __init nft_ct_module_init(void)
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
@@ -1196,6 +1311,7 @@ static void __exit nft_ct_module_exit(void)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	nft_unregister_obj(&nft_ct_timeout_obj_type);
 #endif
+	nft_unregister_obj(&nft_ct_expect_obj_type);
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
@@ -1210,3 +1326,4 @@ MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
-- 
2.21.0

