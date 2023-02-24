Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125A0C64ED8
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 09:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBXJxq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 04:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjBXJxn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 04:53:43 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2135.outbound.protection.outlook.com [40.107.21.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ADC2595F
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 01:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Deo8v30j2rtujSXihimQ9nsdUGPgde988vPsRv2hoPjBC8GjeQ3tiFqObYXA0krVF5Sr+yagN8UoVkMRR7oJjMFUdsP8yiTdYdF7Prnnp2ho2M+FcKA6/58A/loCs8JErZzmSfk+n/L5jrvvMqfaQeywpnNigl8llXOTSe1gd8Ka7VS8bKWb8epZTGGYIusiic+8/JsNjCaiwGNnQZThFC6AkSscAIPwCsrr7L3Po/eadbrlQXYBLzf9uhc9ey607jYR00dTFxmQf7E6lVNlkzsL7s3dTWpglkXSsNYc43Rd3Tl1WRpOekd256GFrcSsCfWu1lEYWzkchakECjm8vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2xww/5o/nAeiaYnJkp14iK4ggpulM0R5LpbUA5QnFg=;
 b=KT+o/pon/C0iiC/TFGtxXXDtXm9+GCnNd2xix5m6uSUWMiQtG5CGYzf+IDudxTeD49QhJ/EC/sij/S4UWPjnFI1P1ru+4Az+iwOZ5xYpvMq8z8EMHtOTJgy9KBdW0si+600cyk0duHd4IBud/DdYLVoKO9JmqJhaYN+6/5uM8Dh0JxBpW/bJDcvmaEqqOkzs+3MQXB3Hend3HAJbxtyqKAj+gWuAEsaStR7jWw20mIsi6VVi2uo5rPgSo/QxZ3RYz8jVxLFjmpBoXWxo1dRmkowYjOwXzo+3SPrz2Pihe7c7kKAeyhHkhOwRXMX7eFp1qHv36z10/BkMlBmTvrSjlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2xww/5o/nAeiaYnJkp14iK4ggpulM0R5LpbUA5QnFg=;
 b=RrEfl6oT4T8uwJgsZdrNP3M9uoZuShf6KCKM+KypTxknpA9nIrk9IwcDNAqDPD4+SpU1NEdRjPgwp6d9RJw49SmstO1w0ud7GNGaSGuADAfOWODVHilkFqSeICEGYwUiMbxmo08015KfjJgG8PXksb9BeZoYnKbdPlWopejC74M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB1870.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:4b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 09:53:38 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 09:53:38 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH nf-next v2] netfilter: bridge: introduce broute meta statement
Date:   Fri, 24 Feb 2023 10:52:51 +0100
Message-Id: <20230224095251.11249-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0059.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::12) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS4P189MB1870:EE_
X-MS-Office365-Filtering-Correlation-Id: 97cbfe3b-bc06-45d5-036b-08db164d00aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nUurSFm8Y2TVtoZKi+FZEqnWF56/l9B9BbZAkpMy7FX7yyeCGIdH7YvUxo2Setq5bQJuVbN4MZPkveki8L8eHmlKXMqkHq4BwwAf/395RlYGivi1kfa+hh6J5NRAqzNIQCabFpzPucXc0STtGcuatqx8kwnOSdVl0Lqm6GDQJZ35W6QwGE2KEBJnqsYz1veeTcP+zhO9hgAqFs4NWjzzQhBF01hFbbimC3vLWoL4RecWU0C59lLKmVKNPvkLoB4Z/wKArSqbANsg07oYYBX9jKwRG4S+2XdyG3iem0GOP9jGUy7iCjzJzsH5LZ7dgpzgk0NlpFbOMqmQOGFLQyqSaGAgR8Cwn7fq82/mQe+f3rMWjny5zatsxOSMZ9oDB9o92hCGWAPH+l1TcezvaTd5TUo5NPnjVe7wtvKrzRSn6okDkE3bJRSCn90vVMAqrx54p8cZtGmFb7Sq7Y4AyKB9DVq4I8Qsc7b6CPJmgkk/Cd1g4HxpSgEYgPD9MM3Tfg3zgS8gdaYkABElCRoX62Vp24FWsHF0XFtmTHNzO2x80qBCZcjt7AyOMRkLpuVXbq7QtsCxPJvKMLg+mrMQ/L7ul+FBiz8+L7PB4KnIsic/9wuZamgp6yMbQobaarCUvQMvsS8UNUCuJtbPaaFguQe1Il2zsUyC9KLJjca5xJ3a9zjrJWj3TRGNrJhHCZZrxX0TD5skU7U73k/0GZ+mTMrvEoUIzx0F6M+sxGRbajrEj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(396003)(39840400004)(136003)(346002)(376002)(451199018)(36756003)(1076003)(83380400001)(6506007)(26005)(186003)(6512007)(6486002)(478600001)(66476007)(6916009)(66946007)(86362001)(66556008)(44832011)(2616005)(70586007)(8676002)(2906002)(41300700001)(5660300002)(4326008)(8936002)(38100700002)(54906003)(316002)(6666004)(37730700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/fc6U7LeycT0/U2duFOsdel02tloH0bhp4MRtD6wKzoRfqtBBpMTsf9YkiP?=
 =?us-ascii?Q?37yj3y2xDINQzHMVb/UloGPRn7+FcZMLD440EHVQElXKzPoI3zMrrkZD6qQg?=
 =?us-ascii?Q?RvU7fv+9tUFpBeuLXQT4dkQIXV0ECMR0SQaE/CNGHjRwA7Pn+Xy3xdRtgVqc?=
 =?us-ascii?Q?7AQBxTcZrm2FjsQIul9m/pASs8px700HqW2ru6O+nQMqskkjMNXVIMUKdlrK?=
 =?us-ascii?Q?3ZZPifyBm5ehxFedACDskPeC3nK6PBoNmEC9K1dtSLvj7r9UC6OWfBxLTS97?=
 =?us-ascii?Q?5buFtbXc6fQXbDWEr86Wg4YxcdUE7vIJzZv5Sp+3smtt+uqU4AeK7h3CoBAD?=
 =?us-ascii?Q?cAn3EF7z6mqkm7uSd9JH6n2m2DmVoBKl1RGIoGJLHg7K9hiIVzE5BfbZRAgF?=
 =?us-ascii?Q?QA9GTohPj1dgxshtz/q1IvFnWB3L8NHLuylfr5tlMeYZTWnfyRYhBW98ViKh?=
 =?us-ascii?Q?eIG5dWsZagptSDCFHtwI4ymAAUQ2V/4E63I3QH4OykDxsRt0uGVfq/Pc2Jtf?=
 =?us-ascii?Q?BqOsCx8kq/IgICJTOTjEVS+5uYTRfNM/VJZ5scs+ddH560xmDeDP4Sd5NCPp?=
 =?us-ascii?Q?VssdZp3tuG5M34W6srNL5r1QXmVcp/QDXaeB0VnLPYL6QH2z4u9wK0HyDgq3?=
 =?us-ascii?Q?/MkjdksGDt9C5SnNIkm5moMC0HfRxAAUpDCyJj5PGJAr10EpvJSLL5f34NxR?=
 =?us-ascii?Q?/NkRDvT7u1VW2N8DPAMFHjudFPkAhDzr2bxb3/n5999FJAG0ZcTL8QO/KF37?=
 =?us-ascii?Q?ACXux1J5AzZmRj4fRY2RzFWAzYYRv5bkR/CuGvvSel29J+qunH81VkW1la9e?=
 =?us-ascii?Q?vEhYfc6xhBFRccCxdCoFcnoU6NQpocBTY/Pazr5z9Mj6GL4j5XJPvFX/F55J?=
 =?us-ascii?Q?7aqALJlMuBzzBKd/cS2MXN1UcBZfhrLeMAmz0Ph1kkFYtvTmZfpuuexhAmoI?=
 =?us-ascii?Q?/D/o6OcYu+E/ZF7VtNIW+ho8nUlgHmZc7ts4KauV0NtKuteojRYu5WfhvyGg?=
 =?us-ascii?Q?DRvqrd6vuL95FOrykVHUDJ7eVnALp8dr4CCFxkZ/irzeRZfpEsPPP8Xh+0rO?=
 =?us-ascii?Q?57J0l6DF16G01nULIMBSnKvH75LDRxka8IyBNK38WmGfXurZ3YXmOT1X+IeP?=
 =?us-ascii?Q?SiEzdmKmvaBqAQ4v7JUsQIe9lMlI05p5nbzqzFVVsvReLTu7af3+89BY7RXA?=
 =?us-ascii?Q?yAhg5nZKZnlhfFTYRxaBgORMpphKtC5sXgYv0tSPvumIvGmkrl49oEI6OEJg?=
 =?us-ascii?Q?RLbcFOmBmyAACDHxY3yjxigrDKmYcOGlpH5qJl+/bU824rJfnsJNm8HMMfue?=
 =?us-ascii?Q?rXOz+WQZXS0IZhge11Tfw54gX26mO1g3WZEiBBYo6rxTwhhaDvx05vOegRJm?=
 =?us-ascii?Q?SEs/+qLlrFHrHIHwbWLyOs9Kwd30xGwkn+ThffXNYtxlptvBMiiMpj9F5fz3?=
 =?us-ascii?Q?f2IARGsHeTVUqMeIL0RHvQ2CojXuEMWniRo+/e8QB8BnGCj35e2y/Y/1h7zR?=
 =?us-ascii?Q?gdt8yYrbd3NBb6Ghi5dZGHIUCulikwTEFGgKy6W24buRsZd492lOgd1Yp67B?=
 =?us-ascii?Q?SWM2ZjLUPL9M6rUHwwLj0OQaMFemHi0vS51pBzVRtBJOJMHF+nikHtLIsm4k?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cbfe3b-bc06-45d5-036b-08db164d00aa
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:53:38.5753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: In++YVp/Roj/guh0L4xN5H1uICWvZiX2XJbT2NsLHOtZ7zDuoqRInpU8B3n/u7sQaM27krr9HJHf/gSA80s3Ha0JJFWmhVs4EsIpe97MYgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB1870
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables equivalent for ebtables -t broute.

Implement broute meta statement to set br_netfilter_broute flag
in skb to force a packet to be routed instead of being bridged.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/bridge/netfilter/nft_meta_bridge.c   | 71 +++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 3 deletions(-)

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
index c3ecd77e25cb..d79ec5f60701 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -8,6 +8,9 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
 #include <linux/if_bridge.h>
+#include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
+
+#include "../br_private.h"
 
 static const struct net_device *
 nft_meta_get_bridge(const struct net_device *dev)
@@ -102,6 +105,50 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.reduce		= nft_meta_get_reduce,
 };
 
+static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
+				     struct nft_regs *regs,
+				     const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *meta = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	u32 *sreg = &regs->data[meta->sreg];
+	u8 value8;
+
+	switch (meta->key) {
+	case NFT_META_BRI_BROUTE:
+		value8 = nft_reg_load8(sreg);
+		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = !!value8;
+		break;
+	default:
+		nft_meta_set_eval(expr, regs, pkt);
+	}
+}
+
+static int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
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
@@ -120,15 +167,33 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 	return false;
 }
 
+static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr,
+					const struct nft_data **data)
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->key) {
+	case NFT_META_BRI_BROUTE:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	default:
+		return nft_meta_set_validate(ctx, expr, data);
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
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
-	.validate	= nft_meta_set_validate,
+	.validate	= nft_meta_bridge_set_validate,
 };
 
 static const struct nft_expr_ops *
-- 
2.34.1

