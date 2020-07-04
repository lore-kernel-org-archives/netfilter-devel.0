Return-Path: <SRS0=AjNT=AP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE06C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 04:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9222084C
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 04:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Kz4DMgfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgGDEx1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Jul 2020 00:53:27 -0400
Received: from mail-vi1eur05on2107.outbound.protection.outlook.com ([40.107.21.107]:34369
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgGDEx1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Jul 2020 00:53:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg71V+WOEhnuT7U44o1RtsLc90iRqymxHnzNnSIUsryLFqfcKdYJN2XPyC4SsfUrwT5N5+/9LqxjIirdHsO0m7Gv2p5C3OW+g75EJLStwunIcnnXLxP3UHHFNl2Gicegb02grqUVmNfa8FnKqhB+0iX800KlKh8x2KjTS1gfbK8v3KM/CpDR/HdnNt6pxTFg7XCpGDx9UzQgqcJiD7dVDo4kA89PRJ4CbcuJuJMnaZJM99acnrIK1RSLKZOOKE4fMJ3E018+3tx2wmN0lyVfwADhR4cZbHacvA+tvvo2YOn8UMRofI7oOFEffYWvu/hFWR1b4mfVygrX7oKNkp8Kbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lQ2Y2bUTvj6uQpS1SVxkKHZnwiPRCf5P2PRaXnVf3w=;
 b=NTVloCIMGKMwIu827tL4QxPc7DSugQA7c0fiimu1mW2lpQd799U2EJETrSnCiCiU7HIK/3JcUkfTpBpA8IK4aezanNPpqO709estcYJAsu89pynq270Z5tXyloIMLG0mqLfEvoMUlDO26tYxa8gMVflpgi/No1EbpyC4Q3VtTpWEojgCEoTY+Tv+DXBnZjYfoIOl5HsPB8Jfvny/XQaRDBYw8nSu9Lcar1fwMznp7LxDhZMSjaxuPk5zwEwP/qSItJeDCzxKo72NQhcNk6QylD+9ivRIbc4nQiUpMko3IiVagfwYgoV6osfKEC6sD3agSEr3klXj/JmaN0PpGgivaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lQ2Y2bUTvj6uQpS1SVxkKHZnwiPRCf5P2PRaXnVf3w=;
 b=Kz4DMgfdnRYD05Zv0mB/yOXugCMZFHBqZTQmHM0gIpjqgwHUWfQJHR/s7RHKzTflpfmSnNGQF9jArZ5W6hdqrP9AslMJKuW9i2DgYOPQjkla8yZTxr8G75JG2RxrztLwUXWmQRfiZSt+3Q1l2k2vlU7WLKkHDO87bIxg5/3bhjk=
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR0502MB3972.eurprd05.prod.outlook.com
 (2603:10a6:208:8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Sat, 4 Jul
 2020 04:53:23 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.029; Sat, 4 Jul 2020
 04:53:23 +0000
Date:   Sat, 4 Jul 2020 06:53:21 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] netfilter: Restore the CT mark in Flow Offload
Message-ID: <20200704045321.a66dptiwvvyxjy4o@SvensMacBookAir.sven.lan>
References: <20200601111209.fluj44n5utfoicko@SvensMacBookAir.sven.lan>
 <20200704001133.GA1023@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704001133.GA1023@salvia>
X-ClientProxiedBy: AM0PR02CA0077.eurprd02.prod.outlook.com
 (2603:10a6:208:154::18) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR02CA0077.eurprd02.prod.outlook.com (2603:10a6:208:154::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Sat, 4 Jul 2020 04:53:22 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c2dc399-8a52-4d89-ffc6-08d81fd62df9
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3972:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3972DC006AF1F1255AFAC1C5EF6B0@AM0PR0502MB3972.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0454444834
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNglrtKJGowXL1GeNhZBLcHAjQ3movXuIuI3gBIBxfSTIwUqrNfwa5O4+tBFOHh5nYpS/blB7d1EXVW50qjQ1h8r56KXDVYe0UdH2l1w5Se1wcHIYYriPG5qjSKLC+ChhI+UL2DeKXzTUUPqe+sT3r6mMsKqlZMco+GEb2hrcYaJmz5YtfgC4BzEVIRHt+pnnOpqLMOisZq7tiDG1hs2jqbEWdA85xg9Cc6SeVSLxS3J6diUenxXTpalh2ZlP/95VGEdQSQ3cBK7VkJ0cCpishbzcpdQTCCKSsoS87+bI6xQ7HlqU6c4qAcgrINevF4s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39830400003)(136003)(396003)(8676002)(6916009)(55016002)(956004)(9686003)(86362001)(8936002)(2906002)(316002)(83380400001)(508600001)(26005)(7696005)(52116002)(6506007)(186003)(4744005)(1076003)(16526019)(5660300002)(4326008)(66556008)(66476007)(66946007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZXxO1sPxftWQio4JRMxlj4fkAoefekMoogkM5wlbYPhYG7LHADehEYWVXoMrstBVHCgyywS2FDQpYD/3hgR+T99Mv48OtBRNVpVB2cukPRGg6dzfujl1p7fnLTjluJoLGY/yRiwFFqLiEHG5vzzAcI3+9NRH/oHxciUaEwCtb2X/6v+YAI0H1PQiFcPmB0Xyg6DDvrUKq9O4TzLYBtyGmsjrTK3CAPVtG2GPk0+M+wzR/UcShjx4tk8K3EltSqNQhRORsr1HuG6Z0C1TwsTRLagtic0yiBhv5cLP4rMkK6yQexCIezrUEU2R/agqsDizFpr6//Hp3DUSy0pAQp0Gr4f7/HFEqBZ27Z6UJBZSA01ApcLagvedZEYHTzjY/VG3LbdolemakczRpIaA0H0QfbGtBjzldfWzpzTppQshSykaQzrQ4ToAoui3dNgMvfjwq+fXVmtYi3g7rIbCEMoYZlD4UIdbR1LgqfUW/UrMZhgJR1jqE9Tw4ujmQF9T4AJa
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2dc399-8a52-4d89-ffc6-08d81fd62df9
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2020 04:53:23.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxVJgUEaAxQIBIQsVQj107MFPi9eqqqU1NngK28TJ11kLSN7c5SiazoiE5fW/y7IKiUWgQ++cV5cjYt8MHueNKHYyRKGHT9yMFWEYxxmEh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3972
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 04, 2020 at 02:11:33AM +0200, Pablo Neira Ayuso wrote:
> Hi Sven,
> 
> On Mon, Jun 01, 2020 at 01:12:09PM +0200, Sven Auhagen wrote:
> > The skb mark is often used in TC action at egress.
> > In order to have the skb mark set we can add it to the
> > skb when we do a flow offload lookup from the CT mark.
> 
> Thanks for your patch.
> 
> I can see a use case for this, however, enabling the skb->mark =
> ct->mark restoration is not very flexible.
> 
> Every time a default behaviour like this is introduced in the
> netfilter codebase, there is someone following up to request a toggle
> to enable / to disable it.

Hi Pablo,

I understand the argument.
Please disregard the patch in this case.

Best
Sven

