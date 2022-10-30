Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C050DC38A02
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Oct 2022 12:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJ3MZx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Oct 2022 08:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3MZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2022 08:25:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70109.outbound.protection.outlook.com [40.107.7.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630571B1
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Oct 2022 05:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5dGXEQladn29DwUpKWuRjL7aqLG2ZLK999aPWolq7ExMeMQN3eokjpD+AucqtZw+OengbpcGNnowa+QPo7RJlePMN57m0fICB4u2RwwoTMHpQbatjfVfnP7BItbM+QsowfaZAKLMP8LKq9SHAqift66jowSLqNtszxNPJxY0wjLv9kJbH5WhQyepSxmnTQp0blsGHa12yir9gvHXi42S4SUKnQvYMOpi+X5AdZXTIn7Mos6AncXVmq1fl1kY/TKfrekuFzWspSlqwOw5ePiIcE3Pmtybvzn0vNUUhLuKkvEyccBWBEe0UkYMUUDPN0EKWXXHCofwrDDAClZQIyd2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+hqoHqnQxCyZQjscfstDcK+6rDFXRG0/pSxympK5T/s=;
 b=mZNJ45BqmT58ZRnTiXchYaqqo1rM47SK9by5tCdCxmOzOnee5w+MJZc1tsGHCdfacKOGbEbKAI8JQNRMGJQpBO3KQtO0J9HGHoINqyCCn7Qzu2r+C2DWObOUZeo3lJhpCl+EZZIoBOQkRZbN8hVL+NS+mImU9f3YhZTgdywtzwjM7aBKeFf1k0qBAiARgBL7XkTD4jRF0EZfmEHa86LALvC35mXmurVv6LMlcax4cTlENMNElHZiUdfNoMe1WVxfAHgWLyMX2b8xx8WkptXR+T76Y5+IcIYdyvM6hIUUQiVdNeKCyAU49B7LIYDogpsi7skTEzxdE87e8dJ+rKEavA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hqoHqnQxCyZQjscfstDcK+6rDFXRG0/pSxympK5T/s=;
 b=JJOWZrpKYbdTTG7fcJWvmcMeiUCWYRg1uFSfGM3bu88LAUWMEtbm4//BsfzN0qeGPsDnQhRYD8Scd/8At4+vtvNXEr7nHe4E+RagEgB6qxONIUPYJIIFHrbSxy66NeRYoRnYiqpCvQpgfVQzdChRMNZBRoyceSloefjcHeY/BRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB2231.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:582::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.10; Sun, 30 Oct
 2022 12:25:47 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8%7]) with mapi id 15.20.5791.015; Sun, 30 Oct 2022
 12:25:47 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 0/2] netfilter: conntrack: improve SCTP multihoming
Date:   Sun, 30 Oct 2022 13:25:39 +0100
Message-Id: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3PEPF000000CE.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:2:0:5) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS4P189MB2231:EE_
X-MS-Office365-Filtering-Correlation-Id: 60786bd3-5687-41c3-7f5f-08daba71dfe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrvfYX5B5bCyDdBp/MO0zIWqjFGB0RIQMDHkW7pR2rP4zf/sjE4QMATW6QoUUBy8VMa12ebcKpSGtRXIO/CwsHAtQVqcIIykYQqaqbe6nhIlzHHdOJBKqtDpneJCoB6JqXsCuqggnF9pKwzyxLCquyQUT66u3XaH4RCgEfqLlOZkQElZ/BW7f3dU0OC2+DIV7ILuPhucrHu7rSBI+v6ZMT2KylVTky7O8//aTYBvQVZVfx8J3A4mbQuhn1Pca4M1Z6zzomUBrLEdKLtNpTKfgEBe9VRfBwrd23h2QEGOtWyz0BEvpezNlaewKjUbUj04Qcd74I3f7l0H+Q1JB4DU+jo7Gtoays5xRqgl2a4WW0Q1gDSHcbsppqxV2pN733bvZDTUkRxnLsg9++h09SZc21c5D6CYRwhwnReNEvinTR6R76sHdBkHB6m93epe0kfEKOoXtdMfR5GT43pvRArPpb0kVL70HUeoRbDMaPjcWp/dR/HDwbobjY3Qe7JdNwXRzjuGo4uSAweKwl6hao9KqOZN7XDO+ABAVCUGURI0dRbZR5/4zt3dZNS63cq/iBcTBhMr7k+/OsxH8RHilByT9bfYaOg2X9KHajSb+f9Gv7QMIyilrSy8g+msaMGIfInBw+OZUPoSngIPdKHmw23gtcHlpH4PHzdnHMNvFSnrAG/dTU+NWkBIO9y5gnplnNXtQvsKNMLoYgSQhpgGan4liyqD2SkVPuNceFD4WoLcHoC1AGZxc5JjEKtuefq2q+wo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(396003)(136003)(346002)(451199015)(36756003)(316002)(66476007)(4326008)(6486002)(66556008)(8676002)(83380400001)(41300700001)(478600001)(8936002)(6916009)(2906002)(5660300002)(186003)(2616005)(6512007)(1076003)(38100700002)(66946007)(9686003)(70586007)(26005)(86362001)(6666004)(6506007)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hd/LEJzwfst5yvdinigYaj9WOwpTeZAd/vi9qxsRyCbfER7uN/96S2nLs7wc?=
 =?us-ascii?Q?ZMSRwwvOltDlWKIbEVwL12rlV5EwWSWxc5q6Ane16Al/GmMagpfD2K+RELrZ?=
 =?us-ascii?Q?ErT6P1aNuQXX5OhLAzgOriCNX4C/pCQubJ8cTxObw45q0fOguaYxuzVyk07u?=
 =?us-ascii?Q?l/1oMKzIoKnwkk9qogoeA9G+teR2ISJV/9d4B00N0HhfaKICqHZNMlOFi6Dh?=
 =?us-ascii?Q?0nHo4auTNOPhhg0TnzdVwATzGfEbu7AezrB26cFYK8nUL4p9oilO+ZUbhmIA?=
 =?us-ascii?Q?zjEsV7mmGWMmY2MUXlM8P2HD5AX4nmHE9pcjZ8Kx65IFzn+Jvxfs2BbfgYDl?=
 =?us-ascii?Q?+hrns64FAhDM6p7/HwScWyHpFOLUSilVQW97dEaqYJ4M43s0vg2JN48BV9s1?=
 =?us-ascii?Q?Xc7lMKmGCQMzS8oElF7Xt/I26ab0K3y9GZNmGBMWeqkE0Vw/2XALdjOdvXEJ?=
 =?us-ascii?Q?K9nC0KR/GlPwdZ0So2sedo9PBa1kxoNC5i/QIe5E7aaV+X8+6G9UeP++JX80?=
 =?us-ascii?Q?1KMn4s9Rk/Fq385gEoZPVfbQ7D6aS3v6vjt1zcBU3Ie8TvtTAMXE/Q3M7/ih?=
 =?us-ascii?Q?Pm2ndrFjopC22+Mbc6bA7lQoX+y2mDOyWZY+++iaoxbJucXD0eO+RARiz+Wg?=
 =?us-ascii?Q?+mYaEpupn0HQqcTf7uCB0AaFtDW3telAFTZoo2XJ/1CTI0rNZTrGrJ3n0eM/?=
 =?us-ascii?Q?ladkZ2/VdjadrOoDntuzLlaBZPIjKe62LMk+Vn9DumAbHOgvRaCa4/i5aEmM?=
 =?us-ascii?Q?vugyLGJaUIu4fr5e2+yiHSo0L/tqCLguSjpKPkUMimwQWqCOFzXbPi/7k+af?=
 =?us-ascii?Q?NvJGDUoLrodgdHgH6z7DpAV/BcH/5AJtA0K/TP5Uk0gRyPww3sjtZzrju32x?=
 =?us-ascii?Q?gsxHbVwapqFmDy20rbKjtQodROKD3SAMlh5zC1Yd/b5Q1IbCxMKItBmu+P9Q?=
 =?us-ascii?Q?8qjLLuIALgNf81lxA66xcqy9/MzJhe3bDEzI+mUqi9ti/RQfaC+KasQ9J4ey?=
 =?us-ascii?Q?+8oD/wqRDXvxrh4jYgepQVGTe9GOicYY+lb1Cpee7QiVInUWuhCV44XYFnsu?=
 =?us-ascii?Q?77gn42HssNOSA9ByVtzT3l3IMFkLcxe5PrsaRPjR+MhCvMkrxJvdz2E9fxkB?=
 =?us-ascii?Q?xDwRoanC5qXvTlOm2bDwq2+dPdYaQiAmcfABQ26ahZDolbPSsIzH8gQ5fYME?=
 =?us-ascii?Q?bJpB3awLeQ+2RXSdfC9dbOEgVfXcmEdfsif1ggzgcFLMuxXnm1w5Q2KoH2e9?=
 =?us-ascii?Q?Z4xXIFGj88hJM90UZ+pbcq8sVH208efCXCNZuN6crN4rz/6KkSYixd8gzF6y?=
 =?us-ascii?Q?34wG9+23BLi9s1JKTGcj97dpRl/kl8V070BHWHxHIniOxTGLTk/uNWhulfSx?=
 =?us-ascii?Q?SSyszdaapsey1bn7qrhRH4s6jqmHeipdLj6oRsCAkYIYSbyVMII7w95oXY9s?=
 =?us-ascii?Q?DoTXqrVT+cP/MjwD7UY2uOuK6w8WNDznG76zj+ZFs6ebk9d1xbtHzfZNVAAP?=
 =?us-ascii?Q?DZAbtXndywu911O0t3VFU8Tb9fXJvBpnA47g7nPsaiFOvO2Y0grArCTqvsRZ?=
 =?us-ascii?Q?28tF/q3tvJkFWPYBk3xf6mN1srqbAx49MrpMGoFdxYeNSuXkhMITLCAB46rl?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 60786bd3-5687-41c3-7f5f-08daba71dfe8
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 12:25:47.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jhSSIkioiPJ78EuVO1hfuDmQhkVfx5KZnGHrvtaCZdTpu/x6K+5CyLnR7a4e1ybdqYlrScP9JPGvsjNanOCu6RBYM2qVgeHlIJtQI1w5Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB2231
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

Changes since v1:
- Fixed kernel test robot reported issues on fallthrough

Original cover letter text:

This patch series introduces a couple of changes to improve SCTP multihoming support when running behind NAT.

An SCTP association having multiple alternative paths, will have different IP addreses but will still have to use the same SCTP port. This means all the paths that have an NAT/middlebox will have to co-ordinate and use the same source port after SNAT.
This patch series introduces a sysctl to disable source port randomization.

An SCTP endpoint is allowed to use alternative paths during the lifetime of an association. This makes it hard to write a stateful SCTP connection tracking module. This patch series adds a new conntrack state DATA_SENT that will be triggered on receiving a DATA/SACK chunk on a new conntrack entry. This state behaves similar to the existing HEARTBEAT_SENT state.

Sriram Yagnaraman (2):
  netfilter: conntrack: introduce no_random_port proc entry
  netfilter: conntrack: add sctp DATA_SENT state

 include/net/netns/conntrack.h                 |   1 +
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   1 +
 .../linux/netfilter/nfnetlink_cttimeout.h     |   1 +
 net/netfilter/nf_conntrack_proto_sctp.c       | 107 +++++++++++-------
 net/netfilter/nf_conntrack_standalone.c       |  21 ++++
 net/netfilter/nf_nat_core.c                   |  10 +-
 6 files changed, 97 insertions(+), 44 deletions(-)

-- 
2.34.1

