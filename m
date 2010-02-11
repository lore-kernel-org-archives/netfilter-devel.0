From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 14:12:32 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111403280.30927@obet.zrqbmnf.qr>
References: <b6fcc0a1002110114n3961c1b7v4cb556e4827fc137@mail.gmail.com>  <4B73CD6C.2090302@trash.net> <b6fcc0a1002110142p524de4ddm5260751cc68f4482@mail.gmail.com> <4B73D46B.8090701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57009 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0BKNMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:12:33 -0500
In-Reply-To: <4B73D46B.8090701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-11 10:56, Patrick McHardy wrote:

>Alexey Dobriyan wrote:
>> On Thu, Feb 11, 2010 at 11:27 AM, Patrick McHardy <kaber@trash.net> wrote:
>>> Alexey Dobriyan wrote:
>>>>> -static inline int ebt_basic_match(struct ebt_entry *e, struct ethhdr *h,
>>>>> -   const struct net_device *in, const struct net_device *out)
>>>>> +static inline int
>>>>> +ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
>>>>> +                const struct net_device *in, const struct net_device *out)
>>>> These const modifiers are pointless because compilers are smart enough
>>>> to notice non-modifiability and generate the very same code in both cases.
>
>Yes, occasionally it has caught typos or other variable mixups for me.
>It also documents that a variable is only supposed to be read.

In this case it allows parameter and local variable reduction
because I have proven, by means of const, that they would
remain the same over the entire function. (Scheduled commit
3c58069510:
http://dev.medozas.de/gitweb.cgi?p=linux;a=commit;h=3c58069510a498110240ceaff8c2a10c0d9b4460
 - this will be in the next pull group.)

>>>>> -    struct ebt_entry *e = (struct ebt_entry *)chain->data;
>>>>> +    const struct ebt_entry *e = (struct ebt_entry *)chain->data;
>>>> And such things are wrong (not second const).
>>> What's wrong about this?
>> 
>> Should it be (const struct ebt_entry *)?
>
>That's not necessary. Its just declaring the the memory should
>not be modified through e. The const qualification happens
>automatically.

Conversion from T* to const T* is permitted and implicit across =.
