From: Harald Welte <laforge@netfilter.org>
Subject: Merge of iptables 'fuzzy', 'random' and 'nth' match
Date: Sun, 24 Aug 2003 09:21:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824072158.GL6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yK/6QRnH3Zanb0EF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: hime@engineer.com, fabrice@netfilter.org, rwagner@cloudnet.com
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


--yK/6QRnH3Zanb0EF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

At the netfilter developer workshop, it was decided that we would like
to include the functionality of the fuzzy, random and nth match into the
upcoming 2.6 mainstream kernel.

However, it is doubtful that each of those three features really need=20
their own module.

We'd like to ask you to merge the three modules into one
ipt_statistical.c module, that can be used in 'nth', 'random' or 'fuzzy'
mode.

If you would work together on this issue (or one of you wants to take up
this job), I would be very happy to submit the result for kernel
inclusion.

[btw: the same goes for the IPv6 counterpart - but that 'port' can
follow later on]

Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yK/6QRnH3Zanb0EF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SGeWXaXGVTD0i/8RAgu8AJ9hb81h1rVUK+D7cAAlkNjzHioRfgCfQADI
aM1KL3LLGeqYBGCXOPZQCSo=
=aaRR
-----END PGP SIGNATURE-----

--yK/6QRnH3Zanb0EF--
