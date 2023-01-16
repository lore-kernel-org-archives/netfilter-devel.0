Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CE7C63797
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 09:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjAPJgN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 04:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjAPJgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 04:36:11 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B23418A9E
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 01:36:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGo9IqNMGgGscn9+UMdf98nCYK8irPrrzmmSpJfZtlyVY1ZENJMtbmVUsS/xxHzgdxpxS7UbnQ9neDAxAXQAAnzK8ji5yfrrZd+wlN4Fdz7JS5xIlwnvt0MpxWIKsA04lnXpXJ7D3BPK8CtEklNTV1o0Jz3Apj4ZLLt8ktN9CtULHogtolQS+5tq7sBiXHOYiLueDq4jJm4M5W9jhovLmk1BoS4rpb7WgZNjwiMC0/3oG45AfzreXL+bNXIBbcpqRAzc04B34/3ydEXCJuTfpHjaVCq49+64U3rJYAAYb9LFvPKqxJ1bawTlD+GK2uL5vLCMr5hoLBFQ5159wzl1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFSeYtW9TFJ6vMRTlNBpO+JPzm/7UvjDLT6RUKKofpc=;
 b=guxFlComb74N1O6zzDpeqhiG2dWMb54FjpmTB6w6K7io0eD0/J+pfJLoN8aWTmRk0L2wCvLRyzqUPG+d+tcOk4Fsy2AL9g9U/ZHap3SWV6OwTNgePCYnD5UXiy25KGQre2MMHH7pcl6WGeWmTx4BCoMbGGx/L/RF3IWBDb7t2y8zlQ8cfXnJo0pPfRO0qmApAlovdJP0eGMEhbinQOKzYSfeh9qncqIqU53SsLelwV7DJgO+7VrxBjHuPMAhY5QrDmH3P0tHnbb7w/g28i8tH852h+0hctTGA4wxERWPSu81aX+jkoyS7nKJS7plD+XK6LOZcesUkcS6SvLmmVtXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFSeYtW9TFJ6vMRTlNBpO+JPzm/7UvjDLT6RUKKofpc=;
 b=floRbDcMFumR1zm8rrZ2am0yB3LrEwH7uAKtbTY7f+YIllHHw0hmuxRVun2lYCMTUHTssXBjiYyL1ZncEwfBTSTR3ED7nAQQZ1ahvLtwKZl82PIzcMEYjm3Um3We+JWncJ3r7rTN6wnkIhgINWAuC6IyGeV/tQaaaPMgJEFSUE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB1012.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 09:36:01 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 09:36:01 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 0/3] sctp conntrack fixes
Date:   Mon, 16 Jan 2023 10:35:53 +0100
Message-Id: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0026.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::29) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB1012:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bafc572-b655-48f8-d086-08daf7a51425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ILmOQaB/Vdfzfa2nyz9uRoNYZrxSOFqm3Lwkzitpv0Z7LhGwUq4SpfNZUfcssLHXMYCtfdqJ5OORYuoOpK6Nxwc1+i84/FE4KcynrrSWlGPbuWuTwsxoP0Fd2PSXlpc9P6n31tIa6EB0+xuSPdcPg9g7ekVzsoCXZdU8RHXx/dKrhgZLCGO09/efOihKTtvvwn4UbFmobAIlMEVMadFz7Yo55GT1j8PeyXgjEW/9t5BgOfir5oTYH1y9IYblH4KTDlv9xd2PyMohrhcYOK+zKUFNTEch63fAoyOAh58z1tHBcuHqcvlsV03OXUQXGyXRRb4ud8xPcNflBmfvYNcnhr5+3YR+cQUSs0jh1WgPcJYm3wT2nbW9ZKRDq4ai5IunNQHgDzFHJRWXaRqVN6fHZCJlb6qeb3D//IcNCC55MM90NGAu/22VkTRavurR+ll8/2bhNLmQb6eoi6Z8OHV/fr6nae0omyOSbBszMop2rcAgNcJGXNh6UMH7sc+LaALZkBoin7+f3XRKP6/OInq2N+puWTFGhij/egI+G0urQK1JR2XI0prlWbkXI2y2OvkmIf/khSBZiqzdFPzh1otBBDTPQIezacS271EZqFUC+JbXO9rIrsBl6QbJIECI3Ac8Q6A3rNgeTq/uZaS/hfvhi520hDkGuPVG3v0EMejQqzMioWbFm7zLzhkBAX1FFKiTTrXBBwe9CpA97FvpeHI0CfssxZhaKP7PNMEIAQeapI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39830400003)(136003)(451199015)(6486002)(966005)(2906002)(83380400001)(478600001)(4744005)(86362001)(26005)(186003)(5660300002)(54906003)(6512007)(8936002)(36756003)(44832011)(38100700002)(1076003)(2616005)(6666004)(41300700001)(6506007)(4326008)(66946007)(70586007)(6916009)(66476007)(8676002)(66556008)(316002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m5YqceuMTe+bRhanPJLKkDI1bU429S2I84N17aaTimZ2JkEjW9ZlDG4WXoZm?=
 =?us-ascii?Q?Ux44bs85VvIcfqV/cj3C9xudvKg8494jT33+WWw7O8R+mhd0vQH/s06mixKf?=
 =?us-ascii?Q?EFR6LuTG2YoARSHKRVMJv/N4Np22jCVUX+qgzU4PADcY5b3JOi3M6gc/R5z0?=
 =?us-ascii?Q?Na1Ye3wbbZ5INnCW8DU0C1aQioSjnhCXURtRaerB0Kg1Wnui9dRWQAQM7VE8?=
 =?us-ascii?Q?BXg0BEvr2WfS7W+LTRGTvgolobjmlMdfLIlEqqR0JV5vBT2dz3FRv2I26/Du?=
 =?us-ascii?Q?/Qsu6ZrdOYkEzFvu8tqUgcP4+NEOp9OLaDC8PMV0Bmhq95mPuduiDAAwQYxq?=
 =?us-ascii?Q?WVS/ymrWmLx3wPsWKn1rVDbNVmH27HWm7azwx9BaXLtLXJ+OsyChxX1xDOr/?=
 =?us-ascii?Q?eHJhwKC3zebnZaKokUAxn1I9fFCENTW7XiJIJLy41T2Lb7u7sWRuaRC1kNMy?=
 =?us-ascii?Q?h5ST/t845O/rmq5NLg9RlF6r62Zin9agrKm9tvsBOX4qlagk04moPwVmB24a?=
 =?us-ascii?Q?0Dw9pMqI91p+Xot5E5yrk3N3QeGYlFGUEY0cVVd3VcKCGgVifJIyT6hX7Wl4?=
 =?us-ascii?Q?2iJUvt4AT8o40t1gRpTJOCOS5wLceTCAmDSk7WCabOCtNl4CbvDqIlZAQQl0?=
 =?us-ascii?Q?2+2hYmAm2u4czHCKuBBdksIWjscYW8kXfVLHBzZjE6AvTdRdqtqV6TdYcTEQ?=
 =?us-ascii?Q?Zy7P71vSY81Wni7rSDE5/TYPz4babnQPHx7+Tx4ufXvEtxNGSatCwlW0Mzhp?=
 =?us-ascii?Q?s7DEu1ZBNxr12a1YgnWRXxTAa527iv7lV7JVOqtpY8srQLUChoYJedtKnwx3?=
 =?us-ascii?Q?q2lqInTGs+1jdNodD60JaKPFxqLh7pUTjoZKiteQtcl7u9pPQTdk+wwfdiZN?=
 =?us-ascii?Q?wp3T7WE3EhOeHGcWCER8UY7ukXmpnDiJup2JFHpRURCnEm8y8P1fVoRt+lt7?=
 =?us-ascii?Q?iyyR3gtVIUYaFbeOdfobo+az4aD6OJlxSRVSZAtd2xgJnqj8f1ax3lc/BuPv?=
 =?us-ascii?Q?xfq4cf27edLdnqpKFPI0E7MgZWyofxiUedhX82tGElnj59Jq3Y0CdAdm98PL?=
 =?us-ascii?Q?kAb4uKdfmz2CpvxuBCxehH2WD2RWOqaJO6tV7xUjmz1IU7EbbQjAuSAxtFTq?=
 =?us-ascii?Q?EM48hIrYjY6A1hdl5tUSXBC5D+TmHej7T2Y5zxPq0C6c5+0RAoid2yfMtc0Y?=
 =?us-ascii?Q?1965obQp2gh+3l1umu1WTje83i5R6DLmIkpEPD8KV1WmqHoWmR2VHt1rkih9?=
 =?us-ascii?Q?ixDji8irtozFXvU5BeG4rgBqW1oxx8vxTUsLIaZrf1Kzl9ADinXMVW1XF/67?=
 =?us-ascii?Q?Ioucv+F5JooEziRPHXJ4gxsQ1Emh2+SyEi2xe4hI4vGwETOH51XPX7T6y1vc?=
 =?us-ascii?Q?kaIc6NKZ0HZY8QnMB8So5cE19/NTVZXtGFOvyoKrArGHnnnzuQzmzcKlvWBW?=
 =?us-ascii?Q?gsVII6NF+kaM1/Z3+JGSpWqnTItlNOriQzcgPNR+21rA6Ncq9Wt2ovFPB5Nf?=
 =?us-ascii?Q?zYE5lg9n6IZE6Z+fLIcGryqGnpYUi5hKw1LXIDrSmNpMR5Cp+4m//fm0FdHv?=
 =?us-ascii?Q?PaEEeP2Mr6jEinkNgZLhz9yKqz657hmptq92LW486FLVogOM+tezdrNNTn9p?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bafc572-b655-48f8-d086-08daf7a51425
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 09:36:00.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pb9Ux1gutHLxEWeUgM7SpiLrQ6QXDsmfN/F4t/+L7lrxqtBh0gZc0kVoRJVevAmgz2BJJ9pCeMcN06cH7FIB3j+BavaJUveomDf6soiZyAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB1012
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A less diruptive change as opposed to below RFC patch:
https://lore.kernel.org/netfilter-devel/20230104113143.21769-1-sriram.yagnaraman@est.tech/

This contains a couple of bug fixes to existing bugs that were found
during the review of the above patch series, and also a patch that
unifies the ESTABLISHED states for primary and secondary paths.

Sriram Yagnaraman (3):
  netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
  netfilter: conntrack: fix bug in for_each_sctp_chunk
  netfilter: conntrack: unify established states for SCTP paths

 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   4 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |   4 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 119 +++++++++---------
 net/netfilter/nf_conntrack_standalone.c       |  16 ---
 4 files changed, 60 insertions(+), 83 deletions(-)

-- 
2.34.1

