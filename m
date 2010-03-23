From: wzt wzt <wzt.wzt@gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Tue, 23 Mar 2010 11:11:22 +0800
Message-ID: <628d1651003222011v2389fc68u7ba009ae4b781884@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
	 <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
	 <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
	 <7b6bb4a51003222005v5fd71c8ao7fd1d05fb1ef2d8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61360 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0CWDLX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:11:23 -0400
In-Reply-To: <7b6bb4a51003222005v5fd71c8ao7fd1d05fb1ef2d8b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> get.size is unsigned int, UINT_MAX is 0x FFFFFFFF, not 0x7FFFFFFF
> And you're metioning "addition", then why you're checking as "multipl=
ication"?

oh, my falut:(  the patch is multiplication check, not addition check.
thanks for helping me:)

On Tue, Mar 23, 2010 at 11:05 AM, Xiaotian Feng <xtfeng@gmail.com> wrot=
e:
> On Tue, Mar 23, 2010 at 10:37 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
>>> Patrick's point is that you're using "if (get.size >=3D INT_MAX /
>>> sizeof(struct ipt_get_entries))"
>>> So, did you find any chance that get.size * sizeof(struct
>>> ipt_get_entries) >=3D INT_MAX ?
>>>
>> would you carefully read my explain???
>> get.size is copy from the user space, =C2=A0it can be set as 0x7ffff=
fff,
>> addition with sizeof(struct ipt_get_entries) can be overflow.
>>
>
> get.size is unsigned int, UINT_MAX is 0x FFFFFFFF, not 0x7FFFFFFF
> And you're metioning "addition", then why you're checking as "multipl=
ication"?
>
>>> And, for the addition overflow, can it be caught by
>>>
>>> "if (*len !=3D sizeof(struct ipt_get_entries) + get.size)" =C2=A0??=
?
>>>
>> sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
>> get.size is control by user space with copy_from_user().
>
>
>>
>> On Tue, Mar 23, 2010 at 10:29 AM, Xiaotian Feng <xtfeng@gmail.com> w=
rote:
>>> On Tue, Mar 23, 2010 at 9:34 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
>>>>> I can see that the size might cause an overflow in the addition w=
ith
>>>>> sizeof(struct ipt_get_entries)
>>>> That's the integer overflow i pointed.
>>>> get.size is copy from the user space, =C2=A0it can be set as 0x7ff=
fffff,
>>>> addition with sizeof(struct ipt_get_entries) can be overflow.
>>>
>>> Patrick's point is that you're using "if (get.size >=3D INT_MAX /
>>> sizeof(struct ipt_get_entries))"
>>> So, did you find any chance that get.size * sizeof(struct
>>> ipt_get_entries) >=3D INT_MAX ?
>>>
>>> And, for the addition overflow, can it be caught by
>>>
>>> "if (*len !=3D sizeof(struct ipt_get_entries) + get.size)" =C2=A0??=
?
>>>
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (*len !=3D sizeof(struct ipt_get_ent=
ries) + get.size) {
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0duprintf("g=
et_entries: %u !=3D %zu\n",
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 *len, sizeof(get) + get.size);
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIN=
VAL;
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>>
>>>> so, check get.size max value before addition with sizeof(struct
>>>> ipt_get_entries) to prevent the integer overflow.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ke=
rnel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>>>
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
