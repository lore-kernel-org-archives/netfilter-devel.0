Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80219C43141
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A3C822519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfKTNTH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:07 -0500
Received: from correo.us.es ([193.147.175.20]:49318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbfKTNTG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B909130E4A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C404A7BEA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5BBD9D1911; Wed, 20 Nov 2019 14:19:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F075D1DBB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 355BD42EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 7/7] netfilter: nf_tables: add encapsulation support
Date:   Wed, 20 Nov 2019 14:18:54 +0100
Message-Id: <20191120131854.308740-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds encapsulation support through the encapsulation object,
that specifies the encapsulation policy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  42 +++++-
 net/netfilter/nft_encap.c                | 216 ++++++++++++++++++++++++++++++-
 2 files changed, 256 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 07aa6bba1548..bb0ae2daad59 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1486,7 +1486,8 @@ enum nft_ct_expectation_attributes {
 #define NFT_OBJECT_SECMARK	8
 #define NFT_OBJECT_CT_EXPECT	9
 #define NFT_OBJECT_SYNPROXY	10
-#define __NFT_OBJECT_MAX	11
+#define NFT_OBJECT_ENCAP	11
+#define __NFT_OBJECT_MAX	12
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
@@ -1633,6 +1634,45 @@ enum nft_encap_type {
 	NFT_ENCAP_VLAN	= 0,
 };
 
+enum nft_encap_op {
+	NFT_ENCAP_ADD	= 0,
+	NFT_ENCAP_UPDATE,
+	__NFT_ENCAP_MAX
+};
+#define NFT_ENCAP_MAX	(__NFT_ENCAP_MAX - 1)
+
+/**
+ * enum nft_encap_vlan_attributes - nf_tables VLAN encapsulation expression netlink attributes
+ *
+ * @NFTA_ENCAP_VLAN_ID: VLAN id (NLA_U16)
+ * @NFTA_ENCAP_VLAN_PROTO: VLAN protocol (NLA_U16)
+ * @NFTA_ENCAP_VLAN_PRIO: VLAN priority (NLA_U8)
+ */
+enum nft_encap_vlan_attributes {
+	NFTA_ENCAP_VLAN_UNSPEC,
+	NFTA_ENCAP_VLAN_ID,
+	NFTA_ENCAP_VLAN_PROTO,
+	NFTA_ENCAP_VLAN_PRIO,
+	__NFTA_ENCAP_VLAN_MAX
+};
+#define NFTA_ENCAP_VLAN_MAX	(__NFTA_ENCAP_VLAN_MAX - 1)
+
+/**
+ * enum nft_encap_attributes - nf_tables encapsulation expression netlink attributes
+ *
+ * @NFTA_ENCAP_TYPE: encapsulation type (NLA_U32)
+ * @NFTA_ENCAP_OP: encapsulation operation (NLA_U32)
+ * @NFTA_ENCAP_DATA: encapsulation data (NLA_NESTED)
+ */
+enum nft_encap_attributes {
+	NFTA_ENCAP_UNSPEC,
+	NFTA_ENCAP_TYPE,
+	NFTA_ENCAP_OP,
+	NFTA_ENCAP_DATA,
+	__NFTA_ENCAP_MAX
+};
+#define NFTA_ENCAP_MAX	(__NFTA_ENCAP_MAX - 1)
+
 /**
  * enum nft_decap_attributes - nf_tables decapsulation expression netlink attributes
  *
diff --git a/net/netfilter/nft_encap.c b/net/netfilter/nft_encap.c
index 657a62e4c283..1294b25f28ef 100644
--- a/net/netfilter/nft_encap.c
+++ b/net/netfilter/nft_encap.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/if_vlan.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -101,14 +102,227 @@ static struct nft_expr_type nft_decap_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+struct nft_encap {
+	enum nft_encap_type	type;
+
+	union {
+		struct {
+			__u16	id;
+			__be16	proto;
+			__u8	prio;
+		} vlan;
+	};
+};
+
+static u16 nft_encap_vlan_tci(struct nft_encap *priv)
+{
+	return priv->vlan.id | (priv->vlan.prio << VLAN_PRIO_SHIFT);
+}
+
+static int nft_encap_vlan_eval(struct nft_encap *priv, u8 op,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	int err;
+	u16 tci;
+
+	switch (op) {
+	case NFT_ENCAP_ADD:
+		err = skb_vlan_push(skb, priv->vlan.proto,
+				    nft_encap_vlan_tci(priv));
+		if (err)
+			return err;
+		break;
+	case NFT_ENCAP_UPDATE:
+		if (!skb_vlan_tagged(skb))
+			return -1;
+
+		err = 0;
+		if (skb_vlan_tag_present(skb)) {
+			tci = skb_vlan_tag_get(skb);
+			__vlan_hwaccel_clear_tag(skb);
+		} else {
+			err = __skb_vlan_pop(skb, &tci);
+		}
+		if (err)
+			return err;
+
+		tci = (tci & ~VLAN_VID_MASK) | priv->vlan.id;
+		if (priv->vlan.prio) {
+			tci &= ~VLAN_PRIO_MASK;
+			tci |= priv->vlan.prio << VLAN_PRIO_SHIFT;
+		}
+
+		__vlan_hwaccel_put_tag(skb, priv->vlan.proto, tci);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void nft_encap_obj_eval(struct nft_object_ref *ref,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_encap *priv = nft_obj_data(ref->obj);
+	int err;
+
+	switch (priv->type) {
+	case NFT_ENCAP_VLAN:
+		err = nft_encap_vlan_eval(priv, ref->op, regs, pkt);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -1;
+	}
+
+	if (err < 0)
+		regs->verdict.code = NFT_BREAK;
+}
+
+static const struct nla_policy nft_encap_vlan_policy[NFTA_ENCAP_VLAN_MAX + 1] = {
+	[NFTA_ENCAP_VLAN_ID]	= { .type = NLA_U16 },
+	[NFTA_ENCAP_VLAN_PROTO]	= { .type = NLA_U16 },
+	[NFTA_ENCAP_VLAN_PRIO]	= { .type = NLA_U8 },
+};
+
+static int nft_encap_vlan_parse(const struct nlattr *attr,
+				struct nft_encap *priv)
+{
+	struct nlattr *tb[NFTA_ENCAP_VLAN_MAX + 1];
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, NFTA_ENCAP_VLAN_MAX, attr,
+					  nft_encap_vlan_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_ENCAP_VLAN_PRIO] ||
+	    !tb[NFTA_ENCAP_VLAN_PROTO] ||
+	    !tb[NFTA_ENCAP_VLAN_ID])
+		return -EINVAL;
+
+	priv->vlan.id = ntohs(nla_get_be16(tb[NFTA_ENCAP_VLAN_ID]));
+	priv->vlan.proto = nla_get_be16(tb[NFTA_ENCAP_VLAN_PROTO]);
+	priv->vlan.prio = nla_get_u8(tb[NFTA_ENCAP_VLAN_PRIO]);
+
+	return 0;
+}
+
+static int nft_encap_obj_init(const struct nft_ctx *ctx,
+			      const struct nlattr * const tb[],
+			      struct nft_object *obj)
+{
+	struct nft_encap *priv = nft_obj_data(obj);
+	int err = 0;
+
+	if (!tb[NFTA_ENCAP_TYPE])
+		return -EINVAL;
+
+	priv->type = ntohl(nla_get_be32(tb[NFTA_ENCAP_TYPE]));
+
+	switch (priv->type) {
+	case NFT_ENCAP_VLAN:
+		err = nft_encap_vlan_parse(tb[NFTA_ENCAP_DATA], priv);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int nft_encap_type_dump(struct sk_buff *skb, struct nft_encap *priv)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, NFTA_ENCAP_DATA);
+	if (!nest)
+		goto nla_put_failure;
+
+	switch (priv->type) {
+	case NFT_ENCAP_VLAN:
+		if (nla_put_be16(skb, NFTA_ENCAP_VLAN_ID, htons(priv->vlan.id)) ||
+		    nla_put_be16(skb, NFTA_ENCAP_VLAN_PROTO, priv->vlan.proto) ||
+		    nla_put_u8(skb, NFTA_ENCAP_VLAN_PRIO, priv->vlan.prio))
+			goto nla_put_failure;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_encap_obj_dump(struct sk_buff *skb, struct nft_object *obj,
+			      bool reset)
+{
+	struct nft_encap *priv = nft_obj_data(obj);
+
+	if (nla_put_be32(skb, NFTA_ENCAP_TYPE, htonl(priv->type)) ||
+	    nft_encap_type_dump(skb, priv))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nla_policy nft_encap_policy[NFTA_ENCAP_MAX + 1] = {
+	[NFTA_ENCAP_TYPE]	= { .type = NLA_U32 },
+	[NFTA_ENCAP_DATA]	= { .type = NLA_NESTED },
+};
+
+static struct nft_object_type nft_encap_obj_type;
+static const struct nft_object_ops nft_encap_obj_ops = {
+	.type		= &nft_encap_obj_type,
+	.size		= sizeof(struct nft_encap),
+	.eval		= nft_encap_obj_eval,
+	.init		= nft_encap_obj_init,
+	.dump		= nft_encap_obj_dump,
+};
+
+static struct nft_object_type nft_encap_obj_type __read_mostly = {
+	.type           = NFT_OBJECT_ENCAP,
+	.ops            = &nft_encap_obj_ops,
+	.maxops		= NFT_ENCAP_MAX,
+	.maxattr        = NFTA_ENCAP_MAX,
+	.policy         = nft_encap_policy,
+	.owner          = THIS_MODULE,
+};
+
 static int __init nft_encap_netdev_module_init(void)
 {
-	return nft_register_expr(&nft_decap_type);
+	int err;
+
+	err = nft_register_obj(&nft_encap_obj_type);
+	if (err < 0)
+		return err;
+
+	err = nft_register_expr(&nft_decap_type);
+	if (err < 0)
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	nft_unregister_obj(&nft_encap_obj_type);
+	return err;
 }
 
 static void __exit nft_encap_netdev_module_exit(void)
 {
 	nft_unregister_expr(&nft_decap_type);
+	nft_unregister_obj(&nft_encap_obj_type);
 }
 
 module_init(nft_encap_netdev_module_init);
-- 
2.11.0

