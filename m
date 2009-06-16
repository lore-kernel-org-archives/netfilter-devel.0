From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Wed, 17 Jun 2009 01:08:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906160838410.25132@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bart De Schuymer <bdshuym@pandora.be>,
	Peter Volkov <pva@gentoo.org>,
	Sachin Nasap <sachin.sanap.1gb@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58366 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZFPXIl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:08:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Patrick McHardy wrote on  2009-06-02 12:20:45:
>Jan Engelhardt wrote:
>> On Friday 2009-05-29 18:20, Bart De Schuymer wrote:
>>=20
>>> I think it's best to fix this in the kernel if it's possible, since=
=20
>>> we don't
>>> want to break compatibility.
>>> If the fix has to be in userspace, then it must be a fix that still=
=20
>>> works for
>>> older kernels.
>>=20
>> Since the kernel uses xt_align already, it's best for userspace to d=
o=20
>> the same.
>
>But that doesn't work for older kernels. Please don't dismiss
>compatibility issues that easily. Sometimes things unfortunately
>do slip through, but I expect people to do their best to fix the
>problem properly when this happens.

I compiled myself an ARM crosscompiler, just to see what's going on. No=
t=20
that I could run the binaries, but I could at least look at the objdump=
=20
output. The first impression was: "the state before the supposed=20
regression was introduced could not have worked on ARM in the first=20
place had I run this".

It turns out that ebtables is completely unusable on at least three=20
arches with given ABI configurations even if things were still=20
calculated against ebt_replace instead of _xt_align. One case has been=20
verified by me since it's consumer hardware, and it surprises me=20
the Debian project has not found this earlier, because they actually=20
produced one affected binary distribution in the past (x86 with=20
k64_u32).

Affected arches are all with k64_u32. (Perhaps almost all=C2=A0=E2=80=94=
 I did not=20
recall seeing it on sparc64, and, as I am just checking up on ebtables'=
s=20
Makefile, it has a hack for sparc.) The other configuration I see=20
problems in is a (rather normal) k32_u32 ARM setup with a kernel=20
compiled with CONFIG_EABI=3Dno.

The userspace patch proposed by Sachin Nasap is, IMHO, one to fix the=20
alignment problems (both old and recent) in one clap.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
