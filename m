Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC03C32771
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 00:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47AF02072A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 00:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgAGAeN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 19:34:13 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41613 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgAGAeN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 19:34:13 -0500
Received: from [192.168.1.7] (unknown [101.86.134.13])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D77EC415F5;
        Tue,  7 Jan 2020 08:34:10 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: flowtable: refresh flow if hardware
 offload fails
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200106120337.13626-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <fbdafa04-ee1e-6430-db99-52d41b70e8da@ucloud.cn>
Date:   Tue, 7 Jan 2020 08:33:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106120337.13626-1-pablo@netfilter.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUhJQkJCQ0JMS0tISkxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxA6Dgw6DDg6PD9ITh8*UUJJ
        LRFPCgJVSlVKTkxDSE5MSU5KS09JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        TVVKSE9VSkhZV1kIAVlBT0hCTjcG
X-HM-Tid: 0a6f7d6c5b832086kuqyd77ec415f5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


ÔÚ 2020/1/6 20:03, Pablo Neira Ayuso Ð´µÀ:
> If nf_flow_offload_add() fails to add the flow to hardware, then the
> NF_FLOW_HW flag bit is unset and the flow remains in the flowtable
> software path.
>
> If flowtable hardware offload is enabled, this patch enqueues a new
> request to offload this flow to hardware.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/nf_flow_table_core.c    |  4 +++-
>   net/netfilter/nf_flow_table_ip.c      | 10 ++++++++++
>   net/netfilter/nf_flow_table_offload.c |  3 +--
>   3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 9f134f44d139..388e87b06a00 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -243,8 +243,10 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>   		return err;
>   	}
>   
> -	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD)
> +	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) {
> +		__set_bit(NF_FLOW_HW, &flow->flags);
>   		nf_flow_offload_add(flow_table, flow);
> +	}
>   
>   	return 0;
>   }
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index f4ccb5f5008b..6e0a5bacfe2e 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -259,6 +259,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>   
>   	dir = tuplehash->tuple.dir;
>   	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +
> +	if (unlikely((flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) &&
> +		     !test_and_set_bit(NF_FLOW_HW, &flow->flags)))
> +		nf_flow_offload_add(flow_table, flow);
> +

Maybe put the refresh operation ather the nf_flow_state_check to aviod

the RST/FIN packets do the this?

>   	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
>   	outdev = rt->dst.dev;
>   
> @@ -488,6 +493,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>   
>   	dir = tuplehash->tuple.dir;
>   	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +
> +	if (unlikely((flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) &&
> +		     !test_and_set_bit(NF_FLOW_HW, &flow->flags)))
> +		nf_flow_offload_add(flow_table, flow);
> +
>   	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
>   	outdev = rt->dst.dev;
>   
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 8a1fe391666e..e7b766b3f731 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -723,7 +723,7 @@ static void flow_offload_work_handler(struct work_struct *work)
>   		case FLOW_CLS_REPLACE:
>   			ret = flow_offload_work_add(offload);
>   			if (ret < 0)
> -				__clear_bit(NF_FLOW_HW, &offload->flow->flags);
> +				clear_bit(NF_FLOW_HW, &offload->flow->flags);
>   			break;
>   		case FLOW_CLS_DESTROY:
>   			flow_offload_work_del(offload);
> @@ -776,7 +776,6 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>   	if (!offload)
>   		return;
>   
> -	__set_bit(NF_FLOW_HW, &flow->flags);
>   	flow_offload_queue_work(offload);
>   }
>   
