From: Harald Welte <laforge@netfilter.org>
Subject: Call for testing: patch-o-matic-ng
Date: Sun, 21 Dec 2003 13:24:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>
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


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've now gotten patch-o-matic-ng to a state where it is actually quite
useable. =20

Everybody interested can check it out from CVS
(netfilter/patch-o-matic-ng).  Everything should look exactly like the
old patch-o-matic, including screen output and command syntax.

However, the implementation behind the curtain is completely different.
Interested people are invited to look into the perl source of
Netfilter_POM.pm and 'runme'.

I would like to have people start testing/using pom-ng and report errors
back to me (via email).

The differences from a user's point of view:

- dependencies are resolved recursively
- verbose error reporting
- new, more verbose './runme --man' documentation
- if you want to apply a specific set of patches, don't prefix them
  with the repository name (i.e. use
  	./runme pptp-conntrack-nat
  instead of
  	./runme extra/pptp-conntrack-nat

The differences from a developer's point of view:

- support for requirements (i.e. kernel >=3D 2.4.22)
- recursive dependencies
- support for multiple kernel build systems (i.e. 2.4.x and 2.6.x)
- automatic creation of Configure.help entries / Kconfig help sections
  from the patches 'help' file
- no wholefile-patches in CVS.  This means that entirely new files like
  net/ipv4/netfilter/ipt_foo.c / ipt_foo.h are not stored as patches but
  rather in their original form.   This in turn means real version
  control on the sourcecode!
- backend seperated from frontend (i.e. other user frontends could be
  implemented
- not limited to the linux sourcecode.  It is easy to add support for
  other projects (if a patchlet would have to patch other software, too)

However, some stuff is still missing (see the patch-o-matic/TODO file).
I'm working on implementing those missing features, though.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/5ZENXaXGVTD0i/8RAuBYAJ0fYlBOrW2VjaII8vfTtegnqaXYdwCgnu/S
hx1A9hlikuWdGktclY7czYc=
=fZLo
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
