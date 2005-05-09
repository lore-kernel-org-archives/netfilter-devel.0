From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] alternative to conntrack ID
Date: Mon, 09 May 2005 16:17:16 +0200
Message-ID: <1115648236.25627.17.camel@nienna.balabit>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <427D41FA.5080506@ingate.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2005-05-08, v keltez=E9ssel 00.32-kor Marcus Sundberg ezt =EDrta:
> >>You don't even need fast CPUs or networks to risk precision problems
> >>- think multiple NICs and SMP.
> >=20
> > SMP or multiple NIcs don't matter because at any point in time only
> > one instance of a connection can exist. The challenge is to have a
> > unique identifier over time.
>=20
> Yes, having a unique identifier over time was what was being discussed,
> and I was merely pointing out that with SMP you can get two conntracks
> with identical timestamps even if you have infinite precision, since
> two new conntracks can be timestamped simultaneously by different CPUs.

  OK, but it's not a problem. If the two conntracks are identical (their
tuples are the same) then equal timestamps are not a problem (and of
course one of them will be dropped anyway, since hash insertion is
serialized). If they are not the same, then it does not matter because
the timestamp is just an additional info -- the tuple identifies the
conntrack by itself.

  Probably Patrick was referring to a possible problem where the
following happens: a new connection is established and destroyed in a
very short time. If a new connection with the same tuple is created
before the timestamp increases (which is perfectly possible IMHO if you
have some slow embedded HW with no high precision timer available) then
you won't be able to tell the difference in the userspace app, so that
the race described by Amin is still possible.

--=20
 Regards,
  Krisztian Kovacs
