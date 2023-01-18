Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0687C32793
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjARMRH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjARMQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:16:27 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2100.outbound.protection.outlook.com [40.107.8.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91305585
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:39:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIM4t3XzMexM9bPTVOlt3KeSOqQ7xZjIBhLesyLUiZcF8aMWGOx+fEE0Dtafjj95FbkbLfXFyKebdRBR+YBfyGp7MbrYlGSpq9A1OKvvW8Hq99FHWRooOoost9Kd4p3q981hMYV7McXumCyVMdyjrOpdh+ZM0ckOSN+6v2mo3eKAkoaFwPIFPCAIT9tTqLbxbltmwOqorX5eh8lqqH4ff4Qh3nVGvb3ad0JNX2EzqJ16vNE5fS+DzpiSijLtUicrOZkMrnXY/sUeYTdwtcdQOgzELZouljMiRW60TQraShu+RcIbeqdUkGeX2AMEMbDZEO8fA9gbGVJd6EHuFQXMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=htcq3hXfqS6vck1yQAaw+AhwoqXD0uyWntZnmcebzoa7M1Yi6saHSo/HB8/Hn4BZhjzGF5HMKT7RfiAqvB6T5HZ6au7njTs234pzPF4z8bagNCFeW5n9qnhsbZw3xZ0ze/kNWltuSHyrueJht6wHC6bNaqGtkOB32ot3dTdefp+2GrOaNoMaSz+5XiaCaEqqWl4rJNmxtSJ4izFYByA8qY1s/YyTPOdWGpQsiXk1B5mBd9ZnQHYdjvNe/p2NWvj/DY2pnttLN3u94uXI+018+LgdVPnAJAyKAcLie4nhZQtRYDywOz/hFcJhbjg6oy869XUR4J88RiYRRomHSzczwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=OUIlYt9k14W4zfQMkdpc6epXyRdHL07XIG+1IvBsLl4UdTl9VCPdi4MR/w1q8sOXr28G7NR+zrcMy8hDS+vhxtk4NGW15Z8oCUCgNO3ZqQ6gSXV0qd9DWCkvoO1v51Y0hfKRfLHGZlhzF77DojN/NjqnImzgiSh8odTR+r8lk40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DU0P189MB1867.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:347::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Wed, 18 Jan
 2023 11:39:03 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:39:03 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v3 2/4] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date:   Wed, 18 Jan 2023 12:38:51 +0100
Message-Id: <20230118113853.8067-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0050.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::13) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DU0P189MB1867:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de92bc8-9b4c-4c52-5176-08daf948991c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jO2tidNvQ2S6Rn50iTqZe4BkxjpajCZR/X/GINdl1bhdcTcqRxixT5Cb08TZW9rUReOrdGCnJ0qKD6dH+wC2CUEQL+j5SiNx6sICDtkLflChAYeXwPQTeovIHPGJ5kbeojnCEDEBptO7l6StFodBokhn/jTQkFyS/oRhgFuPo2dzoYnf65pjfSZCPjJa3n1Ap/X1sZ3HqfhHaWobf8nGHaztLEj0NM5cx+Q1oeG9HhG7pnNkQjMwfYz7Z/sYHLbmHadNkoVN/YxSc72LyEeANqgoRbSGksEvCMwZuNW1714bKJcVp7e6Lhg8oSTmdyDogfRnLSVlTwHvxWvXw3eddoaZzp65MqqzwFhpAPe/YZO4UjnaGc08SPJ68aGB72HqoWhRmS5Azcsk1kx40r8pTTxCAcThoGagxw3vSYirY/1L6oZMiZYzAw6XQCnLFqPHG+nEw8to8P5Nss40BQJXmSPMKji4F3BFHCxif0uMLNIWWZEY1DkvjdkI4wtZ4SlDALyWhr28hjKg0J7oM1U33X36wbwad5QRtwiHx6Cb31SfOXSAc+UTxHVXVivwktqv9W3sdlQBJm4/KekmJEU3D03JPH7mcdjaLiBbjQHmHPzvJU2tgoB+t39BcbCKxuySLnbFv0A68kSPGhsixWRq3ok4Tt4SgJRnacuzqne+mzUs4fpIDEem4oq7H1NSHIK32E5gqAX7MYlQhEwCIjDKDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39840400004)(346002)(451199015)(1076003)(8936002)(36756003)(38100700002)(2616005)(5660300002)(6506007)(66946007)(186003)(6666004)(86362001)(54906003)(6916009)(316002)(6512007)(8676002)(66476007)(70586007)(478600001)(41300700001)(4326008)(26005)(6486002)(66556008)(44832011)(2906002)(83380400001)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C8Fn3YrHGIa+OV0p11v1te2gF1pwfIDnyNxoYAEr26VbKz8Wypcks1F7CtTs?=
 =?us-ascii?Q?CcLD5+Nos6bHB/PYMjO0sWfbvyXzvV4aDyR9FeuuXRzqt0yDbhewStChLLbZ?=
 =?us-ascii?Q?8QZCHFvjFXtIehCX3/XPLnOIdSR0yxXNZyif2ofDqMjx4SbbrRDky5Xq36Bg?=
 =?us-ascii?Q?8yA9+r92q3VYu0o7qOgaBh1SncsP5DFpY8s7BRCu80TZAHE+v8Aqu2L8uflg?=
 =?us-ascii?Q?Clwpdt/hb53MmGA/B7GmR6GyT96RTB1ys0I/t0ecG3FUdpe0xFAjR8VxvJCH?=
 =?us-ascii?Q?Ztj2Xwh8KmfStU4f2G95LUFOyQVjrctbnx4XVmN+/xKAlkjYNtmXnspke8QK?=
 =?us-ascii?Q?eLCqR8mHK4kTRGyMxd7XhlhboRmXK50xhNovNyEkWJFCpp3Lr0g3Dcutphiu?=
 =?us-ascii?Q?LhTiwuegBPMskaHK4l2jaZLy1j91wVLOmwD+1Y/PLFEInE/miA9OUgnB0Klv?=
 =?us-ascii?Q?KXGaGgdPF0TzioZRdZC9t1vGJLUlAckWtLclMu4+c2+o6kxi0FNGAm6ek1hx?=
 =?us-ascii?Q?zGaeaSkJIkaueFR7mr0DOEKNQO+P5YySnHpzjhGVmkoYFUiHgVtl2z/4aJCL?=
 =?us-ascii?Q?YYwF+ClBn0AarLLJcUTVycSZxgADNYfbPxtieDWuHcN7s5xx2RKFBoegdfQw?=
 =?us-ascii?Q?c4ry59ewlR0QYAR9o9oYxKd2V1/+280NpJvj5ckUsTlcfydlJTXsyipisNS0?=
 =?us-ascii?Q?LIdAwJzZpHOj+HBcJ/Hx/bPR6f+x9zxVOLN8LWb/sSpeC/VD9Gmxw1mpDrqx?=
 =?us-ascii?Q?vw1imr01DdfGHI17HZrT7RDhFuPe0G32Npt6zp3hcVC5i7p881YaRxFF0y8w?=
 =?us-ascii?Q?m9o6lB3BxYYCQWpDR+HSaHXwDIZBC8NZyPyTCfe7SAOWkqRM68OdE2IA/Nhc?=
 =?us-ascii?Q?GCoR+1MMttaQihXR1q6683W21Zb77UzHxgJMC7FtwvODS+HGt1eRjqO196rA?=
 =?us-ascii?Q?zwzDqiaxCFarnSTV2eFKGGS7xzr1lvw3l0KUPKNwRzdb1M8TKj8TZNWZ19mc?=
 =?us-ascii?Q?3/EGfG2ZRv31VpkSdZVIRJlDScCy3nLr3hl92IbDf2IQgOppetbwsYdkux/I?=
 =?us-ascii?Q?DDd5MuSHxlVhv3tN4h5py4x6MIWlgbW5Yj26LV742M79HRuruCXxDdbnXeaC?=
 =?us-ascii?Q?R/clinI1rDd2Kysukt7xfZMr2TR5tTd+UvJAAlu+xITOQD/N+tgBC6vtJILq?=
 =?us-ascii?Q?7ET/WMwA1PUvQu9V0CmzUrFQE0pF6qheox0jIZT5BU1diouyP70Ai2SuSctn?=
 =?us-ascii?Q?LsT/MkjRlOZmEXJ7mWyNEXKY9EOc75bFpCyjxKGBY9g7+/jGwMWZeV/N6D9Y?=
 =?us-ascii?Q?5Zc8HRFGl0M5PsizWMumy+q/4zvzDAN2PrDRiBeAQAi03WPVwj/2xdycj2mn?=
 =?us-ascii?Q?hqHVbdSVbYAwJ11NRrzDTh5pMaAuzXd0beTYZzcdBsKWe4XIAz4JALn528Mn?=
 =?us-ascii?Q?7ZJys75wItoKs0l7LEpapfbPMIRtXSdhwRdUS1XPa42RwdelhdcCEx3xeCx9?=
 =?us-ascii?Q?I0xkbpPZiBlse1ffQct/dAioZlL81X9G7VIxQpkBpESCFp9RDIZgQhOa4sGw?=
 =?us-ascii?Q?/0wV6A+X71mVnEo9xfqc3aJTaFCPmUwqOibX4vIyNAmhCg2mwQWJF7sT+U8B?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de92bc8-9b4c-4c52-5176-08daf948991c
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:39:02.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlKDbA1nuAwSQ1FCxu0G2xlyRV9JIaBmSpOrJHZNHSOWzy4SHHJPWqPZWjWDMw3vbbBLbBtuJ5sZjXffduivRpooUxJZc/CzQOA+0N4CNnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB1867
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
skb->len, so this offset < skb->len test is redundant.

if sch->length == 0, this will end up in an infinite loop, add a check
for sch->length > 0

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2b2c549ba678..c561c1213704 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -160,8 +160,8 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	(offset) < (skb)->len &&					\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
+	(sch)->length;	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.34.1

