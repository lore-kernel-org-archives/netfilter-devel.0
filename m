Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4924C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 14:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4152071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 14:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="JUZ0m4Cy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403916AbgEYOAa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 10:00:30 -0400
Received: from mail-eopbgr80118.outbound.protection.outlook.com ([40.107.8.118]:31246
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403869AbgEYOA2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 10:00:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQ/netXxniIqlrna1uH+YY7iHhXfpu+7IhBW5Ymq4wPg9cPi+1XzWUklXyvA4+8mNRjc3mscOTZ9nzZCOkmPjYnBo+DMtZpX8iBHq2JDHmNFpR/MFCcSQ7k+BOQTMFdlWNmAaOX6r3u3ZNsBcWhe4twx6sQR5LFydSjiZtNEJ+i8QpTuaGnZ+PgLLj21aQHBc4LJMVKz9J9z091+LA/nlXyfT7DZlPXOR4YLMFk8AhQgb7WdhCDh+yzaPyvqMCGnvxomQKn+M5k5cAx2L+Fda4WRyJFUdV/xPttjRXi8ASXRkkHUyJWBoHapCHeLWK4LP1DiEbbaNPRZfAT0ZpSdGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xigQnclWjhQqMZwe3uGu2KYLISmM7Bw5VuhFWpHuKW0=;
 b=fqYPNW9rYp8hUbsAgVU4v06USzUKxH+13HjinfS8+0nh/R+EE4u7iTQUF7gHkEP5Fki6Pa5o4k0xxKxFOk27R1xn7BtLLzGtzAqnxy4GTaBkzckV3dchllI0M2Nucw2dnDC8g4StCmMSa22TenGwNzEnlxGJLN2zq1YejhSgCDLb7BQ4a15d7gsg0iF7yRxSkB52FABHgXI8wXTZC7Yf0ATTMjhe4h3XMwvJwS4tRIr30BC5cA3/l0Uy5SqG+GevkAnkcPNWp5RtLoa4elva9i3kxk104ncXOb6QNa+in7f0SXGQeZY5e9gK71Rl6VOlDVyJGF+mL5sHpquB0H2JoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xigQnclWjhQqMZwe3uGu2KYLISmM7Bw5VuhFWpHuKW0=;
 b=JUZ0m4CyXJ7sFM9bPIAdMDqQl3xKyijWVjwJquW6mv6FzXWQNmz1EEUE/OD2cPk+k5gw3ZgilHyIeWJpqyJCREN06yLHyiEnDsNeR3SWIBtH4LM+6e02tFW7VuDiGEKy7Ra3GT40tQgDPXrjjspjfKbPUexaDCoeZ6i1Pu8DWOY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com (2603:10a6:3:c7::11)
 by HE1PR0802MB2378.eurprd08.prod.outlook.com (2603:10a6:3:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 14:00:24 +0000
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7]) by HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7%11]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 14:00:24 +0000
Subject: Re: How to test the kernel netfilter logic?
To:     Stefano Brivio <sbrivio@redhat.com>
References: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
 <20200525145031.42afc130@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
From:   Konstantin Khorenko <khorenko@virtuozzo.com>
Message-ID: <8499b3da-fef3-2e42-289a-c824837d8ca3@virtuozzo.com>
Date:   Mon, 25 May 2020 17:00:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.6.0
In-Reply-To: <20200525145031.42afc130@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0302CA0031.eurprd03.prod.outlook.com
 (2603:10a6:205:2::44) To HE1PR0802MB2218.eurprd08.prod.outlook.com
 (2603:10a6:3:c7::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-e4ne.site (79.165.243.60) by AM4PR0302CA0031.eurprd03.prod.outlook.com (2603:10a6:205:2::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.20.3021.24 via Frontend Transport; Mon, 25 May 2020 14:00:23 +0000
X-Originating-IP: [79.165.243.60]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 978f24b5-e12b-4985-bd54-08d800b3f848
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2378:
X-Microsoft-Antispam-PRVS: <HE1PR0802MB2378AD2204C78B9B9293213BC8B30@HE1PR0802MB2378.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7byXfnt1X8PGnYwUJPO/GI+mQb6ThMa9al2X2B3/0TGZP8clICTKWVfnDYx1IRxpUfj1wBnmaGe85TrsJ97JVeTKnRrW4J49oCDxOkUhalcVd+wt3X872F5b+uQ7IaxCfuYBJoAdIWjAQeE9g3xnY7sJ6sZcDhbqHcp3Lw5u/En6jrB6ur5fTveAn2+G2qW/o7un9QX3pLh/u8qSMeZ/hRpc8zgZlfy8BQaIWg14ukNQJBMXKVhYVewxCBiqukrGMHEDn87iFU4jQiim4DmtlCEpGGQ/jC8HoO+ENtoirZ0MIeSWZk6xmJhauKFoc8CZ0qf2e/Jmy/Eiwe4gQyvUnGHIlA+su+wRFN08t7Y3JdAtufAfl1wWuV6cgNDgGNj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2218.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39840400004)(366004)(346002)(396003)(478600001)(53546011)(316002)(6506007)(4326008)(66556008)(66946007)(66476007)(52116002)(31686004)(86362001)(31696002)(956004)(16526019)(2616005)(8886007)(8936002)(2906002)(6486002)(26005)(6916009)(36756003)(186003)(4744005)(8676002)(5660300002)(6512007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hbn50dFej+iqOEG5VGWv/gDhoiyUp9pRiJhuAvU5VqVA7psMb4wobUwbT1lf2pvDUOBy2Nhrjr+Pe2sBwauSwU+PUmEfMPiX1lbo4LcmfGcFaz3Cl+TPOiKsdVDVGbOh4r+otWMBSL+zsERPxiG2moENUBMOpAo7Q6iysJt44zcolLupbk6b6uZ5EWkDWcfe6T2skHvDPVIr/X1j3g1BVCP854wWzlExmX0+Ydjq+PrbSLZ0QNH5kAIlpseZSxGfPfbOwt3i8Z58gu7wbqysQeVV6Gz7aQMhPOntMpEEeDXzecu629bSd8oVvpEBq8FE7Rav/FGS4w2q6W62zpcnhvDxLDlzAhJs+GnhUj/pKUr/e5OYe5u3nJSMrkMPeASh5D4RrMk5qs49bATiARgfNASiPgbocItLOxXjOf7zeao76pRqvxJOZoKRIuPB3hMMgphtMeAcXRJ9Wu/Gdxd3K2uC85fIVP9uZlDOjBL2azo=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978f24b5-e12b-4985-bd54-08d800b3f848
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 14:00:24.1026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RopHC/jCspMU2sHcu325XjYyo6+O5W228DjYPw7ZEp4KJ1rHuyV9E8fEFC0TecfYsrn2AziRCJjEu3t1PShG5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2378
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05/25/2020 03:50 PM, Stefano Brivio wrote:
> Hi Konstantin,
>
> On Mon, 25 May 2020 11:37:57 +0300
> Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
>
>> but did not find netfilter tests in kernel git repo as well.
>
> Have a look at tools/testing/selftests/netfilter/, some of the tests
> there actually send traffic and check the outcome.

Hi Stefano,

thank you very much for the answer!

Yes, you are right, i know about that place, i just thought it's just for "smoke" testing:
"iptables" and "nftables" repos have many more testcases (for add/del rules),
so i thought there is some additional place with similar very detailed tests for kernel part.

If not, well, it's great we have a least those! :)

Have a nice day!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team
