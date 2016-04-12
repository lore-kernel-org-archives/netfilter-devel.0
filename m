From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] NFQUEUE: Fix bug with order of fanout and bypass
Date: Tue, 12 Apr 2016 23:05:36 +0530
Message-ID: <CAKHNQQEaV9-DWByD7vaxQYL5nPKjAvZyo_3YKxMGGGCLyUCkRA@mail.gmail.com>
References: <20160412171857.GA9814@shivani> <20160412172837.GA4311@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36154 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbcDLRgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 13:36:16 -0400
Received: by mail-oi0-f42.google.com with SMTP id y204so31278942oie.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 10:36:16 -0700 (PDT)
In-Reply-To: <20160412172837.GA4311@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 10:58 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> NFQUEUE had a bug with the ordering of fanout and bypass options which
>> was arising due to same and odd values for flags and bypass when used
>> together. Because of this, during bitwise ANDing of flags and
>> NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
>> NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
>> whenever it was used before bypass because then flags would be 1.
>>
>> Before this patch,
>>
>> $ sudo iptables -A FORWARD -j NFQUEUE -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout --queue-bypass
>>
>> Chain FORWARD (policy ACCEPT)
>> target     prot opt source               destination
>> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass
>>
>> After this patch,
>>
>> Chain FORWARD (policy ACCEPT)
>> target     prot opt source               destination
>> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass cpu-fanout
>
>> Closes bugzilla entry: http://bugzilla.netfilter.org/show_bug.cgi?id=939
>
> Ugh, good catch!
>
>> diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
>> index 8115457..0b5becc 100644
>> --- a/extensions/libxt_NFQUEUE.c
>> +++ b/extensions/libxt_NFQUEUE.c
>> @@ -99,7 +99,7 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
>>       NFQUEUE_parse_v1(cb);
>>       switch (cb->entry->id) {
>>       case O_QUEUE_BYPASS:
>> -             info->bypass = 1;
>> +             info->bypass |= NFQ_FLAG_BYPASS;
>>               break;
>
> I don't like this mix of v2 and v3 layout.
>
> Could you try to create an alternate patch that changes
> NFQUEUE_parse_v3 to call NFQUEUE_parse_v1 and then add
>         case O_QUEUE_BYPASS:
>                 info->bypass |= NFQ_FLAG_BYPASS;
>
> to NFQUEUE_parse_v3?
>
> I think that this would make it a bit clearer and
> it also avoids the v3/v2/v1 stacking.
>
Sure.
Just to make sure I get this right, should I be using two objects of
structures xt_NFQ_info_v3 and xt_NFQ_info_v2 (since v3 does not have
bypass) and make switch cases accordingly in v3?
Should I be doing this for all the functions (save, xlate, print)
since the same stacking is there too?

Thanks!

> Thanks!
