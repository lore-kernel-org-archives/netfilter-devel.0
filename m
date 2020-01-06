Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3744CC32771
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F0EC207FD
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgAFJQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 04:16:14 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:60395 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgAFJQO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 04:16:14 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B60F34191D;
        Mon,  6 Jan 2020 17:16:09 +0800 (CST)
Subject: Re: [PATCH nf,v3] netfilter: flowtable: add nf_flowtable_time_stamp
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200106090639.279982-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <68c9cfab-ed14-43d2-aa43-d09a60ff393b@ucloud.cn>
Date:   Mon, 6 Jan 2020 17:16:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200106090639.279982-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pJS0tLS01LS0NKT0NZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pzo6LTo6NTg5Qz8DFC0*GjQh
        Ak0wChVVSlVKTkxDSEtJSk1CQkxMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTktISzcG
X-HM-Tid: 0a6f7a23e2cc2086kuqyb60f34191d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Acked-by: wenxu <wenxu@ucloud.cn>

On 1/6/2020 5:06 PM, Pablo Neira Ayuso wrote:
> This patch adds nf_flowtable_time_stamp and updates the existing code to
> use it.
>
> This patch is also implicitly fixing up hardware statistic fetching via
> nf_flow_offload_stats() where casting to u32 is missing. Use
> nf_flow_timeout_delta() to fix this.
>
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: update nf_flow_timeout_delta() to use nf_flowtable_time_stamp - wenxu.
>
>  include/net/netfilter/nf_flow_table.h | 6 ++++++
>  net/netfilter/nf_flow_table_core.c    | 7 +------
>  net/netfilter/nf_flow_table_ip.c      | 4 ++--
>  net/netfilter/nf_flow_table_offload.c | 4 ++--
>  4 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index f0897b3c97fb..415b8f49d150 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -106,6 +106,12 @@ struct flow_offload {
>  };
>  
>  #define NF_FLOW_TIMEOUT (30 * HZ)
> +#define nf_flowtable_time_stamp	(u32)jiffies
> +
> +static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
> +{
> +	return (__s32)(timeout - nf_flowtable_time_stamp);
> +}
>  
>  struct nf_flow_route {
>  	struct {
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 9889d52eda82..e33a73cb1f42 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -134,11 +134,6 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
>  #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
>  #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
>  
> -static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
> -{
> -	return (__s32)(timeout - (u32)jiffies);
> -}
> -
>  static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
>  {
>  	const struct nf_conntrack_l4proto *l4proto;
> @@ -232,7 +227,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  {
>  	int err;
>  
> -	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
> +	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
>  
>  	err = rhashtable_insert_fast(&flow_table->rhashtable,
>  				     &flow->tuplehash[0].node,
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index b9e7dd6e60ce..7ea2ddc2aa93 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -280,7 +280,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
>  		return NF_DROP;
>  
> -	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
> +	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
>  	iph = ip_hdr(skb);
>  	ip_decrease_ttl(iph);
>  	skb->tstamp = 0;
> @@ -509,7 +509,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
>  		return NF_DROP;
>  
> -	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
> +	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
>  	ip6h = ipv6_hdr(skb);
>  	ip6h->hop_limit--;
>  	skb->tstamp = 0;
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 6c162c954c4f..d06969af1085 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -781,9 +781,9 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>  			   struct flow_offload *flow)
>  {
>  	struct flow_offload_work *offload;
> -	s64 delta;
> +	__s32 delta;
>  
> -	delta = flow->timeout - jiffies;
> +	delta = nf_flow_timeout_delta(flow->timeout);
>  	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10) ||
>  	    flow->flags & FLOW_OFFLOAD_HW_DYING)
>  		return;
