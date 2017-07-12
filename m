From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] monitor: fix printing of range elements in named sets
Date: Wed, 12 Jul 2017 13:24:24 +0200
Message-ID: <CAOkSjBgWYqk1sd-Z2A8_DUUTK3pMW3b=W-8qiYAkQ5imc32TEA@mail.gmail.com>
References: <149935174634.19966.16018870027671610502.stgit@nfdev2.cica.es> <20170711181104.GP16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36555 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbdGLLYr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 07:24:47 -0400
Received: by mail-it0-f52.google.com with SMTP id m68so9935277ith.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 04:24:47 -0700 (PDT)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com. [209.85.223.169])
        by smtp.gmail.com with ESMTPSA id i5sm1055893iti.20.2017.07.12.04.24.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 04:24:45 -0700 (PDT)
Received: by mail-io0-f169.google.com with SMTP id z62so10762893ioi.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 04:24:45 -0700 (PDT)
In-Reply-To: <20170711181104.GP16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 July 2017 at 20:11, Phil Sutter <phil@nwl.cc> wrote:
> Hi,
>
> On Thu, Jul 06, 2017 at 04:36:45PM +0200, Arturo Borrero Gonzalez wrote:
>> If you add set elements to interval sets, the output is wrong.
>> Fix this by caching first element of the range (first event),
>> then wait for the second element of the range (second event) to
>> print them both at the same time.
>
> As promised, I am preparing my own solution for side-by-side comparison.
> Though I'm running into problems and want to use the occasion to discuss
> them first:
>
> What I wasn't able to solve yet are half-open ranges, like so:
>
> | nft add set ip t portrange { type inet_service; flags interval; }
> | nft add element ip t portrange { 1024-65535 }
>
> In this case there is only a single element with value 1024 which
> doesn't have EXPR_F_INTERVAL_END set. Looking at
> interval_map_decompose(), this is identified to be a range till the end
> of the scope if it's the last element in the set.
>
> In monitor code though, I can't predict whether an interval end element
> will come afterwards or not, so I end up caching the element and
> everything turns into a mess. I'm pretty sure your solution has the same
> problem, could you check that?
>
> Right now, I only see two ways to get this sorted:
>
> 1) Change kernel code to always include both start end end of a range in
>    a single notification. This would eliminate the need for any caching
>    in netlink_events_setelem_cb() altogether!
>
> 2) Change monitor code to cache all events until the final NFTA_GEN_ID
>    message, then handle all messages at once.
>
> What do you think?
>

We should avoid touching the kernel for this.

Anyway, my patch doesn't solve the same issue for deleting range elements.
In this patch I added the logic in netlink_events_setelem_cb() and
probably a better place for this
is in the netlink_events_cache_update() routine.

I'm sending a patch to add a bit of debugging to the monitor code path
meanwhile we solve this issue.
