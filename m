From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Tue, 24 May 2011 16:56:15 +0200
Message-ID: <1306248975.3026.47.camel@edumazet-laptop>
References: <4DC1FACC.4080204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1EXO4U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 10:56:20 -0400
Received: by wwa36 with SMTP id 36so7421636wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 07:56:19 -0700 (PDT)
In-Reply-To: <4DC1FACC.4080204@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 05 mai 2011 =C3=A0 03:18 +0200, Pierre Rondou a =C3=A9crit :
> Hello everybody,
>=20
> I'm currently a student at the University of Li=C3=A8ge. As part of m=
y master=20
> thesis, I have to develop a Linux kernel module for IVI (=20
> http://datatracker.ietf.org/doc/rfc6219/ ).
>=20
> I now consider my module as finished (i.e, all functionalities are=20
> implemented) and publish it.
>=20
> It is available on sourceforge:
>=20
> http://sourceforge.net/projects/nativi/
>=20
> Feel free to test it and report to me any bug, bad implementation,=20
> error, ...
>=20
> If you believe that this module can be included is the Linux Kernel o=
r=20
> in the Xtables-addons framework, I'll be glad and will help you in th=
is=20
> task.
>=20
>=20
> I have tested my module inside the Xtables-addons framework (version=20
> 1.32) on a debian squeeze (6.0.1) linux with a 2.6.32-5  kernel (i686=
).
>=20
> Because of the lack of "EXPORT_SYMBOL" in the kernel, I had to=20
> copy-paste several functions from the kernel into the=20
> nativi_kernel_code.c file in order to use some features already=20
> available in the kernel (ip_finish_output, ip6_output, icmp_send).
>=20
> Documentation is provided in the source code, if you have any questio=
n=20
> don't hesitate to ask me.
>=20

Hi Pierre

1) Are you sure netfilter is the right place for this IVI feature ?
   (fact that you had to copy/paste ~1300 lines of code from kernel
might show that this would be better to use a module hooked into
forwarding stack ?)

2) How this can integrate a {conntrack enabled} firewall ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
