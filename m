From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 14:13:03 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38871 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1DMMNE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:13:04 -0400
In-Reply-To: <4DA58A73.9030308@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-04-13 13:35, Ed W wrote:

>On 13/04/2011 10:10, Maciej =C5=BBenczykowski wrote:
>> I should probably point out that iptables module autoloading behavio=
ur
>> is very different for a pre-my commit statically compiled, non-share=
d
>> iptables binary
>> vs a post-my commit or non-statically compiled binary.
>
>Aha.  I am using a static (well, --static --shared) iptables
>
>> The modprobe issue would only show up if you had a statically
>> compiled, non-shared iptables binary.
>> ie. one where all the extensions were already part of the iptables
>> binary and would always get initialized at startup (even for iptable=
s
>> -h).
>
>Thanks - although my evidence suggests its simply the statically
>compiled bit which is enough to trigger this?  My binary is both stati=
c
>and shared (is that the correct term?)

In iptables, the options --enable-static and --enable-shared are=20
semantically different from other projects.

--enable-static/--disable-static decides whether [not] to put all=20
shipped plugins into the binary.

--enable-shared/--disable-shared selects whether the iptables-multi=20
binary will attempt to dlopen extensions when they have not already bee=
n=20
found inside the binary.

Which is really what people want. --enable-static is _not_ going to=20
produce a fully-static executable (one that would yield "not a dynamic=20
executable" when running ldd) in iptables.

>Additionally, as helpfully pointed out by Jan, a chunk of my problem i=
s
>my static iptables apparently trying to probe a kernel module which
>isn't incorporated into my kernel version.  I can't immediately see a
>solution to not uselessly probing for that (without patching iptables)=
?
> Any ideas?

I would have said it could be the missing SET module being the cause fo=
r=20
your modprobe time accumulation, but since you also use iptables-restor=
e=20
that possibility, too, is eliminated.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
