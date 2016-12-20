From: mark diener <rpzrpzrpz@gmail.com>
Subject: Re: RFC: nft.8 review
Date: Tue, 20 Dec 2016 11:42:16 -0600
Message-ID: <CAChgv6q8rYBu96Nvh+dCnOYq4NV0mHZw9egnLOgZNsAb1JFgvA@mail.gmail.com>
References: <20161210102715.GA2955@orbyte.nwl.cc> <20161219235330.GA7565@salvia>
 <CAChgv6pVKFz3fH5yGCA+8av84=c_2Ob25hy5AcTL=YLzw+n7Aw@mail.gmail.com> <20161220172130.GI13857@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Phil Sutter <phil@nwl.cc>, mark diener <rpzrpzrpz@gmail.com>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34895 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbcLTRmS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 12:42:18 -0500
Received: by mail-oi0-f46.google.com with SMTP id b126so185313061oia.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 09:42:17 -0800 (PST)
In-Reply-To: <20161220172130.GI13857@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil:

Yes, I certainly hope that the netfilter interface is byte level
backwards compatible from the netfilter calls upwards, but there is a
chance that compatibility
is only from userspace libmnl and upwards.

If that is the case, what kernel version release can I expect the
current netfilter message packing structures to be changed
where the current version 4.x kernel based libmnl would no longer work?

It would be lovely if the kernel netfilter team documented the byte
level interface that libmnl is written, but I don't have sponsorship
dollars.

Merry Christmas,

Marco







On Tue, Dec 20, 2016 at 11:21 AM, Phil Sutter <phil@nwl.cc> wrote:
> Hi Mark,
>
> On Tue, Dec 20, 2016 at 10:27:45AM -0600, mark diener wrote:
>> Will the V8 NFT have byte level protocol compatibility with current
>> linux kernel versions?
>
> We were talking about nft manpage (which happens to live in section 8,
> hence why I referred to it as 'nft.8'), not some version 8 (which would
> still take a while to come as we're only at version 0.6 ATM).
>
>> I am deployed on kernel  4.4.0-53-generic and would like to know when
>> structural defines like RTM_NEWADDR,NLM_F_REQUEST, etc become updated
>> or obsoleted.
>
> Not sure I understand you correctly, but why should userspace exported
> constants like RTM_NEWADDR or NLM_F_REQUEST become obsolete? This would
> break backwards compatibility, which is generally frowned upon.
>
>> As you can likely tell, I am not using libmnl or libnft but using
>> direct NETFILTER kernel calls.
>>
>> What a challenge to scan the code and reverse-engineer the byte
>> sequences and understand the way the NFT virtual machine works in the
>> kernel.
>
> Sounds like you're baking your own cake here. I'd say if you decide to
> reinvent the wheel, well, then you have to invent a wheel. No? ;)
>
> Cheers, Phil
