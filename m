From: Harald Welte <laforge@netfilter.org>
Subject: Ruleset loading performance / libiptc2 / iptables-1.3.0
Date: Mon, 30 Aug 2004 01:54:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040829235427.GM5824@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/1XGRQlv2BMqnS3"
Cc: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--W/1XGRQlv2BMqnS3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As we all know, loading a big ruleset can be quite slow, even when using
iptables-restore.

Back in June last year I added some improvements to libiptc, providing
about 40% speedup when loading my artificial 1000-chain 10000-rule ruleset.

However, there were still a couple of algorithms with too high
computational complexity left in libiptc.  They could not be eliminated
without a complete rewrite.

During the last week, I did that [painful, and probably still quite buggy]
complete rewrite - it has just been commited to CVS.

Let the numbers speak for themselves:

Loading a ruleset with 1000 chains, each 10 rules with iptables-restore
on an Intel P3-733:

original code (iptables-1.2.8)
	3m55.575s (3m27.310s/0m28.270s)

modified libiptc with relative offset + correct_cache() (iptables-1.2.9)
	2m19.566s (1m52.510s/0m26.980s)

new rewritten libiptc2 (upcoming iptables-1.3.0)
	0m1.255s (0m1.205s/0m0.048s)

If you want to thank me for this speedup: Please do so by finding and
debugging the remaining issues:

TODO:
- implement TC_DELETE_ENTRY (should be fairly trivial)
- fix all the debugging/checking/dumping macros that I have disabled
- fix a race condition with rule_iterator_cur (already fixed with
  chain_iterator_cur, easy)
- find out why 'iptables -X' doesn't work yet
- verify that counter mapping really works in all obscure cases
- more testing
- find a theory why the system time decreased when modifications
  happened only in userspace code.. and getsockopt/setsockopt is still=20
  called the same way
- consume less memory: release (*handle)->entries after parsing

Thanks!
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--W/1XGRQlv2BMqnS3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBMmyzXaXGVTD0i/8RAvS1AJ9i7bcBmpSVqkelgX9DCtH84HfT7gCfZ3fv
42kR5sENGx8Gt4YxtOfqs7s=
=HoMp
-----END PGP SIGNATURE-----

--W/1XGRQlv2BMqnS3--
