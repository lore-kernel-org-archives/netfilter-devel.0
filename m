From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons ACCOUNT - userspace
Date: Fri, 25 Sep 2009 09:53:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909250950130.10538@obet.zrqbmnf.qr>
References: <4ABA69F3.9010907@ttx.sk> <alpine.LNX.2.00.0909232154500.25578@cedric.unob.cz> <alpine.LSU.2.00.0909240150350.30035@obet.zrqbmnf.qr> <4ABBDD8E.1030703@ttx.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Vlado_Dr=C5=BE=C3=ADk?= <vlado@ttx.sk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56460 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbZIYHxs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:53:48 -0400
In-Reply-To: <4ABBDD8E.1030703@ttx.sk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-09-24 22:58, Vlado Dr=C5=BE=C3=ADk wrote:

>Thanks for that!,
>I was able to get also the userspace part working with snapshot from
>ACCOUNT branch but I'm not able to compile whole xtables-addons from
>this branch.
>
>Compile was running on CentOS 5 (x86 and x86_64)
>
>I've recieved following when trying compile:
>  CC     libxt_RAWDNAT.oo
>In file included from libxt_RAWDNAT.c:17:
>xt_RAWNAT.h:5: error: field =E2=80=98addr=E2=80=99 has incomplete type
>
>Do you have any clue what can be possibly wrong?

I could imagine that, on systems with a /usr/include/linux older than=20
2.6.25, you need to point it to the iptables source tree, which has a=20
timely copy of linux/netfilter.h shipping said type; in other words,=20
please try:

	./configure --with-xtables=3D/path/to/iptables.src
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
