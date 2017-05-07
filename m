From: Pavel Vajarov <pavel@x3me.net>
Subject: Re: How to reinject a packet (skb) at some later point in time
Date: Sun, 7 May 2017 17:59:35 +0300
Message-ID: <CAJEV1igPB6fxkmkqg5PV01V7JpuS8ZB_PmAuJ03D23oyS_ocKw@mail.gmail.com>
References: <CAJEV1ijznokQj78RNXTRxMnrnRTBtoWZUVwcB4k7JHYb9FfLJw@mail.gmail.com>
 <20170506194009.GB20672@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36069 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756925AbdEGWVx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2017 18:21:53 -0400
Received: by mail-oi0-f42.google.com with SMTP id h4so32848294oib.3
        for <netfilter-devel@vger.kernel.org>; Sun, 07 May 2017 15:21:53 -0700 (PDT)
In-Reply-To: <20170506194009.GB20672@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> I think you should change our in kernel nfnetlink_queue backend
> to use a single hash table to store nf_entry.
>
> You can use rhashtable, and hash via
>
> hash(netns, queueid, packetid, secret);
>
> to avoid the linear searches in kernel.
> This will unfortunately need repeated lookups for the VERDICT_BATCH
> case though so we might end up needing two hash tables (2nd one would
> a rhlist one that just hashes lists via hash(netns, queueid, secret),
> used by VERDICT_BATCH.

This seems doable for me.
The problem is that we use kernel, with some modifications in the tcp stack,
which is provided/maintained by a different company. I can see no way,
at least currently, the other company to allow us to do changes in the kernel
that they provide. The only way, we've done some things in the kernel so far,
was through kernel modules which we developed and tested against the main
stream kernel and the other company produced the final build of the modules.
That's the reason I was searching for a solution with a kernel module.

> It might be possible to avoid that by combining nfqueue with -m
> hashlimit and a small timeout (or nft flow statement) instead.
>
> Or do you consider that too broken?

I didn't think about it. It seems acceptable. The only cons,
if I understand it correctly, is that some connections may get
slightly more delay
because it may drop the first syns for a some tcp connections, for others it
may drop the first and the some of the re-transmitted syns. This way for some
connections the syn packet which will provoke checking of the origin will be
additionally delayed.

Thanks for the response,
Pavel.
