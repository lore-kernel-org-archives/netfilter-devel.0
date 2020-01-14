Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B3FC33CA9
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 05:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299D82072B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 05:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgANF6e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 00:58:34 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:60441 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgANF6e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 00:58:34 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 65008418E0;
        Tue, 14 Jan 2020 13:58:29 +0800 (CST)
Subject: Re: [PATCH nf-next 8/9] netfilter: flowtable: add
 flow_offload_tuple() helper
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200113181554.52612-1-pablo@netfilter.org>
 <20200113181554.52612-8-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b7313b85-3c93-fba5-ea8f-47cdd5d7e4f7@ucloud.cn>
Date:   Tue, 14 Jan 2020 13:58:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200113181554.52612-8-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhKQkJCQk1CT0NJT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ND46Qyo*FTg0FjJMPzIMHlE8
        HwEKFB9VSlVKTkxDQkNKTktCTU9LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0xJTzcG
X-HM-Tid: 0a6fa2a1c96c2086kuqy65008418e0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 1/14/2020 2:15 AM, Pablo Neira Ayuso wrote:
> Consolidate code to configure the flow_cls_offload structure into one
> helper function.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_offload.c | 47 ++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 77b129f196c6..a08756dc96e4 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -592,23 +592,25 @@ static void nf_flow_offload_init(struct flow_cls_offload *cls_flow,
>  	cls_flow->cookie = (unsigned long)tuple;
>  }
>  
> -static int flow_offload_tuple_add(struct flow_offload_work *offload,
> -				  struct nf_flow_rule *flow_rule,
> -				  enum flow_offload_tuple_dir dir)
> +static int flow_offload_tuple(struct nf_flowtable *flowtable,
> +			      struct flow_offload *flow,
> +			      struct nf_flow_rule *flow_rule,
> +			      enum flow_offload_tuple_dir dir,
> +			      int priority, int cmd,
> +			      struct list_head *block_cb_list)
>  {
> -	struct nf_flowtable *flowtable = offload->flowtable;
>  	struct flow_cls_offload cls_flow = {};
>  	struct flow_block_cb *block_cb;
>  	struct netlink_ext_ack extack;
>  	__be16 proto = ETH_P_ALL;
>  	int err, i = 0;
>  
> -	nf_flow_offload_init(&cls_flow, proto, offload->priority,
> -			     FLOW_CLS_REPLACE,
> -			     &offload->flow->tuplehash[dir].tuple, &extack);
> -	cls_flow.rule = flow_rule->rule;
> +	nf_flow_offload_init(&cls_flow, proto, priority, cmd,
> +			     &flow->tuplehash[dir].tuple, &extack);
> +	if (cmd == FLOW_CLS_REPLACE)
> +		cls_flow.rule = flow_rule->rule;
>  
> -	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list) {
> +	list_for_each_entry(block_cb, block_cb_list, list) {
>  		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
>  				   block_cb->cb_priv);
>  		if (err < 0)
> @@ -619,24 +621,23 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
>  
>  	return i;
>  }
> +EXPORT_SYMBOL_GPL(flow_offload_tuple);
flow_offload_tuple is a static EXPORT_SYMBOL_GPL?
> +
> +static int flow_offload_tuple_add(struct flow_offload_work *offload,
> +				  struct nf_flow_rule *flow_rule,
> +				  enum flow_offload_tuple_dir dir)
> +{
> +	return flow_offload_tuple(offload->flowtable, offload->flow, flow_rule,
> +				  dir, offload->priority, FLOW_CLS_REPLACE,
> +				  &offload->flowtable->flow_block.cb_list);
> +}
>  
>  static void flow_offload_tuple_del(struct flow_offload_work *offload,
>  				   enum flow_offload_tuple_dir dir)
>  {
> -	struct nf_flowtable *flowtable = offload->flowtable;
> -	struct flow_cls_offload cls_flow = {};
> -	struct flow_block_cb *block_cb;
> -	struct netlink_ext_ack extack;
> -	__be16 proto = ETH_P_ALL;
> -
> -	nf_flow_offload_init(&cls_flow, proto, offload->priority,
> -			     FLOW_CLS_DESTROY,
> -			     &offload->flow->tuplehash[dir].tuple, &extack);
> -
> -	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
> -		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
> -
> -	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> +	flow_offload_tuple(offload->flowtable, offload->flow, NULL,
> +			   dir, offload->priority, FLOW_CLS_DESTROY,
> +			   &offload->flowtable->flow_block.cb_list);
>  }
>  
>  static int flow_offload_rule_add(struct flow_offload_work *offload,
