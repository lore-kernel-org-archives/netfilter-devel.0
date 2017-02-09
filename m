From: Shaun Crampton <shaun@cantab.net>
Subject: Re: Concurrent iptables-restore calls clobberring each other
Date: Thu, 9 Feb 2017 14:39:01 +0000
Message-ID: <CAB3ewxNX=DegAesrqjb8_7q9-ghHcW-Pr7-LAYfqWX+5E9EqvQ@mail.gmail.com>
References: <CAB3ewxODtiHoKQChouTcYX7uZxHvHobxxCMLtOH_Uvkco9XaGA@mail.gmail.com>
 <alpine.LSU.2.20.1702040040050.2578@erq.vanv.qr> <CAB3ewxN62EQgdg1LTCyodOA+xA=SibM=khWpjp3ptzTKpBTw0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36760 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752692AbdBIOkN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 09:40:13 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so2412290itf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2017 06:39:02 -0800 (PST)
In-Reply-To: <CAB3ewxN62EQgdg1LTCyodOA+xA=SibM=khWpjp3ptzTKpBTw0A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Is there any protection built into the protocol to prevent concurrent
> writes from clobbering each other?

Ah, I think I see the reason for the behaviour that I'm seeing.  It looks
like the kernel does check that the number of entries in the table hasn't
changed since the data was read [1]  That explains why the unrelated rule
change in my second script causes the COMMIT to fail.

[1] https://github.com/torvalds/linux/blob/master/net/ipv4/netfilter/ip_tables.c#L1033

On 4 February 2017 at 08:53, Shaun Crampton <shaun@cantab.net> wrote:
>> This is by design; the RMW cycle in principle also affects the "slower"
>> iptables - which is why it is slower, because it does only one rule per cycle.
>
> Thanks for the response. I understand that the RMW is by design. Is there
> any protection built into the protocol to prevent concurrent writes from
> clobbering each other?  I thought I'd read that there was a "version"
> on the read
> that let the kernel spot if a write was stale.
>
> My second script acts as if there is; the commits of the "kube" loop
> fail reliably
> rather than clobbering the writes of the "felix" loop.  However,
> that's not the case
> for the first script.  I'm wondering if there is supposed to be
> protection but it's
> bugged.
