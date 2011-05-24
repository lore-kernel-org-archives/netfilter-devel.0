From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset and interfaces
Date: Tue, 24 May 2011 14:37:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241433030.1846@blackhole.kfki.hu>
References: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com> <alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu> <BANLkTi=drvnwAiXk-Js+1Dw0wxWGNsT1xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1456250243-1306240650=:1846"
Cc: netfilter-devel@vger.kernel.org
To: Oskar Berggren <oskar.berggren@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37778 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1EXMhb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:37:31 -0400
In-Reply-To: <BANLkTi=drvnwAiXk-Js+1Dw0wxWGNsT1xA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1456250243-1306240650=:1846
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 24 May 2011, Oskar Berggren wrote:

> 2011/5/24 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
> > On Tue, 24 May 2011, Oskar Berggren wrote:
> >
> >> Regarding ipsets.... how crazy would it be to add a set type
> >> containing interface names?
> >
> > Usually the number of interfaces are not quite high in a system, so it
> > does not seem required.
>=20
> I have machines with plenty of vlans. About 700 interfaces in the=20
> largest instance currently. That said, I don't have a clear use case for=
=20
> this particular set type currently, but out of curiosity, would it be=20
> reasonably doable within the ipset framework?

Yes, I don't see any problem here.
=20
> >> And how crazy would it be to add a set type containing tuples of
> >> ip-address and interface name? =A0(I.e. the set match would look for i=
p,
> >> and match if a tuple with the proper interface is found)
> >
> > What is the case where a combination of matches does not solve the issu=
e?
> > Something like this
> >
> > -N interfaces
> > -A interfaces -i foo -j ACTION
> > ...
> >
> > -A rule -m set --match-set src -j interfaces
> >
> > and thus you can match IP addresses and possible (incoming) interfaces
> > easily.
>=20
> As above, about 700 interfaces, each with a generally just a few source=
=20
> ip-addresses expected for each interface, or a few subnets. I.e. in the=
=20
> simplest case a single ip is acceptable for a single interface, for a=20
> total of a couple of hundred interfaces. This is similar to rp_filter,=20
> but I had trouble getting that to work predictably with multiple routing=
=20
> tables. Currently I've solved it with a tree structure of iptables=20
> chains and rules, but being able to use a single set for this would look=
=20
> so much nicer.

So it looks like a valid case, for a new set type with interfaces and IP=20
addresses/networks ;-) I'll work on it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1456250243-1306240650=:1846--
