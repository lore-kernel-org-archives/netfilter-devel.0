From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24 combined with KVM switch (fwd)
Date: Tue, 3 Feb 2004 23:00:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203220020.GC25175@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.58L.0401271021230.9958@logos.cnet> <20040127124259.GP11761@sunbeam.de.gnumonks.org> <1075825496.23902.9.camel@tammuz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>,
	Andreas Stempfhuber <andreas.stempfhuber@cyclades.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Oliver Kurth <oliver.kurth@cyclades.de>
Content-Disposition: inline
In-Reply-To: <1075825496.23902.9.camel@tammuz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 03, 2004 at 05:24:57PM +0100, Oliver Kurth wrote:
> Hi Harald,
>=20
> > > We are having a problem with 2.4.24 on cyclades germany, the box
> > > (firewall) is crashing in the netfilter code.
>=20
> Anything new about that problem? Do you need more information?

sorry, I lost that issue because I'm extremely overloaded at the moment.

It seems like it crashes in the following piece of code (from
ip_conntrack_core.c)

        /* If the expectation is dying, then this is a looser. */
        if (expected
            && expected->expectant->helper->timeout
            && !del_timer(&expected->timeout))
                expected =3D NULL;


To be more precise, it cannot dereference helper->timeout, since helper
is NULL.  I am extremely puzzled how you would end up with a conntrack
expectation (which can only be caused by a helper) that has not assigned
a helper.

Could you please tell me, which conntrack and/or NAT helpers you were
using on that machine?

We haven't had something like this before.

As a workaround, you could add an additional check into that piece of
code.  At least it won't oops anymore, although it is still unclear how
you end up with this kind of situation.

if (expected
    && expected->expectant->helper
    && expected->expectant->helper->timeout
    && !del_timer(&expected->timeout))
        expected =3D NULL;


> Greetings,
> Oliver

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAIBn0XaXGVTD0i/8RAjzRAJ0fS56/3AsFrvvcTq6E3/DePcQPgACeJcDd
wYMXmMjLAm6NDT98drbAqqs=
=dzbk
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
