Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4F9C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98C72465E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLTJTV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:19:21 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:39915 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfLTJTV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 04:19:21 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id ABFED41AD4;
        Fri, 20 Dec 2019 17:19:13 +0800 (CST)
Subject: Re: [PATCH nf v2 1/3] netfilter: nf_flow_table_offload: fix dst_neigh
 lookup
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
 <1576572767-19779-2-git-send-email-wenxu@ucloud.cn>
 <20191219221816.rywke7de6izqrere@salvia>
 <25e03002-ba64-45aa-c94d-2588706ba6d8@ucloud.cn>
 <20191220091308.stmalopyx7cnmwxc@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <3cfa870a-bb2b-5a8b-7c90-e11677d951ec@ucloud.cn>
Date:   Fri, 20 Dec 2019 17:19:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191220091308.stmalopyx7cnmwxc@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSU5IS0tLS0lLQkNLQ0hZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006FCo6MDg4SEMzHBJDMjUp
        OBIKCQhVSlVKTkxNQ0hITk5IQ0hOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUJDSDcG
X-HM-Tid: 0a6f229a95662086kuqyabfed41ad4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/20/2019 5:13 PM, Pablo Neira Ayuso wrote:
> On Fri, Dec 20, 2019 at 11:53:38AM +0800, wenxu wrote:
>> Maybe the patch your suggestion is not correct?
>>
>> On 12/20/2019 6:18 AM, Pablo Neira Ayuso wrote:
>>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>>> index 506aaaf8151d..8680fc56cd7c 100644
>>> --- a/net/netfilter/nf_flow_table_offload.c
>>> +++ b/net/netfilter/nf_flow_table_offload.c
>>> @@ -156,14 +156,14 @@ static int flow_offload_eth_dst(struct net *net,
>>>  				enum flow_offload_tuple_dir dir,
>>>  				struct nf_flow_rule *flow_rule)
>>>  {
>>> -	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
>>> +	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
>>>  	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
>>>  	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
>>>  	struct neighbour *n;
>>>  	u32 mask, val;
>>>  	u16 val16;
>>>  
>>> -	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
>>> +	n = dst_neigh_lookup(tuple->dst_cache, &tuple->src_v4);
>>                 The dst_cache should be flow->tuplehash[dir].tuple.dst_cache  but not peer dir's;
> Hm, I think this is like your patch, but without the two extra new lines
> and new variable definitions.

There is a little bit different. The dst_cache should get from  flow->tuplehash[dir].tuple.dst_cache

but not flow->tuplehash[!dir].tuple.dst_cache

>
