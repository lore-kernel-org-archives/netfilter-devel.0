From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Fri, 29 May 2009 12:02:06 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>  <4A1EB783.4090801@pandora.be> <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: sachin sanap <sachin.sanap.1gb@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43305 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZE2KCE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2009 06:02:04 -0400
In-Reply-To: <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-05-29 07:51, sachin sanap wrote:

>Iam facing problem with ebtables binay on 2.6.28 kernel (same binary
>works well with 2.6.27). Its mostly a structure alignment issue with
>standard targets like DROP,ACCEPT etc. Message seen by user is
>"eb_tables: standard target: invalid size 8 !=3D 4"
>Iam trying to fix it, this mail is just to check if its already fixed
>by someone else?

Indeed this seems to happen, but only when using a mixed-bitness
combination:

/tmp/usr/sbin # LD_LIBRARY_PATH=3D../lib ./ebtables -A INPUT -j ACCEPT
The kernel doesn't support the ebtables 'filter' table.

/tmp/usr/sbin # uname -a
Linux sovereign 2.6.29.3-jen80-default #1 SMP 2009-04-06 18:10:58 +0200=
=20
x86_64 x86_64 x86_64 GNU/Linux

/tmp/usr/sbin # file ebtables
ebtables: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), for=
=20
GNU/Linux 2.6.4, dynamically linked (uses shared libs), stripped

ebtables does work when it is 64-bit too, so the immediate workaround=C2=
=A0=E2=80=94
assuming you are on x86=C2=A0=E2=80=94 is to not use a 32-bit userspace=
 with a
64-bit kernel.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
