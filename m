From: Loganaden Velvindron <loganaden@gmail.com>
Subject: Re: Harden iptables memory allocator
Date: Mon, 25 May 2015 19:52:40 +0000
Message-ID: <CAOp4FwQ5oav-iH+NbBJHCbXuC2tmPZQR+oso8f14qeV96GFriQ@mail.gmail.com>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com>
	<20150525175633.GA3186@salvia>
	<CAOp4FwQC=NuK2YRWxhOuYyKQJjgi86r1VD6oTfzO=e=OaWhFOw@mail.gmail.com>
	<20150525192807.GA15963@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34901 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbEYTwk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 15:52:40 -0400
Received: by iesa3 with SMTP id a3so78071342ies.2
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2015 12:52:40 -0700 (PDT)
In-Reply-To: <20150525192807.GA15963@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 25, 2015 at 7:28 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 25, 2015 at 06:59:01PM +0000, Loganaden Velvindron wrote:
> [...]
>> >> @@ -1753,8 +1787,8 @@ xtables_ip6parse_multiple(const char *name,
>> >> struct in6_addr **addrpp,
>> >>   ++loop; /* skip ',' */
>> >>   }
>> >>
>> >> - *addrpp = xtables_malloc(sizeof(struct in6_addr) * count);
>> >> - *maskpp = xtables_malloc(sizeof(struct in6_addr) * count);
>> >> + *addrpp = xtables_reallocarray(NULL, count, sizeof(struct in6_addr));
>> >> + *maskpp = xtables_reallocarray(NULL, count, sizeof(struct in6_addr));
>> >
>> > How feasible is to trigger this overflow in iptables? I'm hitting here
>> > argument list too long before I can trigger this.
>> >
>>
>> Those were conversions that I identified as cases involving
>> malloc(x*y), which could be readily changed. Rather than having cases
>> where malloc(x*y) is used, we can switch to reallocarray(x*y).
>>
>>
>> > I'd rather see an evalution on how this integer overflow can affect
>> > us.
>>
>> Well, it's a safe and easy to use API that can be used instead of the
>> malloc(x*y).
>>
>>
>> Are they exploitable ? I'm not really into crafting exploits, but I
>> welcome an easy to use API that prevents that.
>>
>> At the very least, having it available in the library, would be a good
>> thing, when there's a case for a dangerous malloc(x*y).
>
> The only client of this library that I know is iptables, which feeds
> this function with an input from the command line.

What if someone wants to have another client tomorrow  that works differently ?

>
>> This is what the Xorg project did:
>> https://www.freetype.org/patch/46133/
>>
>> They imported reallocarray() and converted cases of malloc(x*y) into
>> reallocarray(NULL, x, y).
>
> That seems good for a public library that is used by third parties,
> but this is not the case.
>
> Moreover, we also have more spots that were not converted for some
> reason in this patch.
>
> Sorry, this doesn't sound very convincing.

My point is that reallocarray() is a more robust & safer API than
malloc(x*y).  Having xtables_reallocarray() would have been a nice
addition, but I understand your point.
