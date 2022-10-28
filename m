Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C00ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 20:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJ1Uwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ1Uwh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 16:52:37 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70090.outbound.protection.outlook.com [40.107.7.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6E247E0A
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 13:52:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csCx8BCiyAiIlOqCh21z7NcjxAB+a3NTIQ1ccVgFh/+eBvuYe1QgTuAAvSpnmrZIAEzM6PLkvuUFBUiDtlsKFd7brMsMMtF3SvZLK1ziW0EADD2kecwyjAo5MtvBTQq8mvFr4eHxyeLLYStWS3dLGbny1C0Yt3E7iA9WPyc3GJ7oxoxi7UIwkHOIX9gj+KMrG05YF7SxwDrku3bRbWkk5KdvwbLPpsyc0L7+xi2ORKkTSVFX0ahJwfmTGx+3EL30UfuQdc9Pw/LMf+fLT0TA/TLV/KJ/yC8kD6Zs8gN9b9r5eCkGA2tJ93BgfkVd9biz3nrJRE0oxIyAIeje6sWTvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV52F3GRLSewRT+ru6iv7xl7vrUOQS1oQKA6lq+Pg9A=;
 b=njDKpwyCeFAhA1ODFrUahtIe46wnYuy8cN34glB/bFLodgcwwNNP7B+bTd6q/me2Mv+IryuTk894Tko4VMetDapaJhnIMTniPQTph20lySkPIBSCKQ69Mg/KSkEKTbudrz9Yp6CIduXvyHvRkUMCr4PRv97HJarHx43E7D88LF1z9p7lAs0CIjaCgUryS/rsrEoD/ItpDD8Kp5saYpMQ8UnldC6e+sUQ+p+B86cPL+DobQw9ljxMCbTpGLhRGcG44z8/pdG/YnukL5zdTJhzVkKCLcaQmOdMy2rKn3Px5eo3yj5+p1bpt2xb+cLbxmINJioJatdw3hKK5SH0VgGH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV52F3GRLSewRT+ru6iv7xl7vrUOQS1oQKA6lq+Pg9A=;
 b=ei2o9cADK3kQBN9uf27VqPoxrW63JE+nfw/Wlt6Yi95bpZZcnQZ27F+4qPVESW0pVU0o/LmTx2woKeUQw/zHosRsAToShQ3SWU3fcPuJCDq2oGdyG/RH8uqqSbRE/lPOY0zVcTUDodOz1CTzjbg6Qu7O7EDUDfYkU+ltIrJFKls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DB8P189MB0602.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:12d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Fri, 28 Oct
 2022 20:52:33 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa%9]) with mapi id 15.20.5746.029; Fri, 28 Oct 2022
 20:52:33 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 0/2] netfilter: nf_ct_sctp: improve SCTP multihoming
Date:   Fri, 28 Oct 2022 22:52:23 +0200
Message-Id: <20221028205225.10189-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PA7P264CA0030.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2df::18) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DB8P189MB0602:EE_
X-MS-Office365-Filtering-Correlation-Id: f94fa707-1157-4ad7-8286-08dab9265651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPGoYoXAAzRhgCTOb8/ms8ST9/e15pbIvrnxenBzAV1b9gfIzs3Fjo6gaO49Aa1tvC7vUCal8ryN2MeEdmgIqW5Pzzeb9Evs0rpeA6I3VlvBLK7xPLIEhvdJaL1wNmaLJ0DcuUEeTOx1T5GSVcLY3zqlc6QJKD+lDRQkEo2zw+uLB1WIyQ3DDOV7XUtxFizjZUuwU4rrgTb1whhH6+ZFXTVbscVqsuIPaPYdRe2pjCtdQ5uuxrhZwu+IHBIy3wL/BmHuZfC1GKQFXc8oeh4zVFFsyJftt8QJBF+rOAuEO8eeQQuziwx+MrxQoPCHwfuM/93GqpMVN86waoUB22nP/mNCU5YoHkh9ZDvaLfyIXH2cmRiOJB/yfU6MOArBUTmuqfyaLImcV7BYHDvViXhDp8GLau8f4mXuPsbYM4vh4FLEIR2OzVw2Wtt8y8wXmkKI4OHP6jg7Tz4Cq14jLOu9KjUlMn0kzcPtLM/s6kIW+shOSt2wqUSc1yIixgHJdJ96bDTUAYP8kIxNjN/MHF2TcL9b7u4aoI2fUqFOweIfNsAt+g3tY3jVoQqe7E9CpV8g7R4iYDMpFg2KDjB8+PXyQ29t/yVrSEykWzpqsAA6NLoJ/dBmjaijQL91vyz6Ll5+w4w+a5RTpp6pUVJtcXl5B1CmiI9wRQRvyMZjJrONpybt6OULmE9jO8X7BIwseHUvatZyr7lzKeVJ577JzujUFMQ2HBiCGyFTNByP8ezAJl86myS5ZIlKl9Iud+FupbGC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39840400004)(396003)(136003)(451199015)(83380400001)(36756003)(5660300002)(2906002)(38100700002)(86362001)(2616005)(1076003)(186003)(9686003)(6666004)(26005)(6486002)(478600001)(316002)(6916009)(41300700001)(66946007)(6512007)(8676002)(66476007)(66556008)(4326008)(70586007)(6506007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j6a0xfXgYTjVJ91PmsqA21G77llZt/Nrw7BqK9vkfva2NIGpBeiUHxTe/Sk7?=
 =?us-ascii?Q?LcpHxwQ5zz7ZzZUD/pofwVb3koPMVQjSSvs80T6Icj1UnwLyA9yX5OggDFcH?=
 =?us-ascii?Q?XJOJ4pI0uEOCSDUs2zlvKCd4/UI932ut59wmMZfYr9xg+9ZRW0kjxyMjbVq5?=
 =?us-ascii?Q?c6CCpeqqWxDffmOOyeg8plQJxHsl6RaPLvQqIWnSeIaqX4xM8f9eeZ1XUtlB?=
 =?us-ascii?Q?aWo/gBB8oD8VsWE6kOkMH+EzSAnHjvNRXmwzmHdeQ8B6mmTAGeSmqOujoR/9?=
 =?us-ascii?Q?IaR2FxO0RBzQ78Pp0uv8MnKRurd9HJdzAdowq8Nwh2LYkiYKGwMJRlyqB0Xt?=
 =?us-ascii?Q?ByYDLbUnYTUW8SpMJCibTAjcMciyMJ5WeFAuhuPuk7jQEAcj1H+5Bv4sErT3?=
 =?us-ascii?Q?r1VxxJA2FeF1fVV9FQZpJNrCncYHpWriPxJQv2c3wDBy6G/VqDuN3BgMnf01?=
 =?us-ascii?Q?Q/bUZfZcRex6/6J2aap7cvdo6D3NAY6CrSAo6lgxTpV2O+42l/zmnlEAqQSx?=
 =?us-ascii?Q?fC5aXlIGbGHJ/bj9e6AUa71/zckK/WShQFLCO/U6ocNCsLw8kAJj7zgw8X6i?=
 =?us-ascii?Q?YR0jbpyiOC3oK54flxGbQ9N+VbLdl8SXAmQvishzjMCmjzPdLkyoQnsff7nF?=
 =?us-ascii?Q?am7ffDV+gQjfaeNwPe55cUUpNaLsdKG1GKE0AsusMXdTLL6U11faP9dFfZAi?=
 =?us-ascii?Q?xHNdldRJypq/feMY1Q5gSEXP5bqZnacqNYf3xVKIwtZHpGfSjqgMGq9NFdpr?=
 =?us-ascii?Q?oFdU+SodKwmFV0HNi6aaTLrXipo1cjmF4Ta/zy7G0phz29/f3a/OnPBxY1sD?=
 =?us-ascii?Q?6fpPwDJldLi1rlo9eRe2nb8HNXsFqY7jiZI3ctoKSt+qcF6SOMIsxpGORQlq?=
 =?us-ascii?Q?RtQkgTrJCIlp1tmicqn2v/rL5O84Vx/dGobasgTcL5ZnHeCmj5Fu9+J1AwMi?=
 =?us-ascii?Q?hsMHQ5hBK/qZMmFFvFrLzI/HyGGzcUxeepTUa3MeobunDfkiQ5vfp1VcIpRJ?=
 =?us-ascii?Q?ziU4GlbuIOar/Upqu6bypBtuh5HfPgsGjiZO/rGFzi1jwtjLSsdkviXm+6aR?=
 =?us-ascii?Q?5ZTzJ8fMPPeEvRX77rPz1zD3tCAelKM8pxrcWKDBI+x5ZLpV60DpzwEnedRs?=
 =?us-ascii?Q?+yO1EO1xKl+WoWUKFCI552mmvFCLHvwMmQpM3hL1nbu6Uk1us300C9OEGU/x?=
 =?us-ascii?Q?2N6wyArzBHuufrLdiQ32XoZpQlIUEp7+4v8GajxUSX247YhoCbSzQF5XwkXT?=
 =?us-ascii?Q?BDIuTWoRrqyxUcI7AaFI7uNM+eBQ/8i8My7hp2v2HGByOhqP6hs40J24wt83?=
 =?us-ascii?Q?uBvGOdT7VmaGf5cZ4gJqbWNfW3gukb9l16wdgHf0HWNllBQcnhEgMNnlecD5?=
 =?us-ascii?Q?0AEBKJv+0i3ZVf30vaNE5S9hjgB0F/CYLPDrPretifGYDwvKYbzi9gJIRpnf?=
 =?us-ascii?Q?tOdoUBl+jYFMoeOV32C4hSBdufzKl3lkT3yJxfA0DZOfUFKRpENQH61414lU?=
 =?us-ascii?Q?lcMm18BubXkJwXrv8vDC0kIjKIFcA9IjTblVrjdbWw9cXSBEysyVsN0Q5L8l?=
 =?us-ascii?Q?wQ/R4WLqLqH4Os8thpl4KNgQpe9Mo0bsRQbGnREZP/CMcI8sl1Ilir3qc7wq?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: f94fa707-1157-4ad7-8286-08dab9265651
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:52:33.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSm0uioyt0q8jPEKdQRR/gLpHsVgpnY6Sg5I7kF06x/Ej1idAU6O4QK+Grqnlr8Pl+ofsHaHpGBzpYJdxzoIzta25lK3n9/lU04fLSGr+2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P189MB0602
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

This patch series introduces a couple of changes to improve SCTP multihoming support when running behind NAT.

An SCTP association having multiple alternative paths, will have different IP addreses but will still have to use the same SCTP port. This means all the paths that have an NAT/middlebox will have to co-ordinate and use the same source port after SNAT.
This patch series introduces a sysctl to disable source port randomization.

An SCTP endpoint is allowed to use alternative paths during the lifetime of an association. This makes it hard to write a stateful SCTP connection tracking module. This patch series adds a new conntrack state DATA_SENT that will be triggered on receiving a DATA/SACK chunk on a new conntrack entry. This state behaves similar to the existing HEARTBEAT_SENT state.

Sriram Yagnaraman (2):
  netfilter: nf_ct_sctp: introduce no_random_port proc entry
  netfilter: nf_ct_sctp: add DATA_SENT conntrack state

 include/net/netns/conntrack.h                 |   1 +
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   1 +
 .../linux/netfilter/nfnetlink_cttimeout.h     |   1 +
 net/netfilter/nf_conntrack_proto_sctp.c       | 107 +++++++++++-------
 net/netfilter/nf_conntrack_standalone.c       |  21 ++++
 net/netfilter/nf_nat_core.c                   |   8 +-
 6 files changed, 95 insertions(+), 44 deletions(-)

-- 
2.34.1

