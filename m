Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 20:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiCLUL4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 15:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiCLULz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 15:11:55 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2148E1A8
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 12:10:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V31ZFp5D1K+iZGN8CrbtjAQf5h23yoI926pDcYN8epko5ZLKl1p6WWfujnYOZrlRpCiUYCWGr2q3ckHw6q6GnIINsKd9ikNnX5cUFQcpeufNwKmhthLeqQYkGABH2oBYKhY1g9NfcJxOtGFQYC9MDCosvLxViVxGVCd/mwGbWPckLRzAA7YLNAcUR/lzC3rbFHBW7JdSo3RZtfW33sOGPzYdhCkXq9SH18xUameLogo5WGtcayZzeRiHRDETxX54qZJJIY3y+lR3E816qszFnaUrqMIZL0CfeUl5qS1yFFUwZqpqRHYxDDxTmVVjlwedN3wFa8vhQXlhfOXw0LP0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvCzwS1awXACZ4xF5/g5qYrqG6X4iMHOk1wt+A6v0pg=;
 b=IfcZpcKhjv9k03E7KOad4AnjCD36Rsx+mB1lI/QeTsIPdG5S9kRmp8xsp3LCCmZEVlMTwgIcpk5zno4fkiImjV476exoSnPgTHJp774jp2CVApqz8vUTqrR13q/o9NtmS4dIJ3W7rTSXnUJMG1EbYDIzBvZO8tpEjxr4v0BxbCxv1MEBIGuy1UPtaxc9CeLaAnpkikHcu5XcASf1NOUEo5kuHrDEYxKcWVp6JhfK3/CWFQgCfJ1DJtSWdoLWQMYvv4CuLIPh3A6/Odm2N1+8esCLh1NVwwOw21qgMUxR8iZCzKJmL7B37whxqusIrdb+B463aOCaiKWigGaUHj77OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvCzwS1awXACZ4xF5/g5qYrqG6X4iMHOk1wt+A6v0pg=;
 b=TmDY8nDb3MVDIvmOa5hUcL/ZPUgRzMxcvgsS3/9MKDnOHiFRiTl/h6Mc5D+cX1fnZJ/jK8Qx5uWHnxpOKIzhlCpka3ZIliknROnjaDCbeGmKUVE6+Yh7VKvEVQNskD0SiO6OTZNgB96whMnobRTwrxX3MUc9LxysiYBRie23TWxLU09dg2sZlh+OfKQ3KRUx2ECutiQViYhNqpuQ4SA69ilaRBuFKYWxvN1eBT/dEQ68NzE2b3WchEWYTTiT/I7ZLEnBdLMn/+bX+fZk1a5XgHmcJpa4TQaF3LwAvSya5x5Fj0TwpxIynUi5KBbnPFyn5p0k5W3tyvo2RXJqp8cThA==
Received: from CO2PR05CA0104.namprd05.prod.outlook.com (2603:10b6:104:1::30)
 by MW3PR12MB4443.namprd12.prod.outlook.com (2603:10b6:303:2d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Sat, 12 Mar
 2022 20:10:47 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::6b) by CO2PR05CA0104.outlook.office365.com
 (2603:10b6:104:1::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.12 via Frontend
 Transport; Sat, 12 Mar 2022 20:10:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sat, 12 Mar 2022 20:10:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 12 Mar
 2022 20:10:46 +0000
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 12 Mar
 2022 12:10:43 -0800
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-9-vladbu@nvidia.com> <YiaL5a8akGHoIXLE@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next 8/8] netfilter: flowtable: add hardware offload
 tracepoints
Date:   Sat, 12 Mar 2022 22:05:55 +0200
In-Reply-To: <YiaL5a8akGHoIXLE@salvia>
Message-ID: <877d8zue2n.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20158cab-1358-42e0-020b-08da04646566
X-MS-TrafficTypeDiagnostic: MW3PR12MB4443:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB44431B478EABDA2E8FABB249A00D9@MW3PR12MB4443.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iv/YRAYfzmLOEA28Lk+dyd6QhE2xnrlP1PxhZo6EmOPoQcMCUyfsYQaA2tok0K3nXMZZRWw0ylFNB5Y48IzhI3148FdIrVknc/MEunDplJm/1kIsNtP4sj18o2a/JTVyrHQjnY7cyblcHxDz93VAD3btzpeQISFgtGWzU+ASo9zdeGbZRiTMofN5ws4G+NxXsU+ZmCSKnWBWe+ow5inaQ0jrU++Av1gunucN8Y0qo/ri/vVq7heaQKyaavaUN+VKc2z4acktB29Txtj+XsN0Zj8NzMwaNNwAd6QucS/H9Mu4Nw6fcjtINdQreogxxC6HLoT3sRNIvqRyu2bxp7NkX3o5lm5RL2np8J6hdx4CcvVChkoDt9BvOurUzHhfNnAW+mVxnfH43+oyrN16VxrZc8NSO3LBwGl+v6mSS+lq37ZDK5zlzPD0R9LU6fgWc6AeqJaRAwwIbFVPHtA3fIy6wul4QCIZjUqG2nLH2x2vHrvtAYtVZ856PKuvvpn1DYWPedLk9VjhGdynyeYTIxPRxVxtcpDGuLgkgiYUOzFvz4G2tBiGiIXBTakmm5ilZAk6uEyaNS3fzJClEBgDlOK0I0sfhlEEBp9V5O6w0SY3yLOT624OX0fXVoN0q9kKy6v7g/NCdFwWbtHOZJY8fIBpxjIzIyqb0KROJclzNHIpyHsPJ+Ni6zOdWSRLkhN+ukZFp1jjwNFtx0CZmm2xGAhI0g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(81166007)(8676002)(356005)(70586007)(316002)(4326008)(70206006)(6916009)(82310400004)(5660300002)(8936002)(86362001)(7696005)(2906002)(47076005)(426003)(16526019)(36756003)(107886003)(2616005)(26005)(186003)(83380400001)(54906003)(6666004)(40460700003)(36860700001)(508600001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 20:10:46.9833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20158cab-1358-42e0-020b-08da04646566
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4443
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Mon 07 Mar 2022 at 23:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 22, 2022 at 05:10:03PM +0200, Vlad Buslov wrote:
>> Add tracepoints to trace creation and start of execution of flowtable
>> hardware offload 'add', 'del' and 'stats' tasks. Move struct
>> flow_offload_work from source into header file to allow access to structure
>> fields from tracepoint code.
>
> This patch, I would prefer to keep it back and explore exposing trace
> infrastructure for the flowtable through netlink.
>

What approach do you have in mind with netlink? I used tracepoints here
because they are:

- Incur no performance penalty when disabled.

- Handy to attach BPF programs to.

According to my experience with optimizing TC control path parsing
Netlink is CPU-intensive. I am also not aware of mechanisms to leverage
it to attach BPF.

>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>  include/net/netfilter/nf_flow_table.h       |  9 ++++
>>  net/netfilter/nf_flow_table_offload.c       | 20 +++++----
>>  net/netfilter/nf_flow_table_offload_trace.h | 48 +++++++++++++++++++++
>>  3 files changed, 68 insertions(+), 9 deletions(-)
>>  create mode 100644 net/netfilter/nf_flow_table_offload_trace.h
>> 
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index a3647fadf1cc..5e2aef34acaa 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -174,6 +174,15 @@ struct flow_offload {
>>  	struct rcu_head				rcu_head;
>>  };
>>  
>> +struct flow_offload_work {
>> +	struct list_head list;
>> +	enum flow_cls_command cmd;
>> +	int priority;
>> +	struct nf_flowtable *flowtable;
>> +	struct flow_offload *flow;
>> +	struct work_struct work;
>> +};
>> +
>>  #define NF_FLOW_TIMEOUT (30 * HZ)
>>  #define nf_flowtable_time_stamp	(u32)jiffies
>>  
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index ff52d903aad9..bf94050d5b54 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -12,20 +12,13 @@
>>  #include <net/netfilter/nf_conntrack_acct.h>
>>  #include <net/netfilter/nf_conntrack_core.h>
>>  #include <net/netfilter/nf_conntrack_tuple.h>
>> +#define CREATE_TRACE_POINTS
>> +#include "nf_flow_table_offload_trace.h"
>>  
>>  static struct workqueue_struct *nf_flow_offload_add_wq;
>>  static struct workqueue_struct *nf_flow_offload_del_wq;
>>  static struct workqueue_struct *nf_flow_offload_stats_wq;
>>  
>> -struct flow_offload_work {
>> -	struct list_head	list;
>> -	enum flow_cls_command	cmd;
>> -	int			priority;
>> -	struct nf_flowtable	*flowtable;
>> -	struct flow_offload	*flow;
>> -	struct work_struct	work;
>> -};
>> -
>>  #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
>>  	(__match)->dissector.offset[__type] =		\
>>  		offsetof(struct nf_flow_key, __field)
>> @@ -895,6 +888,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
>>  	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
>>  	int err;
>>  
>> +	trace_flow_offload_work_add(offload);
>> +
>>  	err = nf_flow_offload_alloc(offload, flow_rule);
>>  	if (err < 0)
>>  		return;
>> @@ -911,6 +906,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
>>  
>>  static void flow_offload_work_del(struct flow_offload_work *offload)
>>  {
>> +	trace_flow_offload_work_del(offload);
>> +
>>  	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
>>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
>>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
>> @@ -931,6 +928,8 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>>  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
>>  	u64 lastused;
>>  
>> +	trace_flow_offload_work_stats(offload);
>> +
>>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
>>  
>> @@ -1034,6 +1033,7 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>>  		return;
>>  	}
>>  
>> +	trace_flow_offload_add(offload);
>>  	flow_offload_queue_work(offload);
>>  }
>>  
>> @@ -1048,6 +1048,7 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
>>  		return;
>>  
>>  	atomic_inc(&net->nft.count_wq_del);
>> +	trace_flow_offload_del(offload);
>>  	set_bit(NF_FLOW_HW_DYING, &flow->flags);
>>  	flow_offload_queue_work(offload);
>>  }
>> @@ -1068,6 +1069,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>>  		return;
>>  
>>  	atomic_inc(&net->nft.count_wq_stats);
>> +	trace_flow_offload_stats(offload);
>>  	flow_offload_queue_work(offload);
>>  }
>>  
>> diff --git a/net/netfilter/nf_flow_table_offload_trace.h b/net/netfilter/nf_flow_table_offload_trace.h
>> new file mode 100644
>> index 000000000000..49cfbc2ec35d
>> --- /dev/null
>> +++ b/net/netfilter/nf_flow_table_offload_trace.h
>> @@ -0,0 +1,48 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM nf
>> +
>> +#if !defined(_NF_FLOW_TABLE_OFFLOAD_TRACE_) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _NF_FLOW_TABLE_OFFLOAD_TRACE_
>> +
>> +#include <linux/tracepoint.h>
>> +#include <net/netfilter/nf_tables.h>
>> +
>> +DECLARE_EVENT_CLASS(
>> +	nf_flow_offload_work_template,
>> +	TP_PROTO(struct flow_offload_work *w),
>> +	TP_ARGS(w),
>> +	TP_STRUCT__entry(
>> +		__field(void *, work)
>> +		__field(void *, flowtable)
>> +		__field(void *, flow)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->work = w;
>> +		__entry->flowtable = w->flowtable;
>> +		__entry->flow = w->flow;
>> +	),
>> +	TP_printk("work=%p flowtable=%p flow=%p",
>> +		  __entry->work, __entry->flowtable, __entry->flow)
>> +);
>> +
>> +#define DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(name)				\
>> +	DEFINE_EVENT(nf_flow_offload_work_template, name,		\
>> +		     TP_PROTO(struct flow_offload_work *w), TP_ARGS(w))
>> +
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_add);
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_add);
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_del);
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_del);
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_stats);
>> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_stats);
>> +
>> +#endif
>> +
>> +/* This part must be outside protection */
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH ../../net/netfilter
>> +#undef TRACE_INCLUDE_FILE
>> +#define TRACE_INCLUDE_FILE nf_flow_table_offload_trace
>> +#include <trace/define_trace.h>
>> -- 
>> 2.31.1
>> 

