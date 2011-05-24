From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Tue, 24 May 2011 17:55:54 +0200
Message-ID: <1306252554.3026.66.camel@edumazet-laptop>
References: <4DC1FACC.4080204@gmail.com>
	 <1306248975.3026.47.camel@edumazet-laptop>  <4DDBD2F1.3020704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49817 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab1EXPz6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 11:55:58 -0400
Received: by wwa36 with SMTP id 36so7487553wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 08:55:57 -0700 (PDT)
In-Reply-To: <4DDBD2F1.3020704@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 24 mai 2011 =C3=A0 17:46 +0200, Pierre Rondou a =C3=A9crit :
> Le 24/05/11 16:56, Eric Dumazet a =C3=A9crit :
> > Le jeudi 05 mai 2011 =C3=A0 03:18 +0200, Pierre Rondou a =C3=A9crit=
 :
> >   =20
> >> Hello everybody,
> >>
> >> I'm currently a student at the University of Li=C3=A8ge. As part o=
f my master
> >> thesis, I have to develop a Linux kernel module for IVI (
> >> http://datatracker.ietf.org/doc/rfc6219/ ).
> >>
> >> I now consider my module as finished (i.e, all functionalities are
> >> implemented) and publish it.
> >>
> >> It is available on sourceforge:
> >>
> >> http://sourceforge.net/projects/nativi/
> >>
> >> Feel free to test it and report to me any bug, bad implementation,
> >> error, ...
> >>
> >> If you believe that this module can be included is the Linux Kerne=
l or
> >> in the Xtables-addons framework, I'll be glad and will help you in=
 this
> >> task.
> >>
> >>
> >> I have tested my module inside the Xtables-addons framework (versi=
on
> >> 1.32) on a debian squeeze (6.0.1) linux with a 2.6.32-5  kernel (i=
686).
> >>
> >> Because of the lack of "EXPORT_SYMBOL" in the kernel, I had to
> >> copy-paste several functions from the kernel into the
> >> nativi_kernel_code.c file in order to use some features already
> >> available in the kernel (ip_finish_output, ip6_output, icmp_send).
> >>
> >> Documentation is provided in the source code, if you have any ques=
tion
> >> don't hesitate to ask me.
> >>
> >>     =20
> > Hi Pierre
> >
> > 1) Are you sure netfilter is the right place for this IVI feature ?
> >     (fact that you had to copy/paste ~1300 lines of code from kerne=
l
> > might show that this would be better to use a module hooked into
> > forwarding stack ?)
> >   =20
> I used Xtables to produce my module, fact is that I was (and still am=
) a=20
> kernel nooby, Xtables seemed to a be good way to produce this code.
> I'm not sure to what you're refering about, are you suggesting I shou=
ld=20
> have developed the module directly into the kernel?
>=20

We all were kernel newbie at very beginning ;)

> > 2) How this can integrate a {conntrack enabled} firewall ?
> >
> >   =20
>=20
> I can't ... It's a drawback of the module. The fact is that I only ha=
ve=20
> found a very little documentation about conntrack code, so I dropped =
the=20
> idea of dealing with it.
> But it shouldn't be difficult to update the conntrack for a kernel pr=
o I=20
> guess ;-)

This has to be discussed before even coding ;)

One packet going through this gateway has one IPv6 side and one ipv4
side. This can be a problem to firewalling (either its ipv4, either its
ipv6) and conntracking.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
