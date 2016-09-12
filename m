From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and _SRGE_TO
 to select the queue numbers
Date: Mon, 12 Sep 2016 10:19:15 +0800
Message-ID: <CAML_gOfze-vy-q7EzH86ZEgriMCuB7HsTf3674Cb8x_3BE6XeQ@mail.gmail.com>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com> <20160911211226.GB6572@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33747 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932258AbcILCTQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 22:19:16 -0400
Received: by mail-vk0-f66.google.com with SMTP id v189so5101861vkv.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Sep 2016 19:19:16 -0700 (PDT)
In-Reply-To: <20160911211226.GB6572@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-09-12 5:12 GMT+08:00 Florian Westphal <fw@strlen.de>:
> Liping Zhang <zlpnobody@163.com> wrote:
>> So similer to nft_nat, take two registers to select the queue numbers,
>> then we can add one simple rule to mapping queues, maybe like this:
>>   queue num tcp dport map { 80:0, 81:1, 82:2 ... }
>
> I like this.
>
> My first thought was that it would be better to just support one single
> sreg (the queue number) and eventually externalize the hashing/queue
> selection:
>
> queue num jhash ip saddr . ip daddr mod ...

Sounds good.

At first, my another intention is use _SREG_FROM and _SREG_TO to replace
_QUEUE_NUM and _QUEUE_TOTAL, there's no restriction to use range 0-65535:

[ immediate reg 1 0x00000000 ]
[ immediate reg 2 0x0000ffff ]
[ queue num 0 reg_from 1 reg_to 2 ]

But I think your "queue num jhash ip saddr . ip daddr mod ..." is more
flexible and
there's no restriction to use range 0-65535 too.

I agree with you, one sreg seems enough. I will send V2 later.

> Problem is that with plain jhash we won't get a symmetric hash
> for origin and reply, so for this we would need a new expression/hash
> mode.
>
> We would also need another expression to allow distribution
> starting with a queue other than 0.

I think Laura is developing this option, see
https://patchwork.ozlabs.org/patch/666334/.
