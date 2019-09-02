Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EDCC3A59B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 06:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 897152190F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 06:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfIBGPD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 02:15:03 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55081 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbfIBGPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 02:15:02 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C182B4195A;
        Mon,  2 Sep 2019 14:14:56 +0800 (CST)
Subject: Re: [PATCH nf-next v2] netfilter: nf_table_offload: Fix the incorrect
 rcu usage in nft_indr_block_get_and_ing_cmd
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1566220952-27225-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <f8951093-2874-847e-4a3c-0e4cc69b6f6f@ucloud.cn>
Date:   Mon, 2 Sep 2019 14:14:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566220952-27225-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0xIS0tLT0hKS01LTEJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NVE6HSo*PzgyOTEVCEtLOFYY
        TSkaCilVSlVKTk1MT0tPQ0JMSkJCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUxNSDcG
X-HM-Tid: 0a6cf09cb2812086kuqyc182b4195a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


any other questions about this patch?


BR

wenxu

On 8/19/2019 9:22 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> The flow_block_ing_cmd() needs to call blocking functions while iterating
> block_ing_cb_list, nft_indr_block_get_and_ing_cmd is in the cb_list,
> So it is the incorrect rcu case. To fix it just traverse the list under
> the commit mutex.
>
> Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nf_tables_offload.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index b95e27b..5431741 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -363,11 +363,12 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
>  	const struct nft_table *table;
>  	const struct nft_chain *chain;
>  
> -	list_for_each_entry_rcu(table, &net->nft.tables, list) {
> +	mutex_lock(&net->nft.commit_mutex);
> +	list_for_each_entry(table, &net->nft.tables, list) {
>  		if (table->family != NFPROTO_NETDEV)
>  			continue;
>  
> -		list_for_each_entry_rcu(chain, &table->chains, list) {
> +		list_for_each_entry(chain, &table->chains, list) {
>  			if (nft_is_base_chain(chain)) {
>  				struct nft_base_chain *basechain;
>  
> @@ -382,4 +383,5 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
>  			}
>  		}
>  	}
> +	mutex_unlock(&net->nft.commit_mutex);
>  }
