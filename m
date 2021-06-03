Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843E9C4708F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61228613E6
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFCAhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:37:16 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3040 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhFCAhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 20:37:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwRdK2XKbzWqw0;
        Thu,  3 Jun 2021 08:30:45 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 08:35:29 +0800
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 08:35:28 +0800
Subject: Re: [PATCH] netfilter: conntrack: remove the repeated declaration
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <1622270966-36196-1-git-send-email-zhangshaokun@hisilicon.com>
 <20210602104049.GA8127@salvia>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <f48bed40-005d-35b8-5501-76dd1d137681@hisilicon.com>
Date:   Thu, 3 Jun 2021 08:35:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210602104049.GA8127@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 2021/6/2 18:40, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Sat, May 29, 2021 at 02:49:26PM +0800, Shaokun Zhang wrote:
>> Variable 'nf_conntrack_net_id' is declared twice, so remove the
>> repeated declaration.
> 
> Thanks for your patch.
> 
> I prefer to fix this in nf-next with this patch I'm proposing:
> 

Look fine to me.

Thanks your reply,
Shaokun

> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210602103907.8082-1-pablo@netfilter.org/
> 
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
>> Cc: Florian Westphal <fw@strlen.de>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>>  net/netfilter/nf_conntrack_core.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
>> index e0befcf8113a..757520725cd4 100644
>> --- a/net/netfilter/nf_conntrack_core.c
>> +++ b/net/netfilter/nf_conntrack_core.c
>> @@ -87,8 +87,6 @@ static __read_mostly bool nf_conntrack_locks_all;
>>  
>>  static struct conntrack_gc_work conntrack_gc_work;
>>  
>> -extern unsigned int nf_conntrack_net_id;
>> -
>>  void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
>>  {
>>  	/* 1) Acquire the lock */
>> -- 
>> 2.7.4
>>
> .
> 
