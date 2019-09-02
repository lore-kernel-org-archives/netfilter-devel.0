Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD278C3A59B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 06:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885742190F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 06:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfIBGN0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 02:13:26 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50891 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfIBGN0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 02:13:26 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C663B4174A;
        Mon,  2 Sep 2019 14:13:20 +0800 (CST)
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_offload: Make
 nft_flow_offload_chain public
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1566207905-22203-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <a0cb6863-23d8-6633-44f5-64167122db28@ucloud.cn>
Date:   Mon, 2 Sep 2019 14:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566207905-22203-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0xIS0tLT0hKS01LTEJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBg6FBw4SDg4HzEBGEswOQwV
        LAEaCQJVSlVKTk1MT0tPQ0tKS0NNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT05KTDcG
X-HM-Tid: 0a6cf09b3bb92086kuqyc663b4174a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,

any idea about this series?


BR

wenxu

On 8/19/2019 5:45 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Refactor nft_flow_offload_chain and make it public in header
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/netfilter/nf_tables_offload.h |  3 +++
>  net/netfilter/nf_tables_offload.c         | 25 ++++++++++++++++---------
>  2 files changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
> index 8a5969d9..a13aab1 100644
> --- a/include/net/netfilter/nf_tables_offload.h
> +++ b/include/net/netfilter/nf_tables_offload.h
> @@ -69,6 +69,9 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
>  				    void *cb_priv,
>  				    enum flow_block_command command);
>  
> +int nft_flow_offload_chain(struct nft_chain *chain,
> +			   enum flow_block_command cmd);
> +
>  #define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
>  	(__reg)->base_offset	=					\
>  		offsetof(struct nft_flow_key, __base);			\
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index fd8d3ab..3ffe4bb 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -262,10 +262,9 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
>  
>  #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
>  
> -static int nft_flow_offload_chain(struct nft_trans *trans,
> -				  enum flow_block_command cmd)
> +int nft_flow_offload_chain(struct nft_chain *chain,
> +			   enum flow_block_command cmd)
>  {
> -	struct nft_chain *chain = trans->ctx.chain;
>  	struct nft_base_chain *basechain;
>  	struct net_device *dev;
>  
> @@ -277,16 +276,24 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
>  	if (!dev)
>  		return -EOPNOTSUPP;
>  
> +	if (dev->netdev_ops->ndo_setup_tc)
> +		return nft_block_offload_cmd(basechain, dev, cmd);
> +	else
> +		return nft_indr_block_offload_cmd(basechain, dev, cmd);
> +}
> +
> +static int __nft_flow_offload_chain(struct nft_trans *trans,
> +				    enum flow_block_command cmd)
> +{
> +	struct nft_chain *chain = trans->ctx.chain;
> +
>  	/* Only default policy to accept is supported for now. */
>  	if (cmd == FLOW_BLOCK_BIND &&
>  	    nft_trans_chain_policy(trans) != -1 &&
>  	    nft_trans_chain_policy(trans) != NF_ACCEPT)
>  		return -EOPNOTSUPP;
>  
> -	if (dev->netdev_ops->ndo_setup_tc)
> -		return nft_block_offload_cmd(basechain, dev, cmd);
> -	else
> -		return nft_indr_block_offload_cmd(basechain, dev, cmd);
> +	return nft_flow_offload_chain(chain, cmd);
>  }
>  
>  int nft_flow_rule_offload_commit(struct net *net)
> @@ -303,13 +310,13 @@ int nft_flow_rule_offload_commit(struct net *net)
>  			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
>  				continue;
>  
> -			err = nft_flow_offload_chain(trans, FLOW_BLOCK_BIND);
> +			err = __nft_flow_offload_chain(trans, FLOW_BLOCK_BIND);
>  			break;
>  		case NFT_MSG_DELCHAIN:
>  			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
>  				continue;
>  
> -			err = nft_flow_offload_chain(trans, FLOW_BLOCK_UNBIND);
> +			err = __nft_flow_offload_chain(trans, FLOW_BLOCK_UNBIND);
>  			break;
>  		case NFT_MSG_NEWRULE:
>  			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
