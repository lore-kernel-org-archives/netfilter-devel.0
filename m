Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA98C606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4582064B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbfGHKdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:33:09 -0400
Received: from mail.us.es ([193.147.175.20]:34310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbfGHKcx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB50DBAE8D
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9E9C1021A4
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF2FE6DA6D; Mon,  8 Jul 2019 12:32:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6A0CD190C;
        Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 885A74265A2F;
        Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/15] netfilter: nft_meta_bridge: Add NFT_META_BRI_IIFVPROTO support
Date:   Mon,  8 Jul 2019 12:32:34 +0200
Message-Id: <20190708103237.28061-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch allows you to match on bridge vlan protocol, eg.

nft add rule bridge firewall zones counter meta ibrvproto 0x8100

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c   | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 87474920615a..0e3462dfb182 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -796,6 +796,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
+ * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -827,6 +828,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_IIFPVID,
+	NFT_META_BRI_IIFVPROTO,
 };
 
 /**
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 9487d42f657a..bed66f536b34 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -49,6 +49,17 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		nft_reg_store16(dest, p_pvid);
 		return;
 	}
+	case NFT_META_BRI_IIFVPROTO: {
+		u16 p_proto;
+
+		br_dev = nft_meta_get_bridge(in);
+		if (!br_dev || !br_vlan_enabled(br_dev))
+			goto err;
+
+		br_vlan_get_proto(br_dev, &p_proto);
+		nft_reg_store16(dest, p_proto);
+		return;
+	}
 	default:
 		goto out;
 	}
@@ -75,6 +86,7 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_BRI_IIFPVID:
+	case NFT_META_BRI_IIFVPROTO:
 		len = sizeof(u16);
 		break;
 	default:
-- 
2.11.0

