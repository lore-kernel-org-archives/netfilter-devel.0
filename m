Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14131C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 19:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiCLTtz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 14:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiCLTty (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 14:49:54 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043AA5E17D
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 11:48:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCbR8Pi5xlIoWD1QDO2OUM24SaZsvrgXgSrA5Ur8SNzJZaH9UKzPLLdIB+/xeKX6Qa+1/YRuJsqWinsDc4bG7sAIQdppCLZvHXucm/Mgy3zDRluUqJKnMHu4a96e84IoEYDeGEv+PI1wyN55JadhCVD2+8VJOaXTfifUy2610HF58OasciT6J7JaC4A+1gnSQywn9eeXz6wmyvwRrE+bwmKIuM7rn65fAUSGFjCWHxsDk2uiHj9x1Pn1xeX+hA/jDm0yHeZdEqZn+fh5i/k2MTSkeqTUarm50sNncJxwJV9eSC6WLTb2e549X+O/nAhD79bP/PSOCdRiLaXKqRX/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKr9wV+J3t8kiYdF5DwipeAg5IThTuXPdkOrXrqX2aE=;
 b=E37in3D1cj2qu0XBApLzxc6fUqTfxChLFTax+hcUQ4qrGmiQ+NZwknY/dRMNhOEOAzXL0zF1Wy/vwcV3fpHSB4fOmWYX7T5VOqOKAgGsySzXH3IYWW4i6jNEA0yrEFFjKrJ3iMVXCzfkPgVCyzw16mclY5Q4mzPia68j8x28IFc7fSTlhyYSvYU/uO7T19QYhMGCI4mk8sRf6bQLdmUpfOyeSyWjGlH42CvGjIrA44p1Rqxvvym577Bhdw4w3rLitp8be8mCWAOYIlSLibRptESqswMh4rA9HgsxfWLTPRIOm/N+ZBHS2GX+OTeTCwuE8r4q9mXIDkfCjsoBHFT1Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKr9wV+J3t8kiYdF5DwipeAg5IThTuXPdkOrXrqX2aE=;
 b=K2T9Q0AiKItPlWuTFIpLf4ve1mVzQTJuQVyJXOJ7oU2waV0ZAiYjXq7C2NbLUoec1ktr5y6tQI7JjQsoP0pYhcVVlwoTvORTSP5pNi7/FPQ4NmoRehysMcU7wN13yPEJAjgBXU8Bt0Ai7w73i+5fGaAyrv66aqPTwQUsWrpdPQiH0hkdfuLiv/pxojfhBJZ3ENNT/SjrVjHUMvhsTNCFQ8t6VAtxok8Z/VEbBxUDrpx0MVPpJqmZJ19Kib7Ivgs18IWh2S1wd4TDfsueNQ6u12UvFtWdr5bTP2xVkeM87hXttLCVo+lHaJZUf23FnttR1K+Y6kKkwrnt6G7OKsHJQA==
Received: from DM6PR06CA0086.namprd06.prod.outlook.com (2603:10b6:5:336::19)
 by BN7PR12MB2835.namprd12.prod.outlook.com (2603:10b6:408:30::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sat, 12 Mar
 2022 19:48:45 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::70) by DM6PR06CA0086.outlook.office365.com
 (2603:10b6:5:336::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.23 via Frontend
 Transport; Sat, 12 Mar 2022 19:48:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sat, 12 Mar 2022 19:48:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 12 Mar
 2022 19:48:44 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 12 Mar
 2022 11:48:40 -0800
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-4-vladbu@nvidia.com> <YiaDhju4TNFtLJSE@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 3/8] netfilter: introduce max count of hw
 offloaded flow table entries
Date:   Sat, 12 Mar 2022 21:32:44 +0200
In-Reply-To: <YiaDhju4TNFtLJSE@salvia>
Message-ID: <87k0czuf3e.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed016b51-7308-4b7c-dd71-08da04615179
X-MS-TrafficTypeDiagnostic: BN7PR12MB2835:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB283516EBC5A7D5C8897BE56DA00D9@BN7PR12MB2835.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNZ8UNaEtzh4I+cVaqVTLFlhsLRVGh4PIZmKRGG95X6wM+RJQza155mw5xpJhxia5vae9Qcbdj4QPTmFwITgbYFEkrHfrJ6FhITzTHW2Wh1m90CZMnFDlP8Js2CzgDNzGl0NOiUzSAYjXCuh5qYXgZWvOd33cmof5sA/oSRPI27fAbe23bqwnEVBGkMgJps+tUZxWfKCujeetKGebJVow7lXCT92fFjDkuDM4Dv8WcPM1mO7jBU49+M8FvYmtdVjalfd0s9JOaJVV1nbo1sfSo3RUZCrnA+Vy6Ays52dbOabYtC9p6RKT+gv8RRJw7bbarWj6nijajdU0LD026yB7l+RS4EbGxEjqzIDA0g1349ruq36TBNSdQfcNUxSM6zdKO2aIVXz7zHbRkyrJQ7Bjv+Up5z19VoawtSPiZvtQaPkkqkSZ19PaJgV8MUpDKyLP0IwUb4ZVtLtRXdYDtMEU1I7gZ3wJHXeWGGXQMMlexRBA4ZaSb16CItUYDS9rQtINp4xT/Q8vW7AoHOJQXUIGLgGPLH34cknySpwqooErGoursZR+QGMVgU9hDUTZhNcGPB8VpwWVU0XbCj47PX83OXqmxLLCm0nyxmiBrrtRQnc4qwZ9uOize7w1wbo3rVslFMd2SVOn3AtvJiXb/IbTsM41XINRKIrINMJ6UTo/hWDeLMEXryaUvElEA7kFTZ4MWHNwnQ6t5q25RbMXws4DQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2616005)(508600001)(36756003)(47076005)(6916009)(83380400001)(54906003)(7696005)(40460700003)(4326008)(70206006)(316002)(82310400004)(8676002)(5660300002)(8936002)(70586007)(336012)(426003)(86362001)(356005)(16526019)(81166007)(36860700001)(186003)(107886003)(26005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 19:48:45.0376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed016b51-7308-4b7c-dd71-08da04615179
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2835
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Mon 07 Mar 2022 at 23:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 22, 2022 at 05:09:58PM +0200, Vlad Buslov wrote:
>> To improve hardware offload debuggability extend struct netns_nftables with
>> 'max_hw' counter and expose it to userspace as 'nf_flowtable_max_hw' sysctl
>> entry. Verify that count_hw value is less than max_hw and don't offload new
>> flow table entry to hardware, if this is not the case. Flows that were not
>> offloaded due to count_hw being larger than set maximum can still be
>> offloaded via refresh function. Mark such flows with NF_FLOW_HW bit and
>> only count them once by checking that the bit was previously not set.
>
> Fine with me. Keep in mind there is also an implicit cap with the
> maximum number of conntrack entries (nf_conntrack_max).

I know. With this counter we have more graceful behavior comparing to
just dropping the packets outright - the flow is still processed in
software and can eventually be offloaded by refresh mechanism when
counter is decremented due to deletion of existing offloaded flow.

>
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>  include/net/netns/nftables.h            |  1 +
>>  net/netfilter/nf_conntrack_standalone.c | 11 +++++++++++
>>  net/netfilter/nf_flow_table_core.c      | 25 +++++++++++++++++++++++--
>>  3 files changed, 35 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
>> index 262b8b3213cb..5677f21fdd4c 100644
>> --- a/include/net/netns/nftables.h
>> +++ b/include/net/netns/nftables.h
>> @@ -7,6 +7,7 @@
>>  struct netns_nftables {
>>  	u8			gencursor;
>>  	atomic_t		count_hw;
>> +	int			max_hw;
>>  };
>>  
>>  #endif
>> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
>> index 8cd55d502ffd..af0dea471119 100644
>> --- a/net/netfilter/nf_conntrack_standalone.c
>> +++ b/net/netfilter/nf_conntrack_standalone.c
>> @@ -620,6 +620,7 @@ enum nf_ct_sysctl_index {
>>  #endif
>>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>>  	NF_SYSCTL_CT_COUNT_HW,
>> +	NF_SYSCTL_CT_MAX_HW,
>>  #endif
>>  
>>  	__NF_SYSCTL_CT_LAST_SYSCTL,
>> @@ -984,6 +985,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>>  		.mode		= 0444,
>>  		.proc_handler	= proc_dointvec,
>>  	},
>> +	[NF_SYSCTL_CT_MAX_HW] = {
>> +		.procname	= "nf_flowtable_max_hw",
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>>  #endif
>>  	{}
>>  };
>> @@ -1123,6 +1130,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>>  #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>>  	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
>>  	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
>> +	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
>>  #endif
>>  
>>  	nf_conntrack_standalone_init_tcp_sysctl(net, table);
>> @@ -1135,6 +1143,9 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>>  		table[NF_SYSCTL_CT_MAX].mode = 0444;
>>  		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
>>  		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
>> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>> +		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
>> +#endif
>>  	}
>>  
>>  	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 9f2b68bc6f80..2631bd0ae9ae 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -290,6 +290,20 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
>>  	return timeout;
>>  }
>>  
>> +static bool flow_offload_inc_count_hw(struct nf_flowtable *flow_table)
>> +{
>> +	struct net *net = read_pnet(&flow_table->net);
>> +	int max_hw = net->nft.max_hw, count_hw;
>> +
>> +	count_hw = atomic_inc_return(&net->nft.count_hw);
>> +	if (max_hw && count_hw > max_hw) {
>> +		atomic_dec(&net->nft.count_hw);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>>  {
>>  	int err;
>> @@ -315,9 +329,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>>  	nf_ct_offload_timeout(flow->ct);
>>  
>>  	if (nf_flowtable_hw_offload(flow_table)) {
>> -		struct net *net = read_pnet(&flow_table->net);
>> +		if (!flow_offload_inc_count_hw(flow_table))
>> +			return 0;
>
> Maybe, here something like:
>
>                 if (atomic_read(count_hw) > max_hw)
>                         return 0;
>
> to catch for early overlimit.
>
> Then, use the logic I suggested for patch 2/8, ie. increment/decrement
> this counter from the work handlers?

Hmm, so you are suggesting to just read the counter value on data path
and only change it in wq task? That could prevent the wq spam, assuming
the counter balancing issue is solved.

>
>> -		atomic_inc(&net->nft.count_hw);
>>  		__set_bit(NF_FLOW_HW, &flow->flags);
>>  		nf_flow_offload_add(flow_table, flow);
>>  	}
>> @@ -329,6 +343,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
>>  void flow_offload_refresh(struct nf_flowtable *flow_table,
>>  			  struct flow_offload *flow)
>>  {
>> +	struct net *net = read_pnet(&flow_table->net);
>>  	u32 timeout;
>>  
>>  	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
>> @@ -338,6 +353,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
>>  	if (likely(!nf_flowtable_hw_offload(flow_table)))
>>  		return;
>>  
>> +	if (!flow_offload_inc_count_hw(flow_table))
>
> This is packet path, better avoid this atomic operation if possible.
>
>> +		return;
>> +	/* only count each flow once when setting NF_FLOW_HW bit */
>> +	if (test_and_set_bit(NF_FLOW_HW, &flow->flags))
>> +		atomic_dec(&net->nft.count_hw);
>> +
>>  	nf_flow_offload_add(flow_table, flow);
>>  }
>>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
>> -- 
>> 2.31.1
>> 

