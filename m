Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C41C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF8A2072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfKOLiQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:38:16 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:14849 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfKOLiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 06:38:16 -0500
Received: from [192.168.1.4] (unknown [116.234.5.178])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5931D41006;
        Fri, 15 Nov 2019 19:38:13 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_tables: check the bind callback
 failed and unbind callback if hook register failed
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1573816886-2743-1-git-send-email-wenxu@ucloud.cn>
 <20191115112501.6xb5adufqxlb6vnu@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <25fb9ea9-758b-4d50-9056-7147bec5c7c2@ucloud.cn>
Date:   Fri, 15 Nov 2019 19:37:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115112501.6xb5adufqxlb6vnu@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUxNS0tLSE5NTUxPSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pi46MAw4Njg*Fwo8ShwIARw#
        FAlPFBBVSlVKTkxIQ0pMQ0JITkxLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTlVKTENZV1kIAVlBSUhLTDcG
X-HM-Tid: 0a6e6edb42542086kuqy5931d41006
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/11/15 19:25, Pablo Neira Ayuso 写道:
>
>>  net/netfilter/nf_tables_api.c | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 0f8080e..149de13 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -6001,12 +6001,20 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>>  			}
>>  		}
>>  
>> -		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
>> -					    FLOW_BLOCK_BIND);
>> -		err = nf_register_net_hook(net, &hook->ops);
>> +		err = flowtable->data.type->setup(&flowtable->data,
>> +						  hook->ops.dev,
>> +						  FLOW_BLOCK_BIND);
> I'd rather not check for the return value. ->setup returns 0 unless
> you use anything else than FLOW_BLOCK_BIND or _UNBIND. Probably better
> turn nf_flow_table_block_setup void and add WARN_ON_ONCE() there.

If BIND failed. It means hw-offload failed. But the flowtable is set as hw-offload.

Maybe it is not too make sense?


