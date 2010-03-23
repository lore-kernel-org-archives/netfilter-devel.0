From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Tue, 23 Mar 2010 18:23:25 +0100
Message-ID: <1269365005.2983.298.camel@edumazet-laptop>
References: <4BA74950.6000305@infopact.nl>
	 <38bcb3ec1003231004y7672ad38v2c16f8c7d042f586@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jorrit Kronjee <j.kronjee@infopact.nl>,
	netfilter-devel@vger.kernel.org
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54968 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0CWRXb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:23:31 -0400
Received: by pwi5 with SMTP id 5so3506765pwi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Mar 2010 10:23:30 -0700 (PDT)
In-Reply-To: <38bcb3ec1003231004y7672ad38v2c16f8c7d042f586@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 23 mars 2010 =C3=A0 10:04 -0700, James King a =C3=A9crit :
> On Mon, Mar 22, 2010 at 3:41 AM, Jorrit Kronjee <j.kronjee@infopact.n=
l> wrote:
> > At around 300 kpps, the amount of packet drops is 40 kpps. For me, =
this
> > amount is too significant to ignore. I see the load average go from=
 a
> > comfortable 0.00 to 1.78, mainly caused by ksoftirqd processes. At =
200
> > kpps, the average amount of packet drops is 23 kpps. At 100 kpps, i=
t's
> > still 2 kpps.
> >
> > When I disable the hashlimit module the packet drops disappear agai=
n.
> > Now I know that hashlimit is made for more than one thing, namely
> > limiting packets based on source/destination host and source/destin=
ation
> > port, so it's not as efficient as it could be for my purposes. I co=
uld
> > rewrite it, but before I do that, I would like to know if the modul=
e
> > itself is really what's causing it, or if there's some underlying c=
ause
> > that I'm not seeing. So my question in short: how can I discover wh=
y
> > it's dropping packets?
>=20
> I'm not sure whether it's even related to the problem you're having,
> but I had a similar problem on a bnx2 interface with high packet rate=
s
> when using l7-filter.  ifconfig reported huge numbers of dropped
> packets, corresponding to rx_fw_discards from "ethtool -S ethX"
> output.  I resolved this by bumping up the driver RX ring size (which
> was defaulting to 100 out of a maximum possible size of 1020).
> -

If increasing latencies is OK, then yes, increasing queue lengthes is a=
n
answer.

Sometime, its better to drop packets after a given threshold of
workload.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
