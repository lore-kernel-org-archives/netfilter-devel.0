From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] iptables 32bit compat layer
Date: Wed, 29 Mar 2006 21:04:45 +0200
Message-ID: <1143659085.4015.77.camel@localhost.localdomain>
References: <200602201110.39092.dim@openvz.org>
	<200603291536.17794.dim@openvz.org> <442A7E72.2080405@trash.net>
	<200603291638.02842.dim@openvz.org>  <442A81DB.7060608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-xjKMkHUIv3olzmmPBG07"
Cc: netfilter-devel@lists.netfilter.org, Arnd Bergmann <arnd@arndb.de>,
	Dmitry Mishin <dim@openvz.org>, rusty@rustcorp.com.au,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <442A81DB.7060608@trash.net>
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


--=-xjKMkHUIv3olzmmPBG07
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-03-29 at 14:47 +0200, Patrick McHardy wrote:
> Dmitry Mishin wrote:
> > On Wednesday 29 March 2006 16:32, Patrick McHardy wrote:
> >>
> >>I know, but SOL_IPV6 implies IP6T_* - but please don't bother sending
> >>a new patch for this :) So the point of the change is to exclude IPv6
> >>from the compat layer because its not implemented yet?
> >=20
> > Exactly. Because do_netfilter_replace still works for some cases, but n=
ewer=20
> > replacement isn't ready yet.
>=20
> Ah OK. One last thing before I'll pass it on. There was one 64 bit
> architecture where iptables already worked with 32 bit userspace for
> some reason. I would like to make sure that it still works before it
> goes in because I can't debug it if it fails afterwards. I don't
> recall which arch it was, but I think Martin had one of these machines.
> Martin, could you give the compat patch a try?

It was an sparc64 machine with 32bit userspace I used for this testing.
Iirc, there was no problem adding/removing rules with the normal built
in matches and targets. The parts that were troublesome was some
matches/targets and rule counters.
That was worked around with very very very very ugly hacks in the
matches/targets in userspace, first an attempt to detect if we are
running 64/32 and if that's the case add some padding to some structs to
make the placement of used struct members match what's in kernel)

That machine (an old ultra1) hasn't seen electricity in a long time,
I'll see if I can dig it out this weekend unless someone else (dave?)
beats me to testing the patch.

--=20
/Martin

--=-xjKMkHUIv3olzmmPBG07
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEKtpNWm2vlfa207ERAlJPAJ0Zj1A7M5WFNc1TcfrG9S6wWV45HwCeNsnO
QCgu2/UFwVMP7Joa2TAkHEw=
=nZyA
-----END PGP SIGNATURE-----

--=-xjKMkHUIv3olzmmPBG07--
