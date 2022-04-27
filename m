Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5689C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 07:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358701AbiD0HTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 03:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358708AbiD0HSk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 03:18:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80120.outbound.protection.outlook.com [40.107.8.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3092BF7
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 00:15:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2MmftfTXfwiQPzLODTGwbYYWC41qr3E6+iGVZSN7CZOOQgW4+rT68k5Pnflo4rnm2hHGkXFHVaXlEJj2yKvtcPAeYA6MCD8WkY733fnDpENAXdgbCRhwMBA87PJ19wt7hdDpVmfpWquas5smUPWE1BE/pyENrWp27ftTE3RfKDnrpyDqe1W92AKpLCPoGknS0mSTshOnEM2UXqyoGD/gLQfvvZOzVM+qRIWkMb3KvokU6z431q511PofemZYJXGcWNbMPc0tG6luZ/7a3DC6S+kS/2Nr/mpIf3eyRXqKKt85L1VOmGP+0zFr1wKLEdZF8aBg4qajGxLRIsQB8X2Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdaJhvynGRx6eX9Qt/V9B/6q63ZC3efjljNDdd+ARZs=;
 b=AoMYWKusRlHcR+Ipm6LXxvSrNAkNS0RFJwraVXIIm9pyOmwU5ZcDdEPJRNlzVnlXb2T5bJJFLHVBwzIJ7SDgexmIvwb+OhU1K9tCf/Kq9VSFhXdnOuQFZMaGSfyolB/uMZJNee+kmgdNpdby92P7+v/NXZGJXme0fHt5WfED8NcalqW6oaHB+qPS0y9d/WPhSYYWFcsZfmivyivftXRzd6xCYDKxUGl3czrQ7H5pfCScllXG5VFlnbDSi+FzN7ERPIOEQjopJGSS0xInPgZdMUlPx0fP1xWlbtk3lFTNIZgZvXXrYh2GKCcSTlHNbQhUyXoK3COXfnVoC8DjRX8Fpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdaJhvynGRx6eX9Qt/V9B/6q63ZC3efjljNDdd+ARZs=;
 b=Z5YLBs687LnZJelrSB9IZtJBRuuOngqazFPhDdbdmWA9OpwbpmmU+3a80E/mX7Ba69zQqlEuK9RL9PIkhx21J7jxn8/H3au/e/eZqkuIhwCeSJexO9OJ1AF5LtFTPJ4qNe0ynmgD6so/XwXMQgS5grAFV85CbW4M/LNPcIocvQI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7153.eurprd05.prod.outlook.com (2603:10a6:20b:1df::20)
 by DB9PR05MB8188.eurprd05.prod.outlook.com (2603:10a6:10:255::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 07:15:23 +0000
Received: from AM8PR05MB7153.eurprd05.prod.outlook.com
 ([fe80::a581:fd5d:1a9a:21d1]) by AM8PR05MB7153.eurprd05.prod.outlook.com
 ([fe80::a581:fd5d:1a9a:21d1%7]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 07:15:22 +0000
Date:   Wed, 27 Apr 2022 09:15:15 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH] nf_flowtable: nft_flow_route use more data for reverse route
Message-ID: <20220427071515.qfgqbs6uzoowwnkg@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AS8PR07CA0049.eurprd07.prod.outlook.com
 (2603:10a6:20b:459::30) To AM8PR05MB7153.eurprd05.prod.outlook.com
 (2603:10a6:20b:1df::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44777d36-eec4-4156-1603-08da281db1cb
X-MS-TrafficTypeDiagnostic: DB9PR05MB8188:EE_
X-Microsoft-Antispam-PRVS: <DB9PR05MB81889E8A72621769E86A6B1DEFFA9@DB9PR05MB8188.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9SIF/Z6guwQrWAgIGYkRw1zppAVu9GUmaLyrz/yiOGmg+B2URsUxni36ku222pI6bT6TXIjRC6IrmKLZIsV0fMDKEZ1jdqgl4QO6xgAN9KkckyJfdNMNuJIIeECt9rObbTLjxgJGZ2cttR0Az/1UN8RW1Qsa+Vg9eE64FtqU3Ij1Yf+menalpxVnGmRlomin3UmtoLoPVAMLjUQ02wowo/HvNHHfCjNaCypWsWH5GAzKg2S9l45k3ddpqNg1miqFUwVcL8W/NCuefPIiHmGVqzaB63CJvEcwxqn8zTy6OB7vnBH/Sx4zH0ekaMoeMUiKg8/bD87CSDBz0y9iwvpXiQqPN1YTLCrCoisfP0nx/5clyYWIf69RBRh/yVOyLpqQWtAOzrR2JSaJwRr1H2BWbr8eaEl6wsq0oDyoWc8J6fYCZB8zpjQBMMHjysrGW9kaPPpYXhfdfDf/1q0I4bogID2q2t56JOlYAqwQzz41I2uandi2mxHrbq/rAqBDtJP8GYTjoBGZbKDpyFaq2NLVnre3vHyYiMXRAzz/b0VCDWR1iGD8HA2xg5ZceU2eoMbqHweRBPlHtx8A/IqrmlFrfedPecOICwBT2HAeqe8zQgBhrojySkGXfCzDMjggce0YOnhUCL9O7x0ml37FTcJLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7153.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39830400003)(366004)(376002)(136003)(346002)(396003)(2906002)(4326008)(508600001)(66556008)(66476007)(66946007)(6486002)(8936002)(6506007)(9686003)(6666004)(6512007)(6916009)(26005)(316002)(5660300002)(1076003)(86362001)(8676002)(38100700002)(83380400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxgMAgbiryDuKeL3X4xbjiDqpPxlwU0bTiOKggPVZ4Ru3g1WRiBtq1EL+49a?=
 =?us-ascii?Q?wfMoDoKOeKHlOhwOfiTVV7tyac2qzPmAutFlNHmi5G8u0Jw8LpUXf/LJZZ0a?=
 =?us-ascii?Q?CoNPinq/sTBd5B9wURIs9d/8v2+J9bG7k2I3JjJpaB/RNGjcnymEmM+i20m2?=
 =?us-ascii?Q?MDCqq8F5OytXyQaKYP5nxgJHEOr77SvkKpWDo8AZsFx2Zx4G23SZG0kRvWa4?=
 =?us-ascii?Q?bc2Xi3x6XERih4xryfEBtcNRtcWt0tIgihUozavzCiCwWyQYrsnhH8146Qez?=
 =?us-ascii?Q?1qJA1sDqnCJ1EK+7ZBQaaQS9TbZYhr1keWS23YP5vtsy0KZChfLAaH72SNiB?=
 =?us-ascii?Q?KcQFqJj8W37vSS7JLdjgAb100mS4R5twxDPdM91g34R5Hdtm/IobqjfnXXpB?=
 =?us-ascii?Q?5LkwRZRSZN6N42ka66c9OuYTOZfzbHYHXpApsZHjJGF3TLY0tE+cEx7PI+h6?=
 =?us-ascii?Q?xGEQfmU/zDbQ4OpeFOIopQ1wD7Th+9peNTxXr+FG/TJJTieVSTAsS8hO7cgk?=
 =?us-ascii?Q?Ha5K5Y6dRKxE/mwuTl9Cys2lWc0FblrzU+aVpbMyPB/MPQBzqUKQBOhliDQI?=
 =?us-ascii?Q?/+YqK5txFZAXaetr0Q+9R3aM+abVxG1xr2zuV6r1wTea95eHi02i5/8aoMYF?=
 =?us-ascii?Q?Jsgs2YTVWt6u+Dqb5CZoF88fG0T0luzHytGON4RxmiB33WXQit7tn53ttUJt?=
 =?us-ascii?Q?tI8NfG6Qa1DP7qrLa3+nHlBUJV2Ywoa2t7ps8xIQOOFrM0PHv3re/WXdn9Gd?=
 =?us-ascii?Q?KHd7pJViFnPxIfaRng7oXkYanwCDi96k8WG6kBbDDKn4fqMxtjYFHy10+JLE?=
 =?us-ascii?Q?1BuaZz3X3Cr933+nhJamQguA7fMxYE4cwoSa6knczOf8qv/HyV7L/ll9s+ov?=
 =?us-ascii?Q?AY2AzL7aFnX0ZIs/cR8nco/IUO4hePj72hsFHybJfCKtMvKxKa8K9Q19gfPN?=
 =?us-ascii?Q?BNi0EoC+MGbaQYfCZaXEk1Yr/k0DfSktd72UHsgpi+i3EUFGPmXHvc0b43fR?=
 =?us-ascii?Q?f0d3fcwCHmnq8fMilwCKReTGndhGCfSMUj9MzUl5LgzZZI2QiD/zN1zYiNrF?=
 =?us-ascii?Q?VBVlVrpXzYckacbIvKAF3wN5J0iLqEWAzn/iIQQc2rJyKOWNNJHr254RPP4M?=
 =?us-ascii?Q?smDO2ECkj+0Qwh07oimBlcycSL6+2wvuxqpvAgA5S9NY2dB0AYuj3Vl45Lt0?=
 =?us-ascii?Q?koU3vN4040tEoH/WAtcAUbriXWazxyPn4OA3KX01k3eMU8t3aUMhhB2cK9Q0?=
 =?us-ascii?Q?IYIOzm8P0Jww5bLV5MMvHKOaft8f5XDwAN/0u7/PT6KGFTnp3HbzQV1J8i1R?=
 =?us-ascii?Q?NwZkGEdBVfyCUBrpv1DW0/59PY8vXZfN8taqE5gvxOEi9wCwE6mcHCw156pS?=
 =?us-ascii?Q?p5lezI+QNPqgfZlQh7ZIhE7kqA5fVSakav74k7JQWe9l1HTN+AE4Jp5ioIbG?=
 =?us-ascii?Q?gwZeYoGs50hN3wWwGkmOK8GN44DG9wd6lRhmrQxQNmT/oAlN3OJcZOFfzvkV?=
 =?us-ascii?Q?bJwBhWRhTkwDrTjfRaU3n9at8yByqqHlvPnAFcEB15QCQvIciVdJolVnT0bg?=
 =?us-ascii?Q?y9mhP3aTne3zKM2FS5r6J8f6Lz32gfDCjlKaOCQdZfeblAK3UFSvdvI2VWYj?=
 =?us-ascii?Q?6qTD1NIkizO7J60LVZWfs10oFmz8hzapiKTHehkhijvkYUDI+O8EBJv4RQht?=
 =?us-ascii?Q?adkOMFW5IdatjMBWr7ZwkeaTEukjIwQgusNODFSir7lKBS+oKQPT8zQO2Wuy?=
 =?us-ascii?Q?pNpo2TspDsGP1dxq/3HHTUjH7uoGusQ=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 44777d36-eec4-4156-1603-08da281db1cb
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7153.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 07:15:22.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSLJr8GbOgcLVa3kepEFZMxNijnjXXvcXp473/+Da2pCSBY+8NC12koLtCiaE2Qex9FgLxIfKILhl4kq+LnZqaKYTBYjevRCI9bMumXtzm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB8188
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When creating a flow table entry, the reverse route is looked
up based on the current packet.
There can be scenarios where the user creates a custom ip rule
to route the traffic differently.
In order to support those scenarios, the lookup needs to add
more information based on the current packet.
The patch adds multiple new information to the route lookup.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0af34ad41479..34116a6cb72b 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -227,11 +227,19 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
+		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;
 		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
+		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
+		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
+		fl.u.ip4.flowi4_mark = pkt->skb->mark;
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
+		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
 		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
+		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
+		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		fl.u.ip6.flowi6_mark = pkt->skb->mark;
 		break;
 	}
 
-- 
2.33.1

