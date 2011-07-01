From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Fri, 01 Jul 2011 06:52:06 +0200
Message-ID: <1309495926.2515.8.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop> <4E0C15A3.9050609@yandex.ru>
	 <BANLkTiksYHMU7ojnKMJBj-EQjW8sxTO2Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41979 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GAEwM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:52:12 -0400
Received: by wyg8 with SMTP id 8so1952912wyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 21:52:11 -0700 (PDT)
In-Reply-To: <BANLkTiksYHMU7ojnKMJBj-EQjW8sxTO2Tw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 30 juin 2011 =C3=A0 15:26 -0700, Sam Roberts a =C3=A9crit :
> On Wed, Jun 29, 2011 at 11:20 PM, Kuzin Andrey <kuzinandrey@yandex.ru=
> wrote:
> >  On 29.06.2011 14:08, Eric Dumazet wrote:
> >> But if some packets are never dequeued (because something is wrong=
 with
> >> your program, failing to give verdict), they stay forever in the l=
ist
> >> and each dequeue is slower since it has to go past these packets..=
=2E
>=20
> > I'am using NFQUEUE several years on our main network router, and pr=
oblem
> > with packets stuck in the queue is still not resolved.
>=20
> Is there any way to see what the current queue is in the kernel? How
> deep, and what  the IDs are?
>=20

check third column (queue_total) of :

# cat /proc/net/netfilter/nfnetlink_queue=20
    0  15363  1024 2 65535   160     0     2208  1

queue_number peer_pid queue_total copy_mode copy_range queue_dropped qu=
eue_user_dropped id_sequence 1

Here my test program 'forgot' to give a verdict to 1024 packets.
So all new packets are dropped (160 so far)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
