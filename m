From: Harald Welte <laforge@netfilter.org>
Subject: nf_conntrack / ipt_{state,conntrack,...} interoperability
Date: Sun, 28 Aug 2005 09:51:56 +0200
Message-ID: <20050828075156.GB4244@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
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


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

IIRC, some time ago there was a lengthy discussion on how to make the
ipt_{state,conntrack} matches work with nf_conntrack.

The goal basically is to make it transparent to the packetfilter ruleset
which of {nf,ip}_conntrack the system is running.

I think we have multiple approaches:

1) make it a compile-time decision and have #ifdef #else #endif in
   ipt_{state,conntrack} (bad)
2) let the user decide at runtime, add accessor functions to
   ipt_{state,conntrack} (sound reasonable)
3) use some unified structures (unlikely)=20

Patrick also told me at OLS that Yasuyuki had developed some code to
make this work.  Could any of you please post the last status of that
code?

I think as soon as this issue is resolved, we can push for nf_conntrack
inclusion.  Since mainline kernel still has not reached 2.6.13, if we're
quick we can stil put it in davem's net-2.6.14 tree.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEW0bXaXGVTD0i/8RAgKmAJwO2JnapLrA5mvPM+Pcg7ivrD7hcACglP7g
hAmmbJi+VhcqsXBOPZysBI4=
=9U9r
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
