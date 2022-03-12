Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40942C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiCLT7O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 14:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCLT7M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 14:59:12 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95106E54F
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 11:58:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXQsMG23Lm2DFsimLaiagSZVuqmXq8VJ0MVACWtfmsDZhh8dhG2re8kW8AdAWDbuV5Ofbk9c2b9YGYqPlovlkxOQfc9xja81wuEwqnNJPO9xq9K2nt2qvmToJgkhhdRiJSezj0i4Ajk7i2gYNA4Nk+hPx+Rw8SAQ/sjfM8YU6svhMuMewQo9vYQw4CrycRfWmRFp58CPH6+MiAONlwWk/edwNQ5Z3Er0E5DDHDzNhogeuqLn3DTIfXjM72tLg4EUq0B62YPILuALY8wsRtNQH+o+z8NqSeEbUmOgdUrJV56uiNTKBGR9Am+zabOjo8u/xDUGnh+x4F568S1+pSpxpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRIxowQ6VJWuYpSKpGhrYleAIsLdU971A0WBYu8Vg+I=;
 b=UbnyedfudzhnP7M1iQ61Yw7Timm6TjPurr8MzG3u8r3IN3IwahE+6cbBuNDuxskXuTRIijBLUJ2auxb1ScXILOvClSQXCarPvT+Iw3ORzqeWoQx2bXIsnlLciyUmNgN2d6b53P5RaKaPmrT3rJJEvhO1INOnTyQnvpi6VhVAOhTC1Yu9/PEn6fCZyhELXHUkTdpw/qNhrA8gIVDwndzGhoK+kUcWb5c/PTfJ8YVnV8UnKWNsUPQu3bMl3sk+YF9oVmT/hz/HSHkTwCHmcNDEHzFAJmL74ENLZv4SE+/JrXwpMZbOeXnH0oxri4dT7thkXbvb0Xo/H3laQMAiqAjLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRIxowQ6VJWuYpSKpGhrYleAIsLdU971A0WBYu8Vg+I=;
 b=rYELgNO7Uo6iMN9pWPgx32JQyxam4vpa2rAdYLiAD+PNHCgPO1kdYlzhhgBUZEUzPj1yL37UnNJyBZ++RKUM1K25yFVb5NDFOIxmCB/nLROeDQQGcd3yOgC/sL3VIjtaUO3L8xNv+NtV19CBaPq5W8ePB9TGFYlzLI3XqnosdhJz6TVQzS6gOJwGDBeIBzfVQAxlrUqSOk7Vk2hleP1Y+YlNeJRt8UPw3BqAhQvgbv4UqlFbhd/NmSsFe8bYJc/mEvHKH5DGb6pz2j0/ghgfLQvHijnsaS0DHkJ7blOom3/PRK7DeZUHEGbKacbJKZSjLeqCbyr9oRy0gTHO3hQJIQ==
Received: from BN6PR1701CA0007.namprd17.prod.outlook.com
 (2603:10b6:405:15::17) by DM5PR12MB2341.namprd12.prod.outlook.com
 (2603:10b6:4:b5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Sat, 12 Mar
 2022 19:58:04 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::47) by BN6PR1701CA0007.outlook.office365.com
 (2603:10b6:405:15::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Sat, 12 Mar 2022 19:58:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sat, 12 Mar 2022 19:58:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 12 Mar
 2022 19:58:02 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 12 Mar
 2022 11:57:58 -0800
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com> <YiZ/j6kYidLRYkRh@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Date:   Sat, 12 Mar 2022 21:51:45 +0200
In-Reply-To: <YiZ/j6kYidLRYkRh@salvia>
Message-ID: <87fsnnuenw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b55e936-0488-4f7a-4e01-08da04629e70
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2341962BE5092F755904C629A00D9@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idd8Dm70+vyAiik90NaD0PE6rC2hDSf/WE4a1duG5O0zyS9WrU9BR0HcmFvffDF8PkAVkT5vxKDew0Y+ATJm3TaoTxduWY9nZx3jrxsvPzD7FHU4Pz0rY0dN/9JUvKbPyrJ+blTzbUcljcoZWnt36Izqxjo+BjAl4fF92gofzUWtkDEsfI8Gefh2tIf5cXVJ4hvKS9JCN83QEjfi0GhjmWrh/fZXi33lA97dK60SBCx5V8UHPX7rnM+TLhMqhgjOMbZYV5Ih+aXuuCNPlV0lb7N1Fp73ncosGnExO8NVkrowc3LoEP5etfX7weM7vO0KcVOdvYUmQx0/bgerdpjWTHbGDDD+FLPbp06v5iHdaCy4jI6faYzoY+kABQXbtdfoWrq7NNj1/iA9wMWaDQ1VCtqi4N+GDa2BByfZfqkrZYDNiTcuxS4pE9YaJ4ahhvVvc8RJ6rI96RO9daSRzoWdhiorfqtHKjl6E96E47suio7cktzyB7IRYW1l+E65mKjGkutaJhNtGuoVH45T6A4NTiDgwS2nNSOWRFJe1CfLHhJluEa+uyTBGW2Aa9yd6fe3sGEE60E7MJYEAFili/v/9ag5IHsy7gAgPKF0krF8crLH9O4lv0D48H82UPCLOD2M0zUuqHuz3hb6632psLP5KyxYvS+TWAJy3pGWhEI+6Uo/po2h8RvVQ9VBznU3PPZAOVDrrhlQ9rJZ9PE3XWLY/w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(54906003)(40460700003)(186003)(26005)(336012)(426003)(82310400004)(6916009)(16526019)(107886003)(316002)(86362001)(2616005)(47076005)(36860700001)(6666004)(7696005)(8676002)(83380400001)(36756003)(4326008)(5660300002)(2906002)(81166007)(70586007)(70206006)(8936002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 19:58:03.6094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b55e936-0488-4f7a-4e01-08da04629e70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2341
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Mon 07 Mar 2022 at 22:56, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 22, 2022 at 05:09:57PM +0200, Vlad Buslov wrote:
>> To improve hardware offload debuggability and allow capping total amount of
>> offloaded entries in following patch extend struct netns_nftables with
>> 'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
>> sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
>> when scheduling offload add task on workqueue and decrement it after
>> successfully scheduling offload del task.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>  include/net/netns/nftables.h            |  1 +
>>  net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
>>  net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
>>  3 files changed, 23 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
>> index 8c77832d0240..262b8b3213cb 100644
>> --- a/include/net/netns/nftables.h
>> +++ b/include/net/netns/nftables.h
>> @@ -6,6 +6,7 @@
>>  
>>  struct netns_nftables {
>>  	u8			gencursor;
>> +	atomic_t		count_hw;
>
> In addition to the previous comments: I'd suggest to use
> register_pernet_subsys() and register the sysctl from the
> nf_flow_table_offload.c through nf_flow_table_offload_init()
> file instead of using the conntrack nf_ct_sysctl_table[].
>
> That would require a bit more work though.

I added the new sysctl in ct because there is already similar-ish
NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD that is also part of ct sysctl
but is actually used by flow table code. I'll implement dedicated sysctl
table for nf_flow_table_* code, if you suggest it is warranted for this
change.

