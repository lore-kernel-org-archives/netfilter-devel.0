From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Wed, 29 Jun 2011 12:08:16 +0200
Message-ID: <1309342096.2532.116.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anders Nilsson Plymoth <lanilsson@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63532 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1F2KIV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:08:21 -0400
Received: by wwg11 with SMTP id 11so3748999wwg.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2011 03:08:20 -0700 (PDT)
In-Reply-To: <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 29 juin 2011 =C3=A0 11:55 +0200, Anders Nilsson Plymoth a =C3=
=A9crit :
> Hi Eric,
>=20
> Thanks for your reply.
> Yes, I am sure I set the verdict, as right now I do it on all packets
> by default.
> I will try upgrading and see if it works. Do you know if commit
> c463ac972315a0 solves the problem you mentioned?

No, it doesnt solve the problem, only make things faster.

But if some packets are never dequeued (because something is wrong with
your program, failing to give verdict), they stay forever in the list
and each dequeue is slower since it has to go past these packets...

2.6.37 also contains commit 29b4433d991c88d86ca48a4c1cc33c671475be4b
(net: percpu net_device refcount) which helps a lot netfilter
queue/dequeue if your machine is SMP.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
