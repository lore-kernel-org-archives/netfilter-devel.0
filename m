From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables extensions manpage
Date: Wed, 21 Jan 2004 17:00:41 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121220041.GC1810@obroa-skai.de.gnumonks.org>
References: <20040120130122.GC8642@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0401210304010.30308-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvF4niNJ+uBMJnEh"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <henrik@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401210304010.30308-200000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gvF4niNJ+uBMJnEh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2004 at 03:16:21AM +0100, Henrik Nordstrom wrote:
> Attached you find version 2 of my proposed patch to split the extensions
> part of the man pages into snippets under extensions/. This time all
> documented extensions is included in the resulting man page but the ones
> not supported by the iptables build is marked with "Unsupported, see
> Patch-O-Matic" with the intent that a Patch-O-Matic section should be
> added documenting what Patch-O-Matic is. There is also a slight format
> change in the snippets to reduce the amount of redundant information.

thanks, I have committed your patch to the CVS repository.  I've also
added dozens of .man files that were missing in the old manpage.

> Regards
> Henrik
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gvF4niNJ+uBMJnEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADvaJXaXGVTD0i/8RAi57AJ9BS7QpHx4BCbyH6f7zxejevIrePgCfeOqz
ARrW1FO1PLiQXRRSEZ3/Euo=
=cP7G
-----END PGP SIGNATURE-----

--gvF4niNJ+uBMJnEh--
