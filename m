Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932FCC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6441E214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgCCFhZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:37:25 -0500
Received: from relay.sw.ru ([185.231.240.75]:49750 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgCCFhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 00:37:25 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1j90Ek-0002FN-9n; Tue, 03 Mar 2020 08:36:58 +0300
Subject: Re: + seq_read-info-message-about-buggy-next-functions.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>, Qian Cai <cai@lca.pw>
Cc:     linux-kernel@vger.kernel.org, dave@stgolabs.net,
        longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com,
        rostedt@goodmis.org, viro@zeniv.linux.org.uk,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200226035621.4NlNn738T%akpm@linux-foundation.org>
 <1583173259.7365.142.camel@lca.pw> <1583177508.7365.144.camel@lca.pw>
 <20200302124219.eaf3d18422b76ff2196d9ce8@linux-foundation.org>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <90db01f0-e8b4-0acb-cd09-d79825f2c03d@virtuozzo.com>
Date:   Tue, 3 Mar 2020 08:36:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302124219.eaf3d18422b76ff2196d9ce8@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 3/2/20 11:42 PM, Andrew Morton wrote:
> On Mon, 02 Mar 2020 14:31:48 -0500 Qian Cai <cai@lca.pw> wrote:
> 
>> On Mon, 2020-03-02 at 13:20 -0500, Qian Cai wrote:
>>> This patch spams the console like crazy while reading sysfs,
>>>
>>> # dmesg | grep 'buggy seq_file' | wc -l
>>> 4204
>>>
>>> [ 9505.321981] LTP: starting read_all_proc (read_all -d /proc -q -r 10)
>>> [ 9508.222934] buggy seq_file .next function xt_match_seq_next [x_tables] did
>>> not updated position index
>>> [ 9508.223319] buggy seq_file .next function xt_match_seq_next [x_tables] did
>>> not updated position index
>>> [ 9508.223654] buggy seq_file .next function xt_match_seq_next [x_tables] did
>>> not updated position index
>>> [ 9508.223994] buggy seq_file .next function xt_match_seq_next [x_tables] did
>>> not updated position index
>>> [ 9508.224337] buggy seq_file .next function xt_match_seq_next [x_tables] did
>>> not updated position index

It should be fixed by following patch-set submitted to Netfilter-Devel mailing list
[PATCH v2 0/4] netfilter: seq_file .next functions should increase position index
https://lore.kernel.org/netfilter-devel/497a82c1-7b6a-adf4-a4ce-df46fe436aae@virtuozzo.com/T/

>>>> --- a/fs/seq_file.c~seq_read-info-message-about-buggy-next-functions
>>>> +++ a/fs/seq_file.c
>>>> @@ -256,9 +256,12 @@ Fill:
>>>>  		loff_t pos = m->index;
>>>>  
>>>>  		p = m->op->next(m, p, &m->index);
>>>> -		if (pos == m->index)
>>>> -			/* Buggy ->next function */
>>>> +		if (pos == m->index) {
>>>> +			pr_info("buggy seq_file .next function %ps "
>>>> +				"did not updated position index\n",
>>>> +				m->op->next);
>>
>> This?
>>
>> s/pr_info/pr_info_ratelimited/
>>
> 
> Fair enough - I made that change.
> 
