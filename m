From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Thu, 18 Jun 2009 18:33:27 +0200
Message-ID: <4A3A6C57.6080403@pandora.be>
References: <alpine.LSU.2.00.0906160838410.25132@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, Peter Volkov <pva@gentoo.org>,
	Sachin Nasap <sachin.sanap.1gb@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:52956 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbZFRQd2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:33:28 -0400
In-Reply-To: <alpine.LSU.2.00.0906160838410.25132@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt schreef:
> Patrick McHardy wrote on  2009-06-02 12:20:45:
>  =20
>> Jan Engelhardt wrote:
>>    =20
>>>
>>> Since the kernel uses xt_align already, it's best for userspace to =
do=20
>>> the same.
>>>      =20
>> But that doesn't work for older kernels. Please don't dismiss
>> compatibility issues that easily. Sometimes things unfortunately
>> do slip through, but I expect people to do their best to fix the
>> problem properly when this happens.
>>    =20
>
> I compiled myself an ARM crosscompiler, just to see what's going on. =
Not=20
> that I could run the binaries, but I could at least look at the objdu=
mp=20
> output. The first impression was: "the state before the supposed=20
> regression was introduced could not have worked on ARM in the first=20
> place had I run this".
>
> It turns out that ebtables is completely unusable on at least three=20
> arches with given ABI configurations even if things were still=20
> calculated against ebt_replace instead of _xt_align. One case has bee=
n=20
> verified by me since it's consumer hardware, and it surprises me=20
> the Debian project has not found this earlier, because they actually=20
> produced one affected binary distribution in the past (x86 with=20
> k64_u32).
>
> Affected arches are all with k64_u32. (Perhaps almost all =E2=80=94 I=
 did not=20
> recall seeing it on sparc64, and, as I am just checking up on ebtable=
s's=20
> Makefile, it has a hack for sparc.) The other configuration I see=20
> problems in is a (rather normal) k32_u32 ARM setup with a kernel=20
> compiled with CONFIG_EABI=3Dno.
>
> The userspace patch proposed by Sachin Nasap is, IMHO, one to fix the=
=20
> alignment problems (both old and recent) in one clap.
>  =20

Thanks, I'll have a look at it this weekend.

cheers,
Bart

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
