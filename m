Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D44C32767
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350932072C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgAFDZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 22:25:41 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:45413 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgAFDZl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 22:25:41 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 3CA165C1946;
        Mon,  6 Jan 2020 11:25:38 +0800 (CST)
Subject: Re: [PATCH nf,v2] netfilter: flowtable: fetch stats only if flow is
 still alive
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200105215938.276229-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <e5428176-3814-00c9-4621-be18027d8afe@ucloud.cn>
Date:   Mon, 6 Jan 2020 11:25:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200105215938.276229-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mwg6Pjo5PDg0LD8pFwFDLBxM
        PgswC0NVSlVKTkxDSUNKSkhDSENPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEhKSzcG
X-HM-Tid: 0a6f78e2f8972087kuqy3ca165c1946
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Acked-by: wenxu <wenxu@ucloud.cn>

On 1/6/2020 5:59 AM, Pablo Neira Ayuso wrote:
> Do not fetch statistics if flow has expired since it might not in
> hardware anymore. After this update, remove the FLOW_OFFLOAD_HW_DYING
> check from nf_flow_offload_stats() since this flag is never set on.
>
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: remove dead code after this update in nf_flow_offload_stats().
>
>  net/netfilter/nf_flow_table_core.c    | 5 ++---
>  net/netfilter/nf_flow_table_offload.c | 3 +--
>  2 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index e33a73cb1f42..9e6de2bbeccb 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -348,9 +348,6 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>  {
>  	struct nf_flowtable *flow_table = data;
>  
> -	if (flow->flags & FLOW_OFFLOAD_HW)
> -		nf_flow_offload_stats(flow_table, flow);
> -
>  	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
>  	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))) {
>  		if (flow->flags & FLOW_OFFLOAD_HW) {
> @@ -361,6 +358,8 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>  		} else {
>  			flow_offload_del(flow_table, flow);
>  		}
> +	} else if (flow->flags & FLOW_OFFLOAD_HW) {
> +		nf_flow_offload_stats(flow_table, flow);
>  	}
>  }
>  
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index d06969af1085..4d1e81e2880f 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -784,8 +784,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>  	__s32 delta;
>  
>  	delta = nf_flow_timeout_delta(flow->timeout);
> -	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10) ||
> -	    flow->flags & FLOW_OFFLOAD_HW_DYING)
> +	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
>  		return;
>  
>  	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
