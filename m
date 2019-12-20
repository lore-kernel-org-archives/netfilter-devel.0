Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE976C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFF32465E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLTJMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:12:24 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:13107 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfLTJMY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 04:12:24 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 14BFC41A20;
        Fri, 20 Dec 2019 17:12:21 +0800 (CST)
Subject: Re: [PATCH nf 3/3] netfilter: nf_tables: fix miss dec set use counter
 in the nf_tables_destroy_set
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576681153-10578-1-git-send-email-wenxu@ucloud.cn>
 <1576681153-10578-4-git-send-email-wenxu@ucloud.cn>
 <20191219235605.hva2ea4edoa5rwrc@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <2c92b1ec-10ea-c9f7-5e77-1afe368ee84a@ucloud.cn>
Date:   Fri, 20 Dec 2019 17:12:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191219235605.hva2ea4edoa5rwrc@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQklKS0tLSklIS0lIQkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mio6CSo4MTgwF0M#OhkLQxUu
        IgsKCRpVSlVKTkxNQ0hISk9KSUJCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU5PTjcG
X-HM-Tid: 0a6f229449a02086kuqy14bfc41a20
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/20/2019 7:56 AM, Pablo Neira Ayuso wrote:
> On Wed, Dec 18, 2019 at 10:59:13PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> In the create rule path nf_tables_bind_set the set->use will inc, and
>> with the activate operatoion also inc it. In the delete rule patch
>> deactivate will dec it. So the destroy opertion should also deactivate
>> it.
> [...]
>
> Is this a theoretical issue? Thanks.
As we talked in patch2.  Destroy the rule don't need  dec the use counter. So just drop this series. Thx!
> [...]
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 174b362..d71793e 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -4147,8 +4147,10 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>>  
>>  void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
>>  {
>> -	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
>> +	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
>> +		set->use--;
>>  		nft_set_destroy(set);
>> +	}
>>  }
>>  EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
>>  
>> -- 
>> 1.8.3.1
>>
