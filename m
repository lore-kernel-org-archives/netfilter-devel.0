Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51926C33CA9
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 05:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25ECF2075B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 05:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgANFpP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 00:45:15 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:53014 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgANFpP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 00:45:15 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 1AFA55C19C5;
        Tue, 14 Jan 2020 13:45:09 +0800 (CST)
Subject: Re: [PATCH nf-next 9/9] netfilter: flowtable: add
 nf_flow_table_offload_cmd()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200113181554.52612-1-pablo@netfilter.org>
 <20200113181554.52612-9-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <30705b0a-11ad-cd80-ffa6-f855b2e3c174@ucloud.cn>
Date:   Tue, 14 Jan 2020 13:45:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200113181554.52612-9-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhNQkJCQk1PTEpPS05ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MT46Qzo6Szg5GjIsET8pPE4j
        Qk0wCh1VSlVKTkxDQkNLTEtCTkxNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSExNSjcG
X-HM-Tid: 0a6fa29593392087kuqy1afa55c19c5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 1/14/2020 2:15 AM, Pablo Neira Ayuso wrote:
> Split nf_flow_table_offload_setup() in two functions to make it more
> maintainable.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_offload.c | 38 +++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index a08756dc96e4..cb10d903cc47 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -838,12 +838,12 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
>  	return err;
>  }
>  
> -int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
> -				struct net_device *dev,
> -				enum flow_block_command cmd)
> +static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
> +				     struct nf_flowtable *flowtable,
> +				     struct net_device *dev,
> +				     enum flow_block_command cmd,
> +				     struct netlink_ext_ack *extack)
>  {
> -	struct netlink_ext_ack extack = {};
> -	struct flow_block_offload bo = {};
>  	int err;
>  
>  	if (!nf_flowtable_hw_offload(flowtable))
> @@ -852,17 +852,33 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  	if (!dev->netdev_ops->ndo_setup_tc)
>  		return -EOPNOTSUPP;
>  
> -	bo.net		= dev_net(dev);
> -	bo.block	= &flowtable->flow_block;
> -	bo.command	= cmd;
> -	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> -	bo.extack	= &extack;
> -	INIT_LIST_HEAD(&bo.cb_list);
> +	memset(bo, 0, sizeof(*bo));
> +	bo->net		= dev_net(dev);
> +	bo->block	= &flowtable->flow_block;
> +	bo->command	= cmd;
> +	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> +	bo->extack	= extack;
> +	INIT_LIST_HEAD(&bo->cb_list);
>  
>  	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, &bo);

This callback should be :

                err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT,  bo);

>  	if (err < 0)
>  		return err;
>  
> +	return 0;
> +}
> +
> +int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
> +				struct net_device *dev,
> +				enum flow_block_command cmd)
> +{
> +	struct netlink_ext_ack extack = {};
> +	struct flow_block_offload bo;
> +	int err;
> +
> +	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
> +	if (err < 0)
> +		return err;
> +
>  	return nf_flow_table_block_setup(flowtable, &bo, cmd);
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
