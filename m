From: ruby joker <ruby.joker@op.pl>
Subject: [PATCH] ipt_ULOG delays packets caught by filter
Date: Tue, 20 Jul 2004 02:10:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040720001021.GA4226@wonderland>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I want once again bring your attention to ipt_ULOG problem I described
in my previous post [1]. There was no response, still I think problem
is too serious to leave it. Christopher J. Oliver's case [2] shows
the similar behaviour. Maybe bug is hard to notice but it decrease
ulog reliability.

Please correct me if I'm wrong.

Patch was attached to my first mail [1].

[1] http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015860.h=
tml
[2] http://lists.gnumonks.org/pipermail/ulogd/2001-October/000034.html

Regards,
rj
--=20
 . o .       >>  http://joker.linuxstuff.pl  <<
 . . o   It's easier to get forgiveness for being wrong
 o o o   than forgiveness for being right.

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQFA/GLtVzhR48jg84ARAmM+AKCX+NVbR3gArRwCfWJIJAJ0tY8tbQCePxjY
j4ghG8GO31m7JmOj8K3zoZg=
=xr6y
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
