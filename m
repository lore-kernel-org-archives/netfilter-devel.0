Return-Path: <SRS0=Nn+d=TE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E86FC43219
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 May 2019 17:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BFC205C9
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 May 2019 17:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mM4NpXyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfEDRfr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 May 2019 13:35:47 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37494 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfEDRfr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 May 2019 13:35:47 -0400
Received: by mail-wm1-f41.google.com with SMTP id y5so10267130wma.2
        for <netfilter-devel@vger.kernel.org>; Sat, 04 May 2019 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=p1zD2zYIFMQZ0gvh9hRe9Vt2Cltb7u8xzvCffp0+F3k=;
        b=mM4NpXyRjLpWga+J2bXI1Fdso4+cHlnEqv9zFfCFcILZ6vyWrpl7kTgDMa5a+wHtsG
         K8vpy/ybMovuMt8ICuUaLq4KbYIpoNTtdYWDBCN030aacjdrOTZvM+xVzSCE+dt92374
         mknETMU5T0X3CCoAMb/M52jv6FFeUPFYx7r8if2g9JTRleGiSufUUgffLSvz+tX78eQ2
         8n2FJcAf581vSzmnrTQBxEqqfwl7ZmRJeE6r2AHGyTI0F9+T4ffv0E0f4KC6y5lCYuxq
         UalwcqJVcVgI/6pgW9wfEDFHqHGAsDyWlg6KoftYMp5O9SF0IfdkjOrq+ZR/XRcyUDmE
         da1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=p1zD2zYIFMQZ0gvh9hRe9Vt2Cltb7u8xzvCffp0+F3k=;
        b=QUv1JqYsR2UrPtVPsV76SvK1+3GQYrQAQxR3aa+yx6koNXRJ281h/NrYChcg1ivLQ8
         bALOwZBl2kB/fSxWwv4vwHw1LQS6/ODGtDrScA333wtsNSBCC+n2F7HMdKpol3bXk299
         rFz+jKPFg40p2H04XbR5hrW8BYNW2xZiP8k5sJ3ciSJ5EO1UCtuFcxsodstuB82uLov8
         FzVNVL5/qTifSEk8gYGoQxuAjBiVphTauq/wmPKeoFVfztiQp4r7T9cVdeTDmNZN+eia
         Wo+1LzTRlrrnxYCikwd0uR1nY4nbl43U+177vyGBNN8ratsAHAwfoj3TAWmlbh2Pdq55
         bt/A==
X-Gm-Message-State: APjAAAUHloNoeV23Ofmw1sKsgK2omyI14Ba/ZadLZIrBx37q5/kPpOB4
        8MMdKqQzp3Te/J504cNgy8ke1udt
X-Google-Smtp-Source: APXvYqx/gjD0BJe/T/Mb9UGyDcZKCbBrQTM7uHcfJeSMPYRi27tf1kFHH6azNfr3QuXAGud+4zZ+Pg==
X-Received: by 2002:a1c:2045:: with SMTP id g66mr10756833wmg.16.1556991343907;
        Sat, 04 May 2019 10:35:43 -0700 (PDT)
Received: from [10.21.222.43] (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id c63sm6063089wma.29.2019.05.04.10.35.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 10:35:43 -0700 (PDT)
From:   =?UTF-8?Q?St=c3=a9phane_Veyret?= <sveyret@gmail.com>
Subject: [PATCH] netfilter: nft_ct: add ct expectations support
To:     netfilter-devel@vger.kernel.org
Message-ID: <107c7e2d-dd8a-38d3-7386-f4ea56082edd@gmail.com>
Date:   Sat, 4 May 2019 19:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr-reforme1990
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows to add, list and delete expectations via nft objref
infrastructure and assigning these expectations via nft rule.

Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
---
include/uapi/linux/netfilter/nf_tables.h | 15 ++-
net/netfilter/nft_ct.c | 124 ++++++++++++++++++++++-
2 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h
b/include/uapi/linux/netfilter/nf_tables.h
index f0cf7b0f4f35..0a3452ca684c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -968,6 +968,7 @@ enum nft_socket_keys {
* @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
* @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
* @NFT_CT_ID: conntrack id
+ * @NFT_CT_EXPECT: connection tracking expectation
*/
enum nft_ct_keys {
NFT_CT_STATE,
@@ -995,6 +996,7 @@ enum nft_ct_keys {
NFT_CT_DST_IP6,
NFT_CT_TIMEOUT,
NFT_CT_ID,
+ NFT_CT_EXPECT,
__NFT_CT_MAX
};
#define NFT_CT_MAX (__NFT_CT_MAX - 1)
@@ -1447,6 +1449,16 @@ enum nft_ct_timeout_timeout_attributes {
};
#define NFTA_CT_TIMEOUT_MAX (__NFTA_CT_TIMEOUT_MAX - 1)
+enum nft_ct_expectation_attributes {
+ NFTA_CT_EXPECT_UNSPEC,
+ NFTA_CT_EXPECT_L3PROTO,
+ NFTA_CT_EXPECT_L4PROTO,
+ NFTA_CT_EXPECT_DPORT,
+ NFTA_CT_EXPECT_TIMEOUT,
+ __NFTA_CT_EXPECT_MAX,
+};
+#define NFTA_CT_EXPECT_MAX (__NFTA_CT_EXPECT_MAX - 1)
+
#define NFT_OBJECT_UNSPEC 0
#define NFT_OBJECT_COUNTER 1
#define NFT_OBJECT_QUOTA 2
@@ -1456,7 +1468,8 @@ enum nft_ct_timeout_timeout_attributes {
#define NFT_OBJECT_TUNNEL 6
#define NFT_OBJECT_CT_TIMEOUT 7
#define NFT_OBJECT_SECMARK 8
-#define __NFT_OBJECT_MAX 9
+#define NFT_OBJECT_CT_EXPECT 9
+#define __NFT_OBJECT_MAX 10
#define NFT_OBJECT_MAX (__NFT_OBJECT_MAX - 1)
/**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index f043936763f3..06c13b2dfb78 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,6 +24,7 @@
#include <net/netfilter/nf_conntrack_labels.h>
#include <net/netfilter/nf_conntrack_timeout.h>
#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
struct nft_ct {
enum nft_ct_keys key:8;
@@ -790,6 +791,117 @@ static struct nft_expr_type nft_notrack_type
__read_mostly = {
.owner = THIS_MODULE,
};
+struct nft_ct_expect_obj {
+ int l3num;
+ u8 l4proto;
+ __be16 dport;
+ u32 timeout;
+};
+
+static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
+ const struct nlattr * const tb[],
+ struct nft_object *obj)
+{
+ struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+ int ret;
+
+ if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
+ !tb[NFTA_CT_EXPECT_DPORT])
+ return -EINVAL;
+
+ priv->l3num = ctx->family;
+ if (tb[NFTA_CT_EXPECT_L3PROTO])
+ priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
+ priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+
+ priv->dportmin = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT_MIN]);
+
+ priv->timeout = 0;
+ if (tb[NFTA_CT_EXPECT_TIMEOUT])
+ priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
+
+ ret = nf_ct_netns_get(ctx->net, ctx->family);
+ if (ret < 0)
+ return ret;
+
+ return 0;
+}
+
+static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
+ struct nft_object *obj)
+{
+ nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_ct_expect_obj_dump(struct sk_buff *skb,
+ struct nft_object *obj, bool reset)
+{
+ const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
+ if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
+ nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
+ nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
+ nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout))
+ return -1
+
+ return 0;
+}
+
+static void nft_ct_expect_obj_eval(struct nft_object *obj,
+ struct nft_regs *regs,
+ const struct nft_pktinfo *pkt)
+{
+ const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+ enum ip_conntrack_info ctinfo;
+ struct nf_conn *ct = nf_ct_get(pkt->skb, ctinfo);
+ int dir = CTINFO2DIR(ctinfo);
+ struct nf_conntrack_expect *exp;
+
+ exp = nf_ct_expect_alloc(ct);
+ if (exp == NULL) {
+ nf_ct_helper_log(skb, ct, "cannot allocate expectation");
+ regs->verdict.code = NF_DROP;
+ return;
+ }
+
+ nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
+ &ct->tuplehash[!dir].tuple.src.u3, &ct->tuplehash[!dir].tuple.dst.u3,
+ priv->l4proto, NULL, &priv->dport);
+ if (priv->timeout)
+ exp->timeout.expires = jiffies + priv->timeout * HZ;
+
+ if (nf_ct_expect_related(exp) != 0) {
+ nf_ct_helper_log(skb, ct, "cannot add expectation");
+ regs->verdict.code = NF_DROP;
+ }
+}
+
+static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX
+ 1] = {
+ [NFTA_CT_EXPECT_L3PROTO] = {.type = NLA_U16 },
+ [NFTA_CT_EXPECT_L4PROTO] = {.type = NLA_U8 },
+ [NFTA_CT_EXPECT_DPORT] = {.type = NLA_U16 },
+ [NFTA_CT_EXPECT_TIMEOUT] = {.type = NLA_U32 },
+};
+
+static struct nft_object_type nft_ct_expect_obj_type;
+
+static const struct nft_object_ops nft_ct_expect_obj_ops = {
+ .type = &nft_ct_expect_obj_type,
+ .size = sizeof(struct nft_ct_expect_obj),
+ .eval = nft_ct_expect_obj_eval,
+ .init = nft_ct_expect_obj_init,
+ .destroy = nft_ct_expect_obj_destroy,
+ .dump = nft_ct_expect_obj_dump,
+};
+
+static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
+ .type = NFT_OBJECT_CT_EXPECT,
+ .ops = &nft_ct_expect_obj_ops,
+ .maxattr = NFTA_CT_EXPECT_MAX,
+ .policy = nft_ct_expect_policy,
+ .owner = THIS_MODULE,
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
+ err = nft_register_obj(&nft_ct_expect_obj_type);
+ if (err < 0)
+ goto err3;
#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
err = nft_register_obj(&nft_ct_timeout_obj_type);
if (err < 0)
- goto err3;
+ goto err4;
#endif
return 0;
#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+err4:
+ nft_unregister_obj(&nft_ct_expect_obj_type);
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
+ nft_unregister_obj(&nft_ct_expect_obj_type);
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

