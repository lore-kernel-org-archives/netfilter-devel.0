From: Harald Welte <laforge@netfilter.org>
Subject: oops in init_conntrack (master->helper == NULL)
Date: Wed, 4 Feb 2004 00:10:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203231012.GD25175@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Cc: Oliver Kurth <oliver.kurth@cyclades.de>,
	Marcelo Tosatti <marcelo.tosatti@cyclades.com>,
	Andreas Stempfhuber <andreas.stempfhuber@cyclades.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi netfilter-devel!

I think we've now had the second bug report on this issue.  IIRC,
there's one in Bugzilla (I'm offline right now, so I cannot verify), and
I've received one from cyclades.

I really have no idea how this might be caused.

The description is like:

in ip_conntrack_core.c:init_conntrack()
- we have a matching expect
- expected->expectant exists (master conntrack is present)
- expected->expectant->helper is NULL
- thus, accessing expected->expectant->helper->timeout causes a NULL
  deref and oopses

this means that an expectation was issued by some master conntrack - but
the master conntrack doesn't have a helper (anymore).  Let's assume that
the helper did still exist at the time the expectation was raised [no
code in patch-o-matic is calling ip_conntrack_expect_related() from
something else than a conntrack helper, does it?].

So between raising the expectation and receiving the first packet of
that expectation, the master conntrack 'help' field has been set to
NULL.

The possible occasions where ct->helper could be set to zero are:
- ip_conntrack_alter_reply()
	- only called via ip_nat_setup_info()
		- only called for NEW packet which usually doesn't
		  create expects
- unhelp() via ip_conntrack_helper_unregister()
	- removes any unconfirmed expectations
	- resets helper to NULL
		- since it removes all unconfirmed expectations,=20
		  our now-confirmed-and-crashing expect would no longer
		  exist.

So (like way too often) we see the impossible.

Any comments?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAICpUXaXGVTD0i/8RAvplAKCg1RnhCuqI1yESfcQzSDdt77M6WgCgowBN
E6SiGyGpDBvfN1jjaLYn654=
=hGTp
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
