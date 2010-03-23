From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Tue, 23 Mar 2010 12:49:48 +0800
Message-ID: <7b6bb4a51003222149v5346c3eje94ed1182b207206@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
	 <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
	 <628d1651003221937q58ff39fel467636ab55531128@mail.gmail.com>
	 <alpine.LSU.2.01.1003230346010.12017@obet.zrqbmnf.qr>
	 <628d1651003222048k1eaf6929r81fd06e401190e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: wzt wzt <wzt.wzt@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f182.google.com ([209.85.221.182]:55143 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0CWEtv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:49:51 -0400
In-Reply-To: <628d1651003222048k1eaf6929r81fd06e401190e0@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:48 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
> 1=E3=80=81 suppose *len =3D 35, =C2=A0sizeof(struct ipt_get_entries) =
=3D 36
> 2=E3=80=81 set get.size =3D 0xffffffff from user space
> 3=E3=80=81 sizeof(struct ipt_get_entries) + get.size =3D 36 =C2=A0+ 0=
xffffffff =3D 35;
> 4=E3=80=81 if (*len !=3D sizeof(struct ipt_get_entries) + get.size) w=
as bypassed.
>
> you can test with c code:
>
> #include <stdio.h>
>
> int main(void)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int arg =3D 0xffffffff;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("%u\n", arg + 36);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (35 !=3D arg + 36) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("not ov=
er flow.\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("arg over flow.\n");
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> }
>

You didn't get his point... The key point is that sizeof() result type
is size_t, slightly modify you code, try the result.
> int main(void)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int arg =3D 0xffffffff;
>        unsigned int foo;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("%lu\n", arg + sizeof(foo));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sizeof(foo) - 1 !=3D arg + sizeof(foo)=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("not ov=
er flow.\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("arg over flow.\n");
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> }

> On Tue, Mar 23, 2010 at 11:04 AM, Jan Engelhardt <jengelh@medozas.de>=
 wrote:
>>
>> On Tuesday 2010-03-23 03:37, wzt wzt wrote:
>>>> And, for the addition overflow, can it be caught by
>>>>
>>>> "if (*len !=3D sizeof(struct ipt_get_entries) + get.size)" =C2=A0?=
??
>>>
>>>sizeof(struct ipt_get_entries) + get.size can be overflow as *len,
>>>get.size is control by user space with copy_from_user().
>>
>> The !=3D should catch it.
>>
>> For 64-bit environments:
>> * + invoked with size_t, unsigned int
>> =C2=A0=3D> right side promoted to size_t, result type is size_t
>> * !=3D invoked with int and size_t
>> =C2=A0=3D> left-side promoted to ssize_t (probably; but something as=
 large as size_t)
>> * get.size is 32-bit bounded, as is *len,
>> =C2=A0so no overflow to worry about at all unless you make
>> =C2=A0sizeof(X) hilariously big close to 2^64 which is rather unlike=
ly.
>>
>> For 32-bit environments:
>> * Let *len be a number of choice (e.g. 36)
>> * Find a sizeof(X)+get.size that equals 36 mod 2^32.
>> * Since sizeof(X) is const, get.size must be 0 mod 2^32.
>> * So get.size must be a multiple of 2^32 to fool the system.
>> * Since get.size itself is only a 32-bit quantity, you cannot
>> =C2=A0represent any value larger than 4294967295.
>>
>>
>> What Was What Was Wanted.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
