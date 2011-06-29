From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Wed, 29 Jun 2011 11:47:23 +0200
Message-ID: <1309340843.2532.112.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anders Nilsson Plymoth <lanilsson@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1F2Jr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:47:27 -0400
Received: by wyg8 with SMTP id 8so730760wyg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2011 02:47:26 -0700 (PDT)
In-Reply-To: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 29 juin 2011 =C3=A0 11:17 +0200, Anders Nilsson Plymoth a =C3=
=A9crit :
> Hi,
>=20
> I am using libnetfilter-queue on a router running Ubuntu 10.10 with
> 2.6.35-28-generic. The problem I am having is that I am experiencing =
a
> very significant throughput slowdown whenever my NFQUEUE program is
> running. This happens even when I use bare bone libnetfilter-queue
> program that immediately issues an ACCEPT verdict as soon as it
> receives a packet. Whenever this program is running, my max throughpu=
t
> is cut in half, and the reason it happens is because nf_queue
> overflows (nf_queue: full at 1024 entries, dropping packets(s)), and =
I
> notice my CPU utilization is 100%. However, when my program is not
> running and I am not passing packets through NFQUEUE and the router
> routes packets as normal, I get full throughput with only 0.1% CPU
> utilization.
>=20
> I find this a bit strange, can the netfilter queue processing take th=
e
> cpu from 0.1% to 100% and start dropping packets even with no other
> processing than setting immediately setting the verdict? We have two
> of these machines, with identical hardware and OS, and they experienc=
e
> the same behavior.
> I am also confused as we have been using these machines previously an=
d
> been able to obtain full throughput with our netfilter program.
>=20
> Does anyone have a clue here, or suggest what I should look into in
> order to speed things up.
>=20

Hmm, this is a known problem.

net/netfilter/nfnetlink_queue.c uses a single list of packets per queue=
=2E

If your application gives verdict for a packet not at the head of queue=
,
find_dequeue_entry() spend a lot of time to find the packet.

So are you sure you dont forget to give verdict for some packets, and
queue fills to its limit ?

Some attempts in the past tried to convert this list in a tree but AFAI=
K
nothing was merged.

By the way, latest Ubuntu has more recent kernel, you could try it as i=
t
includes commit c463ac972315a0 (netfilter: nfnetlink_queue: some
optimizations)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
