From: Jeff Haran <jharan@bytemobile.com>
Subject: RE: concatenate udp payloads of multiple packet
Date: Thu, 19 Apr 2012 17:58:33 +0000
Message-ID: <471DE477E2B1F549A58F3A14A27180BE01687C@HQ-EX01.bytemobile.com>
References: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Arif Hossain <aftnix@gmail.com>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:63550 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2DSR64 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:58:56 -0400
In-Reply-To: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Arif Hossain
> Sent: Thursday, April 19, 2012 7:32 AM
> To: netfilter@vger.kernel.org; netfilter-devel@vger.kernel.org
> Subject: concatenate udp payloads of multiple packet
>=20
> Hi all.
>=20
> I have a netfilter_queue app which receives packets on a port range
> and do modifications on them. Now =A0i need to introduce to new featu=
res
> with this basic app.
>=20
> First the traffic is quiet high. I have seen the --queue-balance
> option. If i want to use it how should i approach? i mean should i
> manage every queue from separate threads or
> separate process to manage individual queues?=A0 I'm not sure how can=
 i
> use fork() to manage every queue separately.
>=20
> Secondly How packets are distributed among different queues? Based on
> what property a =A0packet is distributed? Any relationship i need to
> know about
> this distribution?
>=20
> Thirdly I need to concatenate udp payloads of several packet to
> improve bandwidth usage. how should i approach this? The confusion is
> when i stop finish processing
> of one packet i call nfq_set_verdict() in nfq_callback().  My
> confusion  is when  a packet popped from the NFQUEUE? when
> nfq_set_verdict() returns or when nfq_callback()
> returns?
>=20
> I mean if i push the incoming packets in user managed queues for
> concatenation of udp payload(by this i will also drop individual
> packets), then return from the nfq_callback().
> After processing in user managed queues(concatenation is done) then i
> will issue nfq_set_verdict(). Would that work?
>=20
> Thanks in advance.
>=20
> --
> -aft

I'm not an expert in this interface, but what I've observed is when use=
r space reads a packet off of a socket to an NFQUEUE, a subsequent read=
 on that socket will block if the first packet is not returned via nfq_=
set_verdict(), even if further packets have been queued from the kernel=
=2E So I don't think you can expect to read a bunch of packets, concate=
nate them and then return verdicts on them. You'd never see packets pas=
t the first one. At least that's what I have observed. I haven't dug in=
to the kernel code to see if that is expected behavior.

I had written an application which poll()'ed on two fds; one a socket t=
o an NFQUEUE and another from signalfd() to SIGUSR1. The "handler" code=
 for the SIGUSR1 signal fd just printf()'ed some statistics maintained =
by the application. Funny thing was, if ever my application failed to c=
all nfq_set_verdict() for a packet read off of the socket, then poll() =
wouldn't return even when I sent the application a SIGUSR1 via kill. No=
t sure what was going on there.

Good luck,

Jeff Haran



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
