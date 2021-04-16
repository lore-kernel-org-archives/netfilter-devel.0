Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BE9C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94326121E
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Apr 2021 04:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhDPEMg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 00:12:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:21721 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234757AbhDPEMf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 00:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618546330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6qAK0FVjWD8NNwOOLlksLYTaXD47VIeZO7KtIuqR1Lk=;
        b=jfbKs6Jhh+04DsNedHuDu8GCekGw9z3Jz1yhhxGLtkO5sqY57SGmco6Vg/UbGgL3S5p9cb
        dwXQUusuW3BEShrWVF6oyl7baQtR3AIrBYKUptLIUf9NJVnZQRjDTBOW95PnyyaJby/sJt
        tRellhcLd+GHnmvedCjjklFOrTtuzNM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-4nbpLkoAPDW8TZuAlWfBsw-1; Fri, 16 Apr 2021 06:12:09 +0200
X-MC-Unique: 4nbpLkoAPDW8TZuAlWfBsw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4DThToZqLn1Lisj1Xw6W2AW5PkvjHBAzf61Uh+7CIs+E/oxFdGJnN8t40EdMiBqqiUJrlK57lnBZHNHpm3y0rkWgCvVmLXn1WuykQjLyGSgkn2GMNRpHPO18/G0pquANeCGu2wFpH9d5/f65lPWCl73ReH3gCwbGVluuZIVhqwmh7Ux6D5IyPwlwTcA38AHb4vhoodkMsvQNaVT7y45ytpL6T1nOCCXBfCQG+DCKPTsBzXYGWpNl4ccsNRXy3E+zodU60zYMZwgaDVb0sePtRIfeH6GkRtbbHRo6QuttJchMErbLlYeSZHOAcUO7enILyf4UVg6XQYu3GhlUKW+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWSRZL+k4pXpQp1VecrPOs5CwHiNFTAQSLjV/uBNPvg=;
 b=MazmsqS49ciCuhPMPkEwqZs+hfWmxOUvNAaMzcrAtJA/n2mBQ0vhm9thTwhmRebnsqE0fZpzNJ2E0K51yV8ErhmyXaDWeKP4X21LLo4pTQNOFIsfDJBDcYU+R0kwvfCDmfRACTnNbRebmciqGFonQh5nQi8MnCgYBquR0JgshBedd92tEVORhpbNTzanLv9OkCr80wir2HKd+dDm9qWoqFLfluFulPs3q9MW1xibINl0jmVXF/AMoUmazcv8Pd7vFF5+RbGJ9o1EtuB/H01edUXGRkLuiXklILD7a31uVNFsDAKAXyn/M+HJXdPAMjO1jweBq4rrXU0BG7yJgjO5Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR04MB6991.eurprd04.prod.outlook.com (2603:10a6:803:12d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 04:12:08 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::8b3:2975:72d7:de70%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 04:12:08 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
CC:     sflees@suse.de, firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH v2 1/2] libebtc: Fix an issue that '--concurrent' doesn't work with NFS
Date:   Fri, 16 Apr 2021 12:11:40 +0800
Message-ID: <20210416041141.27891-2-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416041141.27891-1-firo.yang@suse.com>
References: <20210416041141.27891-1-firo.yang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.189.239]
X-ClientProxiedBy: HK2PR02CA0152.apcprd02.prod.outlook.com
 (2603:1096:201:1f::12) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.189.239) by HK2PR02CA0152.apcprd02.prod.outlook.com (2603:1096:201:1f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 04:12:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f0b8293-4cff-4c08-69ba-08d9008dcd10
X-MS-TrafficTypeDiagnostic: VI1PR04MB6991:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB699195BF39C799F54C235E69884C9@VI1PR04MB6991.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:403;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ImdI3yHUohKMAZ4ig0TaV3Cw+fTvX1ZwVaIB/WPEGP0jsFoblW0/CK3RoxIZ1bzrqlm/2ZvAve25s37TKMO/ylgJWFXrRhob9PEoQglQ775fYvKie7xBSeXpshcKYxtpl4hJerZ3EUbc+/FCVHrp3NEnY3UKMJIfmaBSsEh48iopsyxl24TWT8NkPBFcANFxtQQ2aa/aDvosHyu5+/HX3dxYccmGJHNLvuGYVFk4QDG7jps6+G7odNlTS7/WCOfVRdr1rW2YmopAUv4a/bEo4yu1Fr7FLYXK3tAh1ggYfCyN/5+wAm/hE3Vd1nHmLw250ugZOo6QKjkYPTcNRtqb8LtsaLt1rP9urpRZ3Cugmu43HamTO50rnQJBJ/69fkVIcboorLeanZy00zkekuKant1mYdhXZ8mAwtvqGIysY5M4tB9Hu+LZtb3pe2ebbFdrj1Vr3n2IxC0w5pvCgL1eEXTjZB3l8rKjM4lSTEYDskfv9q0dml+aSPZxw8ImOgM69wWPe0Y4yXPQCRayXxUiV6dEnoPTDKg3etFsPI2rH6CYa04Ny5ypsIUMpup5XOnU0V9GSaKz5GBl68/3KIFoSo8Cb6WQmv74O9l4I3DOzlGVzVquHOl4YFob2JpTRZASmV5xl/xk+FLmPyo8eEaRFMtDMTa+SygrD4n6MiQYu1WyDI/NzO7yRhaILT9zyEgN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(2906002)(107886003)(6486002)(44832011)(6512007)(316002)(2616005)(52116002)(4326008)(86362001)(66476007)(956004)(6506007)(186003)(5660300002)(16526019)(8936002)(66946007)(36756003)(66556008)(478600001)(38100700002)(1076003)(69590400012)(38350700002)(8676002)(83380400001)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3NINHJpZBQhfBGoDk10gtmFAuu29PP0jEzyKpB/zbV3rmeUYkXeJxELRdQEy?=
 =?us-ascii?Q?0/dkVzvWFmJvZ8wCpZm7mxHEjapYNnbuAakd18Y/EC4ur+Q2QrlSAOlvreK2?=
 =?us-ascii?Q?nobeS78EbCTP/kOV6fRy+OzfdoBtkXJ3337HGD1unCTmY1/wHwnZ0uwzY91Z?=
 =?us-ascii?Q?BfFd0NxdWOwfibrrvhu282c6CowwSi8kFLdouPoTFvML6qNk0xBpQqFBwsZM?=
 =?us-ascii?Q?zC3G8jAUO9t8pBBK98oyKn8msv0m1rdoQaP/ASi+54Peb1Kb3Cq2A3Ri61Ww?=
 =?us-ascii?Q?Zab+ox+EfywdvZLw4doRPTLLVNS3mdH8W24J37FXcEYXIEXV5l67Of1Qv2bH?=
 =?us-ascii?Q?l2P0gA6xcaWk1OUjnBwRhd9VUgJJeueYTpISqA4yKtSy3bpU6sR9bWlvh5dF?=
 =?us-ascii?Q?aK4B8CbltXEh7mUrkHcePY7RgFeRpn1bTDWTBtaCeU5eO6wA64kGFTbVarGw?=
 =?us-ascii?Q?sq/hOgnoAUm7yk5CvnzUjTWLwib/gmQi1CAyRgUuPtVbxsqjEEMco9l440c7?=
 =?us-ascii?Q?thGjQGEo8w0ZWdQ/AMXc5ckjFrLRkLls/1QsuIna4NfjsrcqRavepzE7Mqgo?=
 =?us-ascii?Q?i84xzCMkGEat/EuGfN6Lk+79ZnAUm+uQYHRM7QoFnfb6WnxaKxPfNMyh6nQo?=
 =?us-ascii?Q?WzbA3ratY+tx/QFOYyVbAYtzTvug1Y4wLyaMUk5iJSFDOPQ8lkpH+LQLfeJi?=
 =?us-ascii?Q?GXTg3UCNJC+bVLYsFw8jwjEgveAi9UVoLlkM1ivnliRNuW2X3OAl1hd9xWdE?=
 =?us-ascii?Q?8QZAkspDoROBx+Ng17I3l9nhTPmC+SUFAVVSEFehxweMGZ9/6AeMAsk2IZms?=
 =?us-ascii?Q?/aUG8n3rj0QoJP14O2ACVLkn9Ler2QzD1NETC/MGcCsnGV4988njiVXA6jJ4?=
 =?us-ascii?Q?X6UJO5GTxryA5SmmzMRhfJ/jgFa2hCbdcWeJEuOpv5/CGeWVLruIOHquAfO9?=
 =?us-ascii?Q?3sUhn5BPnSl44G9HxgGBYf82pifxrT/8XWGOQmxBvDH2ULP6qu/q1vLOEZZ2?=
 =?us-ascii?Q?quytQFQsb842yMcA7neKz9m3CiLsp9YgW9tT1kKwpqBKMhZKqu7ZhkFxXmN3?=
 =?us-ascii?Q?ualm6lEleXyPF3ttmt+Y0AIgbDMpgSlrhEz+BE/JnbxUPy698VrhsSW8aYcy?=
 =?us-ascii?Q?I1Z//nW/L3z+eO7b1CWcCCGxoTijOhs57nnpcmCs/a39Red0xuQPxscAjIBU?=
 =?us-ascii?Q?8i2eG7q1+blJrZYPdPM5DRGM5E4Xolnpa9SnmCSupZjsv0SlKQsfNF0JiE3T?=
 =?us-ascii?Q?fKPuour5EvZs0tKmhAgzrcRHLeKsYizhBUNSfJYIlYdAXn40lDKv3P5WoUlZ?=
 =?us-ascii?Q?+mJIehmKJoqQBqCw7EBbe1d7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0b8293-4cff-4c08-69ba-08d9008dcd10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 04:12:08.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ovv9bPVVqqEBZnqRbWZ5aIRzyE/doMklbb0XWmADuOoMcvGiCLgOxGYwvRG0RMD9yYDOdO9S8jhsJwidEcYN8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6991
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

