From: Patrick McHardy <kaber@trash.net>
Subject: Re: Questions about early_drop()
Date: Wed, 04 Nov 2009 12:31:37 +0100
Message-ID: <4AF16619.2090807@trash.net>
References: <873dce860910310507v756ce39nf68bb102afb28658@mail.gmail.com> <4AEC32A9.8090405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZKDLbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:31:35 -0500
In-Reply-To: <4AEC32A9.8090405@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce wrote:
> I just realized that point 4 is very lame and wrong, so please skip it,
> consider only the first three questions.
> Thanks.
> 
> Luca Pesce ha scritto:
>> Hi all,
>>     today I was looking at early_drop() code in nf_conntrack_core.c,
>> and I came
>> up with some questions, due to the fact that I am not such a netfilter
>> expert...
>> I am not running the latest kernel:  I am cutting&pasting early_drop()
>> of my kernel
>> at the end of this mail, note that compared to 2.6.31.x this is quite
>> different.
>>
>> 1- why does early_drop() increase the ct_general.use count of the ct
>> to be dropped
>> before calling death_by_timeout(), and then decreases it with
>> nf_ct_put(ct)? Is
>> this a way to postpone ct death? What for?

Quoting the changelog:

    [NETFILTER]: conntrack: fix race condition in early_drop

    On SMP environments the maximum number of conntracks can be overpassed
    under heavy stress situations due to an existing race condition.

            CPU A                   CPU B
         atomic_read()               ...
         early_drop()                ...
            ...                  atomic_read()
       allocate conntrack      allocate conntrack
         atomic_inc()             atomic_inc()

    This patch moves the counter incrementation before the early drop stage.

>> 2- I see that 2.6.31.5 version of early_drop() is more complex: it
>> crosses more
>> than one bucket looking for not assured connections to be killed. I
>> like that
>> approach, but I was wondering if this is not burning too much CPU when
>> the
>> conntrack table is overly saturated persistently (and so when this
>> function is
>> called very often)...any experience about that?

No negative experience at least :) It does greatly improve
robustness under DoS since with jhash() and a properly sized
hash table there's likely only a single entry per bucket.

>> Can I port the whole early_drop() of 2.6.31.5 on my kernel?

Probably not.

>> 3- on 2.6.31.5 version of early_drop(), there are two added checks
>> before killing
>> the conntrack:
>>
>>  if (ct && unlikely(nf_ct_is_dying(ct) ||
>>                    !atomic_inc_not_zero(&ct->ct_general.use)))
>>             ct = NULL;
>>            
>> I understand that these are to ensure that the ct is not already dying
>> for itself:
>> should I add those to early_drop() which I am currently using to avoid
>> races?

This was fixing RCU races. Without knowing your version I can't
tell. Probably not though, the affected -stable versions should
already include this.
