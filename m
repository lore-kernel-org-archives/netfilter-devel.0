From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Deleting iptable-extended rule
Date: Mon, 9 Dec 2002 19:46:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209184617.GP2223@sunbeam.de.gnumonks.org>
References: <20021204225219.78871.qmail@web41309.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E187YRO8KGM40JwS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lists brk <brk_lists@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20021204225219.78871.qmail@web41309.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--E187YRO8KGM40JwS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2002 at 02:52:19PM -0800, lists brk wrote:
> I am able to delete the rule using the rule number,
> but I am not able to remove it using the rule specifed
> above but with -D option, something like
> iptables -D INPUT -m coustom --ip-id -j DROP
>=20
> The error I get is:
> iptables: Bad rule (does a matching rule exist in that
> chain?)
>=20
> I tried to debug it and found that iptables fails at
>=20
> mptr =3D matchmask + sizeof(STRUCT_ENTRY);
> 	if (IPT_MATCH_ITERATE(a, match_different, a->elems,
> b->elems, &mptr))
> 	  return 0;
>=20
> in is_same() found in file libiptc/libip4tc.c
>=20
> Any ideas why this might be happening??

because the compare fails for some reason.  Maybe there are some
uninitialized fields in the match private data structure.  Try
explicitly memset()ing it to zero when it is initlailzed from the
parse() function.

> Thanks,
> brk

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--E187YRO8KGM40JwS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99OT5XaXGVTD0i/8RAkiTAJ44QoNEl6gban2fL/+eZz6FhWs1ZgCgrCix
Cx6cQmlP2S/twhyN6FsVGgo=
=vByP
-----END PGP SIGNATURE-----

--E187YRO8KGM40JwS--
