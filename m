Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01190C43460
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7D36101A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 04:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbhDAEIj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 00:08:39 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57508 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhDAEIK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 00:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617250088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MiAIAtqwl7nPmPrGRmzzdoAWwM70lr4SBkVJ/7UR6Ew=;
        b=Lf7COK/w+1XtYDd7AKitcWKf/EjI+YNIEgY5mM1btsZhlQKGVsz8FWoqSBOlvH54EIthZ7
        OGsK5f5Zr+ZnNtcdJCfgm3kKUSD4+VaL7XM14k+rjeTacF/gOG1VMPIztcgupVyIYKgo8P
        Om+v0wyi6ThquctDzzgm6D7w6tUvHQc=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2056.outbound.protection.outlook.com [104.47.8.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29--hGGlML5Nhu0L2M2zbgcdA-1; Thu, 01 Apr 2021 06:08:08 +0200
X-MC-Unique: -hGGlML5Nhu0L2M2zbgcdA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlCB/rk/rRTcLNLA5IcOwvNWea8NriVqs3Udy3hFtzBkDszRR/DjRCVjiZof+NHnxFLd1rlkpkvETlCOTioqCqvcTNrlU5V6EMmtu4q3weC8YtpG/dmvYAytuTzKoVyTeB3RgQleyoZOhnLbVH1xMgKnif3sppKo2L9R/Paytp/17V6/4gbSS7Qp52MXCobFkn43WrU4Ep4iOQSvI+0FDvmP225yNkKYL+zm6MUrNXqpbZX5tGe5NWi3oxgOT+389tWmzRqhdA+EcqC5ixvMHKUnlxf8NtuRBjfY41GsLImk6p2JyN0l6pK+Gl07goDo09YfY+Mz/7eAF3c/Sb6lrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ir00c7JoEBMrghWvgl9lWb2Zh/b5KWamyoVueKE3i4=;
 b=XBBZtfIrO+VCwA9+ZL3tkbHEAYQAN58MZaFsXk08gFNhFgzLvy/5Q9QmKWgj//DrUpERhWVNZpaU9AcbzZuq8uPbFTM0lAkEgpNsnkriOjrUV+bY3mEoVdjSqx5nYTLnblvL1DKcMfSJZOLIJkdINbTp3R5nd+8LhI5ztGt3g7thvJTkO/kcoC23iXaG6m1ATMbJfvBlHgTWqMUprCYPCKuxya1x7hsxR06wjBDG/wvitnSIl4upC7JNJvMsas4qZF0PTLf+tMQ5a0/NiQ3NTAKZanjueep1Jg7EOSgxfS0WleVc8sm5AYg1rHElRdkz+Jr+NI4ECgiOHAhz5t2xjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR0401MB2320.eurprd04.prod.outlook.com (2603:10a6:800:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 1 Apr
 2021 04:08:06 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb%7]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 04:08:06 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     netfilter-devel@vger.kernel.org
CC:     Firo Yang <firo.yang@suse.com>
Subject: [PATCH 0/2] Two fixes related to '--concurrent'.
Date:   Thu,  1 Apr 2021 12:07:39 +0800
Message-ID: <20210401040741.15672-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.130.191.126]
X-ClientProxiedBy: HK2PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:202:2::29) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (36.130.191.126) by HK2PR0401CA0019.apcprd04.prod.outlook.com (2603:1096:202:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 04:08:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b80f874-c877-4455-0412-08d8f4c3c07d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23201B6BDBF4DFD62FAC65E7887B9@VI1PR0401MB2320.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hqoXOikxnVJv9Y1X1wK2dCum+G4j7A2i7g+IjIKq7pEhzEfKNss7VDWiWuXu4y5KsQgFTqxpfk3aoAEdvLRokwk5F3J1R2qfsenzBsZKY7RTHsUdzTC3vya3OXFQ3F9jZwzGSNscvnHBjme5vE5hgYIZHMolmhZM0kjCGCLtvVn3sbrSpEKkFkhy1ZLgSv+DibgqUPhz3UJJC3lOnINkSuzPV9J9XeeYezcKGkhPWGYI/bZoV/ukU3rUrbtqoid28KofRhhi3/AYVpmUSikrZuK9IWx19ECaj+0BZvLvm+MjC4S/0RXPEt/08DbMrXGku2ugW1XPIo8dJBhpC6BVOKhLj9+i8xtpoVyMW3AzdHQUjfrR7n20xUwPffJ/wdaGd2oyYcVWaLfwJIIs+2Vu/FWylsKEqZwpzZTE1IRzNUxBaenou+ORDGFA11DUljjhVtKjvjZztK+QRlqgGgYNN8h/rnF32whWCEczglsXWPTGh2WISC8UwJi/VGy6npBokMDH2gYdimA2yTaFCJzcQxzsvCbFjWNoZHnedi/IiFGzqYDCB7I+ewIvY9nIS2wNkPf59SDEjSisHQkEE20hdKoWOXLTnmF/5IVuXUeiJoM2ufxuXPeVebGk30QEKxgCj7SpAtds+1aRLN7FCGcO3jSZxNzccztMKu1ulvp7/TY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(44832011)(16526019)(956004)(107886003)(66476007)(26005)(4326008)(2616005)(6916009)(5660300002)(6506007)(52116002)(38100700001)(4744005)(186003)(8936002)(1076003)(66556008)(6512007)(86362001)(83380400001)(6486002)(66946007)(8676002)(478600001)(2906002)(6666004)(36756003)(69590400012)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n5vMWfICeEN369koe+bqaZl1AZ+TbkLL/SS1vQRg8Xx9wgY3JDJ0DqB67+Vs?=
 =?us-ascii?Q?18hsh3Rj02xOXjnk8T3ud10Vj4dinkbBzktZ5i2Koer+2GxHBlSh+ahfcnm6?=
 =?us-ascii?Q?8xeIo87ooTSYMhq7GaWAb/D93rsgdaODMCV8SAs7S9tWYJHUXKuE8FasgUDu?=
 =?us-ascii?Q?Pem5w5tCJ2qLh5bbPPMTDKaM1S1GSuleib3X83aXTNRuVDMqeRzzILH95bXA?=
 =?us-ascii?Q?mM4HsDv/VzSKxbejKhRBctSBE9TzgWlMuHWgKOFZa7UxdudTBiBrU4JhDEHl?=
 =?us-ascii?Q?432qekl5EKmbEKzawHwDVSm4Iifym1QrXWxVAtzC5xfMNH4CR0CCIvb0iK4w?=
 =?us-ascii?Q?kw+w5n4HetPBNOrygCVNrYkUIoCEkE/DEiYjPlL+QMIB6t2dPxCRf6z2XZNf?=
 =?us-ascii?Q?ebVlhwPQOLu3kUHDD3nk2lQWSaeMPxpt5DLx3Mdc/LGB9DwtSagmY6ekolqL?=
 =?us-ascii?Q?CS8NQwfi3MpIEllK08CjI+GvJ/T4QMyoYTRnrIA3vaKIM/aLzImIk9L93peY?=
 =?us-ascii?Q?8O50K6S4SHWWGPVAMH/3t9jjHH36leyZItuuXZpLMhkSv024oLXirSrmMD9I?=
 =?us-ascii?Q?dmwKhseiOB806KdXBowGXsmi6TNNGHf2g9Ps2zOqwQrkTSJXqn13JhL6+9Mo?=
 =?us-ascii?Q?z99wa1U1qxZrq89FKrW6VVRtUX1rV+qBrc09lrb0cvwPxrMEBqRjT02E0Syg?=
 =?us-ascii?Q?Mqv8er4q7Zteylierh3NqCadw4Sq1AZGkVs5iJVvh7l41gWjD0+79xlwSoUB?=
 =?us-ascii?Q?mT4b72bFred2EiJ4YXSzTehgKFuGIcPsqJNeoEiYTHNIJ3eb+faKShRg9Cv0?=
 =?us-ascii?Q?YVagG86vj1Oku1SgZQSsnQ/wTFkRkK9VFU/d6K7uPLOB1QTShpuLjs/qRwCS?=
 =?us-ascii?Q?TmcLIx0wgX+ID8ji5C1MgQ/Sm2wiPoFAC4mpXXe5+khqAMVhq5cew7uulGxa?=
 =?us-ascii?Q?W3wJdQM/Am/L5z2WlfpI/F8/Hkxv6usDE5+M0BfLGgv0pZ7KoJtGZyQerk47?=
 =?us-ascii?Q?lgQsNI7P92JKv0xLt5DkoG2uGpPCl6qiCFtd/HcAc0kDgfxLHZchrjYeArS6?=
 =?us-ascii?Q?YBvja8gYY559h7XxG7IaMGMkq/vTB9ZdJz2mNnt9RsKPvkZDJkQdQRzheyFH?=
 =?us-ascii?Q?3JSB3Ri5gFk/GruvCu5qktYXgcPwd+74W4aIDQnVBjnkeaGF6WroETzpC+Z1?=
 =?us-ascii?Q?urwO+WvjmbXSo2eOe/TwfWmOPxHSnLlptbUITlFjPbWLJkZJkGHmflxZukvY?=
 =?us-ascii?Q?vCSOrvkgkAqwTAPWPHRttK6XfZYV3BJQAm4OMNgjPWnqizmXkbdjmw9q5Dzt?=
 =?us-ascii?Q?y2MeQ9ylFdCEd0S5WGZbi5QH?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b80f874-c877-4455-0412-08d8f4c3c07d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 04:08:06.2251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jClitc+v2ZjbYoBvFhIKWTP39Q2uhXf86j40enpnizTJsMkXGdxmoZiwXL+0SO5th/FwqJste6cncnMo/9JeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2320
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed two problems related to '--concurrent'.

Firo Yang (2):
  ebtables: processing '--concurrent' beofore other arguments
  libebtc: Fix an issue that '--concurrent' doesn't work with NFS

 ebtables.c | 22 +++++++++++++++++++---
 libebtc.c  |  2 +-
 2 files changed, 20 insertions(+), 4 deletions(-)


base-commit: 46eb78ff358724f5addf14e45f2cfc31542ede3c
--=20
2.30.2

