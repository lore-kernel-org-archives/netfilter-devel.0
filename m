Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9F9C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 19:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiCLT2T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 14:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiCLT2S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 14:28:18 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48091E017B
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 11:27:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVMgEHYou3eLW2mFUUL9qYT1/1EWlLK1i1xB1Mj5i1CD4aLQIA0KbBRAgoA8XUxZa4oAenukugmRsPYobtU223ZCD/VERnue8DOvF16tCnMwXw6ypmABxxIvYDYFAZUSIjBWFWhQG1+sMNBCS4HA2mdP9LH7sEQtZPYkY1cqvaQq6FljJb/KtgPcb/bTadXndwCZYgFGKGe3UbJ1RAt2KVl39AOCkJavSyhD6e1ny3Rbk4XrVZ8IS4sMPRiPb4psYL5RlI4bj1NuDOfiV/b6QS8pUxvmJ+fH++uACHKKfqqYqF41yBQ+q6mtUcko1rdjr7tOh9jXI7zmKlYd4vD6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL3ylloouGr4YHD5BQb6IIzMxJKGiH8ikI0HBl0Zy5Y=;
 b=TRxmu2WVC7vPwKMpqiFd7jti6hqPymYcK/GY7yBsBXD977YCZ01SsoumdIEQAADMkJxSgH4qUNVUyTzbZouZoDZj9aXvnq6JT+hNmSyIDqug8alJkJ4C2TtE4dSYUwXIvrRaMGdTkIgoAqt6S6OLIjtpLvBLdcVZ1wQJPmWGAJWvu7wmtliL5TwOEWacgRt/vfqg2wQJfVaeXdQIbFIuqnFj4BPmyTR3/utp9BFxzVTJEfZUh50+gFlziNJDjAqJdCFRhEC1D1bguhP5IB7apLXzsl8zuAIZzvdhuDAQyAn7fgkwUR8apfDwq9iG+FNl27VU3VkqKefUbp5b98NQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL3ylloouGr4YHD5BQb6IIzMxJKGiH8ikI0HBl0Zy5Y=;
 b=KPlCHONY5YHLg7fAiFW7A/z3xF8/bdILT9vH+kR8NvA5PK7CUEPQwBdQ/ljMrslXUpCwYHGZN4iVJqG0d+IkLDlnXnAhahqbVOdJcGXmE5cxxb1ol55VYylsaCB4LlQ46oKXjrqbuRvIahvfzif3s/yfLKf+Fa7yjBkRHFtv8TFgt7ir3qdPn6c4qzq1gxFm0YipcqsLi1KrTTVxTOy127aQw2q6mxDfRI5dFwZ39JtKviAdMucRCAEYnIfuXUN4bSdhFaCB1iDtATjsLas0+qYoGFnl+pJWmvATkvGYdkqAaF23FakQWy5rUbfinYjEWsaSaJl/4UZVltBEee395w==
Received: from MWHPR17CA0092.namprd17.prod.outlook.com (2603:10b6:300:c2::30)
 by BN8PR12MB3250.namprd12.prod.outlook.com (2603:10b6:408:99::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sat, 12 Mar
 2022 19:27:09 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::fb) by MWHPR17CA0092.outlook.office365.com
 (2603:10b6:300:c2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Sat, 12 Mar 2022 19:27:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.24 via Frontend Transport; Sat, 12 Mar 2022 19:27:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 12 Mar
 2022 19:27:08 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 12 Mar
 2022 11:27:05 -0800
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-3-vladbu@nvidia.com> <YiZ9fQ8oMSOn5Su2@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 2/8] netfilter: introduce total count of hw
 offloaded flow table entries
Date:   Sat, 12 Mar 2022 20:56:49 +0200
In-Reply-To: <YiZ9fQ8oMSOn5Su2@salvia>
Message-ID: <87o82bug3d.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4843cd3d-73dc-4f0a-a284-08da045e4d33
X-MS-TrafficTypeDiagnostic: BN8PR12MB3250:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB32508C9165B1710F54F0B844A00D9@BN8PR12MB3250.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32JcAWcyTsl5YAbUWOG8NLemACR71CYz5bxSPHoRSfqFw3e8SNSsElbW5SWTJ9oMDszoqhlv8B91WZ3vXnPmiP5p6P0GmQcR88YsdkwMt+53g8LkvsDJeOXuK2NOJOf3uVY3mwFi+lnSKndDOMAOQ0aCrBwBJZgTaN6iAkKiDtZRJRDIm2nuS0iTldAitaUNs8iwxv7EBKFN1jjT/rv8hWabexDXbsuHlyjARBc224KI+ipX6qJHcmYYakZ1NAMZ2MWcwIdicXqZoT/Ow2p142yOaZx5rRx2vFo5+AxqybinfsNErCQnfm1IhikP5FSgCn4xEAAdLv+ucEo/VrNBQw6kV8+ef+nVfP/ZMsmX707xr2fDV4TpIg7gUPKaNE67FOzRxWTexLlILtHuJZ5nU3yBOaUKhNyxYeymwRVLBXBDlDSSoFnSbgre0WLS50a1Bifjt6MY6ltjNLinV0KxrVAOThdIOCzYVX0KoeLboxysO3/ZeAya1Y8nBmccJ7bQoFSpuuRWd/siuhPRWGwJVaECNEBNnrSgK0MFuGhpF8LQ3WgATYIL06loKxtiwII87JpdrbDB7740TUSlu8XIF5Z7FsmN69aXZWd2WrkCL8WZQuxmhAMXKc/c7oXFJiJ1k9LPIFsUiM4RYASMcaoZV2w/hSNKXxZGGLAT9Zr/RkKUj2s5T6dQ7isoTzFKKZ1KhvABA4f4FHR/G/GQcHrffA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(54906003)(508600001)(36756003)(6916009)(36860700001)(86362001)(2616005)(107886003)(47076005)(186003)(26005)(6666004)(426003)(336012)(16526019)(83380400001)(7696005)(4326008)(8676002)(81166007)(70206006)(70586007)(356005)(82310400004)(2906002)(316002)(8936002)(5660300002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 19:27:09.3919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4843cd3d-73dc-4f0a-a284-08da045e4d33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3250
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon 07 Mar 2022 at 22:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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
>>  };
>>  
>>  #endif
>> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
>> index 3e1afd10a9b6..8cd55d502ffd 100644
>> --- a/net/netfilter/nf_conntrack_standalone.c
>> +++ b/net/netfilter/nf_conntrack_standalone.c
>> @@ -618,6 +618,9 @@ enum nf_ct_sysctl_index {
>>  #ifdef CONFIG_LWTUNNEL
>>  	NF_SYSCTL_CT_LWTUNNEL,
>>  #endif
>> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>> +	NF_SYSCTL_CT_COUNT_HW,
>> +#endif
>>  
>>  	__NF_SYSCTL_CT_LAST_SYSCTL,
>>  };
>> @@ -973,6 +976,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>>  		.mode		= 0644,
>>  		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
>>  	},
>> +#endif
>> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>> +	[NF_SYSCTL_CT_COUNT_HW] = {
>> +		.procname	= "nf_flowtable_count_hw",
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0444,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>>  #endif
>>  	{}
>>  };
>> @@ -1111,6 +1122,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
>>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
>> +	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
>>  #endif
>>  
>>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index b90eca7a2f22..9f2b68bc6f80 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -315,6 +315,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>>  	nf_ct_offload_timeout(flow->ct);
>>  
>>  	if (nf_flowtable_hw_offload(flow_table)) {
>> +		struct net *net = read_pnet(&flow_table->net);
>> +
>> +		atomic_inc(&net->nft.count_hw);
>>  		__set_bit(NF_FLOW_HW, &flow->flags);
>>  		nf_flow_offload_add(flow_table, flow);
>
> Better increment this new counter from flow_offload_work_add()? There
> is offload->flowtable->net, you could use it from there to bump the
> counter once this is placed in hardware (by when IPS_HW_OFFLOAD_BIT is
> set on).

Hi Pablo,

Thanks for reviewing my code and sorry for the late reply.

We explored the approach you propose and found several issues with it.
First, the nice benefit of implementation in this patch is that having
counter increment in flow_offload_add() (and test in following patch)
completely avoids spamming the workqueue when the limit is reached which
is an important concern for slower embedded DPU cores. Second, it is not
possible to change it when IPS_HW_OFFLOAD_BIT is set at the very end of
flow_offload_work_add() function because in following patch we need to
verify that counter is in user-specified limit before attempting
offload. Third, changing the counter in wq tasks makes it hard to
balance correctly. Consider following cases:

- flow_offload_work_add() can be called arbitrary amount of times per
  flow due to refresh logic. However, any such flow is still deleted
  only once.

- flow_offload_work_del() can be called for flows that were never
  actually offloaded (it is called for flows that have NF_FLOW_HW bit
  that is unconditionally set before attempting to schedule offload task
  on wq).

Counter balancing issues could maybe be solved by carefully
conditionally changing it based on current value IPS_HW_OFFLOAD_BIT, but
spamming the workqueue can't be prevented for such design.

>
> That also moves the atomic would be away from the packet path.

I understand your concern. However, note that this atomic is normally
changed once for adding offloaded flow and once for removing it. The
code path is only executed per-packet in error cases where flow has
failed to offload and refresh is called repeatedly for same flow.

>
>>  	}
>> @@ -462,10 +465,15 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>>  
>>  	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
>>  		if (test_bit(NF_FLOW_HW, &flow->flags)) {
>> -			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
>> +			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
>> +				struct net *net = read_pnet(&flow_table->net);
>> +
>>  				nf_flow_offload_del(flow_table, flow);
>> -			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
>> +				if (test_bit(NF_FLOW_HW_DYING, &flow->flags))
>> +					atomic_dec(&net->nft.count_hw);
>
> Same with this, I'd suggest to decrement it from flow_offload_work_del().
>
>> +			} else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags)) {
>>  				flow_offload_del(flow_table, flow);
>> +			}
>>  		} else {
>>  			flow_offload_del(flow_table, flow);
>>  		}
>> -- 
>> 2.31.1
>> 

