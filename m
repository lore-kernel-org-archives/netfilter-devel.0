From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] netfilter: ipvs: Convert timers to use timer_setup()
Date: Thu, 2 Nov 2017 15:11:54 -0700
Message-ID: <CAGXu5jKi-yKO+QuvJ7kTJreZpvh_-Ozmbjr0e-HiXRXueT-RSg@mail.gmail.com>
References: <20171024084521.GA23684@beast> <alpine.LFD.2.20.1710242203100.2078@ja.home.ssi.bg>
 <20171102144247.yz2yupsj4cjctvio@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Network Development <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:50202 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752438AbdKBWL4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2017 18:11:56 -0400
Received: by mail-io0-f193.google.com with SMTP id 97so2291720iok.7
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2017 15:11:55 -0700 (PDT)
In-Reply-To: <20171102144247.yz2yupsj4cjctvio@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 2, 2017 at 7:42 AM, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Oct 24, 2017 at 10:07:03PM +0300, Julian Anastasov wrote:
>>
>>       Hello,
>>
>> On Tue, 24 Oct 2017, Kees Cook wrote:
>>
>> > In preparation for unconditionally passing the struct timer_list pointer to
>> > all timer callbacks, switch to using the new timer_setup() and from_timer()
>> > to pass the timer pointer explicitly.
>> >
>> > Cc: Wensong Zhang <wensong@linux-vs.org>
>> > Cc: Simon Horman <horms@verge.net.au>
>> > Cc: Julian Anastasov <ja@ssi.bg>
>> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> > Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> > Cc: Florian Westphal <fw@strlen.de>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: netdev@vger.kernel.org
>> > Cc: lvs-devel@vger.kernel.org
>> > Cc: netfilter-devel@vger.kernel.org
>> > Cc: coreteam@netfilter.org
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>>       Looks good to me,
>>
>> Acked-by: Julian Anastasov <ja@ssi.bg>
>
> Signed-off-by: Simon Horman <horms@verge.net.au>
>
> Pablo, could you take this?

If it's helpful, we could take this via the timers tree. Either way. :) Thanks!

-Kees

-- 
Kees Cook
Pixel Security
