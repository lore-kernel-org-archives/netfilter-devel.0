Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1647FC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EADDA61132
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhDPEMb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 00:12:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25139 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234757AbhDPEMb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 00:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618546326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=o/YzCjEEllwxDNOLVZHsDxl+3/qLEF5CETPjOiwZGVU=;
        b=eXAHIoLVorYmVZIrIgXrmypMMpm/GSXR1xttwGwJujvir3h+cCK6ARi7zrcxB0m8AFxvDd
        W2/ZCNmmj2m0UzCtyAcn+bj37YMgRNenz61x1t9jlRj09c9BMFrQoAunNKGC06v2I7brsp
        5kSTcZmGN4YqGXmDKEBHaUrmBMzdGKA=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-uaEemktwOai4g2YYgV_wnQ-1; Fri, 16 Apr 2021 06:12:05 +0200
X-MC-Unique: uaEemktwOai4g2YYgV_wnQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGNcHpqsQWKvrk25IPt07gk/Gmic7lVTk07YlXW2utRVYgEEZDTpt6UCxvCTxNgh1qaSZBTjooNAeh6V2vKnUsTmUF/MrSoB+q4mwvgiPLDmL+9qm9sXaRGwbA1vyGV2JsqEGYMxLeymfize9/dcBe2lWEqEdoBZ1N4hz4cFqYiS6wgakv7Q967eMPOVh0FKHd9dEziDNlPAWKt5Fsc9EGCYRIAQaKsQdPgQHqMgCVjA7gjmglOR9IoXGV31ZwUZi66dBv+XfjuqWi6rnK/K7RdsMCimiyZqqWz/S9GBcKZ07jp6JMSsaieVYwzVIWVrMq6/3kbyCN5e+wT5FsInCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6dDgZ+bMlS1ZQI6vsO08wzTyzKIfECo04lpjqwWIgs=;
 b=XDu42lOTgK8c2cb2aAZ06V51YRDfcrNd4CXNmjea2ZXIOeOldmBPNjpFJhVsc2P3Zr8xixuKOiXPF2jaoZ9uydq3zwkfBVN4Q/Pwk4L0Z706BLRlxi2YTDbmdYZ2K3SqMny/JUIPgw6ZlWqUsbz2xdX6k2/sbaQ52+dL9A1sfKOmQvn7TNDerPuOBN6q8h6UrQZlhPy2jSFjrMmQ8+iZ2/mRfUk415Rd0knF3XUNxqWAYOit/55j8P+b4LR/7vt1Kav8TBrB03+FaBnVOnzv8/KsYUA3FGN5PMOS1+vbYu6NmzNe7HSDNfv+zpPI612dlvyShlpymMbahXm8HSuSLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR04MB6991.eurprd04.prod.outlook.com (2603:10a6:803:12d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 04:12:03 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 04:12:03 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
CC:     sflees@suse.de, firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH v2 0/2] Two fixes related to '--concurrent'
Date:   Fri, 16 Apr 2021 12:11:39 +0800
Message-ID: <20210416041141.27891-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.189.239]
X-ClientProxiedBy: HK2PR02CA0152.apcprd02.prod.outlook.com
 (2603:1096:201:1f::12) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.189.239) by HK2PR02CA0152.apcprd02.prod.outlook.com (2603:1096:201:1f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 04:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae070ec0-4aba-4187-a265-08d9008dc9dd
X-MS-TrafficTypeDiagnostic: VI1PR04MB6991:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69913F57647B7F12DD62C5D9884C9@VI1PR04MB6991.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17fY77nU34ir0+OocADLISXSNt0YIPQ+Omuv8eD9LPbhleOPFrH3ORse/Ua+R0DdZ1HL1Hta8pnv2GQNUnvUzxKbq/v8fxGJIZjVajJNPbIaWNiNMAJwoZFZpWsFoHQBeKYt0lVgQ2D0vFykUQ3ZUpS7oXBAO4HAWtjfIPi5VbDmZu0f55f5kBrxeVlVuABA4wT4LWdkYNALA3K+p2yReD7YcoGJaG6ah8E5pCjmuE9ga1BSsJ9LHpZeCOnEJayisSeiOO3xWwE0MtXWUhKw5Ve8Yum8h0VL/4TjTz26UJTkqXiA1VI+L/xU05822a/8lSV8ihr66eFes864HoQnyqczbqkm7qIr+Ej4MCAy8NJXFNUSEhHLUGXZHtb+MFvHZosz1pd02ZqWGoQAzeU20wFaZRNHrJWcz9q2EvwxT3cUEpAB2CQZ0L/XV5LnGUILMFpCHKwe/crmmWM2FBW4mBzfeilIauai70Gv14dNUt7YaTf8vEbtt5WFPDyMeXT+v6zxzkXCzqz1wdR+F/oAjIIHXeAu9+BgTIjThn/plwEA/p1q9Mez1Vncqqrqfq80W+E9lGqEja+KgEg9hEe5fHzGxGewupHv0Qi8MiLruwZCiDYQYzB5AwPdFg0P5M/3zz+Bya05+0dJdfl5TF2irgwK1uNVl49VWmOXbp7RKB7yRsFxbD9/d9KN7jLCpVC3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(2906002)(107886003)(6486002)(44832011)(6512007)(316002)(2616005)(52116002)(4326008)(86362001)(66476007)(956004)(6506007)(186003)(5660300002)(4744005)(16526019)(8936002)(66946007)(36756003)(66556008)(478600001)(38100700002)(1076003)(69590400012)(38350700002)(8676002)(83380400001)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+iRyv9rbP+1mR8ipyKJpv8SCUiJIDDBFXyx6+xLpBAM575xYMi7+g3xvrHTu?=
 =?us-ascii?Q?PGPvrzMHFDCsDsNWO/plEGwTNxiDmMFRezCM9OmdVM/MbecWxqAUrKOAlZWE?=
 =?us-ascii?Q?KaOVlE/I6Njh7j/SM0/tvLS9eln9rr8DTYEGsx6HOcdqS8T4dVzNtA5KO2Ww?=
 =?us-ascii?Q?LK9n+LdxewB/EoNLYuNUoDB7/UJtcKkIMAIimaWxmAUyJvw1a3OJOiRyPkDd?=
 =?us-ascii?Q?ZKN3ukSWm3/OPG0i35BLkFRKhvwcwZMNdxOflivSXSj7vYd5hPjsydoGu4/0?=
 =?us-ascii?Q?x3vhmoXZL69jVomUPScNPytfxxxliNYJB3GPsx7X4W66bGN6FeSlGD2I6pwV?=
 =?us-ascii?Q?TWlqbF3zK2EUb3GngMYXcGNmWrfIx2YiIdgTT1CmmjwkP/cBEimtp6AzXyUe?=
 =?us-ascii?Q?ytEtZlMhu0IuCfCHHFTWQzSlrLXMJlTiry31con+zWd+VRQhfa9mjQDRxREV?=
 =?us-ascii?Q?4mWwyIAAi0ye2dl64pj8ViLgKAAbfhe8T9OuhU5PCyeN2aStz358XkX+cAej?=
 =?us-ascii?Q?OTkThZLkWmsJxfopz1lZY6xPNvYJ0yqPknykSNmdg/Pl9PlNh2NqEm66R63/?=
 =?us-ascii?Q?wOPGfXzZK7hBh+UX8WczX71ksnPuJDZTJaE4r5eND6eK5QKF9OLnFFfsddmI?=
 =?us-ascii?Q?oLWoDzqFRRND2W8nk30ucwj+1vrE4Bf1MLIAH9Wrzo0Yx1FAVtF9ysvYL9PA?=
 =?us-ascii?Q?+wvhPubw78lPcSiv8I4QJG/m4Fcp6ZMybK/MByLah2eA4nacvyeTDXD3Bo5A?=
 =?us-ascii?Q?n9m0QDd6s6UVUdstyTZWRz1xX+uw9Vo8035HWrWBBGu/YJ+uLA2aiYsQJzgb?=
 =?us-ascii?Q?pOkJg7bjo3sfaz5zeMfb/XPrTk11LKozdvrPH68db3bH51EqYAGMRe9bbg8G?=
 =?us-ascii?Q?77ul8zq31MxK2OXMPqFyuvcy99hqeI+9ori21r47p+4O3RCmsCF93B9B/XZQ?=
 =?us-ascii?Q?4sYMk/Rm1QGAk+8YtXnqV2BRhMJpWZTqQd/kWZ0ov/xM274zeUvVwzZP+T7x?=
 =?us-ascii?Q?bKiBmrckDjJIfdsra3xSL66b/TnjxLr/ckkryyBIp9yexWn6wrel3bHd87F3?=
 =?us-ascii?Q?2snPo013R6zHzaXzRQ3PwvmRSUvbJejak7kfRmLgyB2AldoHZR6Ad6C3M8Ux?=
 =?us-ascii?Q?R8a3nSLeRcZ06gAF9iHpDUbqTLJUSVovwggJfKBJDGpGy2pf86NaYTdUrFwv?=
 =?us-ascii?Q?LdIlopvOSo2+xrOQBP1vNOS59NA8lzAjlm89H+cJKoLW0y9KeFy0blOqkZIj?=
 =?us-ascii?Q?Vd6qqXFzn7pJpeIArSbM01AMTOqQmv8geD2vk2ERnsYBruIPGAcruv/Vd5H/?=
 =?us-ascii?Q?HRn+HgwQqocSjMYzebq9V25K?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae070ec0-4aba-4187-a265-08d9008dc9dd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 04:12:03.2386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrCM7owQ3xnCviF1c7UYgD0nzYiXkMKGiz8oQdbks1pPoxZixN1cnz1iz4TuxSqt1l7WBF2nmxHImhCnF+I88A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6991
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed two problems related to '--concurrent'.

v2:
  Simply print an error message suggested by Pablo Neira Ayuso.

Firo Yang (2):
  libebtc: Fix an issue that '--concurrent' doesn't work with NFS
  ebtables: Spewing an error if --concurrent isn't first argument

 ebtables.c | 2 ++
 libebtc.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--=20
2.30.2

