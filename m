From: Harald Welte <laforge@netfilter.org>
Subject: Re: Patch to save ca 100.000 kbyte,
	integrate save & restore to iptables
Date: Tue, 21 Sep 2004 16:16:36 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040921141636.GM1307@sunbeam.de.gnumonks.org>
References: <414EF618.4070602@artech.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VOAkKSXG6MhRWuAn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Holmberg <jan@artech.net>
Content-Disposition: inline
In-Reply-To: <414EF618.4070602@artech.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--VOAkKSXG6MhRWuAn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 20, 2004 at 05:24:08PM +0200, Jan Holmberg wrote:
> Hi all,
>=20
> A patch to save flash memory in embedded system  and make a symbolic=20
> link to iptables to iptables-save and iptables-restore. More than
> 100.000 kbyte saved with this patch.

Thanks, but this is already implemented in our CVS tree since Fri Jun 25
11:18:57 2004 UTC

> //Jan
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VOAkKSXG6MhRWuAn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBUDfEXaXGVTD0i/8RAuhrAJ49fR9bctlqDVZwjs53Jw6+wtwcnQCeLUG4
Ie0peDldW0hGTkw2xUOE9eI=
=k1fR
-----END PGP SIGNATURE-----

--VOAkKSXG6MhRWuAn--
