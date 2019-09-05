Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22AFC3A5A5
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 03:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B57AC206BB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 03:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfIED0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 23:26:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8365 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfIED0x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 23:26:53 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2E4E9418C8;
        Thu,  5 Sep 2019 11:26:49 +0800 (CST)
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_tables_offload: clean
 offload things when the device unregister
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1567580851-15042-1-git-send-email-wenxu@ucloud.cn>
 <1567580851-15042-4-git-send-email-wenxu@ucloud.cn>
 <20190904194024.q2rxmdpnthgkono4@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <466178d0-3f97-e474-467d-df732b867daa@ucloud.cn>
Date:   Thu, 5 Sep 2019 11:26:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904194024.q2rxmdpnthgkono4@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENCS0tLSUJNTkJJTEpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxQ6FSo*KDg5FzcfPjI2Fz4#
        KT9PCgFVSlVKTk1MTU5PS0tCSEpIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0tDSTcG
X-HM-Tid: 0a6cff75d9a32086kuqy2e4e9418c8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 9/5/2019 3:40 AM, Pablo Neira Ayuso wrote:
> Thanks for working on this.
>
> On Wed, Sep 04, 2019 at 03:07:31PM +0800, wenxu@ucloud.cn wrote:
>> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>> index 9657001..9fa3bdb 100644
>> --- a/net/netfilter/nf_tables_offload.c
>> +++ b/net/netfilter/nf_tables_offload.c
>> @@ -396,17 +396,78 @@ static void nft_indr_block_cb(struct net_device *dev,
>>  	mutex_unlock(&net->nft.commit_mutex);
>>  }
>>  
>> +static void nft_offload_chain_clean(struct nft_chain *chain)
>> +{
>> +	struct nft_rule *rule;
>> +
>> +	list_for_each_entry(rule, &chain->rules, list) {
>> +		nft_flow_offload_rule(chain, rule,
>> +				      NULL, FLOW_CLS_DESTROY);
>> +	}
>> +
>> +	nft_flow_offload_chain(chain, FLOW_BLOCK_UNBIND);
>> +}
>> +
>> +static int nft_offload_netdev_event(struct notifier_block *this,
>> +				    unsigned long event, void *ptr)
>> +{
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct nft_base_chain *basechain;
>> +	struct net *net = dev_net(dev);
>> +	struct nft_table *table;
>> +	struct nft_chain *chain;
>> +
>> +	if (event != NETDEV_UNREGISTER)
>> +		return NOTIFY_DONE;
>> +
>> +	mutex_lock(&net->nft.commit_mutex);
>> +	list_for_each_entry(table, &net->nft.tables, list) {
>> +		if (table->family != NFPROTO_NETDEV)
>> +			continue;
>> +
>> +		list_for_each_entry(chain, &table->chains, list) {
>> +			if (!nft_is_base_chain(chain) ||
>> +			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
>> +				continue;
>> +
>> +			basechain = nft_base_chain(chain);
>> +			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
>> +				continue;
>> +
>> +			nft_offload_chain_clean(chain);
>> +			mutex_unlock(&net->nft.commit_mutex);
>> +			return NOTIFY_DONE;
>> +		}
>> +	}
>> +	mutex_unlock(&net->nft.commit_mutex);
> This code around the mutex look very similar to nft_block_indr_cb(),
> could you consolidate this? Probably something like
> nft_offload_netdev_iterate() and add a callback.

nft_offload_netdev_iterate is a good idear, But maybe it can't provide
a common callback. The nft_offload_netdev_iterate(without mutex) can return the chain
amke each function(with mutex) use it  

>
>> +	return NOTIFY_DONE;
>> +}
>> +
>>  static struct flow_indr_block_ing_entry block_ing_entry = {
>>  	.cb	= nft_indr_block_cb,
>>  	.list	= LIST_HEAD_INIT(block_ing_entry.list),
>>  };
>>  
>> -void nft_offload_init(void)
>> +static struct notifier_block nft_offload_netdev_notifier = {
>> +	.notifier_call	= nft_offload_netdev_event,
> No need for priority because of registration order, right?
yes,  nft_offload_init will early than nft_chain_filter mod init
>
