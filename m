Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52447C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 16:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350108AbiCOQgz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350106AbiCOQgz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 12:36:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B404C5005F
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 09:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgm9CscvwloDOupT2Pzzq73FJUPzl0QbXtxRzvlAzexT5EJJ8X0hFbaxpPD23I/9hggzG3smETSS1gJieSMu9wq6tGDVF5d5ACuQjOMvsnD8qKTRB0Tbz/RXKlg+zRnhtHJNfslsmYRuVEX4eLjnbJZYg3B2NGAFKaMwdt8wYmBO6Tjz3NaFis+G7qHK1Cz/nwNpuunbX9pdjVwPbd2Iu7zE8eL1RmImmrNZLHRN3FqwZfCSLqcFi+KeyDG7WMeAwPoAj6zbsBYr+C16a12y6v8ghOUt0fOHsQk5djp7yv6zxYdixLUqx7k7c0/yMYTboIOiZ+ZhFy23cZmqrfYLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w37QUbcvs7YlHK6hMpDEQTyLaBHBLXdlcCHM043ABmg=;
 b=PlnYMg+a9oSUf/ghjvl9evp5jSxLOI88LjVXg14d0K0I0U5Z4eU2R4YP7xSKIQ2I/qELr5o11F4WkYek3kk7oYI/Z6IN//mV164fP5l7sWatjf2g4iLHUs3nFZ1CKjxOm6fuLq9OCUae2C/HZAqMr3nPnVTbmV/p+71u6a0wxiBFHqc18PMQqylBPLf9RhSbcMM2aWx+pKaVF0Y3NcouXaQUjPvHcuBI0J+3gTmiZe6U4pmQXvEJBWurLdLo5bEZKp1YKaARH9F6nrWm6qKlq9NRWQPAGuvaTPD2Mddw31TzrUnJxdNaG/QAWh2l0x1fLdG4p6IWuYsXV6XxNn9k8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w37QUbcvs7YlHK6hMpDEQTyLaBHBLXdlcCHM043ABmg=;
 b=J+1Y7uXTLnfnLexRU3j6c4iiayeXhk+sCAxXo5mFa8o+XbBEcOIZ+ipkp9O+P6l0cf/4su2LOh3qsPI2WskG6ovX2yicvOy1BqcM02MLLOFiYwLkFu13oZNMrhetUqd/guhGdHN1uf9d95mWi5dXcBf2Dje5pnrb2lQ3NwAw1bIWeXiWA7fPwEG8hGKfy9PUH6/IC2NrzudS7rVr3yJN5dh++iy9e3FSGD11IcZjIn+MY3Df3+TlBkOK4PqAs18RulfGUsWD8SvT2+Sjj9x+WKjVo7+LaDHxznuZLjfikKuO9v1B8YHB/FvbefTMaFaChVYVw79PHwosmm5/YgNuDg==
Received: from MW4P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::12)
 by DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 16:35:41 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::1f) by MW4P222CA0007.outlook.office365.com
 (2603:10b6:303:114::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Tue, 15 Mar 2022 16:35:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 16:35:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 16:35:40 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 09:35:36 -0700
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com> <YiZ/j6kYidLRYkRh@salvia>
 <87fsnnuenw.fsf@nvidia.com> <YjBtTdcYk0lJqsYw@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Date:   Tue, 15 Mar 2022 18:34:36 +0200
In-Reply-To: <YjBtTdcYk0lJqsYw@salvia>
Message-ID: <87pmmntbqi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6e976fb-c219-4118-2887-08da06a1d7f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4316:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4316FBDB640068287E7E3BF1A0109@DM6PR12MB4316.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2iKf1rgwl6uqrEWfo5YK0T/6PqpB4Ruy+YQSnWBiFlY9g1/T5+9IeE/8OREQMjXS6JZzGWUQ3/b6x/QkcMsx59mcLn6POUw0J9OrfV0HhEI7W3b6hTOmbtGOsHma0YgnDuB7DKlCmIYs7GEuafVhUx8N6sfS2/yVethKLfRewAVYefROHNYjZzANadiR5uIdVC0M4pzn3/hSZDXvPL8ew8Mv1e9imbDwOM1+xPHT+TjT7yGVfraMaW8HbBH29Pj/MZbE2QqkUF3STxXrDboHxsf6YRdYrWKfUFsOVQbWZnohmbx4hqdjMGdLcKs5fqqA+4N2D45zB4y7jRHrc6IRlbf9b5kKebjph9O1PhW9bj5UFy+l0BIGN6KsgdEIDHKGSIIGA6Uf7PwpX11D9THbHULFAn1J2aY7ZP7qOzK+3cfKgCgBP36l2lSm1pPwN65byoxp5rZpphR9wIcBXHWrfUOrvT/H++KFTi88QLzsqeOjI34f1Js3HLKCWaX0L2q+zJWFq6jbk2zjRdwMaX3024l6ajDh+s/uDaaGJjDM9M9CpQdMji2v4EgPVVIW/IlV2t9emxKYXooJbfqv+2Aro5TEZIdfLo57Dg8P9JXkPCQmJzPShODWvb3bnV2FloIegGguSn8nBaYgLlh62KXC3iVAmrsRx4P+645mJ6TSxwpb0sxCrMtmnUkJWcBgR8BgVD3U6BJB8EYT3q4BVX/UQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(5660300002)(2616005)(81166007)(8936002)(107886003)(508600001)(356005)(26005)(186003)(47076005)(316002)(40460700003)(2906002)(36756003)(426003)(336012)(54906003)(6916009)(83380400001)(70206006)(82310400004)(70586007)(8676002)(7696005)(86362001)(4326008)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 16:35:40.7634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e976fb-c219-4118-2887-08da06a1d7f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue 15 Mar 2022 at 11:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Mar 12, 2022 at 09:51:45PM +0200, Vlad Buslov wrote:
>> 
>> On Mon 07 Mar 2022 at 22:56, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Tue, Feb 22, 2022 at 05:09:57PM +0200, Vlad Buslov wrote:
>> >> To improve hardware offload debuggability and allow capping total amount of
>> >> offloaded entries in following patch extend struct netns_nftables with
>> >> 'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
>> >> sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
>> >> when scheduling offload add task on workqueue and decrement it after
>> >> successfully scheduling offload del task.
>> >> 
>> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> >> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> >> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> >> ---
>> >>  include/net/netns/nftables.h            |  1 +
>> >>  net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
>> >>  net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
>> >>  3 files changed, 23 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
>> >> index 8c77832d0240..262b8b3213cb 100644
>> >> --- a/include/net/netns/nftables.h
>> >> +++ b/include/net/netns/nftables.h
>> >> @@ -6,6 +6,7 @@
>> >>  
>> >>  struct netns_nftables {
>> >>  	u8			gencursor;
>> >> +	atomic_t		count_hw;
>> >
>> > In addition to the previous comments: I'd suggest to use
>> > register_pernet_subsys() and register the sysctl from the
>> > nf_flow_table_offload.c through nf_flow_table_offload_init()
>> > file instead of using the conntrack nf_ct_sysctl_table[].
>> >
>> > That would require a bit more work though.
>> 
>> I added the new sysctl in ct because there is already similar-ish
>> NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD that is also part of ct sysctl
>> but is actually used by flow table code. I'll implement dedicated sysctl
>> table for nf_flow_table_* code, if you suggest it is warranted for this
>> change.
>
> IIRC, that was removed.
>
> commit 4592ee7f525c4683ec9e290381601fdee50ae110
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Aug 4 15:02:15 2021 +0200
>
>     netfilter: conntrack: remove offload_pickup sysctl again
>
> I think it's good if we start having a dedicated sysctl for the
> flowtable, yes.
>
> Thanks.

Got it. Will move these sysctls into dedicated namespace in v2.

