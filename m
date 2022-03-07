Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 22:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiCGWuJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiCGWuI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 17:50:08 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62A626565
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 14:49:13 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2068B625F9;
        Mon,  7 Mar 2022 23:47:22 +0100 (CET)
Date:   Mon, 7 Mar 2022 23:49:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 8/8] netfilter: flowtable: add hardware offload
 tracepoints
Message-ID: <YiaL5a8akGHoIXLE@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-9-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-9-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:10:03PM +0200, Vlad Buslov wrote:
> Add tracepoints to trace creation and start of execution of flowtable
> hardware offload 'add', 'del' and 'stats' tasks. Move struct
> flow_offload_work from source into header file to allow access to structure
> fields from tracepoint code.

This patch, I would prefer to keep it back and explore exposing trace
infrastructure for the flowtable through netlink.

> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---
>  include/net/netfilter/nf_flow_table.h       |  9 ++++
>  net/netfilter/nf_flow_table_offload.c       | 20 +++++----
>  net/netfilter/nf_flow_table_offload_trace.h | 48 +++++++++++++++++++++
>  3 files changed, 68 insertions(+), 9 deletions(-)
>  create mode 100644 net/netfilter/nf_flow_table_offload_trace.h
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index a3647fadf1cc..5e2aef34acaa 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -174,6 +174,15 @@ struct flow_offload {
>  	struct rcu_head				rcu_head;
>  };
>  
> +struct flow_offload_work {
> +	struct list_head list;
> +	enum flow_cls_command cmd;
> +	int priority;
> +	struct nf_flowtable *flowtable;
> +	struct flow_offload *flow;
> +	struct work_struct work;
> +};
> +
>  #define NF_FLOW_TIMEOUT (30 * HZ)
>  #define nf_flowtable_time_stamp	(u32)jiffies
>  
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index ff52d903aad9..bf94050d5b54 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -12,20 +12,13 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_tuple.h>
> +#define CREATE_TRACE_POINTS
> +#include "nf_flow_table_offload_trace.h"
>  
>  static struct workqueue_struct *nf_flow_offload_add_wq;
>  static struct workqueue_struct *nf_flow_offload_del_wq;
>  static struct workqueue_struct *nf_flow_offload_stats_wq;
>  
> -struct flow_offload_work {
> -	struct list_head	list;
> -	enum flow_cls_command	cmd;
> -	int			priority;
> -	struct nf_flowtable	*flowtable;
> -	struct flow_offload	*flow;
> -	struct work_struct	work;
> -};
> -
>  #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
>  	(__match)->dissector.offset[__type] =		\
>  		offsetof(struct nf_flow_key, __field)
> @@ -895,6 +888,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
>  	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
>  	int err;
>  
> +	trace_flow_offload_work_add(offload);
> +
>  	err = nf_flow_offload_alloc(offload, flow_rule);
>  	if (err < 0)
>  		return;
> @@ -911,6 +906,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
>  
>  static void flow_offload_work_del(struct flow_offload_work *offload)
>  {
> +	trace_flow_offload_work_del(offload);
> +
>  	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> @@ -931,6 +928,8 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
>  	u64 lastused;
>  
> +	trace_flow_offload_work_stats(offload);
> +
>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
>  
> @@ -1034,6 +1033,7 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>  		return;
>  	}
>  
> +	trace_flow_offload_add(offload);
>  	flow_offload_queue_work(offload);
>  }
>  
> @@ -1048,6 +1048,7 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
>  		return;
>  
>  	atomic_inc(&net->nft.count_wq_del);
> +	trace_flow_offload_del(offload);
>  	set_bit(NF_FLOW_HW_DYING, &flow->flags);
>  	flow_offload_queue_work(offload);
>  }
> @@ -1068,6 +1069,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>  		return;
>  
>  	atomic_inc(&net->nft.count_wq_stats);
> +	trace_flow_offload_stats(offload);
>  	flow_offload_queue_work(offload);
>  }
>  
> diff --git a/net/netfilter/nf_flow_table_offload_trace.h b/net/netfilter/nf_flow_table_offload_trace.h
> new file mode 100644
> index 000000000000..49cfbc2ec35d
> --- /dev/null
> +++ b/net/netfilter/nf_flow_table_offload_trace.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM nf
> +
> +#if !defined(_NF_FLOW_TABLE_OFFLOAD_TRACE_) || defined(TRACE_HEADER_MULTI_READ)
> +#define _NF_FLOW_TABLE_OFFLOAD_TRACE_
> +
> +#include <linux/tracepoint.h>
> +#include <net/netfilter/nf_tables.h>
> +
> +DECLARE_EVENT_CLASS(
> +	nf_flow_offload_work_template,
> +	TP_PROTO(struct flow_offload_work *w),
> +	TP_ARGS(w),
> +	TP_STRUCT__entry(
> +		__field(void *, work)
> +		__field(void *, flowtable)
> +		__field(void *, flow)
> +	),
> +	TP_fast_assign(
> +		__entry->work = w;
> +		__entry->flowtable = w->flowtable;
> +		__entry->flow = w->flow;
> +	),
> +	TP_printk("work=%p flowtable=%p flow=%p",
> +		  __entry->work, __entry->flowtable, __entry->flow)
> +);
> +
> +#define DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(name)				\
> +	DEFINE_EVENT(nf_flow_offload_work_template, name,		\
> +		     TP_PROTO(struct flow_offload_work *w), TP_ARGS(w))
> +
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_add);
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_add);
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_del);
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_del);
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_stats);
> +DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_stats);
> +
> +#endif
> +
> +/* This part must be outside protection */
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../net/netfilter
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE nf_flow_table_offload_trace
> +#include <trace/define_trace.h>
> -- 
> 2.31.1
> 
