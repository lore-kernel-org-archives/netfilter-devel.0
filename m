Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAAAC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 03:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6226D20854
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 03:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfCNDUk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 23:20:40 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5278 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbfCNDUk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 23:20:40 -0400
X-IronPort-AV: E=Sophos;i="5.58,476,1544457600"; 
   d="scan'208";a="56729303"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Mar 2019 11:20:38 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id A29424C8B051;
        Thu, 14 Mar 2019 11:20:15 +0800 (CST)
Received: from [10.167.226.33] (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 14 Mar 2019 11:20:39 +0800
From:   "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter: nf_ct_helper: Fix possible panic when
 nf_conntrack_helper_unregister is used in an unloadable module
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Su Yanjun <suyanjun218@163.com>
CC:     <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
 <20190308155934.vfx2ah4k4guqvhyu@salvia>
Message-ID: <94c12f0d-a558-4719-a339-cded8d614b66@cn.fujitsu.com>
Date:   Thu, 14 Mar 2019 11:20:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20190308155934.vfx2ah4k4guqvhyu@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: A29424C8B051.A943C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2019/3/8 23:59, Pablo Neira Ayuso wrote:
> On Fri, Mar 01, 2019 at 01:56:06PM +0800, Su Yanjun wrote:
>> From: Su Yanjun<suyj.fnst@cn.fujitsu.com>
>>
>> Because nf_conntrack_helper_unregister maybe used in an unloadable module,
>> it uses 'synchronize_rcu' which may cause kernel panic.
>>
>> According to the artical:
>> RCU and Unloadable Modules
>> https://lwn.net/Articles/217484/
>>
>> When we have a heavy rcu callback load, then some of the callbacks might be
>> deferred in order to allow other processing to proceed. sychnorize_rcu does
>> not wait rcu callback complete and module may be unloaded before callback
>> done.
>>
>> This patch uses rcu_barrier instead of synchronize_rcu will prevent this
>> situation.
>>
>> Signed-off-by: Su Yanjun<suyj.fnst@cn.fujitsu.com>
>> ---
>>   net/netfilter/nf_conntrack_helper.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
>> index 274baf1..0ee9378 100644
>> --- a/net/netfilter/nf_conntrack_helper.c
>> +++ b/net/netfilter/nf_conntrack_helper.c
>> @@ -397,8 +397,15 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>>   
>>   	/* Make sure every nothing is still using the helper unless its a
>>   	 * connection in the hash.
>> +	 *
>> +	 * 'synchronize_rcu' may have problem when rcu callback function
>> +	 * is used in unloadable modules. Use rcu_barrier instead, so that
>> +	 * it will wait until rcu callback completes before modules are
>> +	 * unloaded.
>> +	 * More detail about rcu_barrier please see:
>> +	 *https://lwn.net/Articles/217484/
>>   	 */
>> -	synchronize_rcu();
>> +	rcu_barrier();
> Are you sure this is correct?
>
> IIRC rcu_barrier() makes sure no pending callback is still waiting in
> the queue to run. We have don't use call_rcu() in this code, which is
> what rcu_barrier() is meant for.
>
> Please correct me if I'm mistaken.
>
> Thanks!

The issue is not whether your module invokes|call_rcu()|,
but rather whether the corresponding RCU callback invokes a function that is in a module.
For unloadable modules, **rcu_barrier** make the code more robust than synchronize_rcu.

Thanks
Su

>>   
>>   	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
>>   	nf_ct_iterate_destroy(unhelp, me);
>> @@ -406,7 +413,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>>   	/* Maybe someone has gotten the helper already when unhelp above.
>>   	 * So need to wait it.
>>   	 */
>> -	synchronize_rcu();
>> +	rcu_barrier();
>>   }
>>   EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
>>   
>> -- 
>> 2.7.4
>>
>>


