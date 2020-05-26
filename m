Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C11C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 09:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA730205CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 09:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="r7D5jlda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgEZJDy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 05:03:54 -0400
Received: from mail-eopbgr80130.outbound.protection.outlook.com ([40.107.8.130]:38752
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731599AbgEZJDy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 05:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8t3BYWk1KtJye8BJn/9cru2sUy0SwYryDvtd1LIqPYaaRjWVuKF8rXT2HJ/Jfcp4bzRXnGEsZpY3pKm0H3lTcMAoITXb3NeGBRGstz8pYOfG5AdfqdqC4eIxMfLKRtDdLvqrH2rnjqKrALTgKdMqeYmdWs+/EbrTrbLfPu6jIhz6O71tdYOuhz4rXr8N4KCDYET3SelvbNFWrFPCqZK7R2j0SEWwpRK9sVbzNSGvkgJnx4fgBtZT4gqMW2YCYNtJEqBAawg65vHmwe8CJkupD+EjGl/PmcEk3vFgQYyob6JSUrPnGHNblaHcvfNBnXBmU1EM3CI2m7qLoL+/qkPiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxKTi9ZSZ9qh+kf1AxjIrduYjgpRzG/1xOw+fyOA9J4=;
 b=nEFTZ4sCZJRsmEKHqOZpszOMo0AlfgCLTyXgpXsqx+UWm+ey8Gg6YmNHumgV9ykyCMXONngyhnjWNy+xj5fzSyr61yWC9TC+K9BcbrynL1KDu6n3STmfdcMhWh9iguAnozQ5YloXZCUHhf5EGytINsfdcfLE63yuYRA+SgzgXvX1/61UGBp4VqDO62l5EqZoC6TtwEt6XJn/NVBXK8ayXONYq1yz56OStqX4mAkROhal43mfIBAdOI2WZnPpQJlU8mrEk6KDYfU6cYM7PYUVZgqd5osx2hEgb3vjAUq7eJl2kN8KGo0VRgoBY/Xghr+N5GHwvkIiFW/o6mDQ027B2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxKTi9ZSZ9qh+kf1AxjIrduYjgpRzG/1xOw+fyOA9J4=;
 b=r7D5jldaO9VCCxKItB3fXlgGkzgbohtGVaEGPIiJ5VFJVqls2DvVTfx7FaWGjuqE5Z/KYJfSthOnao2LbsC1yAF8jNS3cg5PioLhwzio0xYi8XZTd9hx37gx8kZfW9/OnQfkKv+h2uKU52NZq+tJfSf8lQQD4VV5oCjXcVStur0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com (2603:10a6:3:c7::11)
 by HE1PR0802MB2298.eurprd08.prod.outlook.com (2603:10a6:3:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:03:51 +0000
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7]) by HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7%11]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:03:51 +0000
Subject: Re: How to test the kernel netfilter logic?
To:     Stefano Brivio <sbrivio@redhat.com>
References: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
 <20200525145031.42afc130@redhat.com>
 <8499b3da-fef3-2e42-289a-c824837d8ca3@virtuozzo.com>
 <20200526011213.37df67a1@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
From:   Konstantin Khorenko <khorenko@virtuozzo.com>
Message-ID: <4cf62529-aa5b-dedc-136e-15d76c2ff597@virtuozzo.com>
Date:   Tue, 26 May 2020 12:03:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.6.0
In-Reply-To: <20200526011213.37df67a1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To HE1PR0802MB2218.eurprd08.prod.outlook.com
 (2603:10a6:3:c7::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-e4ne.site (79.165.243.60) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 09:03:50 +0000
X-Originating-IP: [79.165.243.60]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e285861-5bac-4562-387f-08d80153b545
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2298:
X-Microsoft-Antispam-PRVS: <HE1PR0802MB2298AA4A0E23D063DDB923A5C8B00@HE1PR0802MB2298.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbRBTk407BljrmNC+RSIaEj4t9DEYNbjZcgxyvYU7b7FFemSIm7fMSVl6tcquzlkqtpyoXZGcs4MOT1BXkCmbxqi7WO9KmCsoB5+14J2IdQDf7E/aHwp+2HzWmHnfRvzCe+hb2m7eSVMMb5z+FmV8Ckp4l3N17dXUu8gm9lN6pqQyxXlx5dz+eKwNoCn9Lsf0SKjsISWKNQFXgxOZspI1NWRYLveEi6kkYf95gBYMcHNwbNC22FCyTiFoJ4AxB/6DH253mHRpjpr4GoeUmrH7Y6FfKYTDcrUTNWrFU6aV4PX8bNaJJPRfgi2MZL3YOh5ey5zHKKnAoYuAkbBx/rd2ac1KF9zTciHk4nYnTxPYBBRq+wpUMbfqcF9hHDrc9Re
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2218.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(956004)(2616005)(8936002)(66946007)(66476007)(8676002)(6486002)(66556008)(6916009)(478600001)(31696002)(36756003)(6512007)(31686004)(4326008)(2906002)(52116002)(86362001)(6506007)(4744005)(5660300002)(316002)(6666004)(8886007)(16526019)(26005)(186003)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cj4G1FRV7DECfD4EzCvFRGrUWaTpZBIofs3sKIx29RU0/nNBJsWJroE71ZZpK9hAwv40PtKFEc7+mkV/OxmbLqEOAbOXXlMNbGnf9+HBiiAGz/fiLy60nuWZVKzVNxP8ZzCi9miUwy6iL/JnyW0TwAjOYLjazNFjgFCpLpARvHq6XFeauRg08Y5MHl7GySOTogMUL5IUdllC6wTNrvrfknsQmcXoGPRXLJxBJB3c+RZkDpcziUaFEXHh5So/0GK/QiRZHFbIfFSZIORg9lbT4O67f8UOjuVrPeyTROO8LsAnMJNv8u2miZzJpAKScRp3HPq0dFsxgGpeiRBsNaXTPKqHBgANErft+o+mESx/s2qUvnT7NuJdTmLjrpbgVAwYBpdRhsIi1xrnnESJjB945lKMH/2O8cEqnqIwLvWoyyNJnBwMoL5Vj3nMwidtlT2JLD4tI8BVaPRZHAulJIjTRKifYaQ2AtJJyCEvc4/fzVWY8Ou4zM6kNiQHWx6WqQr/
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e285861-5bac-4562-387f-08d80153b545
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:03:51.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCnhD8KBTtQ733SXXlolyw+4la+IS5mV0B6cD2SYDQegLhP9yWaKvLYIDJ1F8X79yf5KDJFFDZWAjTCjergULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2298
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05/26/2020 02:12 AM, Stefano Brivio wrote:
>> Yes, you are right, i know about that place, i just thought it's just
>> for "smoke" testing:
>
> Well, I'd say it's a bit more than that, some tests there cover
> specific functionalities rather extensively.

Yes, i take it back, taking more closer look reveals those tests
are quite big in size and perform deep testing.
Not for all functionality surely, but still - very good! :)

Thank you once again!

--
Best regards,

Konstantin Khorenko
