From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_count broken - kernel 2.6 - New patch
Date: Thu, 19 Aug 2004 12:52:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819105214.GH3921@sunbeam.de.gnumonks.org>
References: <20040815131740.GA23767@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fQa200R4EO7jAQ6Z"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Samir Bellabes <sam@cerbere.dyndns.info>
Content-Disposition: inline
In-Reply-To: <20040815131740.GA23767@cerbere.dyndns.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fQa200R4EO7jAQ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 15, 2004 at 03:17:40PM +0200, Samir Bellabes wrote:
> Hi Harald,
>    The ip_conntrack_count is broken with kernel 2.6.8.
>    This patch, which do the same thing, applies correctly.

mh, at least with 2.6.8.1 it works:

laforge@tatooine%pts/2 (12:49) /usr/src/linux-2.6.8.1-test > patch -p1 --dr=
y-run < ~/projects/cvs/netfilter/patch-o-matic-ng/ip_conntrack_count/linux-=
2.6.patch
patching file net/ipv4/netfilter/ip_conntrack_core.c
Hunk #1 succeeded at 65 (offset 1 line).
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 312 (offset 1 line).
Hunk #2 succeeded at 347 (offset 1 line).
patching file include/linux/sysctl.h
Hunk #1 succeeded at 410 (offset 1 line).

Can you be more specific what the problem is?  Also, apart from hunk
reordering, I cannot see how your patch is different from what we have
in cvs.

> thanks.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fQa200R4EO7jAQ6Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJIZeXaXGVTD0i/8RAgmnAJwJt8WEmxwQHrpPGJv31Ty8RDXp6gCeJVc0
tRwYIUAZnsDkgrlee+Vu198=
=4TYY
-----END PGP SIGNATURE-----

--fQa200R4EO7jAQ6Z--
