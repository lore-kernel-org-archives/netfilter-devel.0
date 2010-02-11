From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 10:56:59 +0100
Message-ID: <4B73D46B.8090701@trash.net>
References: <b6fcc0a1002110114n3961c1b7v4cb556e4827fc137@mail.gmail.com>	 <4B73CD6C.2090302@trash.net> <b6fcc0a1002110142p524de4ddm5260751cc68f4482@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38180 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0BKJ5G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:57:06 -0500
In-Reply-To: <b6fcc0a1002110142p524de4ddm5260751cc68f4482@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Thu, Feb 11, 2010 at 11:27 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Alexey Dobriyan wrote:
>>>> -static inline int ebt_basic_match(struct ebt_entry *e, struct ethhdr *h,
>>>> -   const struct net_device *in, const struct net_device *out)
>>>> +static inline int
>>>> +ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
>>>> +                const struct net_device *in, const struct net_device *out)
>>> These const modifiers are pointless because compilers are smart enough
>>> to notice non-modifiability and generate the very same code in both cases.
>>>
>>> Nowadays, half of functions declarations in generic
>>> xtables/iptables/ip6tables/arptables
>>> code are littered with const which makes them pretty unpleasant to read.
>> Well, the benefit is that the compiler can catch accidental modification
>> of data that is supposed to be constant.
> 
> Did it ever? Realistically?

Yes, occasionally it has caught typos or other variable mixups for me.
It also documents that a variable is only supposed to be read.

>>From what I see, const is used with string functions
> (to make string literals go to rodata) and with structures full of hooks
> (to make them go to rodata).

Yes, that's also a reason.

>>>> -    struct ebt_entry *e = (struct ebt_entry *)chain->data;
>>>> +    const struct ebt_entry *e = (struct ebt_entry *)chain->data;
>>> And such things are wrong (not second const).
>> What's wrong about this?
> 
> Should it be (const struct ebt_entry *)?

That's not necessary. Its just declaring the the memory should
not be modified through e. The const qualification happens
automatically.
