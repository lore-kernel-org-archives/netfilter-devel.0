Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A90C4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 566402076E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCTMh3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 08:37:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59386 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCTMh2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 08:37:28 -0400
Received: from [192.168.1.6] (unknown [101.81.70.14])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E62E54161E;
        Fri, 20 Mar 2020 20:37:17 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter:nf_flow_table: add HW stats type
 support in flowtable
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1584689657-17280-1-git-send-email-wenxu@ucloud.cn>
 <20200320121048.siaonqjufl4btb72@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <84bc5ac8-0f3c-c609-84e0-035bdd979c6d@ucloud.cn>
Date:   Fri, 20 Mar 2020 20:36:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200320121048.siaonqjufl4btb72@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0pIS0tLSU9CQ01JTUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nk06HBw4Qzg5NBwxNAE9Fgow
        NChPFBdVSlVKTkNPTEtMQ0hDS01NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVMS1VKT1lXWQgBWUFIT0hNNwY+
X-HM-Tid: 0a70f7f2a0372086kuqye62e54161e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2020/3/20 20:10, Pablo Neira Ayuso 写道:
> On Fri, Mar 20, 2020 at 03:34:17PM +0800, wenxu@ucloud.cn wrote:
> [...]
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index ad54931..60289a6 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -165,8 +165,16 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
>>   flow_action_entry_next(struct nf_flow_rule *flow_rule)
>>   {
>>   	int i = flow_rule->rule->action.num_entries++;
>> +	struct flow_action_entry *entry;
>> +
>> +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_ANY);
>> +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>> +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>> +
>> +	entry = &flow_rule->rule->action.entries[i];
>> +	entry->hw_stats_type = flow_rule->hw_stats_type;
> Please, use FLOW_ACTION_HW_STATS_ANY by now. Remove the uapi code,
> from this patch.
>
> I'm not sure how users will be using this new knob.
>
> At this stage, I think the drivers knows much better what type to pick
> than the user.
Yes, I agree.
>
> You also have to explain me how you are testing things.

I test the flowtable offload with mlnx driver. ALL the flow add in 
driver failed for checking

the hw_stats_type of flow action.


static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
                                 struct flow_action *flow_action,
                                 struct mlx5e_tc_flow *flow,
                                 struct netlink_ext_ack *extack)
{
         ................


         if (!flow_action_hw_stats_check(flow_action, extack,
FLOW_ACTION_HW_STATS_DELAYED_BIT))
                 return -EOPNOTSUPP;

Indeed always set the hw_stats_type of flow_action to 
FLOW_ACTION_HW_STATS_ANY can fix this.

But maybe it can provide a knob for user? Curently with this patch the 
user don't

need set any value with default value FLOW_ACTION_HW_STATS in the kernel.

>
> Thank you.
>
