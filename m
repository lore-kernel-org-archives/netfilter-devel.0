Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76510C38159
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjARMRG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjARMQY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:16:24 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2093.outbound.protection.outlook.com [40.107.21.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540744C23
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:39:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA//JANNH5tm3VdHBxX9J6DY0UKvaaA+e+NtRuGQ2npZKP0Ar4TVW2n1CLlJlXQ76cm7J1ixfSYfx1MG4lqEFjm9yNU/YJmfQtQx2rhQSTZtSSnVuAn/HHsTw4YpX7aZFXlugbMKClebQeOXjpJ0Xork6ND4LX1GSKHBrFRqut4JouqJLOCm0iU033o9W7x4cRTpk2Kocxptq5h7uUyZ+076C+2cHcwx/N2YV8Y5KkP6Da1dKa7o2NppYig+AqZ3DFcf2LWrV5Hxue3C3qvDncJS+AmaILRtaSr3HiJysmYfU1qCkddy2kI66+xAWpPP7khg2ljM/bRP3U6JngQiCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b6hxNnnk3D+knHeQ+uza9+hhV1CqM9kBvLmZdZYoeU=;
 b=AUtoTBcP4X3Z2asZRCnctZlNKowN3Axmup1mfeAKT64viy/WIW03meMb6z4+oSVv7Dzbbn44a4P8kuqy8boqdbUew7KcvNgxs1SVWZQDlho4XAT8Bz/20r8L7pmP/laC3axjaNSRABubRRjuoCgtyh67CyWHhg8daDZ7Y+bVrjWd4klEBdPBJ4g6JbXutDY1vGdF72a8gFFLc46yz9MizA/2A44o9M419ACpkAOXOU/3z7DGS0piwI7eAMcFgmwYoPzAdW1dJoKeb+5nwDtNN9KTl3ilxmgqErMYPmYWT2qcD34tfy7Vlk/DDewsPiXTy8eB/+YapzPlNMihY2kowg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5b6hxNnnk3D+knHeQ+uza9+hhV1CqM9kBvLmZdZYoeU=;
 b=Cf8Se7bZMNDX/ut5rzCpc/xA5KNuLyePdGD21FASao0nnZrvUBlty+LNE/S0naxmILv4NKBbk/y05u7rTfzxyf8GwJnajjFf97dgM0cW2CupKe0P3YZ6nn2NvRw/02mzsIPd1yfMimx58s0iLo/VdrDvwrblw6WsqXvcQsxwiXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM0P189MB0643.EURP189.PROD.OUTLOOK.COM (2603:10a6:208:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:39:00 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:39:00 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v3 0/4] sctp conntrack fixes
Date:   Wed, 18 Jan 2023 12:38:49 +0100
Message-Id: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0034.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::31) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM0P189MB0643:EE_
X-MS-Office365-Filtering-Correlation-Id: 690bb6da-bdad-4717-aefb-08daf948974f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJj14xnormW8JDX2gL8T6zCMQqP7L4m9ZfRqwd+3O9mcsDK1esVuwoJNC7cJhwta9ZzmL+ftkivw0mB7SC4yh5OBysvXecg7Lq7PQ/LkGDnnYeb+vhQWUBr9iFgSCSZk8RxC9hmY/HRXraUMR3/pJkVJzuju+2TMV3ufB+YH9L0QefYQ3b25+etWsWNZkg/e+EMhjTp6NvnU63Gfutu7sf2iuas/Rkf8+82zOi+eF9egCboCHm58jv8j69qPVgfJIDbXUg0vm/QnzxlehrwJ1gUAKN2F/0v4ooXP0tyvivncyI0/XEetYUcxpZOWf7WhdlFO2eRcMbnUuHaYAQ0X21pC5xW6xxc1D/DMYfA09c+GqU7A2Ana5Wi8MrqhzWvjrUYRdC+gaIPE5s4CU1pSx1CnfTUJ2aGaXIYYY6xswT/kGfmM9UDCf+415dAmeaJZbd8bUl43aTQwPvDysu1wKNg3gq+TGGa+cz+kUKZKW5i69a/RuaEMYP41aKMYPg+7U/NMChkJLyvBI6q0yj56OkkibJKaGK8NU76sEUefPSC3aYbkkS8KWZ+WlXtqmD0IS2taQK6aUpP9HBp3UuFBNl/NahAvWZv7By+IggxGKVL+y24WJmJDRZSVqlAwTMSss8Sk8GijSJfplsqgMYS+bHwIdOlq8907FUeIWRR9h6K839WeR1g9kxE+ESELaKjQoEzRI6ePkPZ3lN+ptvGAo9YulBMlfamz62XenZcB7+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(136003)(346002)(376002)(451199015)(66476007)(66946007)(26005)(6512007)(478600001)(186003)(8936002)(41300700001)(83380400001)(86362001)(44832011)(8676002)(4326008)(966005)(6486002)(36756003)(70586007)(5660300002)(66556008)(38100700002)(316002)(6506007)(2906002)(2616005)(6916009)(1076003)(54906003)(6666004)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QD18bPm4jx9mX2dgCzJmk56/ukLFNTvwfEdUImWjs5nwQSEDFAgt8Kn8qOTb?=
 =?us-ascii?Q?m1fhEOz3CD4D0nwMv0vULNDepnwoodAH0EXYZKV5kjR6A9jL6aKgQcHRT8bT?=
 =?us-ascii?Q?h8tiy70XE8GyGgtXUe4inrNJCZDdvv5KbGh8HaBYJH15AvMD0B5lM/mTIhGB?=
 =?us-ascii?Q?qU5/LJ9XbRNyd5DNLt+3D6oxFEU1cBP5yxjfF/4If2Ft6GyikEGLVQDpkeQh?=
 =?us-ascii?Q?Hmapg8Gl1SewhjDMpdnm7vJm6omXmmgy7sermR/KaREqbrE4XEVYBcUt517j?=
 =?us-ascii?Q?M9mjATJGDIA4iWtJHdwGmMn4vCPIvlVqOmfcYo7L0vsJPFrv2Ma/Cw3hmp+Z?=
 =?us-ascii?Q?ytfpFDR0URy+dmZ+wLH0VCqRTNw0V/rYoXxG+Kg+WruOStF2jp5sRsosVSsU?=
 =?us-ascii?Q?f+TWEeHPRqAhRKcQa4fFMlNcw2klIJCObFukyffS6K5UyKq259Kh6WpwQVat?=
 =?us-ascii?Q?WoJXzPk4kKJ+olLpBoDCr2whJQ3kyZFdJ34ZPkJq1rUQc+GKovs34cx2GnC8?=
 =?us-ascii?Q?b1PRC2YRhTgQCGMHMz0j5gXdWd3FL2SkY+oqgxu3PcYf/SuaU34bKbeAqoxd?=
 =?us-ascii?Q?BmJULaEy8KJjUSDDP0WLPd8qBVS59dzkFCAKaMk7q271IM4XVnNb/Te9rGNJ?=
 =?us-ascii?Q?pfOtk2xzevIVLL39w753hZNP6lcevctYpi+kumkxwxOd0rH0XIrHzCMefGJH?=
 =?us-ascii?Q?Pp8hZEXDX0jOeLYeme0QCr/gVHU91iVootgDHFgB9MJuPGrJtoAUalUM27Ov?=
 =?us-ascii?Q?q3hgtdGpn/fiyios0i2Y97NHSiIveu4xY5Ly2eThliYa85Hd0iLWOtI/Pa/4?=
 =?us-ascii?Q?oxWJf60ffcc83HSck6X220+pvrT2VQe3Xt6VeIEFXD0yBbdLMmSQvNONCDQ+?=
 =?us-ascii?Q?Eb1nt787YB+KfjtxvB+FIanSjT8mFshnmNtuf9hvt64GQLDKmrAbZTC5NbmU?=
 =?us-ascii?Q?YoLZZm2zKIabmkItPMMbtPaTsx49Jc0/ytzNrHrSZf70T/x4wZetwo4dxmZG?=
 =?us-ascii?Q?H5uXj7M2XJtWkgIUrF7JWX1Tg+Yyp3oJEMDl9UH1SZqNQnGJadqCvidDVBBI?=
 =?us-ascii?Q?UNTdN3xRb8ClNb1pcGhUn78w8ZyJOn5Xb+d86MeVYjdV4YK7XGw42Hquz4se?=
 =?us-ascii?Q?0JrMYQswDeFYnmpJNMYrSIM/ohpZgfP5NwVbFG2ohXy9AwMF/fLT2pljFh9S?=
 =?us-ascii?Q?vH7aaFgdX//ucMMJnetOMKJg+b1Rv1dqK2Q2bOqoVSkln56skQreLsIRt3up?=
 =?us-ascii?Q?bNZ4HJ0LNu+idBzLCAW2YmwHpEtRY1YZYHdjASGP15xfOZ/9/FwLX4v8fIEU?=
 =?us-ascii?Q?IrQg0lhjmKgoj+LdDT0Kuiyz5R2SBU6nkNaW0Nc1pXDdBPn6lKz0EoetJbVF?=
 =?us-ascii?Q?tzA+wMdw2e3wCIBTSKLhC173zzOleGUdqoFID67tCA0QevJ7fi2xtgcA7ZV2?=
 =?us-ascii?Q?AO1aitvhfymjiRiAwJXxOH1BuddCCHOfsN80WzoG+HrYUZIAlh0tMogizxAT?=
 =?us-ascii?Q?m3IYX7ClvxS1DIrY/Tob+g5gu6lI4SVvQpC83g0GmCAGsoz2EFK1tTMc3Xih?=
 =?us-ascii?Q?6Ghc66v9NWk1lrfkcruB5OnEOAiZrk5M+wru3GP3CjxvkwcA0BQILXQNQvhS?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 690bb6da-bdad-4717-aefb-08daf948974f
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:38:59.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwMA0bicYAtFfZx/FoOHKTHzDHp08yxsj0p9sxx1x9JF43nweRtuQDPGQ8PUiCKNxn0285EBgHMm4HX6javum56rm9HLc1/7Eg74BLIuKIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P189MB0643
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A less diruptive change as opposed to below RFC patch:
https://lore.kernel.org/netfilter-devel/20230104113143.21769-1-sriram.yagnaraman@est.tech/

This contains a couple of bug fixes to existing bugs that were found
during the review of the above patch series, and also a patch that
unifies the ESTABLISHED states for primary and secondary paths.

Changes since v2:
- Remove UAPI changes for DATA_SENT since it is only part of 6.1-rc

Changes since v1:
- Reverted bff3d0534804: DATA_SENT state
- Set assured bit if new state is ESTABLISHED and direction is reply,
  regardless of the old state. Paths established by HEARTBEAT also gets
  the assured bit.
- Update nf_conntrack_sysctl documentation

Sriram Yagnaraman (4):
  netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
  netfilter: conntrack: fix bug in for_each_sctp_chunk
  Revert "netfilter: conntrack: add sctp DATA_SENT state"
  netfilter: conntrack: unify established states for SCTP paths

 .../networking/nf_conntrack-sysctl.rst        |  10 +-
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   3 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |   3 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 159 ++++++++----------
 net/netfilter/nf_conntrack_standalone.c       |  16 --
 5 files changed, 73 insertions(+), 118 deletions(-)

-- 
2.34.1

