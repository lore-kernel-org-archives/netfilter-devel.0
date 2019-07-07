Return-Path: <SRS0=JlPR=VE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A239CC48BDC
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 13:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7866920659
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 13:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGGNhh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 09:37:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59348 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfGGNhg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 09:37:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A28AB4118D;
        Sun,  7 Jul 2019 21:37:30 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, nikolay@cumulusnetworks.com
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3] netfilter:nft_meta: add NFT_META_VLAN support
Date:   Sun,  7 Jul 2019 21:37:29 +0800
Message-Id: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSEtCQkJCQk9JTExCTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDI6Igw5LDg0Mg8wGTAdKTNJ
        SRAaFBdVSlVKTk1JTktNTU5LTE1PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9PQ0g3Bg++
X-HM-Tid: 0a6bcca7643b2086kuqya28ab4118d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide a meta vlan to set the vlan tag of the packet.

for q-in-q outer vlan id 20:
meta vlan set 0x88a8:20

set the default 0x8100 vlan type with vlan id 20
meta vlan set 20

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nft_meta.h         |  5 ++++-
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_meta.c                 | 27 +++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 5c69e9b..cb0f1e8 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -6,7 +6,10 @@ struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
 		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
+		struct {
+			enum nft_registers	sreg:8;
+			enum nft_registers	sreg2:8;
+		};
 	};
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a0d1dbd..699524a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -797,6 +797,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
  * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
+ * @NFT_META_VLAN: packet vlan metadata
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -829,6 +830,7 @@ enum nft_meta_keys {
 	NFT_META_OIFKIND,
 	NFT_META_BRI_IIFPVID,
 	NFT_META_BRI_IIFVPROTO,
+	NFT_META_VLAN,
 };
 
 /**
@@ -895,12 +897,14 @@ enum nft_hash_attributes {
  * @NFTA_META_DREG: destination register (NLA_U32)
  * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
  * @NFTA_META_SREG: source register (NLA_U32)
+ * @NFTA_META_SREG2: source register (NLA_U32)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
 	NFTA_META_KEY,
 	NFTA_META_SREG,
+	NFTA_META_SREG2,
 	__NFTA_META_MAX
 };
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 18a848b..901ad2e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -271,6 +271,22 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		skb->secmark = value;
 		break;
 #endif
+	case NFT_META_VLAN: {
+		u32 *sreg2 = &regs->data[meta->sreg2];
+		u16 vlan_proto;
+		u16 vlan_tci;
+
+		vlan_tci = nft_reg_load16(sreg);
+		vlan_proto = nft_reg_load16(sreg2);
+
+		if (vlan_proto != ETH_P_8021Q && vlan_proto != ETH_P_8021AD)
+			return;
+
+		skb_push_rcsum(skb, skb->mac_len);
+		skb_vlan_push(skb, htons(vlan_proto), vlan_tci & VLAN_VID_MASK);
+		skb_pull_rcsum(skb, skb->mac_len);
+		break;
+	}
 	default:
 		WARN_ON(1);
 	}
@@ -281,6 +297,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
+	[NFTA_META_SREG2]	= { .type = NLA_U32 },
 };
 EXPORT_SYMBOL_GPL(nft_meta_policy);
 
@@ -432,6 +449,13 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 	case NFT_META_PKTTYPE:
 		len = sizeof(u8);
 		break;
+	case NFT_META_VLAN:
+		len = sizeof(u16);
+		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
+		err = nft_validate_register_load(priv->sreg2, len);
+		if (err < 0)
+			return err;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -457,6 +481,9 @@ int nft_meta_get_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_META_DREG, priv->dreg))
 		goto nla_put_failure;
+	if (priv->key == NFT_META_VLAN &&
+	    nft_dump_register(skb, NFTA_META_SREG2, priv->sreg2))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
1.8.3.1

