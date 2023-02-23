Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71014C61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Feb 2023 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBWVEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBWVEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2023 16:04:53 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2119.outbound.protection.outlook.com [40.107.8.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4714C54A3E
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2023 13:04:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn0Pyb6N/2/xBI2HHM/mBdQUrublVTVh7gty5vyi0nH31mHAueSDeJoZc5qt7ugb7WrUYfLZPwKVw8DZ1LZP9M2OV/3Ujq7wtIZcQcrWR4JGAIDvfx+2jhg0mjODoUCORVet2f01jWQlgJf+kwInyPkfSUEPyX4bLhTPDYFmZybK/AZvVsQoMPZpweEB8eAhOsoOqbRID6P/mLT9ZqGXTYpnVOmPGozhB24YtIJww8rff3WY+okzcGRLylfVKnduxkieKC/Lx0XLtGNHqjSRQy0Dev7GAELgknwlSKEB08N63WFtVm8xRDRgjHj7g0CJhtd37jlalcJP+UR0lOndhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXbG6om90yCpHdR0YbjDKyJBYolc3j/X7fxz1BgiGHE=;
 b=eC88E9OvarQ73do1NuD9QOIYb3pjn2DREf3ZVThoYbXgfCVp5dDKpPZeAdEBaITxDGkwrkROhqRvLY0BL1ABCWFkeSntYB/DC+RCxWb/qUwTPcRn7wS+RHZ8g85Ddwb99H0xfsSXrVSwS/jwwDit1R/wMV0YpTy+0rEXpzkNi2oUy+KRY00DABKKwi3oO1whWr+jNqT3aRBzaBAIYUPRgkSFIePb0WkuMlVBjmLfDrxrbE60MR9VwcDj2cDBmzLgZQkSFLukhTXdLgDxPQ6lYwBOlR1mQL6tNbCuTGFHhnjlC0aEl3DCndWe5O9WqmonVF98eSxvcwqMC9IvXRUPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXbG6om90yCpHdR0YbjDKyJBYolc3j/X7fxz1BgiGHE=;
 b=Sqo98EbyFQ44MNyWviOj1p9DQ/T31SEUfuGRknM+AppswC56gm/AflfJjlCyDjbPnZ3atXQTcx4+Iy9pzPxhpH1Y9IFnrG5yS3jYULof42uGYERu3CV/qgTq7pEHf87QkJRu1zDAFd5zFO3Zp7XrtWzGDVDbxk/wYFsciZ7mdyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DB4P189MB2287.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 21:04:46 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 21:04:46 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH nf-next] netfilter: bridge: introduce broute meta statement
Date:   Thu, 23 Feb 2023 21:22:46 +0100
Message-Id: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::27) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DB4P189MB2287:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d9dba34-73e3-4883-a59b-08db15e197b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smZIjDSLHLgeGQT1IyiMqvhi0uB6OhYx7F7dJdlHi7KTfWFUhsyXGNio+nIUYnIn4MYtxaIwgjE6amihsLyH+P5LrS+oe+JdOYXbSsN0TBotoTfdlsFzTazkj44sRwSd/8SlIggcz5TslpE83dONfOaSMBM+5Z/xgXhPv1C6b+WeALEQMi0CGDHYp9t5/FMLsIsu+luJVAgrXY/gcKvGZDCHKcqC4pQMB5/pC6n3oPQk6tdxqEHm0RKPzuYU6KmE+UzvI+T6/c0NsuVyumY8ZzVCR9f5ImAkaROaG+FHTcfM5OnRFTKwtbatc5Qjx5QfWqTYbjAoF9CTWlmez5cFRyQgRPzVyMmC8+CpHXMdo6ixoShCMzZBsJTm+QFGLL4EJxAFrzJyz1hiBi7Zc4q233/XwhOOyxKgsqTtZ4R1mls4oGo2Q4oKUySOU4SIIAHb39+f7hgpE0YTIwFFwk8sdxjRM/QsEumxxonHiN50r1EwwJK+Azdtyu5zWLkhghZ6aQidmnZ3MMH65EVnOF2H3TcVmwis9ljRAXvR2AAmTPCsZxP3z2ua7e00hmBgK5DsC2VpRIjcqeGuS2S7BoSqPR0gkpNcPv5yXYVnG3HbWT3Y7WsHxvx5qVXKhD3jmt44DMEWLEe9Qky7vcF3qHnC+Qd2VHcf2gct7zgfTHJacQ2PbesOXwg8RSsBxdozVPylNgIVnr2IDxkrKSGCwpR9393OmNxDttEZXF93RlWMYIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(396003)(39830400003)(376002)(346002)(136003)(451199018)(36756003)(86362001)(38100700002)(70586007)(8676002)(66946007)(1076003)(186003)(66556008)(6506007)(66476007)(2906002)(41300700001)(6916009)(6512007)(6486002)(478600001)(316002)(2616005)(4326008)(83380400001)(26005)(54906003)(44832011)(5660300002)(8936002)(37730700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/BxqtmkjehMveC0LitlcXZZw/MMHw/tRBlTzRwuzUQo6cydZJhxP+udd7HoH?=
 =?us-ascii?Q?k+tI6+PPmotIQY74DHm3r1eB1kcUOZHOixsR1kky1aYGDmyEjQiYCuesy7xf?=
 =?us-ascii?Q?IIpEYsCSENvlYp3qhECAGid7FjCcz60oHqGosTZDGCxwgvSfXuyehaNwZ7CO?=
 =?us-ascii?Q?kGTiDMPgbVlP4ZXLqgCZmJZ60J4Bb6UsoixEtzlga5gmzCWqxEHzIKIdzBbf?=
 =?us-ascii?Q?rwDsR+ojTHBSInZBSghbbNgEpZsjqwi2t53Wu+eN+tGU4LAN2fIqqFiNrBhH?=
 =?us-ascii?Q?15ZcuQyDL0/6QqT4r/uEGmb0rvicpgIA1c+JoXWNSrD/djUi02W2esWZ0pCN?=
 =?us-ascii?Q?1ePh2AEc9CFH7gyiSd8Pa+qX25r0nIV5VqEbCd+GDSN9GoePABmED8HVK0vh?=
 =?us-ascii?Q?ZPxHk0tCSoGjpnjlYzx5dleyTUQomh9MwCPrZ+H7z4rA37GuI7VZ24mvJywY?=
 =?us-ascii?Q?t8kmADlJgnnx2e/2BYi7m1+s4yTLwJXdV0dF63vTvGTTTkwA+qCZBn5LKYZy?=
 =?us-ascii?Q?Ob6d7vHCOCIDtRPaHykkEQ0lwxzD54j4YnOA7gkMmsM4CoS8NdLMQMtKA8Kr?=
 =?us-ascii?Q?4oj8rZeY/tVRis6Tw/cb2TG/gRqhBTb4eOl+kGbK20P22FRYmJ5W6OPko794?=
 =?us-ascii?Q?opYj3Syl8+K7SyC/2vGpmqwCYoZn8jr6my5mjtTqJ96TimJ8NNMGQv3wetEL?=
 =?us-ascii?Q?w3OupeXdUqXM5i3Wxp3S7etrRTid408TIt4nPl/UyE9ahM7Iy+oJTtFGDwwg?=
 =?us-ascii?Q?GTEvGINgUYhoJrd5kkL2L3D+okPTK1iI/td68Pg/Hnsa4R1jTVCGfj8k23dx?=
 =?us-ascii?Q?AuSv749AE7c/hkW13wZdu5onBMjsEiYL2F34TJsgFYzTH7JWR58bNFlflGpS?=
 =?us-ascii?Q?iSky13bNqHQj752Uc2oB+rOk514yXHFk1RVJDyLPBVODUYBplDK8WE9d2z3L?=
 =?us-ascii?Q?gnLCyh5mlmx08+cs8ztpkRVUNBIjZp/ZtzDEEE9EDwO2AGXbfHhLQqxDnuTl?=
 =?us-ascii?Q?m/42yMfkjiwl5APtSphT66PRGLssg6BTRDbfAuGTZ7nA+pu8h71vrmrm5Thh?=
 =?us-ascii?Q?pB9OcPWg+ql52XZ0UuUUaF1FctmbYVRWmbPvKsRI+W3sAL8pQrm7jseDjz1W?=
 =?us-ascii?Q?yanuCPWN2T/2VDFrW7w3RSdk5gc2HaMfqlG7y284u0nimc4wyTPvXe69zIKB?=
 =?us-ascii?Q?OKlydzCtPp1vX9nTl++Ur4YHmyIBewz254H3KSvk7X9DrDYY5IiwUMVXFxWI?=
 =?us-ascii?Q?bcKHDFh84EkpprWwoovBPKLF4Mfgs+lShRq7ks7owKzD+Ve2aMeqcCnVZHjN?=
 =?us-ascii?Q?M/lCWeMf3gGTd2y0lxljW5atAG/1/ZBL8G3PCfYMt+bxlN90d+WFJW5XkCz+?=
 =?us-ascii?Q?9fXsODhefPsckt5edThpQzKUK02NwcoaI1dfZ2NhOVrgF7G816eunewXyZ4m?=
 =?us-ascii?Q?aULmzrqULL1i+uHEQodPLZHJOsFrHrDZmYbDR1N2j2rcdT2BGh9vK09Dtcyu?=
 =?us-ascii?Q?x/B5uxzDB0LFi0usI7WjpUQ9aWaT2zVxuXkBLW8sujpCiENGGbDyB/X/2g1Y?=
 =?us-ascii?Q?Stdb1+UcLuwy66wY7gl3kVh5ZHb/LHXqoeQq+0pAxbxQgWPOpwWJL5+tDrUo?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9dba34-73e3-4883-a59b-08db15e197b7
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 21:04:46.1370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jy6c0dbkid57cEldMcnfZrOlwbkvq1TOYSOlpYSHQOFVbTVk/PAsNKJ1X6WFERlNzH44j0wRJlV3eou4kGDlj/4MdCG8RfzC1LYOy2F792s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4P189MB2287
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables equivalent for ebtables -t broute.

Implement a new meta statement 'broute' to set br_netfilter_broute flag
in skb to force a packet to be routed instead of being bridged.

---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/bridge/netfilter/nft_meta_bridge.c   | 60 +++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ff677f3a6cad..9c6f02c26054 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -931,6 +931,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -969,6 +970,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
 };
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c3ecd77e25cb..2aa2d1dd89b1 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -8,6 +8,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
 #include <linux/if_bridge.h>
+#include <../br_private.h>
 
 static const struct net_device *
 nft_meta_get_bridge(const struct net_device *dev)
@@ -102,6 +103,61 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.reduce		= nft_meta_get_reduce,
 };
 
+void nft_meta_bridge_set_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *meta = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	u32 *sreg = &regs->data[meta->sreg];
+	u8 value8;
+	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
+	unsigned char *dest;
+
+	switch (meta->key) {
+	case NFT_META_BRI_BROUTE:
+		value8 = nft_reg_load8(sreg);
+
+		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = !!value8;
+		/* undo PACKET_HOST mangling done in br_input in case the dst
+		 * address matches the logical bridge but not the port.
+		 */
+		dest = eth_hdr(skb)->h_dest;
+		if (skb->pkt_type == PACKET_HOST &&
+		    !ether_addr_equal(skb->dev->dev_addr, dest) &&
+		    ether_addr_equal(p->br->dev->dev_addr, dest))
+			skb->pkt_type = PACKET_OTHERHOST;
+		break;
+	default:
+		nft_meta_set_eval(expr, regs, pkt);
+	}
+}
+
+int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int len;
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+	switch (priv->key) {
+	case NFT_META_BRI_BROUTE:
+		len = sizeof(u8);
+		break;
+	default:
+		return nft_meta_set_init(ctx, expr, tb);
+	}
+
+	priv->len = len;
+	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 				       const struct nft_expr *expr)
 {
@@ -123,8 +179,8 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
-	.eval		= nft_meta_set_eval,
-	.init		= nft_meta_set_init,
+	.eval		= nft_meta_bridge_set_eval,
+	.init		= nft_meta_bridge_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
 	.reduce		= nft_meta_bridge_set_reduce,
-- 
2.34.1

