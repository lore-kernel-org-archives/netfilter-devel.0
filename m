Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE84C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B60360E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhHDLyn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:54:43 -0400
Received: from mail-dm6nam08on2078.outbound.protection.outlook.com ([40.107.102.78]:12066
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237858AbhHDLym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 07:54:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY7fdt/a8J5XSaGjU4kL9vpxSlNxrFfYtI/7XOc1PpHfXQLsFDcfwLPRo+cjvyTC8G0uTndm+dGDHSY9zJG5UL50ib9hjhgxpj1H+F/k8duXUxCb8/1Qbny4ztcdoJVSrSGeZw9LTw1kxihzBvpq/JkD/XzRGzDhw+e5q2fod+hoI12+YtfGlcJ+d18d73A0T0ojBWz8FW2/X7FVNY4ZkmRcAAZttZMKX3HxxfRqonzOfnuLZqWK4bizK7NegiyeDbRQ1IB84pMeVQF2ssYOI/jAzC82TYFBlbyRFwZ7o1Fe91+G7l7zoF5hw5OEndPDvRtfmZ53HlVe7LZL1m44Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxzgNdFIxJ4pxnby9/8gWPjaHnMl5imTffi35H6DwmE=;
 b=T38ckOqhsQd8/m6C5KYvnxJAcC3w4DiOGuNRoIiYNWnEsJe/yHGJX6pe0uz/ugSI8OF7fUHcrZzvYcrFDbNmcIVQa+TXSJVO7leEkYhbYItdkF+FErozrmb3uBep68TlObNm0WNJHJUujVHm1XH+9cCuvgpx8csI2OvEArJwMLbvCrebxWrZPrjiKuirsnV6xuASIqfbyT9TB3rolLayufhReyAQtdxfUmOo8Vp22IPaYjN1THwJLCst9Z1ohkOnvcyRHDZ2ULRVZSlFupy6YfEK7uCdbvIFtdEIUT2W7nK27bi7/GhYfdj49TmN7qGurAl4oxXKqE56+U5GL6LtBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxzgNdFIxJ4pxnby9/8gWPjaHnMl5imTffi35H6DwmE=;
 b=nVnkaga+HIEgslJg5xLWsRMpfJ7NG3JlSc18KjV+e+S8iDwcXc7w0N5a1FC0gt0Ws6hYbFRGh77yAtlIyJOeYVwQr48Ny6mCw/APGXLWV8CoHG7PWKZ1Jvy842ueRBzMENGCAIyJIbLdD24EMtq9ZSZhjAHEEgasH79yHSPpweEqJgbILT3K1LZ0QF77RYq6h3XErHyIOFVCA0ZZjXzmZI5XBVIFsjK/6Ac9Nx1+/TbQt7mjnRSdT4L24LaQkSU++YourdfSlbmDLZU+JG2MOTnyFRPnbUzpDdnp3+S7sdTe3k8cwWRJd9uys54F7Em4C6QBWWW/BbbgjQ1NCTSYSA==
Received: from BN9PR03CA0568.namprd03.prod.outlook.com (2603:10b6:408:138::33)
 by CH2PR12MB4165.namprd12.prod.outlook.com (2603:10b6:610:a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Wed, 4 Aug
 2021 11:54:29 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::30) by BN9PR03CA0568.outlook.office365.com
 (2603:10b6:408:138::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend
 Transport; Wed, 4 Aug 2021 11:54:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 11:54:29 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug
 2021 11:54:28 +0000
Received: from [172.27.15.182] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug 2021
 11:54:26 +0000
Subject: Re: [PATCH nf] netfilter: conntrack: remove offload_pickup sysctl
 again
To:     Florian Westphal <fw@strlen.de>
CC:     <netfilter-devel@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>
References: <20210804092549.1091-1-fw@strlen.de>
 <57d7336e-67a9-661e-e0ef-aa49ee08b8c5@nvidia.com>
 <20210804111934.GE607@breakpoint.cc>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <c66e0d7c-8d99-3dbf-59fa-745133799b43@nvidia.com>
Date:   Wed, 4 Aug 2021 14:54:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804111934.GE607@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37ebf24d-4330-419b-e08e-08d9573e9d92
X-MS-TrafficTypeDiagnostic: CH2PR12MB4165:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4165B089E1C816521CC44323A6F19@CH2PR12MB4165.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqm5/q5AzBMVr0EiPHRae0vFFeiDxZ6Jm3/gtxlNztN+zyqszy1fh/UsPHszMYpaoFp91plGecsiig49nLYK5cqqirUgj/dHPMOKVAN1KBeH1JRlAfjAjed00BX+H6ptjaV2P22JDVCGVNi8ej/6dXrlXoQDh7UrXANFYGTcvm9xihAfr1ClODm7NjyLSgYsmeZH5FRBmOVhfyqS3gZ1PmKUnzdGY77pXGo2Ns0fFRVd0XgyqHvTOmYug/os+RxMN93KVu8jFV8SvNAIhuZGnEGJ/ftjiw7GZbvmuvdoPzjfxGYGTc69AnMBL/AB8K0oQRVfGyKdk2nxCrFgzvjwKI5mCeWTFZJqqDQ0CmSfZKrukjmK/+2Mo9TqgVaQ5moOQmv1UqxBik8GGUkrs2Ch6/yOz7f11ChR7EMoCU3wdNNbd8IL0lFpPLEP7h4HnV1LpwliPAAgjy0UP6FpZGxIPdV7hJ8vh7L0LkU/wdi2c6HDI7RcVDy86IvW/CHJKhhhiuArgcKDnKxg7rxvEakneNzqmdAN5ezMyGIJoZsfLOX71Y4oqDUkppApoi2+IboYCOvOQqdXiG9M9IbXgpt+zX+T06OGXoUwjrivD2+M1CPDz3vpMKniKyfotSjQ/6ge7FcbVtIwF2aoZE4S6DAEICGSkd8JNJzKS40Zx66/DMDWbppKrGRa/dP+KYI8+6VJKrnCAt7ZqXdkz5y3DYlWo3Zvv7+bWVbage5jdMAunjE=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(336012)(8936002)(36756003)(82740400003)(86362001)(36860700001)(4326008)(36906005)(8676002)(356005)(47076005)(7636003)(54906003)(26005)(70586007)(5660300002)(6666004)(426003)(316002)(2906002)(53546011)(2616005)(31696002)(16576012)(83380400001)(82310400003)(16526019)(31686004)(70206006)(186003)(6916009)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 11:54:29.1274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ebf24d-4330-419b-e08e-08d9573e9d92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On 8/4/2021 2:19 PM, Florian Westphal wrote:
> Oz Shlomo <ozsh@nvidia.com> wrote:
>>> When flow transitions back from offload to software, also clear the
>>> ASSURED bit -- this allows conntrack to early-expire the entry in case
>>> the table is full.
>>
>> Doesn't this introduce a discrpency between offloaded and non-offload connections?
>> IIUC, offloaded connections might timeout earlier after they are picked up
>> by the software when the conntrack table is full.
> 
> Yes, if no packet was seen after the flow got moved back to software and
> a new connection request is made while table is full.
> 

Then perhaps it is better not to clear the ASSURED bit.
What do you think?

>> However, if the same tcp connection was not offloaded it would timeout after 5 days.
> 
> Yes.  The problem is that AFAIU HW may move flow back to SW path after
> it saw e.g. FIN bit, or after one side went silent (i.e., unacked data).
> 
> And and in that case, SW path has a lot smaller timeout than the 5day
> established value.
> 
> AFAICS there is no way to detect this on generic side and it might even
> be different depending on hw/driver?
> 

Actually, the hardware sends all packets with a set FIN flags to sw.
When act_ct processes a FIN packet it sets the teardown flag for the offloaded connection and 
continues to process the packet through nf conntrack.
Therefore, the connection timeout interval will be updated by nf conntrack.

Connections that are aged in hardware are expected to be in the established state.
Therefore, the pickup time should align with the nf conntrack settings.




