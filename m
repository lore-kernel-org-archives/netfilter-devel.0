From: Harald Welte <laforge@netfilter.org>
Subject: New patch-o-matic release needed
Date: Fri, 19 Dec 2003 09:26:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031219082612.GC2794@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
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


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin!

Could you please prepare the 'old' patch-o-matic tree to be ready for a
new release?  Lot's of people are still using 030912, which for example
has lots of known bugs in the pptp code.

The new release should apply to 2.4.18-2.4.23.

Thanks a lot.

btw: feel free to change patches in 'submitted' without any notification
to me.   But please inform me if you have to touch anything else, so I
can merge the changes to the respective pom-ng patchlets.

expect a mostly-compatible 'runme' later today.  The internal
implementation in pom.pm is almost completed.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/4rYjXaXGVTD0i/8RAiM5AKCXAJd1RdYInNmHCbiV55Iwh/ACgACgk/q+
NcqHN/AIwBvGIEdL4VYEpLs=
=7X2C
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
