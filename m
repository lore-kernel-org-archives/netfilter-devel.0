Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E84C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 20:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiCLUGv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 15:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiCLUGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 15:06:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5D54180
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 12:05:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYP8kwOMgQfzXiDC1qvcyeti3SAAUfJVuPbkczjhAhUsD9R39BEyjtL6DNTuMCCOADvcfKIGTIJVRjw5eIs8nL8wqLdoKKoCwARXApYJBJipIOixoGfqqTPGr0TI8DWo+IJ1Q+ERC0wMhqJ3fy5chPMYog/B2E42qlVgtcobiaoOyE0rxLG2ks1GBLdl2rwgha64ux/1JJVXJz0KKr3LoDuk5RTXxa7PPSR0ncD6wePhk/x/fxuxNBL4HgiDoAXXs+IW5NdPhUWNbrE7WQqF719cayhpF7KptpV8sQtXOdsxFPzd9owp1HQZYqnJ35x31ML+caQzmfG17LO+R5N+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5KjihgjPW3A2vXF9XyPYl3wewR2HuzF+GULdgdJu2g=;
 b=eSsHMhElYUmt69USvQ/1dnpkfcgZiUXBtw45ceIBXRgLgjZy69XXVwG9bldqKvRQ5XTihpVrIsyOOCemqMuLy3U+zTMB3lr+bJF0QPe4AdIuQ2ak4J/NTOjFVwVNDcGsqNEcVhkAzG0JHzLpD5fiF+vHy7I3IDosGoGXs4xBzl6H3cYiQFm7BbbkhDYPPZM1W2FdYpIgWRvwJ2frdXkYCIAfvPSwHZUcEbJi2fS9Wm6vMhBCDbzJ/NOpXWvV25sO7J9IkNU3LPoyY3JZ7RqOhTiseUvnYSXNOK6h/dR2kPcWX/Z1R056RUUwGa967OQ2DQ4kwD749lTiEvu6cyqycg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5KjihgjPW3A2vXF9XyPYl3wewR2HuzF+GULdgdJu2g=;
 b=lrLXmWF6sdkenv+GHfYCRcW2RuCF1Xhvh7hBCvnLseOZXUp++NJF1TcsFX7DPZEsZKGIhVoYvVtT5d0DBBWEq0Vv+83VrDgOThBF76rCFtPL2OIVWYObmVE29IkXS/HGIO3UH6Rj9GLQW6LXw2q2PIyl0zYz96a6gqot5X8RAkVlbJ0RmehU/x3q0/EsyL+dJrkGOIgHTyYIPqn6Ish06Fow/LioTR9nTIa+DofUPob2u9/+qTyIdU0WqiZFl5zYInaaQGhe2e4DJ60rf5VTT2aX+lmQgDKeJvOK+lMGCzTYXl/wZqBt0xN4IbX4SbtbrPmutIKqZwUnMetGaiwr+g==
Received: from MW4PR04CA0218.namprd04.prod.outlook.com (2603:10b6:303:87::13)
 by BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sat, 12 Mar
 2022 20:05:42 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::f8) by MW4PR04CA0218.outlook.office365.com
 (2603:10b6:303:87::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.23 via Frontend
 Transport; Sat, 12 Mar 2022 20:05:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sat, 12 Mar 2022 20:05:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 12 Mar
 2022 20:05:41 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 12 Mar
 2022 12:05:38 -0800
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-6-vladbu@nvidia.com> <YiaKdytbtq5Nt6gg@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 5/8] netfilter: introduce max count of hw
 offload 'add' workqueue tasks
Date:   Sat, 12 Mar 2022 21:59:04 +0200
In-Reply-To: <YiaKdytbtq5Nt6gg@salvia>
Message-ID: <87bkybueb5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59900662-99d4-46a0-2fff-08da0463af93
X-MS-TrafficTypeDiagnostic: BY5PR12MB4194:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41943547322643C7800775A3A00D9@BY5PR12MB4194.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DOtmEkX/jLFRLfEUyvMisaJeb8buu5U3TCQkoaUm7EGR7a9SWITBDFmDzuYQHkQAAP8HxWVIVkIz8Tq/NcpeZUH7SWrmxn0drF0Xw03eZEhK9pviZ0xZthahpTyIJfHhIpfQX2m8EuXJAQE7v/Fia5nKHyXfwkAMmcb0vx9kpIDatVVg5UgI7Yqu9fBfNPc18o2D613bZgpX6Sz0RdJRL5tZo0UBKshvk3LkamPuQ50C90pC5k3+RZ4lbgaINb5zalEUg9XzgXNaQKHhWkkg3NtLfD7MIZ0IroV9+4MWnIyZawXxPCHApSwTYQD2GD0VtjKgGruKoCeZ5+yzX6A4RnC+NYxdJDWPEtpiPghnJA+FgSvKNygqCMAqIBVAEsVrTKDUoYzp6qpi6J445uAHGwbxfK0BSn/JZ08APgM7uvW0EJhagA6JJyaIaHsC2Enc/ZGdXIr5Dt2dQfJe0664kMeA0qWqpeqflGgHGoxFM3OzUgcHX0p7s5oNR1zpnekz79BMqa1nPKtsIutjmzLOV1kEWJMSq9SxBCSXfSFwpBUvoydRa5SKzbVu9LONuVm0VdvWqCRcophGQOcROiJSpWWoRIUXH7ZofjslgMYcRtY8rfccyhcdh+JuSddOQQ3p16WCby+2b5xO3RYXP5hutyZld5I3TeoK7yZf/nOCkMtgQWyTFD6RL7xuysI8GX372AaqWY/PnR24AsNZpL3Dw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(40460700003)(82310400004)(356005)(86362001)(81166007)(316002)(54906003)(6916009)(5660300002)(8936002)(4326008)(8676002)(70586007)(70206006)(83380400001)(2616005)(16526019)(107886003)(2906002)(36860700001)(47076005)(508600001)(6666004)(426003)(336012)(186003)(26005)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 20:05:41.9185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59900662-99d4-46a0-2fff-08da0463af93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Mon 07 Mar 2022 at 23:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 22, 2022 at 05:10:00PM +0200, Vlad Buslov wrote:
>> To improve hardware offload debuggability extend struct netns_nftables with
>> 'max_wq_add' counter and expose it to userspace as
>> 'nf_flowtable_max_wq_add' sysctl entry. Verify that count_wq_add value is
>> less than max_wq_add and don't schedule new flow table entry 'add' task to
>> workqueue, if this is not the case.
>
> For this toggle, I'm not sure what value I would select, this maximum
> number of in-flight work objects might be a difficult guess for users.
> This is disabled by default, but what reasonable limit could be set?
>
> Moreover, there is also tc-police and ratelimit that could be combined
> from the ruleset to throttle the number of entries that are created to
> the flowtable, ie. packet is accepted but the tc ct action is skipped.
> I agree this would not specifically restrict the number of in-flight
> pending work though since this depends on how fast the worker empties
> the queue.
>
> My understanding is that the goal for this toggle is to tackle a
> scenario where the network creates a pattern to create high load on
> the workqueue (e.g. lots of small flows per second). In that case, it
> is likely safer to use add an explicit ratelimit to skip the tc ct
> action in case of stress, and probably easier to infer?
>

I'm afraid such approach would be a very crude substitute for dedicated
counter because the offload rate depends on both current system load
(CPU can be busy with something else) and also number of existing
offloaded flows (offloading 1000000th flow is probably slower than the
1st one). However, current workqueue size directly reflects system
(over)load. With this, it is probably impossible to come up with good
rate limit value, but quite straight forward to infer something like
"even in perfect conditions there is no use in scheduling another
offload task on the workqueue that already has 1m tasks pending".

>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>  include/net/netns/nftables.h            | 1 +
>>  net/netfilter/nf_conntrack_standalone.c | 9 +++++++++
>>  net/netfilter/nf_flow_table_offload.c   | 9 ++++++++-
>>  3 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
>> index a971d986a75b..ce270803ef27 100644
>> --- a/include/net/netns/nftables.h
>> +++ b/include/net/netns/nftables.h
>> @@ -9,6 +9,7 @@ struct netns_nftables {
>>  	atomic_t		count_hw;
>>  	int			max_hw;
>>  	atomic_t		count_wq_add;
>> +	int			max_wq_add;
>>  };
>>
>>  #endif
>> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
>> index fe2327823f7a..26e2b86eb060 100644
>> --- a/net/netfilter/nf_conntrack_standalone.c
>> +++ b/net/netfilter/nf_conntrack_standalone.c
>> @@ -622,6 +622,7 @@ enum nf_ct_sysctl_index {
>>  	NF_SYSCTL_CT_COUNT_HW,
>>  	NF_SYSCTL_CT_MAX_HW,
>>  	NF_SYSCTL_CT_COUNT_WQ_ADD,
>> +	NF_SYSCTL_CT_MAX_WQ_ADD,
>>  #endif
>>
>>  	__NF_SYSCTL_CT_LAST_SYSCTL,
>> @@ -998,6 +999,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>>  		.mode		= 0444,
>>  		.proc_handler	= proc_dointvec,
>>  	},
>> +	[NF_SYSCTL_CT_MAX_WQ_ADD] = {
>> +		.procname	= "nf_flowtable_max_wq_add",
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>>  #endif
>>  	{}
>>  };
>> @@ -1139,6 +1146,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>>  	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
>>  	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
>>  	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
>> +	table[NF_SYSCTL_CT_MAX_WQ_ADD].data = &net->nft.max_wq_add;
>>  #endif
>>
>>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
>> @@ -1153,6 +1161,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>>  		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
>>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>>  		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
>> +		table[NF_SYSCTL_CT_MAX_WQ_ADD].mode = 0444;
>>  #endif
>>  	}
>>
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index ffbcf0cfefeb..e29aa51696f5 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -1016,9 +1016,16 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>>  			 struct flow_offload *flow)
>>  {
>>  	struct net *net = read_pnet(&flowtable->net);
>> +	int max_wq_add = net->nft.max_wq_add;
>>  	struct flow_offload_work *offload;
>> +	int count_wq_add;
>> +
>> +	count_wq_add = atomic_inc_return(&net->nft.count_wq_add);
>> +	if (max_wq_add && count_wq_add > max_wq_add) {
>> +		atomic_dec(&net->nft.count_wq_add);
>> +		return;
>> +	}
>>
>> -	atomic_inc(&net->nft.count_wq_add);
>>  	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>>  	if (!offload) {
>>  		atomic_dec(&net->nft.count_wq_add);
>> --
>> 2.31.1
>>

