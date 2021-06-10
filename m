Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080FCC47094
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 07:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB7D613AE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 07:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhFJHKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:10:19 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:44001
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229725AbhFJHKQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 03:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/dGu04DkXIsVXH7v7xpsQOik+q3k4uhH2MvsepDMvclQc1MwCDea8Yv9wnQpytaT6uK3HEqW7l8rwq4kk2T2Ng8HltV56u/4WIfs/9rUAUo1hPYCppUz0WCAS+hrnRESwbmNTO5rZx5Qz0u0EQqkKEEQ9v349shOOcsIOyOEsInR/qNf6K3g/c07M5W/ACCFnax2h+K+y5bH2eBxMMtzyx/UsqhwhwKCEvmRvGrt20pv6md80tsfGVH2gemtKAVDbYDZwwR3qyrEin56UIDVES9QOJsSzrt2xVZ/8qnSMfjTgk0Gds8VRkKwG5mT5RdZrGqvTtk2S23C6rDf9srFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd+1Jf07m5PQfgm8wLPEcUt4qXh73LNPzVmx4oYDpD8=;
 b=kDECAeQ2l5kZHoMvyAmQi//MBfSVDFkVK3ttRdY67ynSgSvS8IWmHw7lsvvTs+3QpmIHBF+Dzaiks8+zNbHpKWWKt4yy0w++Ov76wC5ktoj2ZuFUxdQsyj0xTbxT8QuYimm2WoHfnMkPW1uOK70k/FJFu8cBiSgkqB/0JfnC28orhKUo9E2TYVRhHriwGvUyxsYvXiXbb+0TCj+HByFxJYhhgpuCevDcGNXxmoaSll0ZsPzQPr4ns6cQEd7PgLC9vtDo5qG/e8biTQvWZFODgeZdd8qkXDiLVj0fYmutVK0xx/XaLVs2+f/6dGKejozDvpyPgyFxqjTm34rpC1c07w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd+1Jf07m5PQfgm8wLPEcUt4qXh73LNPzVmx4oYDpD8=;
 b=RdUdKegDvtB3z63OQxuEVeCIV7QnlZBEKlzU8mCg88N7Pv7ngfZLGLpjcpdcXcf4pzGXeEdbGeiC0BYgzdItXwyZAN2i8cFnAPKurhIkqyU4E1JVer1GPV6njDlsarise44iAG7cFd69riC48auNz47gwXCHOTGPaDvMa9viUNDjYU7uVXXy9719bwznb4x5iBWbaQplXo9ouBtwcqxpFMF9+18oKVDqFGy/3wYIassroWjMdSBAzBDRnhoem0lxKlAQgqtzqB0w+7vWK3QGJnWGQVj6ryFzpQa1rDzq6achFpvfmRj9DDJuD0Fqoi6obSl44Teok+SKtXcLr1dETw==
Received: from DM5PR07CA0139.namprd07.prod.outlook.com (2603:10b6:3:13e::29)
 by MN2PR12MB3469.namprd12.prod.outlook.com (2603:10b6:208:ca::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 07:08:19 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::f4) by DM5PR07CA0139.outlook.office365.com
 (2603:10b6:3:13e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Thu, 10 Jun 2021 07:08:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 07:08:19 +0000
Received: from [172.27.13.132] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 07:08:17 +0000
Subject: Re: [PATCH nf-next 0/3] Control nf flow table timeouts
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
References: <20210603121235.13804-1-ozsh@nvidia.com>
 <20210607121609.GA7908@salvia>
 <CALnP8ZYO25m0o_T1ABVu4uXN9NJh3E5G3gd0j66uEDHi6XUwqg@mail.gmail.com>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <d743411a-1228-a3bf-6878-e14c4ea285b1@nvidia.com>
Date:   Thu, 10 Jun 2021 10:08:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALnP8ZYO25m0o_T1ABVu4uXN9NJh3E5G3gd0j66uEDHi6XUwqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d4d8c18-c238-4cf2-ceda-08d92bde86c5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3469:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3469284A8B8327085008A361A6359@MN2PR12MB3469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iB9b9mDQpoLL5Shm0NLmdt8RBERY0/Us2wEe98NtXm63llqAwde//yaGPeYGIgyyXr7Q9sl/Z7e0UTNRMZbt9h8U2uxGQYr37ZOVqx/6mHpLesYmAwwsJO4n17+Qems/6n9rFeRIXj00BEW1bnK1OhX0SRlBvBwd6MWN4CH+dChPNmnuKtnD8nl5cjBfNfXuGSo+A5G4/e1EboEOwx7P2BIU2mJNw+4yb+nyBArpN8y+yxV1e7K8G6AZB2ER2fdfd/vQeVzDnFfqEfgVRoBTnrukls+K5VdTC7q34ciAQUDzCUC1FHSt/JtkM2QJmvhT8/GyIUdO03ZKuB/l31JfvEsYiiaAGwUnAJjEuI4Otg3NF5SHJaem5uz23rnAB+BfCxtrdE/QiI2sa9JRj59H2NgyhHiJolZbucfIvYh83JKrPIexWkrS9ss1kHWvegfwdlhfamA9QfSRKZs9vuDZgkm6CWCP0UnJfMzz/1ONmdpGAjukN+4NjbSuTmWO9f8LvZxQtMhb5mcnUw/3ffb9rAkcsXGQMzVW2z+LU77jUpZs/yQM8JcvfT8kH8P4kKfzuj3TKr/pbQACeZtITpjHslsPV8FgmlL/kIrbKS+6P88jrJRuIzivjlFWgpyk+R2kOcGs94uk6p2raYLW3gnrbIzrDLjeGxa/nrw1SkDtbRnend18ejik5C569FvtiiG2
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(47076005)(36756003)(83380400001)(26005)(31686004)(16526019)(356005)(6666004)(478600001)(7636003)(70206006)(31696002)(2906002)(186003)(82740400003)(8936002)(426003)(54906003)(4326008)(53546011)(2616005)(107886003)(86362001)(70586007)(336012)(110136005)(82310400003)(5660300002)(36906005)(16576012)(316002)(36860700001)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 07:08:19.2530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4d8c18-c238-4cf2-ceda-08d92bde86c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3469
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/10/2021 2:12 AM, Marcelo Ricardo Leitner wrote:
> On Mon, Jun 07, 2021 at 02:16:09PM +0200, Pablo Neira Ayuso wrote:
>> On Thu, Jun 03, 2021 at 03:12:32PM +0300, Oz Shlomo wrote:
>>> TCP and UDP connections may be offloaded from nf conntrack to nf flow table.
>>> Offloaded connections are aged after 30 seconds of inactivity.
>>> Once aged, ownership is returned to conntrack with a hard coded tcp/udp
>>> pickup time of 120/30 seconds, after which the connection may be deleted.
>>>
>>> The current hard-coded pickup intervals may introduce a very aggressive
>>> aging policy. For example, offloaded tcp connections in established state
>>> will timeout from nf conntrack after just 150 seconds of inactivity,
>>> instead of 5 days. In addition, the hard-coded 30 second offload timeout
>>> period can significantly increase the hardware insertion rate requirements
>>> in some use cases.
>>>
>>> This patchset provides the user with the ability to configure protocol
>>> specific offload timeout and pickup intervals via sysctl.
>>> The first and second patches introduce the sysctl configuration for
>>> tcp and udp protocols. The last patch modifies nf flow table aging
>>> mechanisms to use the configured time intervals.
>>
>> Series applied, thanks.
> 
> Patchset missed a description of the new sysctl entries in
> nf_conntrack-sysctl.rst, btw.

I will update the documentation,
Thanks

> 
>    Marcelo
> 
