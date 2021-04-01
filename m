Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BE2C43460
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D08060BD3
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDAEJH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 00:09:07 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39791 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229790AbhDAEIM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 00:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617250091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6qAK0FVjWD8NNwOOLlksLYTaXD47VIeZO7KtIuqR1Lk=;
        b=NmqUP5bmplOk57kvzBv4jXnHtVRq+YSEGTw3TWF2UQYsJO5RC2C4vCEFWk1s6SuLFw0+av
        A+65jwIp/Co0M0W049RxaQJ1YeFfKoNGM+WRwoJKyi7pic6wt+TMCwM4jOSf26ZtJnvasF
        0ZbGEWWiv6wsSveksjlmYZ4Lxue/8Mo=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2056.outbound.protection.outlook.com [104.47.8.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-kXKC3nEzMJCVlPDWSCUsEg-1; Thu, 01 Apr 2021 06:08:10 +0200
X-MC-Unique: kXKC3nEzMJCVlPDWSCUsEg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMAGMo17gqFZXCbi4FQMmQqIKRsyWVTHch4PqbgC4OYEkCcq6/8x1XgvnPSBCVzqSU6mxzWHyyOfDtpRTyxSbD4x4JgW1GGwuYyG7oaEfQaxjk4fMWvx6uZ7e5gJsPTet1GlWSUHq7XcU4w602Th0MlETmA2KH0SV2gn0l8dmhPZP3+oAiKu0ULA2xHuOFM620hqSF+oSb3uya3ZXrISXsFj1gsaYj9vj5bZjUNtPa0RoV+nHxKxdFCJV6KbeGprzdGDuAcXuTNY1pk7riP9Ifm7X/0h87MHGy9LGU1r+EsI+VeSMvC5uXk4hjU/8pb28n/bR5QTlYLOJ3hpvCgp8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWSRZL+k4pXpQp1VecrPOs5CwHiNFTAQSLjV/uBNPvg=;
 b=S56P6Ue9FKuCFmybU+kFJUIhsWgtc/iT3Fm7P9bVKXMfsCUS+jaJOJEvff47MAq/L5qR+Pvf5uLu4dd+u5e3Y/iQowwKd36PZ4b6VP/0UAdea/BCqomBeyAJ2RlBjCY9K+i2Sv6aGQ4kJ+P0d+tCSeL1eW5h+cpIHSnO3G2hic7t5noeilJHKm1uvmyWZN5f2dWszpUgwMRg8L/hjuZaH0W55kZvSptT4Ec/PzMQdNWTMdIXsvEBj8Qf78lwUXji3DI+tG9e3/tZwJ19ZodpYQ5eyH6K2EhSUMZLZ+zDnnKuUnqdCAfn3qjKaClq8vF0n4nDWx8E+A3jBueN7EEOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR0401MB2320.eurprd04.prod.outlook.com (2603:10a6:800:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 1 Apr
 2021 04:08:10 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb%7]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 04:08:10 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     netfilter-devel@vger.kernel.org
CC:     Firo Yang <firo.yang@suse.com>
Subject: [PATCH 2/2] libebtc: Fix an issue that '--concurrent' doesn't work with NFS
Date:   Thu,  1 Apr 2021 12:07:41 +0800
Message-ID: <20210401040741.15672-3-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401040741.15672-1-firo.yang@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.191.126]
X-ClientProxiedBy: HK2PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:202:2::29) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.191.126) by HK2PR0401CA0019.apcprd04.prod.outlook.com (2603:1096:202:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 04:08:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bafdd344-33ca-4306-489c-08d8f4c3c2c1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23209067634F676AEB5A923F887B9@VI1PR0401MB2320.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:403;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3RQ36nAkOFa4LMjhVLJU5YLiFjry/NzG7R3AXLu6EpkkFY9M3f+6SVNzWtcSfEsFQlCLLWnnaJuuWtsRlgrSf3XtoH2Jz4y5SC3qdcryYdwOYVK3sYX6OKsSBHNyL1WVsVHKdMJchxxK2NancysAhB/cWZDeZbll+9hn8jfRWuGXsxYfTWaGATEJy+mguxToX5M42urxbnftD6KIw8BWtL1Z5Cp14bmrJFP2gYns/YoNrvBafQqlRtVqIrerrIlplt2aGqVCG6PDpNWRQw9SgO8zNtfwVJpSz4nkRpLo7aCrLrm4aaq5mJTpAdKk3C4cG6bKrZ4ayavwuBko0KbYVCFFFtPma64qJyQulQA/6LR4tiM7X3GwECqUlBbMl+oBBun2fPKuP0iTWMCFPJIW2ePjiNpsEMSSMTfSU8aOhuoczhNh5FUQyb3RErhnn6Tja6rRd09AjqbRKaDnPRPMTVrH1BIgTHAKp5EgvvlGoPGxBaJTOQrjwUoD7Imq4l3M1MyarAgngJbKfa58Y99mXgaBeaOnwj+05X7ZkJOfZsDrjQljAxWzTycB0dNCh4hEREZP9X2yKkqkK3Lq7u0oLU6ykWKMeL8Wnml2kI+dofNT+7fSWlFk8QJI6LfdnPssoywJ9N+9MJot2TFF4zaD7iEyl55iTbv21S1dz09m/XE1J0H3nay9vAgocJ/hbCc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(44832011)(16526019)(956004)(107886003)(66476007)(26005)(4326008)(2616005)(6916009)(5660300002)(6506007)(52116002)(38100700001)(186003)(8936002)(1076003)(66556008)(6512007)(86362001)(83380400001)(6486002)(66946007)(8676002)(478600001)(2906002)(6666004)(36756003)(69590400012)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sRn9SWu1PRV6VpVjKRHIQ+a11rXANiULBtGkpm0SrUdWOYfp/H7umNpgUvLH?=
 =?us-ascii?Q?Ppx91JazEhhNsOfQNW914wbRb0Q9eFbZC7FvMjtOQxvyRidhiF/np0YdGA8Y?=
 =?us-ascii?Q?Hb070gQSvSYf+T1BGWQn+FR+y5TUEjhTiWcSNccxYNFEzJGys8C6hWIX2kWv?=
 =?us-ascii?Q?S0/VxAZ/g++wBleSsh9tJVNRQnBwNppPGZDXEWqO5Gh1VfMibsrsEXPdl/Up?=
 =?us-ascii?Q?KeEvn2Z5t6iTQ6lgRDhHuA6TRa+XyXk8cJdyAlyZPYFgsEYk2R8UUFtTqGu1?=
 =?us-ascii?Q?5liekPhi7u5QZD+M+1P9OLNMkTQOPpMxLwuJCwCsANO0lJxooGmrLJhzFVQi?=
 =?us-ascii?Q?RgrhjUR6bRO9Nnelwd2uAftjhxLfkFLqAEMPd7TmPeY52xgCDA6J02bbaTfP?=
 =?us-ascii?Q?cBy+CIAdcepn9xRBrgLTsg+hU/ukaLbXeppRKErayAN+CKriDQ9BzslDqnrd?=
 =?us-ascii?Q?k22F5qJpjxvHmb4bQFQE07A7T/+YhLjP66gFqWAIPeHsus3ZtsAYWqXXb8C9?=
 =?us-ascii?Q?LA5zb0ddFvdJ/ZnotVBZBvZgdz+rQApGWxSIzg+DPMHwWTIpKhvf4WzriJHN?=
 =?us-ascii?Q?KV+CN9JbvDU6G3RnEb+3OntxCQ+ggbnRvCW6byms5bpa0TWATy4gCreGo53U?=
 =?us-ascii?Q?t6lyM8O0oet3bLVjtInUfpyye4nsC5FkKLuDtb9AFuEZhRmgmfCvh+UZD8Mr?=
 =?us-ascii?Q?VotkCeI8MoWjnAMcHAuw6/ZJmXXey+rSGJvVS0PPeftpoNc/Xzw1oJpxleOy?=
 =?us-ascii?Q?+/7sIa+9Xru4Lj2ZGMiJMMya1v43DNqXU1hllbCaazE4ZXglX9qlRRA0JoUN?=
 =?us-ascii?Q?A1Me4kBP78Q29M4TeJmFN+ThYbROlDiLqXRKq3IkMAhH0K4n7wdYgL3URZsC?=
 =?us-ascii?Q?OQ0kg/RurIoRBjN7ccf+fnFIId6jsafYPj1iVt+qnR3NoOJaHk+25UEXbKMr?=
 =?us-ascii?Q?j44XszLiU4FFVThpcDushl2agoBct3P4NKyXD02ScIh6QyP12D6Rn1D3/fjY?=
 =?us-ascii?Q?xaFKSADUU3Ml0Vm6MJP6pahg74veiX8sd1FTSTSUyf73gMebX48sX5PKqh62?=
 =?us-ascii?Q?u3adtvHJXpnOpXdodUgAbSFGYJwJiOWDk/qd9taVKQdPzXaIJHqFXa04rpFs?=
 =?us-ascii?Q?sI1paqBvnCSpTxjJzMKXBay5zl2Nn9Ar1lehR36q9bTGlrVD1/OtuKvw9Dp6?=
 =?us-ascii?Q?teKKEyviJzQ0ekCBsvDO6HtSCDmQHMmCOzgR41VzLmc1+UD4CEMDdea0hOZS?=
 =?us-ascii?Q?esFNc1ai3GK03JzBVQH9SSD/5Y0Uk/ufCjeV+d0vYqhi3yZyHN3oIUBxpiwG?=
 =?us-ascii?Q?rKBwm/LlUj1oZiXLKo1K1Lmp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafdd344-33ca-4306-489c-08d8f4c3c2c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 04:08:09.9540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VYiy6mkS9iylsbcFfgllvM9tQ21p7HMuvKoplhs5+xxxStk8bEgjinT0e1avsGHWqhykp6gd5US+rb//qSMhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2320
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Due to the following commit[1] from kernel, if '/var/lib/ebtables' was
mounted with a NFS filesystem, ebtables command will hit the following
error:
mount | grep nfs
x.x.x.x:/var/lib/ebtables on /var/lib/ebtables type nfs4 [...]
/usr/sbin/ebtables --concurrent -L
Trying to obtain lock /var/lib/ebtables/lock
Trying to obtain lock /var/lib/ebtables/lock
Trying to obtain lock /var/lib/ebtables/lock
Trying to obtain lock /var/lib/ebtables/lock
[...]

In order to fix this problem, add 'O_WRONLY' to match the requirement of
that kernel commit[1].

[1]: 55725513b5ef ("NFSv4: Ensure that we check lock exclusive/shared type =
against open modes")

Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 libebtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libebtc.c b/libebtc.c
index 1b058ef..112c307 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -144,7 +144,7 @@ static int lock_file()
 	int fd, try =3D 0;
=20
 retry:
-	fd =3D open(LOCKFILE, O_CREAT|O_CLOEXEC, 00600);
+	fd =3D open(LOCKFILE, O_CREAT|O_WRONLY|O_CLOEXEC, 00600);
 	if (fd < 0) {
 		if (try =3D=3D 1 || mkdir(dirname(pathbuf), 00700))
 			return -2;
--=20
2.30.2

