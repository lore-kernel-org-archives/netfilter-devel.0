From: Oliver Kurth <oliver.kurth@cyclades.de>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with
	2.4.24	combined	with KVM switch (fwd)
Date: Wed, 11 Feb 2004 11:19:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076494781.13116.8.camel@tammuz>
References: <200402110757.i1B7vt909860@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R2DfX64AfMMhe/Em4KNK"
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Andreas Stempfhuber <andreas.stempfhuber@cyclades.de>, Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
In-Reply-To: <200402110757.i1B7vt909860@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-R2DfX64AfMMhe/Em4KNK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-02-11 at 08:57, Ian Latter wrote:
> Hello Oliver,
>=20
>=20
> > > While it shouldn't crash (regardless), it should also not be activati=
ng=20
> > > the helper and REJECTing.    Is it possible the the REJECT log entry =
is
> > > on an INPUT rule, while the helper is being triggered on a PREROUTING
> > > rule, due to the architecture of the network you've described (or vic=
e=20
> > > versa)?
> >=20
> > The REJECT is in an INPUT rule. But I do not think that a PREROUTING
> > rule is involved. I just looked at the rules, and PREROUTING is only
> > done for other physical networks.
>=20
> Ok - You said originally that;
>=20
> > > > The problem occurs when:
> > > > - a client broadcasts a tftp request, with source IP 192.168.160.25=
5
> > > > - server in the same physical network, but logical network
> > > > 192.168.10.0/24 replies
> > > > - the reply is routed through the gateway (which has an alias IP
> > > > 192.168.160.1 netmask /24 on the same physical network, if this is
> > > > relevant)
> > > > - gateway blocks with REJECT. This message ist still in the logs, b=
ut
> > > > soon after that the kernel panics.
>=20
> So, I'm assuming that you have something like this on your gateway;
>=20
>   eth0    192.168.10.1/255.255.255.0
>   eth0:1 192.168.160.1/255.255.255.0

Correct. That's what I already said.

> .. and that you're forwarding.  In which direction is the INPUT
> packet REJECTed ?  Ie;
>=20
>     a) RRQ:  broadcaster -> tftp server/broadcast
>     b) ACK/DATA:  tftp server -> broadcaster/booting host

case b). As described above. We do not see a) in the gateway logs,
although it is surely noticed by it.

>   Additional places to look are going to come from how your
> rules are structured.  For example, I'd probably expect to see a
> REJECT on INPUT at "a" and then a some interesting stuff with=20
> "b".  Depending on your ruleset, "b" may REJECT on PREROUTING,
> FORWARD or POSTROUTING.  And, IIRC there is a /proc security=20
> option for restricting directed broadcasts, though I don't know if=20
> this affects forwarded (non-locally generated) traffic.  It may also
> be possible that once the "b" traffic has made it through your
> gateway, that the ACK is received by the INPUT of the eth0
> interface at the gateway again (as the original RRQ source was
> a broadcast address) -- this may also be part of the problem.
>=20
>   Maybe a tcpdump/ethereal capture at the gateway would reveal
> more?

It probably would help. Unfortunately, we can reproduce this only in our
production network, so we can do it only when most people have left the
office. And currently I am overloaded with other work.

Greetings,
Oliver

--=20
Cyclades GmbH                       -              Everywhere with Linux
Oliver Kurth                                               Cyclades GmbH
Research & Development                                        Rennweg 33
Fon/Fax: +49 (0) 8122 90999-34/-33                        D-85435 Erding


--=-R2DfX64AfMMhe/Em4KNK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAKgG9UmVSJkUeqxsRAuClAJ4n7XL/hS7ASDnx2K9sl4HOhZrFbQCggwZR
LqmXTk9UlNo4CbJyGKKujis=
=ok9K
-----END PGP SIGNATURE-----

--=-R2DfX64AfMMhe/Em4KNK--
