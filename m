From: Shaun Crampton <shaun@cantab.net>
Subject: Re: Concurrent iptables-restore calls clobberring each other
Date: Sat, 4 Feb 2017 08:53:22 +0000
Message-ID: <CAB3ewxN62EQgdg1LTCyodOA+xA=SibM=khWpjp3ptzTKpBTw0A@mail.gmail.com>
References: <CAB3ewxODtiHoKQChouTcYX7uZxHvHobxxCMLtOH_Uvkco9XaGA@mail.gmail.com>
 <alpine.LSU.2.20.1702040040050.2578@erq.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34791 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753785AbdBDIxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Feb 2017 03:53:24 -0500
Received: by mail-it0-f65.google.com with SMTP id o185so3728272itb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Feb 2017 00:53:23 -0800 (PST)
In-Reply-To: <alpine.LSU.2.20.1702040040050.2578@erq.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> This is by design; the RMW cycle in principle also affects the "slower"
> iptables - which is why it is slower, because it does only one rule per cycle.

Thanks for the response. I understand that the RMW is by design. Is there
any protection built into the protocol to prevent concurrent writes from
clobbering each other?  I thought I'd read that there was a "version"
on the read
that let the kernel spot if a write was stale.

My second script acts as if there is; the commits of the "kube" loop
fail reliably
rather than clobbering the writes of the "felix" loop.  However,
that's not the case
for the first script.  I'm wondering if there is supposed to be
protection but it's
bugged.
