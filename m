From: Harald Welte <laforge@netfilter.org>
Subject: Re: Comments on iptstate
Date: Mon, 16 Feb 2004 09:34:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040216083410.GL15567@sunbeam.de.gnumonks.org>
References: <20040215190757.GC15567@sunbeam.de.gnumonks.org> <40307447.4030703@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1whYXOlSGJlk+LY"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Dibowitz <phil@ipom.com>
Content-Disposition: inline
In-Reply-To: <40307447.4030703@ipom.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k1whYXOlSGJlk+LY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2004 at 11:41:59PM -0800, Phil Dibowitz wrote:
> >I suggest to consider porting your application on top of ctnetlink (see
> >libctnetlink in netfilter cvs and the nfnetlink-ctnetlink patch in
> >patch-o-matic).
>=20
> I might just do that. Do those libraries have hooks to do things like..=
=20
> um, say remove a state from the state table? Its a commonly requested=20
> feature of iptstate.

yes, exactly.  that is possible using ctnetlink

> >3) The name of the application is misleading. iptables itself does not
> >   track any state information.  it is ip_conntrack who does.  There is
> >   almost no relation between both of them.
>=20
> Sorry, but there's no way I'm renaming my app. =3D) I don't think its THA=
T=20
> misleading. ip_conntrack is an ip tables module. It's not some=20
> application that sits on top of any firewall, its very ip tables=20
> specific. It makes ip tables have stateful capabilities.
>=20

I didn't ask you to rename it, I just wanted to point that out.

Is is _NOT_ an iptables module, it is a netfilter module.  Thus it is a=20
sibling descending from the same father (netfilter).  But technically,
they have nothing in common at all (rather than using the netfilter API
to receive packets, but a lot of people do that now).

It makes the network stack have state tracking.  That iptables is almost
it's only user is just a coincidence.

> Phil Dibowitz                             phil@ipom.com

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--k1whYXOlSGJlk+LY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMICCXaXGVTD0i/8RAqAjAJ9hov4KLQFmuFaD9KoBd5M/4Kl7LQCfYsmm
u8tZbH16hyZMS6uhJGSkeAw=
=Il9O
-----END PGP SIGNATURE-----

--k1whYXOlSGJlk+LY--
