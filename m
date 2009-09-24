From: =?windows-1252?Q?Vlado_Dr=9E=EDk?= <vlado@ttx.sk>
Subject: Re: xtables-addons ACCOUNT - userspace
Date: Thu, 24 Sep 2009 22:58:54 +0200
Message-ID: <4ABBDD8E.1030703@ttx.sk>
References: <4ABA69F3.9010907@ttx.sk> <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz> <alpine.LSU.2.00.0909240150350.30035@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ttx02.ttx-net.sk ([193.110.187.3]:40179 "EHLO ttx02.ttx-net.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZIXVVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:21:24 -0400
In-Reply-To: <alpine.LSU.2.00.0909240150350.30035@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for that!,
I was able to get also the userspace part working with snapshot from
ACCOUNT branch but I'm not able to compile whole xtables-addons from
this branch.

Compile was running on CentOS 5 (x86 and x86_64)

I've recieved following when trying compile:
make  all-recursive
make[1]: Entering directory `/usr/src/xtables-addons'
Making all in extensions
make[2]: Entering directory `/usr/src/xtables-addons/extensions'
if [ -n "/usr/src/linux-2.6.31" ]; then make -C /usr/src/linux-2.6.31 M=
=3D
modules; fi;
make[3]: Entering directory `/usr/src/linux-2.6.31'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  Building modules, stage 2.
  MODPOST 452 modules
make[3]: Leaving directory `/usr/src/linux-2.6.31'
make -f ../Makefile.iptrules all;
make[3]: Entering directory `/usr/src/xtables-addons/extensions'
  CC     libxt_RAWDNAT.oo
In file included from libxt_RAWDNAT.c:17:
xt_RAWNAT.h:5: error: field =91addr=92 has incomplete type
make[3]: *** [libxt_RAWDNAT.oo] Error 1
make[3]: Leaving directory `/usr/src/xtables-addons/extensions'
make[2]: *** [user-all-local] Error 2
make[2]: Leaving directory `/usr/src/xtables-addons/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/usr/src/xtables-addons'
make: *** [all] Error 2

Do you have any clue what can be possibly wrong?
Regards,
Vlado


Jan Engelhardt  wrote / nap=EDsal(a):
> On Wednesday 2009-09-23 22:11, Jan Rafaj wrote:
>> I'm glad you find it useful, like me.
>>
>> I've originally submitted my ports of [ACCOUNT, ...]
>> for inclusion to xtables-addons (Xt-a) few weeks ago. So far Jan Eng=
elhardt,
>> its maintainer, has added just the kernel part of ACCOUNT
>> to Xt-a, perhaps due to lack of time and becouse he probably didnt w=
ant
>> to delay release of Xt-a 1.18 .
>>
>> You may try to ask him about the current status of adding iptaccount
>> as well as the other modules I "ported" (I'm looking forward to this=
 too).
>> From what I know the troublesome part is that I didnt do the ports
>> in git, so he will need to pluck apart all my changes and stuff it
>> into git as separate commits. (Next time - if there will be such tim=
e
>> - I wont make this mistake again).
>=20
> The troublesome part was the extra GNUmakefile.in you proposed
> adding. I spent the last days on getting Automake back and not
> having to use too many own makefiles, because that would lead
> to an update nightmare. (Now it's all nice.)
>=20
> Please test the latest ACCOUNT-e37985b.
>=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
