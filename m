Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDDBC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3A3460F56
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhHDNka (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:40:30 -0400
Received: from mail-mw2nam08on2060.outbound.protection.outlook.com ([40.107.101.60]:31681
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235532AbhHDNk3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 09:40:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LY42JGwsWknu7eBFwERvx5PB9X0iBsBBHEBuuHSb5OenH3IMtUi379WXRUxSpDjLXpjnVSVYqt+P05zjezJpUQRg516Q52OsBf1aP1UDR5N2WQQh7zifqhIryQTMp6NsL9h5DE7rLtVl83AaFE0C3P4/5RHUyQ4kUKiQtoDcGRzGwqgLxkbLh3gLpP5aRoY4eAnbDqFhVSjkIN6FjaskJp6B+KRx7oUIxjeJBgxfiluY1HH5hhkYXkiJZfR7InhJ9yjLorYc+LupbVVVwUh5RZaAySI7AIMHKOw2hnRH/6D/oVekw6QzmntYIffB/Z6tvjaX3OB8vDzf1a99V65TgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL+/JJVHmdFdRnTlny+vk0EZaonNFzR3R57mzwTvT3I=;
 b=E8DdqxGgOQ8+s8ei8bwRMYNCz8pwvrF93M0Mg4uigGDiEaHL8fyxz8bW8no0EMIKbr9ykyJeA580iTjSVavs+ZWgX7Tq9jV2JpUqN74GpUq3ew2wbTbgbX+6FeaoGgcteliHDr6CDrbH2cPKA1bajQ5Ppvew/uHgn5oqiIeBeJiyX8oQ+cnt3/K6Wma48bpjmIngmkc9nv8hjR+uSajoovonj2cYZ7Nhsd/LE5Z5Mad7TA3AGVtw6Set+ZX9BFJDCfBXLBXxho/iPFTI0HJl6LqrK52oNn0Ir1BHV7QdRY5I7LmCf1fcatXKKpCnK9yxIs2CJNBcpEZpEUp4B3NCCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL+/JJVHmdFdRnTlny+vk0EZaonNFzR3R57mzwTvT3I=;
 b=K+xTayXAc+TGGQBzfqen4F3urEcZdQ/Rvtu1+g7GLgig4BSGrnpFzXxJxRfV6b3vYbtdV7ksERXU6/LwdZRzSsVHEMEalKRY85ma2hIUWIjIXqAHkZNvZUEdjcD+l6/GeJ9Fz0MUr2x8thrnG12x04CtYcmDwKR0QvetxCictMKSchlEN5j1XuKoR3ihm87URVjWvUaQEyGCs/lM3XFStHRIFxTEwDi9Wr8B56DwVHEO9q6kKKRxaMHriZK1jChRvRYgOwl9QTvKWvwhLaJjWdi4mgVugnRkiezdnAcxVxFwvWfbyGmChiexnA0Vb0GhCiNLX0/BkgLkggmLPlXzCQ==
Received: from DM5PR08CA0039.namprd08.prod.outlook.com (2603:10b6:4:60::28) by
 BY5PR12MB5559.namprd12.prod.outlook.com (2603:10b6:a03:1d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Wed, 4 Aug
 2021 13:40:16 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::d2) by DM5PR08CA0039.outlook.office365.com
 (2603:10b6:4:60::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Wed, 4 Aug 2021 13:40:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:40:15 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug
 2021 13:40:15 +0000
Received: from [172.27.15.182] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug 2021
 13:40:13 +0000
Subject: Re: [PATCH v2 nf] netfilter: conntrack: remove offload_pickup sysctl
 again
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Florian Westphal <fw@strlen.de>
CC:     <netfilter-devel@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>
References: <20210804130215.3625-1-fw@strlen.de>
 <YQqT7s7tsz9U26xq@horizon.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <0225b766-1389-f326-ab09-21ea1786d314@nvidia.com>
Date:   Wed, 4 Aug 2021 16:40:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQqT7s7tsz9U26xq@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2474203c-36f2-475b-5ac6-08d9574d6470
X-MS-TrafficTypeDiagnostic: BY5PR12MB5559:
X-Microsoft-Antispam-PRVS: <BY5PR12MB55594260B26C921197609B9AA6F19@BY5PR12MB5559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0y1BL5U7VA7cTpbRCYht7QTDQMovKmIlAt5+L21NJlfQ6/0oxFBXG4eZCFbIHRamuJwiIhHcoxgH8Bc+0F2jKlv3L8L5YdGfDMmha0hzfGQ2isOyTvlkZEZ+EKd03rrE5cBCnjqE0kxjWO1niJxMiQUId9af32wTUn3qpFgoHkC6bH6sFTrOULRh+XSZZpFgHuWOHXjauH+LMIdRwWdJ8FK9VXpoafjzddeYdekFxrXRKU/84zO5RvpeaKFcfENiGAs/mndgCFIuo56+2VHdRB4bcclJeXPCSjwgG/FPABELCYAZp8gByTwjm0W9ttlWjoaGr1i5GqhmuuJNkWHydYDwWmfM6sOEOu7uHpZYxQft/JUbshWw/EMyGIaiX+ZQXOFq0iKnm5Ayf3+u5S14qGZ3AWbNHrX85nZ7nGVrKzyJLH5N88H1CEMsfi/NlWljvmrdboSMyACoVrPHaKOM6KQK/qVeW6gT3SagAw9EO+G1ycfreHjAk6bzSVHxtes/HuauCIvP3emIEPfDRAC5hNhCCn2S2sjBPJ13WAsx9LzxKrU3B4AskvptYeiSUrvnJSvhpmXUepHxO5exjvCEeIwKwmz2ZTodVLIVEeYYJzybMi+XGQqsfTc+r2GQQ61qg9hL4M0EkQ4KcJ1Y3JHZJiQIitNmWAXFeE3sP17+/K79YEXbawuoqqfsJchnChddGeWvnQcVQ/GnXUjmmQl03U5kPYDTCxcX8MZUBlyFPU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(86362001)(70586007)(16526019)(186003)(36756003)(8676002)(47076005)(8936002)(70206006)(336012)(26005)(82310400003)(83380400001)(31696002)(36860700001)(356005)(53546011)(2616005)(426003)(2906002)(82740400003)(5660300002)(7636003)(107886003)(316002)(36906005)(54906003)(16576012)(110136005)(478600001)(4326008)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:40:15.7749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2474203c-36f2-475b-5ac6-08d9574d6470
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5559
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/4/2021 4:19 PM, Marcelo Ricardo Leitner wrote:
> On Wed, Aug 04, 2021 at 03:02:15PM +0200, Florian Westphal wrote:
>> These two sysctls were added because the hardcoded defaults (2 minutes,
>> tcp, 30 seconds, udp) turned out to be too low for some setups.
>>
>> They appeared in 5.14-rc1 so it should be fine to remove it again.
>>
>> Marcelo convinced me that there should be no difference between a flow
>> that was offloaded vs. a flow that was not wrt. timeout handling.
>> Thus the default is changed to those for TCP established and UDP stream,
>> 5 days and 120 seconds, respectively.
>>
>> Marcelo also suggested to account for the timeout value used for the
>> offloading, this avoids increase beyond the value in the conntrack-sysctl
>> and will also instantly expire the conntrack entry with altered sysctls.
>>
>> Example:
>>     nf_conntrack_udp_timeout_stream=60
>>     nf_flowtable_udp_timeout=60
>>
>> This will remove offloaded udp flows after one minute, rather than two.
>>
>> An earlier version of this patch also cleared the ASSURED bit to
>> allow nf_conntrack to evict the entry via early_drop (i.e., table full).
>> However, it looks like we can safely assume that connection timed out
>> via HW is still in established state, so this isn't needed.
>>
>> Quoting Oz:
>>   [..] the hardware sends all packets with a set FIN flags to sw.
>>   [..] Connections that are aged in hardware are expected to be in the
>>   established state.
>>
>> In case it turns out that back-to-sw-path transition can occur for
>> 'dodgy' connections too (e.g., one side disappeared while software-path
>> would have been in RETRANS timeout), we can adjust this later.
> 
> Yup. Maybe an early soft timeout in sw.
> 
>>
>> Cc: Oz Shlomo <ozsh@nvidia.com>
>> Cc: Paul Blakey <paulb@nvidia.com>
>> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Thanks!
> 

Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
