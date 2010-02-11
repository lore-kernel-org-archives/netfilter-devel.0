From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 6/6] netfilter: xtables: add const qualifiers
Date: Thu, 11 Feb 2010 11:42:41 +0200
Message-ID: <b6fcc0a1002110142p524de4ddm5260751cc68f4482@mail.gmail.com>
References: <b6fcc0a1002110114n3961c1b7v4cb556e4827fc137@mail.gmail.com>
	 <4B73CD6C.2090302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f185.google.com ([209.85.223.185]:42131 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0BKJmm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:42:42 -0500
Received: by iwn15 with SMTP id 15so1070267iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 01:42:41 -0800 (PST)
In-Reply-To: <4B73CD6C.2090302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 11:27 AM, Patrick McHardy <kaber@trash.net> wro=
te:
> Alexey Dobriyan wrote:
>>> -static inline int ebt_basic_match(struct ebt_entry *e, struct ethh=
dr *h,
>>> - =A0 const struct net_device *in, const struct net_device *out)
>>> +static inline int
>>> +ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct net_device *in, const=
 struct net_device *out)
>>
>> These const modifiers are pointless because compilers are smart enou=
gh
>> to notice non-modifiability and generate the very same code in both =
cases.
>>
>> Nowadays, half of functions declarations in generic
>> xtables/iptables/ip6tables/arptables
>> code are littered with const which makes them pretty unpleasant to r=
ead.
>
> Well, the benefit is that the compiler can catch accidental modificat=
ion
> of data that is supposed to be constant.

Did it ever? Realistically?

=46rom what I see, const is used with string functions
(to make string literals go to rodata) and with structures full of hook=
s
(to make them go to rodata).

>>> - =A0 =A0struct ebt_entry *e =3D (struct ebt_entry *)chain->data;
>>> + =A0 =A0const struct ebt_entry *e =3D (struct ebt_entry *)chain->d=
ata;
>>
>> And such things are wrong (not second const).
>
> What's wrong about this?

Should it be (const struct ebt_entry *)?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
