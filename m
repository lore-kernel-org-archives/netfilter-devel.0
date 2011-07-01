From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Fri, 01 Jul 2011 06:53:58 +0200
Message-ID: <1309496038.2515.10.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop> <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop> <4E0C278B.7010403@yandex.ru>
	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C651A.1000300@trash.net>
	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <BANLkTimJKxShXcxaS7AijtDwvhET0zLWOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39737 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GAEyE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:54:04 -0400
Received: by wwg11 with SMTP id 11so1351974wwg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 21:54:02 -0700 (PDT)
In-Reply-To: <BANLkTimJKxShXcxaS7AijtDwvhET0zLWOg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 30 juin 2011 =C3=A0 15:24 -0700, Sam Roberts a =C3=A9crit :
> On Thu, Jun 30, 2011 at 8:15 AM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> > Le jeudi 30 juin 2011 =C3=A0 13:59 +0200, Patrick McHardy a =C3=A9c=
rit :
> >
> >> Thanks Eric, I agree. Give us data and we'll fix it if really is a=
 bug.
> >>
> >> The fact that the timeout patch apparently helps indicates that so=
me
> >> packets don't receive verdicts.
> >
> > My rough guess is that this user application gets an error in its
> > nfq_set_verdict() call ( maybe a transient out of memory indication=
) and
> > packet never gets its verdict.
>=20
> Hows does ENOBUFS interact with the queue? Is it possible that the
> kernel->userspace notification of the packet id gets dropped, and
> userspace is thus never notified of the packet id, and can't issue a
> verdict?

Its not possible.

If a paquet is in QUEUE, it means a friend packet was also queued on th=
e
netlink socket.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
