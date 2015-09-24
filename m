From: Eugene Strulyov <eugene.strulyov@gmail.com>
Subject: Re: NFQUEUE parallelization
Date: Thu, 24 Sep 2015 14:55:08 -0700
Message-ID: <CAKEqNmmvrHwZGiwMA8AutnW_K+E9Wno3oq8duCFWkUNyBE_=Yw@mail.gmail.com>
References: <CAKEqNm=2vnqe_fmSTM4G7xWsHkrXP29f_QxLUf7v7_-f5ESyKQ@mail.gmail.com>
	<20150924204840.GC29479@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34241 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbIXVzJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 17:55:09 -0400
Received: by obbda8 with SMTP id da8so69162793obb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2015 14:55:09 -0700 (PDT)
In-Reply-To: <20150924204840.GC29479@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your reply.

So with regards to parallelization, I need to use multiple queues, correct?

Also, with --queue-balance, will the same (src_ip, dst_ip) pair always
map to the same queue? If yes, I can make each queue handler a
separate process.

thanks,

Eugene



On Thu, Sep 24, 2015 at 1:48 PM, Florian Westphal <fw@strlen.de> wrote:
> Eugene Strulyov <eugene.strulyov@gmail.com> wrote:
>> When using multiple queues, is it valid to call nfq_open() multiple
>> times in the same process?
>
> Yes.
>
>> When I do that I get negative numbers for
>> peer portid. Is this normal?
>
>> $ sudo cat /proc/net/netfilter/nfnetlink_queue
>>   100  27790     0 2 65531     0     0        0  1
>>   101  -4585     0 2 65531     0     0        0  1
>
> The proc formatter in nfnetlink_queue uses %d instead of %u.
> It was fixed a few months back.
>
>> Also, how exactly does --queue-balance work? All packets seem to be
>> directed to one particular queue.
>
> Hash over ipv4/ipv6 source & dst addresses.
