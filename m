From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Fix RST handling in ip_conntrack_proto_tcp.c
Date: Sat, 01 Jan 2005 16:23:52 +0100
Message-ID: <1104593032.3821.25.camel@tux.rsn.bth.se>
References: <1104511137.3821.20.camel@tux.rsn.bth.se>
	<Pine.LNX.4.58.0501011551420.15783@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-IXMEmW93gN3aEd9GsWMK"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0501011551420.15783@blackhole.kfki.hu>
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


--=-IXMEmW93gN3aEd9GsWMK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2005-01-01 at 15:59 +0100, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef

> Ouch!

I agree :)

> > Please make sure something that fixes the problem is submitted fairly
> > quickly.
>=20
> I think your patch should  be submitted immediately. The introduced bug i=
s
> too bad to leave it linger on.

I'll submit it to Andrew since Davem is on vacation.

> > <hint> A tcp-state/windowtracking testcase for nfsim would be great
> > </hint> :)
>=20
> Yep, I got Rusty's message as well :-) Time to dig out the initial tests
> from the old cvs and convert them to nfsim with new cases added.

:) We need more testcases badly, for all sorts of things.

--=20
/Martin

--=-IXMEmW93gN3aEd9GsWMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB1sCIWm2vlfa207ERAo+iAJ4/jUxYozfi73Y97E91c/v6xbPWGACfWrmk
zXCkldDVcvuPlvC4sgJt2Ho=
=hMo4
-----END PGP SIGNATURE-----

--=-IXMEmW93gN3aEd9GsWMK--
