From: Harald Welte <laforge@netfilter.org>
Subject: [WARNING] iptables current CVS can be instable
Date: Tue, 24 Jun 2003 19:48:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624174805.GC15635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
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


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

current iptables CVS contains some major changes to the low-layer
library libiptc.  (libiptc/libipt.c version >=3D 1.40)

The new libiptc.c code has not yet received that much testing.  It might
cause all sorts of strange bugs in the ruleset, so please use current
iptables CVS with extreme care.

For those interested in the full story about the optimization effort:
http://lists.netfilter.org/pipermail/netfilter-devel/2003-June/011790.html

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++I7VXaXGVTD0i/8RAoKuAJ9DRFNEzK28EpDpE/Qx6AgS1grCaACgibJk
oL/i5sTWWaC56YfqUPvTQtI=
=QNu2
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
