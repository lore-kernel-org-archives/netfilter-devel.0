From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: reset nfacct counters
Date: Fri, 25 Jul 2014 20:39:04 +0400
Message-ID: <53D28828.9070003@samsung.com>
References: <53D20FB8.9050606@samsung.com> <20140725160123.GA20548@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mathieu.poirier@linaro.org, netfilter-devel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	alexey.perevalov@hotmail.com,
	=?UTF-8?B?J+qzoO2YhOyEsSc=?= <hs81.go@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52014 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaGYQjI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:39:08 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A001T80WW1420@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Fri, 25 Jul 2014 17:38:56 +0100 (BST)
In-reply-to: <20140725160123.GA20548@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/25/2014 08:01 PM, Pablo Neira Ayuso wrote:
> Hi Alexey,
>
> On Fri, Jul 25, 2014 at 12:05:12PM +0400, Alexey Perevalov wrote:
>> Hello Pablo and Mathieu.
>> I would like to thank you for quota with notification implementation
>> in nfacct.
>>
>> But also I want to discuss about resetting counters value. Right now
>> nfacct has 2 way to get counter
>> NFNL_MSG_ACCT_GET and NFNL_MSG_ACCT_GET_CTRZERO, last one is
>> intended to nullify accumulated counter.
>> It resets counters with and without populated quota value. After
>> commit 683399eddb nfacct really operates
>> with 2 different entities: pure counter and quota based counter. If
>> so, why not to operate with it separately,
>> maybe by some filter (flag).
>>
>> Also it was strange for me, why reset is not a command of command
>> line tool nfacct, like get? Ok, if it's an argument of get, why not
>> it's a flag (attribute) in netlink serialization?
>>
>> Why I'm asking such questions. My use case requires periodic reset
>> of the counters, also I have quota based counters and I don't want
>> to reset them.
>>
>> I could work around it from user space, for example, I could get
>> quota based counter before I'm going to reset counters, delete it
>> and key it in after counters reset. As you could see too much
>> operations. Or I could could avoid reseting, but in this case I need
>> to operates with deltas in user space and it's not robust in
>> situation when my daemon is restarting. Every variant in user space
>> leads to more run time complexity.
>>
>> And my final question, will you accept a patch, which will move
>> CTRZERO to netlink attribute and CTRZERO will be expanded to
>> CTRZERO_OVERAL, CTRZERO_COUNTER and CTRZERO_QUOTA? For both kernel
>> side and user space part (nfacct tool with libraries).
> You can make a patch that uses NFACCT_FLAGS in the nfnl_acct_get()
> path to specify the filtering criteria. In the nfnl_acct_get() path,
> you can use c->data in struct netlink_dump_control to attach the
> filter, which needs to be allocated before the dump_start() call and
> released through the dump_done() callback. If no NFACCT_FLAGS are
> specified, no filter is specified and all counters should be cleared
> as it happens now.
>
Thank you Pablo for such detailed advice, I hope I'll send patches next 
week.

